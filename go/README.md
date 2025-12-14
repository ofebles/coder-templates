# Go Development Template for Coder

A complete, production-ready development environment for Go projects with flexible versioning, framework selection (Gin, Echo, Chi, Standard Library), integrated IDE support, Docker-in-Docker, and developer tools.

## Features

- **Flexible Go Versions** - Choose Go 1.21, 1.20, 1.19, or 1.18 at workspace creation
- **Framework Selection** - Choose Gin (popular), Echo (lightweight), Chi (minimal), or Standard Library
- **Optional Databases** - Auto-configure PostgreSQL, MongoDB, and/or Redis via docker-compose
- **Git Repository Cloning** - Automatically clone your project repo on startup
- **VS Code Server** - Web-based VS Code IDE with Go extensions
- **JetBrains GoLand** - Full-featured Go IDE
- **JetBrains Fleet** - Lightweight JetBrains IDE
- **Docker-in-Docker** - Build and run containers within workspace
- **Code Server Extensions** - Pre-installed Go, linting, and debugging extensions
- **Hot Reload** - Automatic rebuild with air during development

## Getting Started

### 1. Create a Workspace from Template

In your Coder instance at https://coder.ofebles.dev/:

1. Click **Create Workspace**
2. Select **Go** template
3. **Configure parameters** (optional):
   - **Go Version**: Select 1.21 (default), 1.20, 1.19, or 1.18
   - **Framework**: Select Gin (default), Echo, Chi, or Standard Library
   - **Databases (Optional)**: Select PostgreSQL, MongoDB, Redis, or combinations
   - **Git Repository (Optional)**: Paste URL of repo to clone
   - **Git Branch (Optional)**: Specify branch (default: `main`)
4. Click **Create Workspace**

The workspace will be provisioned in 2-3 minutes.

### Customization Examples

**Example 1: Go 1.21 + Gin Web Framework**
```
Go Version:  Go 1.21
Framework:   Gin
Databases:   PostgreSQL Only
Git Repo:    (leave empty)
```
→ Modern REST API with Gin and PostgreSQL

**Example 2: Go 1.20 + Echo + Multiple Databases**
```
Go Version:  Go 1.20
Framework:   Echo
Databases:   All (PostgreSQL + MongoDB + Redis)
Git Repo:    (leave empty)
```
→ Lightweight web framework with access to all databases

**Example 3: Standard Library HTTP**
```
Go Version:  Go 1.21
Framework:   Standard Library
Databases:   None
Git Repo:    https://github.com/yourorg/go-app.git
```
→ Pure Go HTTP server with no dependencies

**Example 4: Chi Router + Caching**
```
Go Version:  Go 1.21
Framework:   Chi
Databases:   Redis Only
Git Repo:    (leave empty)
```
→ Minimal router with Redis caching

### 2. Access Your Development Environment

Once running, you'll see three applications:

- **VS Code** - Click to open VS Code Server
- **JetBrains GoLand** - Click to open GoLand (requires Coder Desktop)
- **JetBrains Fleet** - Click to open Fleet (lightweight alternative)

### 3. Start Developing

```bash
# Navigate to your project
cd ~/project

# Download dependencies
go mod tidy

# Run with hot reload (requires air)
make dev

# Or run directly
go run cmd/server/main.go
```

## Project Structure

When you create a workspace without a Git repository, a default Go project structure is created:

```
workspace/
├── Dockerfile              # Container image definition
├── main.tf                 # Coder workspace configuration
├── startup.sh              # Environment initialization script
├── project/                # Your Go project
│   ├── cmd/
│   │   └── server/
│   │       └── main.go    # HTTP server entry point
│   ├── internal/           # Internal packages
│   ├── tests/
│   │   └── main_test.go   # Example tests
│   ├── go.mod             # Module definition
│   ├── Makefile           # Build automation
│   ├── .gitignore
│   └── README.md          # Project README
└── README.md              # This file
```

## System Requirements

- **CPU**: 2+ cores
- **Memory**: 2+ GB (4GB recommended)
- **Disk**: 20+ GB free

## Template Parameters

### Go Version
- **Go 1.21** (Latest)
- **Go 1.20** (Stable)
- **Go 1.19**
- **Go 1.18**

Selected version is automatically downloaded and installed.

### Framework

- **Gin** (Recommended - Fast, mature, feature-rich)
- **Echo** (Lightweight, flexible, good performance)
- **Chi** (Minimal, composable, idiomatic Go)
- **Standard Library** (No external dependencies, pure Go)

Each framework comes with boilerplate code and example endpoints.

### Databases (Optional)

Automatically configured with Docker Compose:

- **PostgreSQL 16** - Relational database
- **MongoDB 7** - Document database
- **Redis 7** - In-memory data store

Combinations available:
- PostgreSQL only
- MongoDB only
- Redis only
- PostgreSQL + MongoDB
- PostgreSQL + Redis
- MongoDB + Redis
- All three

Connection details auto-configured in docker-compose.yml.

