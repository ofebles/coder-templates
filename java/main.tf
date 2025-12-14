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

locals {
  username = data.coder_workspace_owner.me.name
}

# ============================================================================
# PARAMETERS - Usuario selecciona al crear workspace
# ============================================================================

data "coder_parameter" "java_version" {
  name        = "Java Version"
  type        = "select"
  description = "Which Java version would you like?"
  mutable     = false
  default     = "21"

  option {
    name  = "Java 21 (LTS - Recommended)"
    value = "21.0.1-tem"
  }

  option {
    name  = "Java 17 (LTS)"
    value = "17.0.9-tem"
  }

  option {
    name  = "Java 11 (LTS)"
    value = "11.0.21-tem"
  }
}

data "coder_parameter" "maven_version" {
  name        = "Maven Version"
  type        = "select"
  description = "Which Maven version would you like?"
  mutable     = false
  default     = "3.9.5"

  option {
    name  = "Maven 3.9.5 (Latest)"
    value = "3.9.5"
  }

  option {
    name  = "Maven 3.8.7"
    value = "3.8.7"
  }

  option {
    name  = "Maven 3.6.3"
    value = "3.6.3"
  }
}

data "coder_parameter" "git_repo_url" {
  name         = "Git Repository (Optional)"
  type         = "string"
  description  = "URL of a git repository to clone (e.g., https://github.com/user/repo.git)"
  mutable      = false
  default      = ""
  display_name = "Git Repository URL"
}

data "coder_parameter" "git_branch" {
  name        = "Git Branch (Optional)"
  type        = "string"
  description = "Branch to clone (only if Git Repository is provided)"
  mutable     = false
  default     = "main"
}

data "coder_parameter" "databases" {
  name        = "Databases (Optional)"
  type        = "string"
  description = "Select databases to pre-configure (comma-separated: postgresql, mongodb, redis)"
  mutable     = false
  default     = "none"

  option {
    name  = "None"
    value = "none"
  }

  option {
    name  = "PostgreSQL Only"
    value = "postgresql"
  }

  option {
    name  = "MongoDB Only"
    value = "mongodb"
  }

  option {
    name  = "Redis Only"
    value = "redis"
  }

  option {
    name  = "PostgreSQL + MongoDB"
    value = "postgresql,mongodb"
  }

  option {
    name  = "PostgreSQL + Redis"
    value = "postgresql,redis"
  }

  option {
    name  = "MongoDB + Redis"
    value = "mongodb,redis"
  }

  option {
    name  = "All (PostgreSQL + MongoDB + Redis)"
    value = "postgresql,mongodb,redis"
  }
}

# ============================================================================
# LEGACY VARIABLES (for backward compatibility with CLI)
# ============================================================================

variable "docker_socket" {
  default     = ""
  description = "(Optional) Docker socket URI"
  type        = string
}

variable "git_repo_url" {
  default     = ""
  description = "(Optional) Git repository URL to clone into workspace"
  type        = string
}

variable "git_clone_depth" {
  default     = 0
  description = "Depth of clone for git-clone module (0 for full clone)"
  type        = number
}

variable "git_clone_single_branch" {
  default     = false
  description = "Clone only the specified branch"
  type        = bool
}

provider "docker" {
  host = var.docker_socket != "" ? var.docker_socket : null
}

data "coder_provisioner" "me" {}
data "coder_workspace" "me" {}
data "coder_workspace_owner" "me" {}

resource "coder_agent" "main" {
  arch           = data.coder_provisioner.me.arch
  os             = "linux"
  startup_script = file("${path.module}/startup.sh")

  env = {
    GIT_AUTHOR_NAME      = coalesce(data.coder_workspace_owner.me.full_name, data.coder_workspace_owner.me.name)
    GIT_AUTHOR_EMAIL     = "${data.coder_workspace_owner.me.email}"
    GIT_COMMITTER_NAME   = coalesce(data.coder_workspace_owner.me.full_name, data.coder_workspace_owner.me.name)
    GIT_COMMITTER_EMAIL  = "${data.coder_workspace_owner.me.email}"
    # User-selected parameters
    JAVA_VERSION         = data.coder_parameter.java_version.value
    MAVEN_VERSION        = data.coder_parameter.maven_version.value
    GIT_REPO_URL         = data.coder_parameter.git_repo_url.value
    GIT_BRANCH           = data.coder_parameter.git_branch.value
    DATABASES            = data.coder_parameter.databases.value
  }

  metadata {
    display_name = "CPU Usage"
    key          = "0_cpu_usage"
    script       = "coder stat cpu"
    interval     = 10
    timeout      = 1
  }

  metadata {
    display_name = "RAM Usage"
    key          = "1_ram_usage"
    script       = "coder stat mem"
    interval     = 10
    timeout      = 1
  }

  metadata {
    display_name = "Home Disk"
    key          = "3_home_disk"
    script       = "coder stat disk --path $${HOME}"
    interval     = 60
    timeout      = 1
  }
}

