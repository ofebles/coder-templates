# Java Development Template for Coder

A complete, production-ready development environment for Java projects with flexible versioning, integrated IDE support, Docker-in-Docker, and developer tools. Supports any Java framework (Spring Boot, Quarkus, Micronaut, etc.) or plain Java applications.

## Features

- **Flexible Java Versions** - Choose Java 21, 17, or 11 LTS at workspace creation
- **Flexible Maven Versions** - Choose Maven 3.9.5, 3.8.7, or 3.6.3
- **Optional Databases** - Auto-configure PostgreSQL, MongoDB, and/or Redis via docker-compose
- **Git Repository Cloning** - Automatically clone your project repo on startup
- **Apache Maven** - Build automation and dependency management
- **VS Code Server** - Web-based VS Code IDE with Java extensions
- **JetBrains IntelliJ IDEA** - Full-featured Java IDE
- **JetBrains Fleet** - Lightweight JetBrains IDE
- **Docker-in-Docker** - Build and run containers within workspace
- **Code Server Extensions** - Pre-installed Java, Maven, Docker, and Git extensions
- **Framework Agnostic** - Works with Spring Boot, Quarkus, Micronaut, or any Maven-based Java project

## Getting Started

### 1. Create a Workspace from Template

In your Coder instance at https://coder.ofebles.dev/:

1. Click **Create Workspace**
2. Select **Java** template
3. **Configure parameters** (optional):
   - **Java Version**: Select 21 (default), 17, or 11 LTS
   - **Maven Version**: Select 3.9.5 (default), 3.8.7, or 3.6.3
   - **Git Repository (Optional)**: Paste URL of repo to clone (e.g., `https://github.com/user/repo.git`)
   - **Git Branch (Optional)**: Specify branch (default: `main`)
4. Click **Create Workspace**

The workspace will be provisioned in 2-3 minutes.

### Customization Examples

**Example 1: Java 17 + Maven 3.8.7 (Legacy Project)**
```
Java Version:  Java 17 (LTS)
Maven Version: Maven 3.8.7
Git Repo:      your-legacy-app.git
Git Branch:    main
```
→ Workspace ready for legacy Java projects

**Example 2: Java 21 + Latest Maven (Modern Development)**
```
Java Version:  Java 21 (LTS - Recommended)
Maven Version: Maven 3.9.5 (Latest)
Git Repo:      (leave empty)
Git Branch:    (leave empty)
```
→ Fresh workspace with latest tools + default Java structure

**Example 3: Spring Boot Project**
```
Java Version:  Java 21 (LTS)
Maven Version: Maven 3.9.5
Git Repo:      https://github.com/yourorg/spring-app.git
Git Branch:    develop
```
→ Workspace with your Spring Boot project auto-cloned

**Example 4: Quarkus Project**
```
Java Version:  Java 21
Maven Version: Maven 3.9.5
Git Repo:      https://github.com/yourorg/quarkus-app.git
```
→ Workspace optimized for Quarkus development

### 2. Access Your Development Environment

Once running, you'll see three applications:

- **VS Code** - Click to open VS Code Server
- **JetBrains IntelliJ IDEA** - Click to open IntelliJ  
- **JetBrains Fleet** - Click to open Fleet (lightweight alternative)

### 3. Start Developing

```bash
# Navigate to your project
cd ~/project

# Build with Maven
mvn clean install

# Run your application
mvn spring-boot:run              # For Spring Boot
mvn quarkus:dev                  # For Quarkus
java -jar target/app.jar         # For packaged apps
```

## Project Structure

When you create a workspace without a Git repository, a default Maven project structure is created:

```
workspace/
├── Dockerfile              # Container image definition
├── main.tf                 # Coder workspace configuration
├── startup.sh              # Environment initialization script
├── project/                # Your Java project
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/
│   │   │   └── resources/
│   │   └── test/
│   │       └── java/
│   ├── pom.xml            # Maven configuration
│   └── target/            # Build output
└── README.md              # This file
```

## System Requirements

- **CPU**: 2+ cores
- **Memory**: 2+ GB (4GB recommended)
- **Disk**: 20+ GB free

## Template Parameters

When creating a workspace, you can customize:

### Java Version
- **Java 21 LTS** (Recommended - Latest)
- **Java 17 LTS** (Stable)
- **Java 11 LTS** (Legacy projects)

Selected version is automatically installed via SDKMAN and set as default.

