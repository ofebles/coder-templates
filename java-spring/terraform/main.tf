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

variable "docker_image" {
  description = "Docker image to use for workspace"
  default     = "ubuntu:22.04"
}

data "coder_workspace" "me" {}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

provider "coder" {}

# Build or use Docker image
resource "docker_image" "main" {
  name = "coder-java-spring-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}:latest"

  build {
    context    = "${path.module}/.."
    dockerfile = "Dockerfile"
    tag = [
      "coder-java-spring-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}:latest"
    ]
  }

  force_remove = true
}

# Create Docker container
resource "docker_container" "workspace" {
  image      = docker_image.main.image_id
  name       = "coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}"
  hostname   = data.coder_workspace.me.name
  must_run   = true
  start      = true
  privileged = false

  # Use the startup script
  command = [
    "/bin/bash",
    "-c",
    base64decode(coder_agent.main.startup_script)
  ]

  env = [
    "CODER_AGENT_TOKEN=${coder_agent.main.token}",
    "CODER_AGENT_URL=${coder_agent.main.url}",
  ]

  # Expose ports for IDEs and applications
  ports {
    internal = 8080
    external = 8080
  }

  ports {
    internal = 8443
    external = 8443
  }

  ports {
    internal = 5000
    external = 5000
  }

  # Volume for workspace data
  volumes {
    container_path = "/home/coder/project"
    host_path      = "/tmp/coder-${data.coder_workspace.me.id}/project"
    read_only      = false
  }

  # Docker socket for Docker-in-Docker
  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
    read_only      = false
  }

  healthcheck {
    test         = ["CMD", "curl", "-f", "http://localhost:8080/health"]
    interval     = "5s"
    timeout      = "1s"
    start_period = "10s"
    retries      = 3
  }
}

# Coder agent
resource "coder_agent" "main" {
  arch           = var.docker_arch
  os             = "linux"
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

# VS Code Server via code-server
resource "coder_app" "code_server" {
  agent_id     = coder_agent.main.id
  slug         = "code"
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

# JetBrains Fleet
resource "coder_app" "fleet" {
  agent_id     = coder_agent.main.id
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

# Spring Boot application
resource "coder_app" "spring_boot" {
  agent_id     = coder_agent.main.id
  slug         = "spring"
  display_name = "Spring Boot App"
  icon         = "/icon/spring.svg"
  url          = "http://localhost:8080"
  subdomain    = false
  share        = "owner"

  healthcheck {
    url       = "http://localhost:8080/health"
    interval  = 10
    threshold = 3
  }
}
