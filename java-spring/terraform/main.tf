terraform {
  required_providers {
    coder = {
      source = "coder/coder"
    }
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

variable "docker_arch" {
  description = "Architecture of the Docker image"
  default     = "amd64"
}

data "coder_workspace" "me" {}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

provider "coder" {}

data "docker_registry_image" "base" {
  name = "ubuntu:22.04"
}

resource "docker_image" "java_spring" {
  name          = "java-spring-workspace:latest"
  build {
    context    = path.module
    dockerfile = "Dockerfile"
  }
}

resource "docker_container" "workspace" {
  image = docker_image.java_spring.image_id
  name  = "coder-${data.coder_workspace.me.id}"

  # CPU and memory limits
  cpu_shares = 2048
  memory     = 4096

  # Environment variables
  env = [
    "CODER_AGENT_TOKEN=${coder_agent.workspace.token}",
    "CODER_AGENT_URL=${coder_agent.workspace.url}"
  ]

  # Volumes
  volumes {
    container_path = "/home/coder/project"
    host_path      = "/home/coder/project"
    read_only      = false
  }

  # Docker socket for Docker-in-Docker
  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
  }

  # Network
  network_mode = "host"

  # Keep container running
  must_run = true
  command  = ["/bin/bash", "-c", "while true; do sleep 1; done"]
}

resource "coder_agent" "workspace" {
  os             = "linux"
  arch           = var.docker_arch
  dir            = "/home/coder"
  startup_script = base64encode(file("${path.module}/startup.sh"))

  metadata {
    key   = "cpu"
    value = "4 cores"
  }
  metadata {
    key   = "memory"
    value = "4 GB"
  }
  metadata {
    key   = "disk"
    value = "50 GB"
  }
}

# VSCode Web configuration
resource "coder_app" "vscode" {
  agent_id     = coder_agent.workspace.id
  slug         = "vscode"
  display_name = "VS Code"
  icon         = "/icon/code.svg"
  url          = "http://localhost:8443?folder=/home/coder/project"
  subdomain    = false
  share        = "owner"

  healthcheck {
    url       = "http://localhost:8443/healthz"
    interval  = 5
    threshold = 6
  }
}

# JetBrains Fleet configuration
resource "coder_app" "fleet" {
  agent_id     = coder_agent.workspace.id
  slug         = "fleet"
  display_name = "JetBrains Fleet"
  icon         = "/icon/jetbrains.svg"
  url          = "http://localhost:5000"
  subdomain    = false
  share        = "owner"

  healthcheck {
    url       = "http://localhost:5000/health"
    interval  = 10
    threshold = 3
  }
}

# SSH access configuration
resource "coder_agent_instance" "dev" {
  agent_id = coder_agent.workspace.id
  instance_id = docker_container.workspace.id

  provisioner "remote-exec" {
    inline = [
      "until curl -fsSL http://localhost:8443/healthz > /dev/null; do sleep 2; done",
    ]
  }
}

output "workspace_url" {
  value = data.coder_workspace.me.access_url
}
