FROM ubuntu:22.04

# Set non-interactive mode
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    # Base utilities
    curl \
    wget \
    git \
    build-essential \
    ca-certificates \
    gnupg \
    lsb-release \
    apt-transport-https \
    # Network tools
    net-tools \
    iputils-ping \
    dnsutils \
    # Text editors
    vim \
    nano \
    # Development tools
    unzip \
    jq \
    tmux \
    openssh-client \
    && rm -rf /var/lib/apt/lists/*

# Install Java 21 (Eclipse Temurin)
RUN apt-get update && apt-get install -y \
    openjdk-21-jdk-headless \
    && rm -rf /var/lib/apt/lists/*

# Install Maven
RUN apt-get update && apt-get install -y \
    maven \
    && rm -rf /var/lib/apt/lists/*

# Install Docker CLI (for Docker-in-Docker support)
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list \
    && apt-get update && apt-get install -y docker-ce-cli \
    && rm -rf /var/lib/apt/lists/*

# Install OpenCode CLI
RUN curl -fsSL https://install.opencode.ai | bash \
    && opencode --version || echo "OpenCode installation completed"

# Create coder user
RUN useradd -m -s /bin/bash coder && \
    mkdir -p /home/coder && \
    chown -R coder:coder /home/coder

# Set working directory
WORKDIR /home/coder

# Set environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH
ENV MAVEN_HOME=/usr/share/maven
ENV PATH=$MAVEN_HOME/bin:$PATH

# Switch to coder user
USER coder

# Print versions for verification
RUN java -version && \
    mvn -version && \
    echo "OpenCode version:" && \
    opencode --version || true

# Default command
CMD ["/bin/bash"]
