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
    && rm -rf /var/lib/apt/lists/*

# Create coder user
RUN useradd -m -s /bin/bash coder && \
    mkdir -p /home/coder/project && \
    chown -R coder:coder /home/coder

# Switch to coder user
USER coder
WORKDIR /home/coder

# Install SDKMAN
RUN curl -s "https://get.sdkman.io" | bash

# Install Java 21 and Maven using SDKMAN
# We need to use a single RUN command with proper shell sourcing
RUN bash -c '. $HOME/.sdkman/bin/sdkman-init.sh && \
    sdk install java 21.0.1-tem --yes && \
    sdk install maven 3.9.5 --yes && \
    sdk default java 21.0.1-tem && \
    sdk default maven 3.9.5'

# Verify installations
RUN bash -c '. $HOME/.sdkman/bin/sdkman-init.sh && \
    java -version && \
    mvn -version'

# Set environment for interactive shells
ENV PATH="/home/coder/.sdkman/candidates/java/current/bin:/home/coder/.sdkman/candidates/maven/current/bin:$PATH"

WORKDIR /home/coder

CMD ["/bin/bash"]
