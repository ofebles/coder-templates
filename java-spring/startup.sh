#!/bin/bash

# Initialize SDKMAN for interactive shells
source $HOME/.sdkman/bin/sdkman-init.sh

# ============================================================================
# Handle version parameters
# ============================================================================

# Get versions from environment (set by Terraform parameters)
JAVA_VERSION="${JAVA_VERSION:-21.0.1-tem}"
MAVEN_VERSION="${MAVEN_VERSION:-3.9.5}"

echo "Setting up tools with user-selected versions..."
echo "Java Version: $JAVA_VERSION"
echo "Maven Version: $MAVEN_VERSION"

# Install Java if not already installed
if ! sdk list java | grep -q "$JAVA_VERSION"; then
    echo "Installing Java $JAVA_VERSION..."
    sdk install java "$JAVA_VERSION" --yes
fi

# Install Maven if not already installed
if ! sdk list maven | grep -q "$MAVEN_VERSION"; then
    echo "Installing Maven $MAVEN_VERSION..."
    sdk install maven "$MAVEN_VERSION" --yes
fi

# Set defaults
sdk default java "$JAVA_VERSION"
sdk default maven "$MAVEN_VERSION"

# Install VSCode extensions on first startup
if [ -f "$HOME/install-vscode-extensions.sh" ] && [ ! -f "$HOME/.vscode-extensions-installed" ]; then
    echo "Installing VSCode extensions for Java/Spring development..."
    bash "$HOME/install-vscode-extensions.sh"
    touch "$HOME/.vscode-extensions-installed"
fi

echo "Starting Java Spring Development Environment..."
echo "User: $(whoami)"
echo "Home: $HOME"

echo ""
echo "Installed tools:"
echo "Java: $(java -version 2>&1 | head -1)"
echo "Maven: $(mvn -v 2>&1 | head -1)"
echo ""

# ============================================================================
# Handle Git repository cloning if provided
# ============================================================================

GIT_REPO_URL="${GIT_REPO_URL:-}"
GIT_BRANCH="${GIT_BRANCH:-main}"

if [ -n "$GIT_REPO_URL" ] && [ "$GIT_REPO_URL" != "" ]; then
    echo "Cloning repository from: $GIT_REPO_URL"
    cd $HOME
    git clone --branch "$GIT_BRANCH" "$GIT_REPO_URL" project 2>/dev/null || git clone "$GIT_REPO_URL" project
    cd $HOME/project
    if [ -n "$GIT_BRANCH" ] && [ "$GIT_BRANCH" != "main" ]; then
        git checkout "$GIT_BRANCH" 2>/dev/null || true
    fi
else
    # Create project directory if it doesn't exist
    echo "Setting up project directory..."
    mkdir -p $HOME/project
    cd $HOME/project
fi

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
    <description>Sample Spring Boot Application for Coder</description>

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
        return "Hello from Spring Boot in Coder with SDKMAN!";
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
logging.level.root=INFO
EOFPROPS

  echo "✓ Project structure created"
fi

# Pre-download Maven dependencies to speed up first build
echo "Pre-downloading Maven dependencies (this may take a moment)..."
mvn dependency:resolve -q 2>/dev/null || true

echo ""
echo "========================================"
echo "✓ Java Spring Development Environment Ready!"
echo "========================================"
echo "Location: ~/project"
echo ""
echo "Quick start:"
echo "  cd ~/project"
echo "  mvn spring-boot:run"
echo ""
echo "Access your app at: http://localhost:8080"
echo ""
echo "SDKMAN available for version management:"
echo "  sdk list java"
echo "  sdk install java <version>"
echo "  sdk use java <version>"
echo "========================================"
