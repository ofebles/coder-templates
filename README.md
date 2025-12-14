# Coder Templates Repository

A comprehensive collection of production-ready templates for Coder workspaces. Each template provides a complete development environment with tools, frameworks, databases, and IDE integrations pre-configured.

## Available Templates

### 📦 Production Templates

| Template | Purpose | Language | Frameworks | Default Versions |
|----------|---------|----------|-----------|-----------------|
| **[java](./java)** | Enterprise backend | Java | Spring Boot, Quarkus, Micronaut | Java 21, Maven 3.9.5 |
| **[kotlin](./kotlin)** | JVM development | Kotlin | Ktor, Spring Boot | Kotlin 1.9.21, Gradle 8.5 |
| **[nodejs-backend](./nodejs-backend)** | REST APIs, microservices | Node.js | Express, Fastify, Nest.js | Node 20 LTS, npm/yarn/pnpm |
| **[nodejs-frontend](./nodejs-frontend)** | Web applications | React/Node.js | React, Vue, Next.js | Node 20 LTS, Vite/Webpack |
| **[python](./python)** | Data, APIs, scripts | Python | FastAPI, Flask, Django | Python 3.11, pip |
| **[go](./go)** | High-performance services | Go | Gin, Echo, Chi | Go 1.21 |

---

## Template Selection Matrix

Choose your template based on your use case:

### 🎯 By Use Case

**Building REST APIs / Microservices:**
- **Go** - Fastest, smallest binaries, excellent for production services
- **Kotlin** - JVM performance, modern language, Spring Boot compatible
- **Python** - Rapid development with FastAPI, great for data APIs
- **Node.js Backend** - JavaScript ecosystem, npm packages
- **Java** - Enterprise-grade, mature ecosystem

**Building Web Applications:**
- **React** (Node.js Frontend) - Modern SPA, component-based
- **Python** - Full-stack with Django, Flask
- **Kotlin** - Backend + Ktor web, Spring Boot web

**Building CLIs / Utilities:**
- **Go** - Single binary, cross-platform
- **Python** - Great for scripts and automation
- **Node.js** - npm ecosystem for utilities

**Data Science / ML:**
- **Python** - Standard for ML/data science

**Enterprise Applications:**
- **Java** - Spring Boot, mature frameworks
- **Kotlin** - Modern JVM language with Spring

### ⚡ By Performance Requirements

**Ultra-High Performance:**
- **Go** - Fastest, lowest memory
- **Kotlin/Java** - JVM performance with optimizations

**High Performance:**
- **Node.js** - Fast async I/O
- **Python (FastAPI)** - Async support, good performance

**Balanced:**
- **Python (Flask)** - Good performance, rapid development
- **Node.js** - Balanced performance and development speed

### 🎓 By Learning Curve

**Easiest to Learn:**
- **Python** - Readable syntax, great for beginners
- **Node.js** - JavaScript is widely known
- **Java** - Mature, lots of tutorials

**Moderate Learning:**
- **Go** - Simple language, different paradigm
- **Kotlin** - Modern JVM, bridges Java knowledge

**Steeper Learning:**
- **None** - All templates are approachable

### 💾 By Database Preferences

All templates support optional database configuration:

| Template | PostgreSQL | MongoDB | Redis |
|----------|:----------:|:-------:|:-----:|
| Java | ✅ | ✅ | ✅ |
| Kotlin | - | - | - |
| Node.js Backend | ✅ | ✅ | ✅ |
| Node.js Frontend | - | - | - |
| Python | ✅ | ✅ | ✅ |
| Go | ✅ | ✅ | ✅ |

**Note**: Kotlin doesn't have optional database parameters yet (add as custom configuration in project)

---

## Quick Start

### 1. Choose Your Template

Use the selection matrix above or follow these simple rules:

```
If you want rapid development → Python
If you want high performance → Go
If you want JVM power → Java or Kotlin
If you want JavaScript ecosystem → Node.js
If you want web apps → Node.js Frontend or Python
```

### 2. Create Workspace

1. Visit https://coder.ofebles.dev/
2. Click **Create Workspace**
3. Select your template
4. Configure parameters:
   - Language/tool version
   - Framework (if applicable)
   - Databases (optional)
   - Git repo (optional)
5. Click **Create Workspace**

### 3. Start Coding

Once workspace is ready:

1. Click **VS Code** to open editor
2. Navigate to `~/project` folder
3. Start developing!

---

## Template Features

### Common Features (All Templates)

✅ **Flexible Version Management**
- Select language/tool versions at workspace creation
- Version manager handles installation (SDKMAN, NVM, Pyenv, etc.)

✅ **Git Integration**
- Auto-clone optional repository on startup
- Git author/committer pre-configured
- GitLens extension for visualization

✅ **IDE Support**
- VS Code Server (web-based)
- JetBrains IDE (requires Coder Desktop)
- JetBrains Fleet (lightweight)
- OpenCode (AI-powered development)