### Git Repository (Optional)

Paste a Git repository URL to automatically clone it:
```
https://github.com/yourorg/your-project.git
```

### Git Branch (Optional)

Specify which branch to checkout (default: `main`):
```
develop
feature/my-feature
v1.2.3
```

---

## Pre-configured Tools

### Go Toolchain

```bash
# Check Go version
go version

# View environment
go env

# List installed tools
go tool

# Update Go
# Reinstall workspace or run startup.sh with different GO_VERSION
```

### Go Modules

```bash
# Initialize module
go mod init github.com/user/project

# Add dependency
go get github.com/user/package

# Update all dependencies
go get -u ./...

# Tidy dependencies
go mod tidy

# Verify dependencies
go mod verify

# View dependency graph
go mod graph
```

### Building and Running

```bash
# Build binary
go build -o bin/app cmd/server/main.go

# Run directly
go run cmd/server/main.go

# Build with optimizations
go build -ldflags="-s -w" -o bin/app cmd/server/main.go

# Cross-compile for other platforms
GOOS=linux GOARCH=amd64 go build -o bin/app

# Build with race detector (development)
go build -race -o bin/app cmd/server/main.go
```

### Development Tools

Pre-installed and configured:

- **Go** - Language toolchain
- **Golangci-lint** - Fast, parallel linter
- **Air** - Hot reload during development

Install additional tools:

```bash
# Golangci-lint (if not installed)
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

# Air (hot reload)
go install github.com/cosmtrek/air@latest

# Delve (debugger)
go install github.com/go-delve/delve/cmd/dlv@latest

# Mockgen (mock generation)
go install github.com/golang/mock/mockgen@latest
```

### VS Code Extensions

Pre-installed extensions:

- **Go** (`golang.go`) - Go language support
- **Go CodeLens** (`golang.codelens-separated`) - Code navigation
- **Makefile Tools** (`ms-vscode.makefile-tools`) - Makefile support
- **Docker** (`ms-azuretools.vscode-docker`) - Docker integration
- **GitLens** (`eamodio.gitlens`) - Git integration
- **REST Client** (`humao.rest-client`) - API testing
- **Thunder Client** (`Thunder.cloud`) - Postman alternative
- **GolangCI-Lint** (`golangci-lint.golangci-lint`) - Linting

### Docker-in-Docker

Build and run Docker containers from within your workspace:

```bash
# Build a Docker image
docker build -t my-app:latest .

# Run a container
docker run -d my-app:latest
```

---

## Common Development Tasks

### Building and Running

```bash
cd ~/project

# Download dependencies
go mod download
go mod tidy

# Build binary
make build

# Run with hot reload (requires air)
make dev

# Run directly
go run cmd/server/main.go

# Run in production mode
./bin/server
```

### Testing

```bash
cd ~/project

# Run all tests
make test

# Run with verbose output
make test-verbose

# Run with coverage
make coverage

# Run specific test
go test -run TestName ./...
```

### Code Quality

```bash
cd ~/project

# Format code
make fmt
# or
gofmt -s -w .

# Lint code
make lint
# or
golangci-lint run

# Vet code
go vet ./...

# Run all checks
make fmt && make vet && make lint
```

### Framework-Specific

#### Gin

```bash
# Access API documentation
# Interactive docs: http://localhost:8000 (if Swagger integrated)

# Test endpoint
curl -X GET http://localhost:8000/api/health

# Test with data
curl -X POST http://localhost:8000/api/echo \
  -H "Content-Type: application/json" \
  -d '{"message":"hello"}'
```

#### Echo

```bash
# Similar to Gin
curl -X GET http://localhost:8000/api/health

curl -X POST http://localhost:8000/api/echo \
  -H "Content-Type: application/json" \
  -d '{"message":"hello"}'
```

#### Chi

```bash
# Chi is minimalist, focus on routing
curl -X GET http://localhost:8000/api/health

curl -X POST http://localhost:8000/api/echo \
  -H "Content-Type: application/json" \
  -d '{"message":"hello"}'
```

#### Standard Library

```bash
# Pure net/http
curl -X GET http://localhost:8000/api/health
```

---

## Database Usage

### PostgreSQL

Connection string:
```
postgres://postgres:postgres@localhost:5432/appdb
```

Using with database/sql:
```go
import (
    "database/sql"
    _ "github.com/lib/pq"
)

db, err := sql.Open("postgres", "postgres://postgres:postgres@localhost:5432/appdb")
```

Using with sqlc:
```bash
go install github.com/kyleconroy/sqlc/cmd/sqlc@latest
```

### MongoDB

Connection string:
```
mongodb://root:password@localhost:27017/
```

Using with mongo-go-driver:
```go
import "go.mongodb.org/mongo-driver/mongo"

client, err := mongo.Connect(ctx, options.Client().ApplyURI("mongodb://root:password@localhost:27017"))
```

### Redis

Connection string:
```
redis://localhost:6379
```

