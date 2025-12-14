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

# Install SDKMAN
RUN curl -s "https://get.sdkman.io" | bash

# Install Kotlin and Gradle using SDKMAN
RUN bash -c '. $HOME/.sdkman/bin/sdkman-init.sh && \
    sdk install kotlin 1.9.21 --yes && \
    sdk install gradle 8.5 --yes && \
    sdk default kotlin 1.9.21 && \
    sdk default gradle 8.5'

# Verify installations
RUN bash -c '. $HOME/.sdkman/bin/sdkman-init.sh && \
    kotlin -version && \
    gradle --version'

# Set environment for interactive shells
ENV PATH="/home/coder/.sdkman/candidates/kotlin/current/bin:/home/coder/.sdkman/candidates/gradle/current/bin:$PATH"

# Create a script for installing VSCode extensions
# These will be installed when code-server starts for the first time
RUN mkdir -p /home/coder/.local/share/code-server/extensions && \
    mkdir -p /home/coder/.config/code-server

# Create extension install script that will run on startup
RUN cat > /home/coder/install-vscode-extensions.sh <<'EOF'
#!/bin/bash
# Install VSCode extensions for Kotlin development
EXTENSIONS=(
    "fwcd.kotlin"
    "gradle.gradle-language-pack"
    "microsoft.vscode-gradle"
    "ms-azuretools.vscode-docker"
    "eamodio.gitlens"
    "ms-vscode.debugger-for-java"
    "vscjava.vscode-java-debug"
    "ms-vscode.extension-pack-java"
)

echo "Installing VSCode extensions for Kotlin development..."
for ext in "${EXTENSIONS[@]}"; do
    echo "Installing $ext..."
    code-server --install-extension "$ext" || true
done
echo "VSCode extensions installation complete!"
EOF

RUN chmod +x /home/coder/install-vscode-extensions.sh

WORKDIR /home/coder

CMD ["/bin/bash"]
