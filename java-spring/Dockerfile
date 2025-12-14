FROM eclipse-temurin:21-jdk-jammy

# Install Maven and other utilities
RUN apt-get update && apt-get install -y --no-install-recommends \
    maven \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create coder user and home
RUN useradd -m -s /bin/bash coder && \
    mkdir -p /home/coder/project && \
    chown -R coder:coder /home/coder

# Set environment
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH=$JAVA_HOME/bin:$PATH

WORKDIR /home/coder
USER coder

CMD ["/bin/bash"]
