FROM codercom/enterprise-base:ubuntu

# Install Java 21 and Maven
RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-21-jdk-headless \
    maven \
    && rm -rf /var/lib/apt/lists/*

# Set Java environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
ENV MAVEN_HOME=/usr/share/maven
ENV PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH
ENV MAVEN_OPTS="-Xmx2048m"

# Create project directory
RUN mkdir -p /home/coder/project && \
    chown -R coder:coder /home/coder/project

WORKDIR /home/coder

CMD ["/bin/bash"]
