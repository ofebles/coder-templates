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

data "coder_parameter" "node_version" {
  name        = "Node.js Version"
  type        = "select"
  description = "Which Node.js version would you like?"
  mutable     = false
  default     = "20.11.0"

  option {
    name  = "Node.js 20 LTS (Recommended)"
    value = "20.11.0"
  }

  option {
    name  = "Node.js 18 LTS"
    value = "18.19.0"
  }

  option {
    name  = "Node.js 21"
    value = "21.6.0"
  }
}

data "coder_parameter" "package_manager" {
  name        = "Package Manager"
  type        = "select"
  description = "Which package manager would you like?"
  mutable     = false
  default     = "npm"

  option {
    name  = "npm (Default)"
    value = "npm"
  }

  option {
    name  = "yarn"
    value = "yarn"
  }

  option {
    name  = "pnpm"
    value = "pnpm"
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
    NODE_VERSION         = data.coder_parameter.node_version.value
    PACKAGE_MANAGER      = data.coder_parameter.package_manager.value
    GIT_REPO_URL         = data.coder_parameter.git_repo_url.value
    GIT_BRANCH           = data.coder_parameter.git_branch.value
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
  name = "coder-nodejs-backend-${data.coder_workspace_owner.me.id}:latest"
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