Using with go-redis:
```go
import "github.com/redis/go-redis/v9"

rdb := redis.NewClient(&redis.Options{
    Addr: "localhost:6379",
})
```

---

## Start/Stop Databases

### Start Services

```bash
cd ~/project

# Start all services in background
docker-compose up -d

# View logs
docker-compose logs -f

# View status
docker-compose ps
```

### Stop Services

```bash
cd ~/project

# Stop all services
docker-compose down

# Stop and remove volumes
docker-compose down -v
```

---

## Workspace Persistence

Your project files in `/home/coder/project` are persisted across workspace rebuilds using a Docker volume. Your work is safe!

## Terminal Access

Use the integrated terminal in VS Code or GoLand to run:

- Go commands (build, test, run)
- Go module management
- Docker commands
- Git operations
- Custom scripts

## Debugging

### VS Code Debugging

1. Open **Run and Debug** (Ctrl+Shift+D)
2. Click **"Create a launch.json file"**
3. Select **Go** configuration
4. Set breakpoints and start debugging

### Delve Debugger

```bash
# Install Delve
go install github.com/go-delve/delve/cmd/dlv@latest

# Run with debugger
dlv debug cmd/server/main.go

# Debug tests
dlv test ./...
```

### GoLand Debugging

1. Set breakpoints in code
2. Right-click main() → **Debug**
3. Use debugger controls

---

## Troubleshooting

### Build Issues

Check Go version and environment:

```bash
go version
go env

# Clean build cache
go clean -cache
go clean -testcache
```

### Dependencies Not Found

Update and tidy:

```bash
go mod tidy
go mod download
go get -u ./...
```

### Hot Reload Not Working

Ensure air is installed:

```bash
go install github.com/cosmtrek/air@latest
air
```

### Port Already in Use

Change port in main.go:

```go
// Change from :8000 to :8001
http.ListenAndServe(":8001", nil)
```

Then access at http://localhost:8001

### Module Not Found

Verify module initialization:

```bash
# Check go.mod exists
cat go.mod

# Reinitialize if needed
go mod init github.com/user/project
go mod tidy
```

---

## Performance Tips

1. **Use Make for development** - `make dev` with air for hot reload
2. **Compile optimizations** - Use `-ldflags="-s -w"` for smaller binaries
3. **Disable CGO for portability** - `CGO_ENABLED=0 go build`
4. **Use race detector during development** - `go build -race`
5. **Profile before optimizing** - Use `pprof` for performance analysis
6. **Minimize dependencies** - Each dependency increases build time
7. **Use go:embed for assets** - Embed static files in binary

## Popular Go Packages

### Web Frameworks

- **Gin** - Fast HTTP web framework
- **Echo** - Lightweight, extensible HTTP framework
- **Chi** - Lightweight, idiomatic HTTP router
- **Fiber** - Express-inspired Go web framework
- **Gorilla Mux** - Powerful HTTP router and URL matcher

### Database Drivers

- **lib/pq** - PostgreSQL driver
- **mongo-go-driver** - Official MongoDB driver
- **go-redis** - Type-safe Redis client

### ORM/Query Builders

- **GORM** - Popular ORM
- **sqlc** - SQL compiler
- **Bun** - SQL query builder

### Testing

- **testify** - Testing toolkit
- **gock** - HTTP mocking
- **sqlmock** - SQL mocking

### Utilities

- **uber/zap** - Logging
- **spf13/cobra** - CLI framework
- **hashicorp/hcl** - Configuration language

---

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

Create `.env` for application configuration:

```bash
# In code
import "github.com/joho/godotenv"
godotenv.Load()
```

## Support & Documentation

- [Go Documentation](https://golang.org/doc/)
- [Gin Documentation](https://gin-gonic.com/)
- [Echo Documentation](https://echo.labstack.com/)
- [Chi Documentation](https://go-chi.io/)
- [Golangci-lint Documentation](https://golangci-lint.run/)
- [Coder Documentation](https://coder.com/docs)
- [VS Code Go Guide](https://github.com/golang/vscode-go)

## Template Information

- **Base Image**: Ubuntu 22.04
- **Go Versions**: 1.21 (latest), 1.20, 1.19, 1.18
- **Installation Method**: Direct download from go.dev
- **Code Server**: Latest with Go extensions
- **Memory**: 4GB default
- **Disk**: 50GB default

## Tips & Tricks

- Use **Cmd/Ctrl + Shift + P** in VS Code to access command palette
- Use **Cmd/Ctrl + `** to toggle integrated terminal
- Enable dark mode in Code Server settings
- Use `go:generate` for code generation
- Create `Makefile` for common tasks
- Use `.goreleaser.yml` for releases
- Use `go.work` for monorepos
- Set up `Dockerfile` for containerization

## Contributing

Found an issue or want to improve this template? Visit:
https://github.com/ofebles/coder-templates

---

**Happy coding!** 🚀

For questions or feedback about this template, visit: https://github.com/ofebles/coder-templates
