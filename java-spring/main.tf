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

# Build Docker image
resource "docker_image" "main" {
  name = "coder-java-spring-${data.coder_workspace.me.id}:latest"

  build {
    context    = path.module
    dockerfile = "Dockerfile"
  }

  force_remove = true
}

# Create Docker container
resource "docker_container" "workspace" {
  image      = docker_image.main.image_id
  name       = "coder-${data.coder_workspace.me.id}"
  hostname   = data.coder_workspace.me.name
  must_run   = true

  command = ["/bin/bash", "-c", "while sleep 1000; do :; done"]
  stdin_open = true
  tty = true

  env = [
    "CODER_AGENT_TOKEN=${coder_agent.main.token}",
  ]

  # Volumes
  volumes {
    container_path = "/home/coder/project"
    host_path      = "/tmp/coder-${data.coder_workspace.me.id}"
    read_only      = false
  }

  # Docker socket for Docker-in-Docker
  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
    read_only      = false
  }
}

# Coder agent
resource "coder_agent" "main" {
  arch           = var.docker_arch
  os             = "linux"
  startup_script = base64encode(file("${path.module}/startup.sh"))
  
  connection_timeout = 300
}

# VS Code Server
resource "coder_app" "code_server" {
  agent_id     = coder_agent.main.id
  slug         = "code"
  display_name = "VS Code"
  icon         = "/icon/code.svg"
  url          = "http://localhost:8443?folder=/home/coder/project"
  subdomain    = false
  share        = "owner"
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
}