✅ **Docker-in-Docker**
- Build and run containers within workspace
- Full Docker CLI available

✅ **Boilerplate Code**
- Framework-specific starter projects
- Example endpoints and tests
- Ready-to-run applications

✅ **Database Support (Java, Node.js Backend, Python, Go)**
- PostgreSQL 16
- MongoDB 7
- Redis 7
- Auto-generated docker-compose.yml
- Pre-configured connection details

✅ **Workspace Persistence**
- `/home/coder/project` persists across rebuilds
- Docker volumes for data safety

✅ **Pre-installed Extensions**
- Language-specific VS Code extensions
- Linting, formatting, debugging tools
- API testing tools (REST Client, Thunder Client)

### Template-Specific Features

#### Java
- SDKMAN for Java/Maven version management
- Support for Spring Boot, Quarkus, Micronaut
- Maven for build automation
- JUnit for testing

#### Kotlin
- SDKMAN for Kotlin/Gradle management
- Gradle with Kotlin DSL
- Compatible with Spring Boot
- JUnit 5 testing

#### Node.js Backend
- NVM for Node.js version management
- npm, yarn, or pnpm package managers
- Express.js boilerplate
- Jest testing, ESLint, Prettier

#### Node.js Frontend
- React 18 + Vite (HMR)
- ESLint + Prettier
- Modern component-based development
- Browser debugging

#### Python
- Pyenv for Python version management
- Framework selection: FastAPI, Flask, Django, None
- Auto-generated project structure per framework
- Pytest, Black, Ruff

#### Go
- Direct Go download (no version manager needed)
- Framework selection: Gin, Echo, Chi, stdlib
- Makefile for build automation
- Hot reload with air

---

## Creating a New Workspace

### Step 1: Access Coder

Navigate to your Coder instance: https://coder.ofebles.dev/

### Step 2: Create Workspace

Click **Create Workspace** button

### Step 3: Select Template

Choose from available templates:
- java
- kotlin
- nodejs-backend
- nodejs-frontend
- python
- go

### Step 4: Configure Parameters

Each template offers customization:

**All Templates:**
- Git Repository URL (optional)
- Git Branch (default: main)

**Language/Version Selection:**
- Choose specific versions (Java 21 vs 17, Python 3.12 vs 3.10, etc.)

**Framework Selection (where applicable):**
- Python: FastAPI, Flask, Django, or None
- Go: Gin, Echo, Chi, or Standard Library

**Database Configuration (Java, Node.js Backend, Python, Go):**
- None (default)
- PostgreSQL only
- MongoDB only
- Redis only
- Combinations (PostgreSQL+MongoDB, PostgreSQL+Redis, etc.)
- All three databases

### Step 5: Create Workspace

Click **Create** button and wait 2-3 minutes for workspace to provision.

### Step 6: Access Applications

Once running, you'll see:
- **VS Code** - Web-based editor
- **IDE** - JetBrains IDE (requires desktop app)
- **Fleet** - Lightweight JetBrains editor
- **OpenCode** - AI-powered assistant

---

## Common Workflows

### Setting Up a New FastAPI Project

```bash
# Create workspace:
Template: Python
Python Version: 3.11
Framework: FastAPI
Databases: PostgreSQL

# Once in workspace:
cd ~/project

# Install dependencies
pip install -r requirements.txt

# Start development
uvicorn src.main:app --reload --host 0.0.0.0 --port 8000

# API docs at http://localhost:8000/docs
```

### Setting Up a Gin REST API

```bash
# Create workspace:
Template: Go
Go Version: 1.21
Framework: Gin
Databases: PostgreSQL + Redis

# Once in workspace:
cd ~/project

# Download dependencies
go mod tidy

# Start with hot reload
make dev

# Server at http://localhost:8000
```

### Setting Up Spring Boot Application

```bash
# Create workspace:
Template: Java
Java Version: 21
Maven Version: 3.9.5
Databases: PostgreSQL + MongoDB

# Once in workspace:
cd ~/project

# Build
mvn clean install

# Run
mvn spring-boot:run

# Server at http://localhost:8080
```

### Setting Up React Frontend

```bash
# Create workspace:
Template: Node.js Frontend
Node Version: 20 LTS
Package Manager: npm

# Once in workspace:
cd ~/project

# Install dependencies
npm install

# Start development
npm run dev

# App at http://localhost:5173
```

### Cloning Existing Repository

When creating workspace, specify:
- **Git Repository URL**: `https://github.com/yourorg/your-project.git`
- **Git Branch**: `main` (or your branch)

Repository will be auto-cloned to `/home/coder/project`

---

## Development Tools by Template

### Java / Kotlin
- Maven / Gradle - Build tools
- SDKMAN - Version management
- JUnit / JUnit 5 - Testing
- Spring Boot / Ktor - Frameworks

