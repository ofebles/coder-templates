#!/bin/bash

set -e

echo "Starting Java Spring Development Environment..."

# Update system packages
apt-get update
apt-get upgrade -y

# Install VSCode Server
echo "Installing VSCode Server..."
curl -fsSL https://code-server.dev/install.sh | sh
mkdir -p ~/.config/code-server
cat > ~/.config/code-server/config.yaml <<EOF
bind-addr: 0.0.0.0:8443
auth: none
cert: false
password: ${CODER_PASSWORD:-coder}
EOF

# Install VSCode extensions for Java development
echo "Installing VSCode extensions..."
code-server --install-extension redhat.java
code-server --install-extension redhat.vscode-xml
code-server --install-extension vscjava.vscode-maven
code-server --install-extension vscjava.vscode-spring-boot
code-server --install-extension vscjava.vscode-lombok
code-server --install-extension ms-azuretools.vscode-docker
code-server --install-extension eamodio.gitlens || true

# Start VSCode Server in background
code-server > /tmp/code-server.log 2>&1 &
echo "VSCode Server started on port 8443"

# Install JetBrains Fleet
echo "Installing JetBrains Fleet..."
if [ -z "$FLEET_VERSION" ]; then
  FLEET_VERSION="latest"
fi

# Download and install Fleet
mkdir -p ~/.local/bin
wget -q -O /tmp/fleet.zip "https://download.jetbrains.com/fleet/releases/latest/fleet-linux-x86_64.tar.gz" || \
wget -q -O /tmp/fleet.zip "https://download.jetbrains.com/fleet/releases/latest/JetBrainsFleet-Linux-x64-latest.tar.gz"

if [ -f /tmp/fleet.zip ]; then
  cd ~/.local/bin
  tar -xzf /tmp/fleet.zip
  chmod +x */bin/fleet
  echo "JetBrains Fleet installed"
  
  # Start Fleet
  ~/.local/bin/*/bin/fleet > /tmp/fleet.log 2>&1 &
  echo "JetBrains Fleet started on port 5000"
else
  echo "Warning: Could not download JetBrains Fleet, skipping..."
fi

# Create project directory if it doesn't exist
mkdir -p ~/project

# Initialize Maven project if empty
if [ ! -f ~/project/pom.xml ]; then
  echo "Creating sample Spring Boot project..."
  cd ~/project
  mvn archetype:generate \
    -DgroupId=com.example \
    -DartifactId=springboot-app \
    -DarchetypeArtifactId=maven-archetype-quickstart \
    -DinteractiveMode=false || echo "Maven archetype generation skipped"
  
  # Alternative: Create a basic Spring Boot project structure
  if [ ! -d src ]; then
    mkdir -p src/main/java/com/example src/main/resources src/test/java/com/example
    
    cat > pom.xml <<'EOFPOM'
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.example</groupId>
    <artifactId>springboot-app</artifactId>
    <version>1.0.0</version>

    <name>Spring Boot Application</name>
    <description>Sample Spring Boot Application</description>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.2.0</version>
        <relativePath/>
    </parent>

    <properties>
        <java.version>21</java.version>
        <maven.compiler.source>21</maven.compiler.source>
        <maven.compiler.target>21</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-jpa</artifactId>
        </dependency>

        <dependency>
            <groupId>org.postgresql</groupId>
            <artifactId>postgresql</artifactId>
            <scope>runtime</scope>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
EOFPOM

    cat > src/main/java/com/example/Application.java <<'EOFJAVA'
package com.example;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
public class Application {

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}

@RestController
class HelloController {
    
    @GetMapping("/")
    public String hello() {
        return "Hello from Spring Boot!";
    }
    
    @GetMapping("/health")
    public String health() {
        return "OK";
    }
}
EOFJAVA

    cat > src/main/resources/application.yml <<'EOFYML'
spring:
  application:
    name: springboot-app
  jpa:
    hibernate:
      ddl-auto: update
  datasource:
    url: jdbc:postgresql://postgres:5432/springdb
    username: coder
    password: coder
    driver-class-name: org.postgresql.Driver
  
server:
  port: 8080
  servlet:
    context-path: /api
EOFYML
  fi
fi

# Download dependencies
echo "Downloading Maven dependencies..."
cd ~/project
mvn dependency:resolve || true

# Keep the container running
echo "Environment setup complete!"
echo "VSCode available at http://localhost:8443"
echo "JetBrains Fleet available at http://localhost:5000"
echo "Spring Boot will run on http://localhost:8080"

# Keep shell alive
exec "$@"
