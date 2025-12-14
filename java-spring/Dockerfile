FROM codercom/enterprise-base:ubuntu

# Install Java 21 and Maven
RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-21-jdk-headless \
    maven \
    && rm -rf /var/lib/apt/lists/*

# Set Java environment
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

# Create project directory
RUN mkdir -p /home/coder/project && chown -R coder:coder /home/coder/project

WORKDIR /home/coder