### Node.js
- npm / yarn / pnpm - Package managers
- NVM - Version management
- Jest - Testing
- ESLint / Prettier - Code quality
- Vite / Webpack - Build tools

### Python
- Pip - Package manager
- Pyenv - Version management
- Pytest - Testing
- Black / Ruff - Code quality

### Go
- Go modules - Dependency management
- Make - Build automation
- Golangci-lint - Linting
- Air - Hot reload

---

## IDE Features

### VS Code Server
- Built-in terminal
- Git integration (GitLens)
- Debugging support
- Extension marketplace
- Web-based access (works from any browser)

### JetBrains IDE (IntelliJ, PyCharm, GoLand, etc.)
- Full-featured IDE
- Advanced debugging
- Refactoring tools
- Requires Coder Desktop application
- Language-specific optimizations

### Fleet
- Lightweight JetBrains editor
- Faster startup
- Web-based
- Full IDE features

---

## Database Configuration

### Starting Databases

After workspace is created with database options:

```bash
cd ~/project

# Start all services
docker-compose up -d

# Check status
docker-compose ps

# View logs
docker-compose logs postgres
```

### Connection Details

**PostgreSQL (if selected):**
```
Host: localhost
Port: 5432
User: postgres
Password: postgres
Database: appdb
```

**MongoDB (if selected):**
```
Host: localhost
Port: 27017
User: root
Password: password
Database: appdb
```

**Redis (if selected):**
```
Host: localhost
Port: 6379
No authentication
```

### Stopping Databases

```bash
# Stop all services
docker-compose down

# Stop and remove volumes
docker-compose down -v
```

---

## Environment Variables

All templates pre-configure Git information:

```bash
GIT_AUTHOR_NAME=Your Name
GIT_AUTHOR_EMAIL=your@email.com
GIT_COMMITTER_NAME=Your Name
GIT_COMMITTER_EMAIL=your@email.com
```

Create `.env` files in your project for application-specific variables.

---

## Persistence

Your work is persisted in:
- `/home/coder/project` - Docker volume persists across rebuilds
- `.vscode` settings - Stored in workspace
- VS Code extensions - Installed on first startup

**Important**: Don't store credentials in workspace. Use environment variables or secret management.

---

## Troubleshooting

### Workspace Won't Start

1. Check Coder logs: Click workspace → view logs
2. Verify Docker is running on host
3. Check disk space (need at least 20GB)
4. Try stopping and restarting workspace

### IDE Won't Connect

1. Check VS Code is running (check logs)
2. Verify network connectivity
3. Try incognito mode (clear browser cache)
4. Restart workspace agent

### Dependencies Won't Install

1. Check internet connectivity
2. Clear package manager cache:
   - **Maven**: `rm -rf ~/.m2/repository`
   - **npm**: `npm cache clean --force`
   - **Pip**: `pip cache purge`
3. Retry installation

### Database Won't Start

1. Check port availability: `netstat -an | grep 5432`
2. View docker-compose logs: `docker-compose logs postgres`
3. Restart services: `docker-compose restart`
4. Check disk space for volumes

### Port Already in Use

Change port in application:
- **Java/Spring**: `server.port=8081`
- **Python FastAPI**: `uvicorn ... --port 8001`
- **Node.js**: `PORT=3001 npm start`
- **Go**: Modify port in main.go

---

## Performance Tips

1. **Use VS Code** - Lighter than full IDE
2. **Enable hot reload** - Faster development iteration
3. **Keep dependencies minimal** - Faster builds and startup
4. **Use workspace cache** - Already persistent
5. **Monitor resource usage** - Coder dashboard shows CPU/RAM
6. **Stop unused services** - `docker-compose down` when done

---

## Contributing

Found a bug or want to add a template? Visit:
https://github.com/ofebles/coder-templates

### Template Standards

New templates should include:
- `main.tf` - Coder/Terraform configuration
- `Dockerfile` - Base image and tools
- `startup.sh` - Environment initialization
- `README.md` - Comprehensive documentation

---

## License

These templates are provided as-is for use with Coder.

## Support

For issues and questions:
- GitHub: https://github.com/ofebles/coder-templates/issues
- Coder Docs: https://coder.com/docs

---

## Template Status

| Template | Status | Last Updated |
|----------|--------|--------------|
| Java | ✅ Production | 2024-01-14 |
| Kotlin | ✅ Production | 2024-01-14 |
| Node.js Backend | ✅ Production | 2024-01-14 |
| Node.js Frontend | ✅ Production | 2024-01-14 |
| Python | ✅ Production | 2024-01-14 |
| Go | ✅ Production | 2024-01-14 |
| Rust | 🔄 In Development | - |
| Ruby | 📋 Planned | - |
| PHP | 📋 Planned | - |

---

**Happy Developing!** 🚀

Access templates at: https://coder.ofebles.dev/
