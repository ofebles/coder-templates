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

# Initialize SDKMAN and install Java 21 and Maven
RUN bash -c "source $HOME/.sdkman/bin/sdkman-init.sh && \
    sdk install java 21.0.1-tem && \
    sdk install maven 3.9.5"

# Set default versions
ENV PATH="$HOME/.sdkman/candidates/java/current/bin:$HOME/.sdkman/candidates/maven/current/bin:$PATH"

# Create startup script that sources SDKMAN
RUN echo '#!/bin/bash' > /tmp/init-sdkman.sh && \
    echo 'source $HOME/.sdkman/bin/sdkman-init.sh' >> /tmp/init-sdkman.sh && \
    chmod +x /tmp/init-sdkman.sh

WORKDIR /home/coder

CMD ["/bin/bash"]
