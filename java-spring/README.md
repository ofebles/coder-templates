# Java Spring Boot Development Template for Coder

A complete, production-ready development environment for Java Spring Boot applications with integrated IDE support and database services.

## Features

- **Java 21 LTS** - Latest long-term support version
- **Apache Maven** - Build automation and dependency management
- **Spring Boot 3.2** - Modern Spring framework
- **VS Code Server** - Web-based VS Code IDE
- **JetBrains Fleet** - Lightweight JetBrains IDE
- **PostgreSQL 16** - Production-grade database
- **Redis 7** - In-memory data store
- **Docker-in-Docker** - Run containers within the workspace
- **OpenCode CLI** - Advanced development tools
- **pgAdmin** - PostgreSQL management UI

## Quick Start

### 1. Create a Workspace in Coder

Using Terraform:

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

Using Docker Compose (for local testing):

```bash
docker-compose up -d
```

### 2. Access Your Development Environment

Once the workspace is running:

- **VS Code**: http://localhost:8443
- **JetBrains Fleet**: http://localhost:5000
- **Spring Boot App**: http://localhost:8080
- **PostgreSQL**: localhost:5432
- **Redis**: localhost:6379
- **pgAdmin**: http://localhost:5050

### 3. Build and Run Your Spring Boot Application

```bash
# Navigate to project
cd ~/project

# Build the project
mvn clean install

# Run the application
mvn spring-boot:run

# Or run the JAR
java -jar target/springboot-app-1.0.0.jar
```

## Project Structure

```
java-spring/
├── Dockerfile              # Docker image definition
├── docker-compose.yml      # Multi-container orchestration
├── README.md              # This file
├── terraform/             # Coder workspace configuration
│   └── main.tf           # Terraform configuration
├── init-scripts/          # Startup scripts
│   └── startup.sh        # Environment initialization
└── .coder/               # Coder-specific configuration
    └── config.yaml       # Workspace metadata
```

## System Requirements

### Minimum
- 4 CPU cores
- 4 GB RAM
- 50 GB disk space

### Recommended
- 8 CPU cores
- 8 GB RAM
- 100 GB disk space

## Environment Variables

The workspace comes pre-configured with:

```
JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
MAVEN_HOME=/usr/share/maven
MAVEN_OPTS=-Xmx2048m
SPRING_PROFILES_ACTIVE=dev
POSTGRES_HOST=postgres
POSTGRES_PORT=5432
POSTGRES_DB=springdb
POSTGRES_USER=coder
POSTGRES_PASSWORD=coder
```

## Database Configuration

### PostgreSQL

Default connection string:
```
jdbc:postgresql://postgres:5432/springdb
Username: coder
Password: coder
```

Create additional databases:

```bash
docker exec java-spring-postgres psql -U coder -d springdb -c "CREATE DATABASE myapp;"
```

### Redis

Redis is available at `redis://redis:6379`

```bash
docker exec -it java-spring-redis redis-cli
```

## IDE Setup

### VS Code

Pre-installed extensions:
- **Java Extension Pack** - RedHat Java support
- **Spring Boot Extension Pack**
- **Maven for Java**
- **Git Lens**
- **Docker support**

Install additional extensions from the marketplace.

### JetBrains Fleet

JetBrains Fleet provides a lightweight, modern development experience with intelligent code completion and refactoring tools.

Access at: http://localhost:5000

## Common Tasks

### Debug Spring Boot Application

In VS Code, create `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "java",
      "name": "Spring Boot App",
      "request": "launch",
      "mainClass": "com.example.Application",
      "projectName": "springboot-app",
      "args": "",
      "cwd": "${workspaceFolder}",
      "console": "integratedTerminal",
      "preLaunchTask": "maven: clean"
    }
  ]
}
```

### Create a New Spring Boot Project

```bash
cd ~/project
mvn archetype:generate \
  -DgroupId=com.example \
  -DartifactId=my-app \
  -DarchetypeArtifactId=maven-archetype-quickstart \
  -DinteractiveMode=false
```

### Run Tests

```bash
mvn test
```

### Build Docker Image for Your App

```bash
# In your project directory
mvn spring-boot:build-image
```

### Push to Registry

```bash
docker tag springboot-app:1.0.0 your-registry/springboot-app:1.0.0
docker push your-registry/springboot-app:1.0.0
```

## Troubleshooting

### Port Already in Use

If ports are already bound, modify `docker-compose.yml`:

```yaml
ports:
  - "8081:8080"  # Change host port
  - "8444:8443"  # Change VSCode port
  - "5001:5000"  # Change Fleet port
```

### Insufficient Disk Space

Increase the volume size in `docker-compose.yml`:

```yaml
volumes:
  postgres_data:
    driver_opts:
      type: tmpfs
      size: 20Gi
```

### PostgreSQL Connection Failed

Check PostgreSQL is running:

```bash
docker-compose ps postgres
docker-compose logs postgres
```

Verify connection:

```bash
docker exec java-spring-postgres psql -U coder -d springdb -c "SELECT 1"
```

### Memory Issues

Increase heap size:

```bash
export MAVEN_OPTS="-Xmx4096m"
export _JAVA_OPTIONS="-Xmx4096m"
```

## Performance Tips

1. **Use Maven offline mode** after first build:
   ```bash
   mvn clean install -o
   ```

2. **Enable Maven parallel builds**:
   ```bash
   mvn -T 1C install
   ```

3. **Use Spring Boot devtools** for faster development:
   ```xml
   <dependency>
       <groupId>org.springframework.boot</groupId>
       <artifactId>spring-boot-devtools</artifactId>
       <scope>runtime</scope>
       <optional>true</optional>
   </dependency>
   ```

4. **Limit Docker resource usage** in `docker-compose.yml`:
   ```yaml
   deploy:
     resources:
       limits:
         cpus: '4'
         memory: 4G
   ```

## Support and Documentation

- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Maven Documentation](https://maven.apache.org/guides/)
- [Coder Documentation](https://coder.com/docs)
- [VS Code Documentation](https://code.visualstudio.com/docs)
- [JetBrains Fleet Documentation](https://www.jetbrains.com/help/fleet/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

## License

This template is provided as-is for use with Coder.

## Contributing

Feel free to fork and customize this template for your specific needs.

---

**Happy Coding!** 🚀

For more information about Coder templates, visit: https://coder.com/docs/templates
