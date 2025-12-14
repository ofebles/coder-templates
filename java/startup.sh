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

echo "Starting Java Development Environment..."
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
  echo "Creating default Java project structure..."
  
  mkdir -p src/main/java/com/example src/main/resources src/test/java/com/example
  
  cat > pom.xml <<'EOFPOM'
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.example</groupId>
    <artifactId>java-app</artifactId>
    <version>1.0.0</version>
    <packaging>jar</packaging>

    <name>Java Application</name>
    <description>Java Application Template for Coder</description>

    <properties>
        <java.version>21</java.version>
        <maven.compiler.source>21</maven.compiler.source>
        <maven.compiler.target>21</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <maven.compiler.release>21</maven.compiler.release>
    </properties>

    <dependencies>
        <!-- Add your dependencies here -->
        <!-- Examples: -->
        <!-- Spring Boot: https://spring.io/projects/spring-boot -->
        <!-- Quarkus: https://quarkus.io/ -->
        <!-- Micronaut: https://micronaut.io/ -->
        
        <!-- JUnit for testing -->
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.13.2</version>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <!-- Maven Compiler Plugin -->
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.11.0</version>
                <configuration>
                    <source>21</source>
                    <target>21</target>
                    <release>21</release>
                </configuration>
            </plugin>
            
            <!-- Maven Shade Plugin for uber JARs -->
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-shade-plugin</artifactId>
                <version>3.5.0</version>
                <!-- Uncomment to create executable JAR:
                <executions>
                    <execution>
                        <phase>package</phase>
                        <goals>
                            <goal>shade</goal>
                        </goals>
                        <configuration>
                            <transformers>
                                <transformer implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
                                    <mainClass>com.example.App</mainClass>
                                </transformer>
                            </transformers>
                        </configuration>
                    </execution>
                </executions>
                -->
            </plugin>
        </plugins>
    </build>
</project>
EOFPOM

  cat > src/main/java/com/example/App.java <<'EOFJAVA'
package com.example;

/**
 * Hello world!
 */
public class App {
    public static void main(String[] args) {
        System.out.println("Hello from Java in Coder!");
        System.out.println("Java version: " + System.getProperty("java.version"));
        System.out.println("Project directory: " + System.getProperty("user.dir"));
    }
}
EOFJAVA

  cat > src/test/java/com/example/AppTest.java <<'EOFJAVATEST'
package com.example;

import org.junit.Test;
import static org.junit.Assert.*;

/**
 * Unit test for App.
 */
public class AppTest {
    @Test
    public void shouldAnswerWithTrue() {
        assertTrue(true);
    }
}
EOFJAVATEST

  echo "✓ Project structure created"
fi

# Pre-download Maven dependencies to speed up first build
echo "Pre-downloading Maven dependencies (this may take a moment)..."
mvn dependency:resolve -q 2>/dev/null || true

echo ""
echo "========================================"
echo "✓ Java Development Environment Ready!"
echo "========================================"
echo "Location: ~/project"
echo ""
echo "Quick start:"
echo "  cd ~/project"
echo "  mvn clean install"
echo "  mvn test"
echo "  java -cp target/classes com.example.App"
echo ""
echo "For Spring Boot:"
echo "  mvn spring-boot:run"
echo ""
echo "For Quarkus:"
echo "  mvn quarkus:dev"
echo ""
echo "For packaged apps:"
echo "  mvn clean package"
echo "  java -jar target/app.jar"
echo ""
echo "SDKMAN available for version management:"
echo "  sdk list java"
echo "  sdk install java <version>"
echo "  sdk use java <version>"
echo "========================================"
