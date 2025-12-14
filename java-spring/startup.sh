#!/bin/bash

set -e

echo "Starting Java Spring Development Environment..."

# Update system packages
apt-get update
apt-get install -y --no-install-recommends \
  openjdk-21-jdk-headless \
  maven \
  curl \
  wget \
  git \
  build-essential \
  ca-certificates

# Create project directory
mkdir -p /home/coder/project
cd /home/coder/project

# Initialize default project structure if empty
if [ ! -f pom.xml ]; then
  echo "Creating default Spring Boot project structure..."
  
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
        return "Hello from Spring Boot in Coder!";
    }
    
    @GetMapping("/health")
    public String health() {
        return "OK";
    }
}
EOFJAVA

  cat > src/main/resources/application.properties <<'EOFPROPS'
spring.application.name=springboot-app
server.port=8080
EOFPROPS
fi

# Download Maven dependencies
echo "Downloading Maven dependencies..."
mvn dependency:resolve -q || true

echo "Environment setup complete!"
echo "Java version:"
java -version
echo ""
echo "Maven version:"
mvn -version
