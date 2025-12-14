#!/bin/bash

# Initialize SDKMAN for interactive shells
source $HOME/.sdkman/bin/sdkman-init.sh

# ============================================================================
# Handle version parameters
# ============================================================================

# Get versions from environment (set by Terraform parameters)
KOTLIN_VERSION="${KOTLIN_VERSION:-1.9.21}"
GRADLE_VERSION="${GRADLE_VERSION:-8.5}"

echo "Setting up tools with user-selected versions..."
echo "Kotlin Version: $KOTLIN_VERSION"
echo "Gradle Version: $GRADLE_VERSION"

# Install Kotlin if not already installed
if ! sdk list kotlin | grep -q "$KOTLIN_VERSION"; then
    echo "Installing Kotlin $KOTLIN_VERSION..."
    sdk install kotlin "$KOTLIN_VERSION" --yes
fi

# Install Gradle if not already installed
if ! sdk list gradle | grep -q "$GRADLE_VERSION"; then
    echo "Installing Gradle $GRADLE_VERSION..."
    sdk install gradle "$GRADLE_VERSION" --yes
fi

# Set defaults
sdk default kotlin "$KOTLIN_VERSION"
sdk default gradle "$GRADLE_VERSION"

# Install VSCode extensions on first startup
if [ -f "$HOME/install-vscode-extensions.sh" ] && [ ! -f "$HOME/.vscode-extensions-installed" ]; then
    echo "Installing VSCode extensions for Kotlin development..."
    bash "$HOME/install-vscode-extensions.sh"
    touch "$HOME/.vscode-extensions-installed"
fi

echo "Starting Kotlin Development Environment..."
echo "User: $(whoami)"
echo "Home: $HOME"

echo ""
echo "Installed tools:"
echo "Kotlin: $(kotlin -version 2>&1 | head -1)"
echo "Gradle: $(gradle --version 2>&1 | head -1)"
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
if [ ! -f build.gradle.kts ]; then
  echo "Creating default Kotlin project structure..."
  
  mkdir -p src/main/kotlin/com/example src/test/kotlin/com/example
  
  cat > build.gradle.kts <<'EOFGRADLE'
plugins {
    kotlin("jvm") version "1.9.21"
    application
}

group = "com.example"
version = "1.0.0"

repositories {
    mavenCentral()
}

dependencies {
    // Kotlin stdlib
    implementation(kotlin("stdlib"))
    
    // JUnit for testing
    testImplementation(kotlin("test"))
    testImplementation("junit:junit:4.13.2")
}

kotlin {
    jvmToolchain(21)
}

application {
    mainClass.set("com.example.AppKt")
}

tasks {
    test {
        useJUnit()
    }
}
EOFGRADLE

  cat > settings.gradle.kts <<'EOFSETTINGS'
rootProject.name = "kotlin-app"
EOFSETTINGS

  cat > src/main/kotlin/com/example/App.kt <<'EOFKOTLIN'
package com.example

fun main(args: Array<String>) {
    println("Hello from Kotlin in Coder!")
    println("Kotlin version: ${System.getProperty("java.version")}")
    println("Project directory: ${System.getProperty("user.dir")}")
    
    // Simple example
    val message = "Welcome to Kotlin Development"
    println(message)
}
EOFKOTLIN

  cat > src/test/kotlin/com/example/AppTest.kt <<'EOFKOTLINTEST'
package com.example

import org.junit.Test
import kotlin.test.assertEquals
import kotlin.test.assertTrue

class AppTest {
    @Test
    fun testSimpleAssertion() {
        assertTrue(true)
    }

    @Test
    fun testStringEquality() {
        val expected = "Kotlin"
        val actual = "Kotlin"
        assertEquals(expected, actual)
    }
}
EOFKOTLINTEST

  cat > .gitignore <<'EOFGIT'
# Gradle
.gradle/
build/
out/
*.class
*.jar

# IDE
.idea/
.vscode/
*.swp
*.swo
*~
.DS_Store

# Environment
.env
.env.local
.env.*.local

# Logs
logs/
*.log
EOFGIT

  echo "✓ Project structure created"
  echo ""
  echo "Downloading Gradle dependencies..."
  
  gradle build --no-daemon 2>/dev/null || true
  
  echo "✓ Initial build completed"
fi

echo ""
echo "========================================"
echo "✓ Kotlin Development Environment Ready!"
echo "========================================"
echo "Location: ~/project"
echo ""
echo "Quick start:"
echo "  cd ~/project"
echo "  gradle build"
echo "  gradle run"
echo ""
echo "Backend will be available at: http://localhost:3000"
echo ""
echo "Available commands:"
echo "  gradle build       - Build the project"
echo "  gradle run         - Run the application"
echo "  gradle test        - Run tests"
echo "  gradle clean       - Clean build artifacts"
echo "  gradle tasks       - List all available tasks"
echo ""
echo "SDKMAN available for version management:"
echo "  sdk list kotlin"
echo "  sdk install kotlin <version>"
echo "  sdk use kotlin <version>"
echo "  sdk list gradle"
echo "  sdk install gradle <version>"
echo "  sdk use gradle <version>"
echo "========================================"
