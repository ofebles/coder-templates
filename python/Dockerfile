FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

# Install base packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    wget \
    git \
    gnupg \
    lsb-release \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3-dev \
    zlib1g-dev \
    libjpeg-dev \
    libpng-dev \
    software-properties-common \
    apt-transport-https \
    docker.io \
    && rm -rf /var/lib/apt/lists/*

# Create coder user
RUN useradd -m -s /bin/bash coder

# Install pyenv for Python version management
RUN git clone https://github.com/pyenv/pyenv.git /home/coder/.pyenv && \
    chown -R coder:coder /home/coder/.pyenv

# Configure pyenv for the coder user
RUN echo 'export PATH="/home/coder/.pyenv/bin:$PATH"' >> /home/coder/.bashrc && \
    echo 'eval "$(pyenv init -)"' >> /home/coder/.bashrc

# Create necessary directories
RUN mkdir -p /home/coder/project && \
    chown -R coder:coder /home/coder

# Install vscode-extensions script helper
RUN cat > /home/coder/install-vscode-extensions.sh <<'EOF'
#!/bin/bash
set -e

# Python extensions for VS Code
EXTENSIONS=(
    "ms-python.python"                          # Python support
    "ms-python.vscode-pylance"                  # Pylance language server
    "ms-python.debugpy"                         # Python debugger
    "kevinrose.vscode-python-preview"           # Python REPL preview
    "charliermarsh.ruff"                        # Ruff linter
    "ms-python.flake8"                          # Flake8 linter
    "ms-python.black-formatter"                 # Black formatter
    "eamodio.gitlens"                           # Git integration
    "ms-azuretools.vscode-docker"              # Docker support
    "ms-vscode.makefile-tools"                  # Makefile support
    "Thunder.cloud"                             # Thunder Client for API testing
    "humao.rest-client"                         # REST Client extension
)

for ext in "${EXTENSIONS[@]}"; do
    echo "Installing extension: $ext"
    code-server --install-extension "$ext" || true
done

echo "✓ All extensions installed"
EOF

chmod +x /home/coder/install-vscode-extensions.sh
chown coder:coder /home/coder/install-vscode-extensions.sh

# Add coder to docker group
RUN usermod -aG docker coder

# Switch to coder user
USER coder

# Set working directory
WORKDIR /home/coder

# Startup script
COPY --chown=coder:coder startup.sh /home/coder/startup.sh
RUN chmod +x /home/coder/startup.sh

CMD ["/home/coder/startup.sh"]
