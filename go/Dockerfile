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
    software-properties-common \
    apt-transport-https \
    docker.io \
    && rm -rf /var/lib/apt/lists/*

# Create coder user
RUN useradd -m -s /bin/bash coder

# Create necessary directories
RUN mkdir -p /home/coder/project && \
    mkdir -p /home/coder/.local/bin && \
    chown -R coder:coder /home/coder

# Add local bin to PATH
RUN echo 'export PATH="/home/coder/.local/bin:$PATH"' >> /home/coder/.bashrc

# Install vscode-extensions script helper
RUN cat > /home/coder/install-vscode-extensions.sh <<'EOF'
#!/bin/bash
set -e

# Go extensions for VS Code
EXTENSIONS=(
    "golang.go"                             # Go language support
    "golang.codelens-separated"             # Go CodeLens
    "ms-vscode.makefile-tools"              # Makefile support
    "eamodio.gitlens"                       # Git integration
    "ms-azuretools.vscode-docker"          # Docker support
    "humao.rest-client"                     # REST Client extension
    "Thunder.cloud"                         # Thunder Client for API testing
    "golangci-lint.golangci-lint"           # GolangCI-Lint integration
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