### Maven Version
- **Maven 3.9.5** (Latest - Recommended)
- **Maven 3.8.7** (Stable)
- **Maven 3.6.3** (Legacy projects)

Selected version is automatically installed via SDKMAN and set as default.

### Git Repository (Optional)
Paste a Git repository URL to automatically clone it into your workspace:
```
https://github.com/yourorg/your-project.git
```

The repo will be cloned to `/home/coder/project` with full history.

### Git Branch (Optional)
Specify which branch to checkout (default: `main`):
```
develop
feature/my-feature
v1.2.3
```

### Databases (Optional)
Pre-configure Docker services for your project:
- **None** - No databases (default)
- **PostgreSQL Only** - PostgreSQL 16 on port 5432
- **MongoDB Only** - MongoDB 7 on port 27017
- **Redis Only** - Redis 7 on port 6379
- **PostgreSQL + MongoDB**
- **PostgreSQL + Redis**
- **MongoDB + Redis**
- **All** - PostgreSQL, MongoDB, and Redis together

When you select databases, a `docker-compose.yml` file is automatically generated. Start services with:
```bash
docker-compose up -d
```

**Database Connection Details:**

PostgreSQL:
```
Host: localhost
Port: 5432
User: postgres
Password: postgres
Database: appdb
```

MongoDB:
```
Host: localhost
Port: 27017
User: root
Password: password
```

Redis:
```
Host: localhost
Port: 6379
```

---

## Pre-configured Tools

### Java & Maven

```bash
# Check versions
java -version
mvn -version

# Versions are configured with Java 21 and Maven 3.9.5 by default
# Change via template parameters during workspace creation
```

### VS Code Extensions

Pre-installed extensions:

- **Red Hat Java** (`redhat.java`) - Language Support for Java (OpenJDK)
- **XML Support** (`redhat.vscode-xml`) - XML language support
- **Extension Pack for Java** (`ms-vscode.extension-pack-java`) - Popular extensions for Java development
- **Maven for Java** (`vscjava.vscode-maven`) - Maven project support
- **Spring Boot Extension Pack** (`vscjava.vscode-spring-boot`) - Spring development support
- **Lombok Annotations** (`vscjava.vscode-lombok`) - Lombok annotation support
- **Docker** (`ms-azuretools.vscode-docker`) - Docker commands and integration
- **GitLens** (`eamodio.gitlens`) - Advanced Git integration and visualization

**Note**: Extensions are installed automatically the first time code-server starts. If an extension fails to install, you can manually install it via the VS Code marketplace.

Install additional extensions from the VS Code marketplace as needed for your workflow.

### Docker-in-Docker

You can build and run Docker containers from within your workspace:

```bash
# Build a Docker image
docker build -t my-app:latest .

# Run a container
docker run -d my-app:latest
```

## Common Development Tasks

### Build Your Project

```bash
cd ~/project

# Full clean build
mvn clean install

# Fast build (skip tests)
mvn clean install -DskipTests

# Compile only
mvn clean compile
```

### Run Your Application

```bash
cd ~/project

# Spring Boot
mvn spring-boot:run

# Quarkus
mvn quarkus:dev

# Micronaut
mvn micronaut:run

# Plain Java JAR
java -jar target/app.jar

# With custom JVM options
java -Xmx2048m -Xms1024m -jar target/app.jar
```

### Run Tests

```bash
cd ~/project

# All tests
mvn test

# Specific test class
mvn test -Dtest=MyTest

# Specific test method
mvn test -Dtest=MyTest#myMethod

# Skip tests during build
mvn install -DskipTests
```

### Create Executable JAR

```bash
cd ~/project

# Standard JAR with Maven Assembly Plugin
mvn clean package

# Or use Spring Boot Maven Plugin
mvn spring-boot:build-image

# Or build with shade/uber JAR
mvn clean package shade:shade
```

### Build Docker Image

```bash
cd ~/project

# Using Spring Boot Maven plugin
mvn spring-boot:build-image

# Or create your own Dockerfile
docker build -t my-java-app:1.0.0 .
```

### Debug Application

In **VS Code**:

1. Open Run and Debug (Ctrl+Shift+D)
2. Click "Create a launch.json file"
3. Select "Java" configuration
4. Start debugging with breakpoints

In **JetBrains IntelliJ**:

1. Set breakpoints in your code
2. Right-click main class → Debug
3. Use debugger controls

## Workspace Persistence