# VSCode via code-server module
module "code-server" {
  count  = data.coder_workspace.me.start_count
  source = "registry.coder.com/coder/code-server/coder"
  version = "~> 1.0"

  agent_id = coder_agent.main.id
  order    = 1
}

# Git clone module - clone a repository if URL is provided
module "git-clone" {
  # Use parameter value, fallback to variable for CLI compatibility
  count  = (data.coder_parameter.git_repo_url.value != "" || var.git_repo_url != "") ? data.coder_workspace.me.start_count : 0
  source = "registry.coder.com/coder/git-clone/coder"
  version = "~> 1.0"

  agent_id = coder_agent.main.id
  url      = data.coder_parameter.git_repo_url.value != "" ? data.coder_parameter.git_repo_url.value : var.git_repo_url
}

# OpenCode module - AI-powered development tool
module "opencode" {
  count  = data.coder_workspace.me.start_count
  source = "registry.coder.com/coder-labs/opencode/coder"
  version = "~> 0.1.1"

  agent_id           = coder_agent.main.id
  workdir            = "/home/coder/project"
  order              = 2
  report_tasks       = true
  install_opencode   = true
  opencode_version   = "latest"
  web_app_display_name = "OpenCode"
}

# JetBrains module - includes IntelliJ IDEA and other IDEs
module "jetbrains" {
  count      = data.coder_workspace.me.start_count
  source     = "registry.coder.com/coder/jetbrains/coder"
  version    = "~> 1.1"
  agent_id   = coder_agent.main.id
  agent_name = "main"
  folder     = "/home/coder/project"
  tooltip    = "You need to [Install Coder Desktop](https://coder.com/docs/user-guides/desktop#install-coder-desktop) to use this button."
}

# JetBrains Fleet module - lightweight alternative
module "fleet" {
  count      = data.coder_workspace.me.start_count
  source     = "registry.coder.com/coder/jetbrains-fleet/coder"
  version    = "~> 1.0"
  agent_id   = coder_agent.main.id
  agent_name = "main"
  folder     = "/home/coder/project"
  order      = 4
}



resource "docker_volume" "home_volume" {
  name = "coder-${data.coder_workspace.me.id}-home"
  lifecycle {
    ignore_changes = all
  }
  labels {
    label = "coder.owner"
    value = data.coder_workspace_owner.me.name
  }
  labels {
    label = "coder.owner_id"
    value = data.coder_workspace_owner.me.id
  }
  labels {
    label = "coder.workspace_id"
    value = data.coder_workspace.me.id
  }
  labels {
    label = "coder.workspace_name_at_creation"
    value = data.coder_workspace.me.name
  }
}

resource "docker_image" "main" {
  name = "coder-java-${data.coder_workspace_owner.me.id}:latest"
  build {
    context    = path.module
    dockerfile = "${path.module}/Dockerfile"
  }
}

resource "docker_container" "workspace" {
  count = data.coder_workspace.me.start_count
  image = docker_image.main.image_id
  name  = "coder-${data.coder_workspace_owner.me.name}-${lower(data.coder_workspace.me.name)}"
  hostname = data.coder_workspace.me.name
  
  # Use init_script instead of startup_script for proper agent initialization
  entrypoint = ["sh", "-c", replace(coder_agent.main.init_script, "/localhost|127\\.0\\.0\\.1/", "host.docker.internal")]
  env        = ["CODER_AGENT_TOKEN=${coder_agent.main.token}"]
  
  host {
    host = "host.docker.internal"
    ip   = "host-gateway"
  }

  volumes {
    container_path = "/home/coder"
    volume_name    = docker_volume.home_volume.name
    read_only      = false
  }

  labels {
    label = "coder.owner"
    value = data.coder_workspace_owner.me.name
  }
  labels {
    label = "coder.owner_id"
    value = data.coder_workspace_owner.me.id
  }
  labels {
    label = "coder.workspace_id"
    value = data.coder_workspace.me.id
  }
  labels {
    label = "coder.workspace_name"
    value = data.coder_workspace.me.name
  }
}
