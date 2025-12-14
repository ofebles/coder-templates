FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies and development tools in one layer
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Base utilities
    ca-certificates \
    curl \
    wget \
    git \
    # Build tools
    build-essential \
    # Java and Maven
    openjdk-21-jdk-headless \
    maven \
    # Development tools
    vim \
    nano \
    unzip \
    jq \
    tmux \
    openssh-client \
    # For Coder agent
    sudo \
    # Docker CLI
    docker.io \
    # Code Server dependencies
    npm \
    # Cleanup
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Set Java environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
ENV MAVEN_HOME=/usr/share/maven
ENV PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH
ENV MAVEN_OPTS="-Xmx2048m"

# Create coder user and configure Docker access
RUN useradd -m -s /bin/bash coder && \
    usermod -aG docker coder && \
    mkdir -p /home/coder && \
    chown -R coder:coder /home/coder

# Install code-server globally
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Install VSCode extensions
RUN code-server --install-extension redhat.java || true && \
    code-server --install-extension redhat.vscode-xml || true && \
    code-server --install-extension vscjava.vscode-maven || true && \
    code-server --install-extension vscjava.vscode-spring-boot || true && \
    code-server --install-extension vscjava.vscode-lombok || true && \
    code-server --install-extension ms-azuretools.vscode-docker || true && \
    code-server --install-extension eamodio.gitlens || true

# Configure code-server
RUN mkdir -p /home/coder/.config/code-server && \
    cat > /home/coder/.config/code-server/config.yaml <<'EOF'
bind-addr: 0.0.0.0:8443
auth: none
cert: false
EOF

# Switch to coder user
USER coder
WORKDIR /home/coder

# Expose ports
EXPOSE 8080 8443 5000

# Default command
CMD ["/bin/bash"]