Your project files in `/home/coder/project` are persisted across workspace rebuilds using a Docker volume. Your work is safe!

## Terminal Access

Use the integrated terminal in VS Code or IntelliJ to run commands:

- Maven builds
- Git operations
- Custom scripts
- Docker commands
- Java CLI tools

## Troubleshooting

### Application Won't Start

Check logs in the terminal:

```bash
cd ~/project
mvn spring-boot:run
```

Look for error messages and check your code.

### Out of Memory

The container has 4GB allocated. If you need more:

1. Edit workspace settings in Coder
2. Increase memory allocation
3. Restart workspace

### Maven Dependencies Won't Download

Clear Maven cache:

```bash
rm -rf ~/.m2/repository
mvn clean install -U
```

### Port Already in Use

Change port in your application:

**For Spring Boot** in `application.properties`:
```properties
server.port=8081
```

**For Quarkus** in `application.properties`:
```properties
quarkus.http.port=8081
```

**For other Java apps**, pass as JVM argument:
```bash
java -Dport=8081 -jar target/app.jar
```

Then access at http://localhost:8081

### SDKMAN Installation Issues

If Java or Maven installation fails:

```bash
# Verify SDKMAN is initialized
source ~/.sdkman/bin/sdkman-init.sh

# List available versions
sdk list java
sdk list maven

# Force reinstall
sdk remove java 21.0.1-tem
sdk install java 21.0.1-tem --yes
```

## Performance Tips

1. **Use VS Code** - Lighter than full IntelliJ
2. **Enable incremental compilation** - Faster rebuilds
3. **Use Framework DevTools** - Spring Boot DevTools, Quarkus Live Reload
4. **Keep dependencies minimal** - Fewer dependencies = faster builds
5. **Use Maven offline mode** - `mvn -o clean install` (after first full build)

## Java Frameworks Supported

This template works with any Maven-based Java framework:

### Popular Options

- **Spring Boot** - Enterprise applications
- **Quarkus** - Cloud-native, fast startup
- **Micronaut** - Lightweight, fast startup
- **Dropwizard** - RESTful web services
- **Play Framework** - Web applications
- **Vert.x** - Reactive applications
- **Helidon** - Lightweight cloud-native
- **Plain Maven** - Any custom Java project

Each requires different setup in `pom.xml`, which you control.

## Git Integration

Initialize or clone a repository:

```bash
# Initialize new repo
cd ~/project
git init
git config user.name "Your Name"
git config user.email "your@email.com"
git add .
git commit -m "Initial commit"

# Or clone existing
cd ~
git clone https://github.com/yourrepo/your-project.git
cd your-project
```

GitLens extension provides visualization of commits and blame.

## Environment Variables

The agent sets up Git configuration automatically:

```bash
echo $GIT_AUTHOR_NAME
echo $GIT_AUTHOR_EMAIL
echo $GIT_COMMITTER_NAME
echo $GIT_COMMITTER_EMAIL
```

## Support & Documentation

- [Java Documentation](https://docs.oracle.com/en/java/)
- [Maven Documentation](https://maven.apache.org/guides/)
- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Quarkus Documentation](https://quarkus.io/guides/)
- [Micronaut Documentation](https://docs.micronaut.io/)
- [Coder Documentation](https://coder.com/docs)
- [VS Code Java Guide](https://code.visualstudio.com/docs/languages/java)
- [JetBrains IntelliJ Help](https://www.jetbrains.com/help/idea/)

## Template Information

- **Base Image**: Ubuntu 22.04
- **Java Versions**: 21 LTS (default), 17 LTS, 11 LTS
- **Maven Versions**: 3.9.5 (default), 3.8.7, 3.6.3
- **Version Manager**: SDKMAN
- **Code Server**: Latest with Java extensions
- **Memory**: 4GB default
- **Disk**: 50GB default

## Tips & Tricks

- Use **Cmd/Ctrl + Shift + P** in VS Code to access command palette
- Use **Cmd/Ctrl + `** to toggle integrated terminal
- Enable dark mode in Code Server settings
- Customize extensions for your workflow
- Use Maven profiles for different environments (dev, test, prod)
- Set up `.mvn/maven.config` for common options
- Use `.mavenrc` for environment-specific settings

## Contributing

Found an issue or want to improve this template? Visit:
https://github.com/ofebles/coder-templates

---

**Happy coding!** 🚀

For questions or feedback about this template, visit: https://github.com/ofebles/coder-templates
