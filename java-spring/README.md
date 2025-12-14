# Java Spring Boot Development Template for Coder

A complete, production-ready development environment for Java Spring Boot applications with integrated IDE support, Docker-in-Docker, and developer tools.

## Features

- **Java 21 LTS** - Latest long-term support version
- **Apache Maven** - Build automation and dependency management
- **Spring Boot 3.2** - Modern Spring framework
- **VS Code Server** - Web-based VS Code IDE with Java extensions
- **JetBrains Fleet** - Lightweight JetBrains IDE
- **Docker-in-Docker** - Build and run containers within workspace
- **Code Server Extensions** - Pre-installed Java, Spring Boot, Docker, and Git extensions

## Getting Started

### 1. Create a Workspace from Template

In your Coder instance at https://coder.ofebles.dev/:

1. Click **Create Workspace**
2. Select **Java Spring Boot** template
3. Configure workspace settings (optional)
4. Click **Create Workspace**

The workspace will be provisioned in 2-3 minutes.

### 2. Access Your Development Environment

Once running, you'll see three applications:

- **VS Code** - Click to open VS Code Server
- **JetBrains Fleet** - Click to open Fleet IDE  
- **Spring Boot App** - Accessible at http://localhost:8080

### 3. Start Developing

```bash
# Navigate to your project
cd ~/project

# Build with Maven
mvn clean install

# Run the application
mvn spring-boot:run

# Or run the JAR directly
java -jar target/springboot-app-1.0.0.jar
```

## Project Structure

```
workspace/
├── Dockerfile              # Container image definition
├── terraform/              # Coder workspace configuration
│   └── main.tf            # Terraform configuration
│   └── startup.sh         # Environment initialization script
├── project/               # Your Spring Boot project
│   ├── src/              
│   ├── pom.xml           
│   └── ...               
└── README.md              # This file
```

## System Requirements

- **CPU**: 2+ cores
- **Memory**: 2+ GB (4GB recommended)
- **Disk**: 20+ GB free

## Pre-configured Tools

### Java & Maven

```bash
# Check versions
java -version
mvn -version

# Maven is configured with:
# - MAVEN_OPTS: -Xmx2048m (2GB heap)
# - Java version: 21
```

### VS Code Extensions

The following extensions are automatically installed on first workspace startup:

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

### Create a New Spring Boot Project

If you need a fresh project:

```bash
cd ~/project
mvn archetype:generate \
  -DgroupId=com.mycompany \
  -DartifactId=my-spring-app \
  -DarchetypeArtifactId=maven-archetype-quickstart
```

### Build and Run

```bash
mvn clean install
mvn spring-boot:run
```

### Run Tests

```bash
mvn test
```

### Create Executable JAR

```bash
mvn clean package
java -jar target/springboot-app-1.0.0.jar
```

### Build Docker Image

```bash
# Using Spring Boot maven plugin
mvn spring-boot:build-image

# Or create your own Dockerfile
docker build -t my-spring-app:1.0.0 .
```

### Debug Application

In **VS Code**:

1. Open Run and Debug (Ctrl+Shift+D)
2. Click "Create a launch.json file"
3. Select "Java" configuration
4. Start debugging

In **JetBrains Fleet**:

1. Set breakpoints in your code
2. Right-click main class → Debug
3. Use debugger controls

## Workspace Persistence

Your project files in `/home/coder/project` are persisted across workspace rebuilds using a Docker volume. Your work is safe!

## Terminal Access

Use the integrated terminal in VS Code or Fleet to run commands:

- Maven builds
- Git operations
- Custom scripts
- Docker commands

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

Change Spring Boot port in `application.properties`:

```properties
server.port=8081
```

Then access at http://localhost:8081

## Performance Tips

1. **Use Code Server** - Lighter than full IDE
2. **Enable incremental compilation** in Maven
3. **Use Spring Boot DevTools** for faster reload
4. **Keep dependencies minimal**

## Spring Boot with External Database

To use an external PostgreSQL database:

1. Update `application.properties`:

```properties
spring.datasource.url=jdbc:postgresql://your-db-host:5432/dbname
spring.datasource.username=user
spring.datasource.password=pass
spring.jpa.hibernate.ddl-auto=update
```

2. Add PostgreSQL driver dependency in `pom.xml`:

```xml
<dependency>
    <groupId>org.postgresql</groupId>
    <artifactId>postgresql</artifactId>
    <scope>runtime</scope>
</dependency>
```

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

## Support & Documentation

- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Maven Documentation](https://maven.apache.org/guides/)
- [Coder Documentation](https://coder.com/docs)
- [VS Code Java Guide](https://code.visualstudio.com/docs/languages/java)
- [JetBrains Fleet Help](https://www.jetbrains.com/help/fleet/)

## Template Information

- **Base Image**: Ubuntu 22.04
- **Java Version**: 21 LTS
- **Maven Version**: Latest from Ubuntu repos
- **Code Server**: Latest
- **Memory**: 4GB default
- **Disk**: 50GB default

## Tips & Tricks

- Use **Cmd/Ctrl + Shift + P** in VS Code to access command palette
- Use **Cmd/Ctrl + `** to toggle integrated terminal
- Enable dark mode in Code Server settings
- Customize extensions for your workflow
- Use Maven profiles for different environments

---

**Happy coding!** 🚀

For issues or questions about this template, visit: https://github.com/ofebles/coder-templates
