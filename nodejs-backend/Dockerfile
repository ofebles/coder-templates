FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install base dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    wget \
    git \
    zip \
    unzip \
    ca-certificates \
    sudo \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Create coder user with sudo access
RUN useradd -m -s /bin/bash coder && \
    mkdir -p /home/coder/project && \
    chown -R coder:coder /home/coder && \
    echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/coder && \
    chmod 440 /etc/sudoers.d/coder

# Switch to coder user
USER coder
WORKDIR /home/coder

# Install NVM (Node Version Manager)
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Install Node.js 20 LTS and npm/yarn
RUN bash -c 'source $HOME/.nvm/nvm.sh && \
    nvm install 20.11.0 && \
    nvm use 20.11.0 && \
    nvm alias default 20.11.0 && \
    npm install -g yarn pnpm'

# Verify installations
RUN bash -c 'source $HOME/.nvm/nvm.sh && \
    node --version && \
    npm --version && \
    yarn --version && \
    pnpm --version'

# Set environment for interactive shells
ENV NVM_DIR="/home/coder/.nvm"
ENV PATH="$NVM_DIR/versions/node/v20.11.0/bin:$PATH"

# Create VSCode extensions directory
RUN mkdir -p /home/coder/.local/share/code-server/extensions && \
    mkdir -p /home/coder/.config/code-server

# Create extension install script
RUN cat > /home/coder/install-vscode-extensions.sh <<'EOF'
#!/bin/bash
# Install VSCode extensions for Backend development
EXTENSIONS=(
    "dbaeumer.vscode-eslint"
    "esbenp.prettier-vscode"
    "ms-vscode.vscode-typescript-next"
    "ms-azuretools.vscode-docker"
    "eamodio.gitlens"
    "humao.rest-client"
    "rangav.vscode-thunder-client"
    "mongodb.mongodb-vscode"
    "cweijan.vscode-postgresql-client2"
    "formulahendry.code-runner"
    "tamasfe.even-better-toml"
)

echo "Installing VSCode extensions for backend development..."
for ext in "${EXTENSIONS[@]}"; do
    echo "Installing $ext..."
    code-server --install-extension "$ext" || true
done
echo "VSCode extensions installation complete!"
EOF

RUN chmod +x /home/coder/install-vscode-extensions.sh

WORKDIR /home/coder

CMD ["/bin/bash"]
