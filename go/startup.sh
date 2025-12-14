#!/bin/bash

# ============================================================================
# Handle Go version and framework parameters
# ============================================================================

GO_VERSION="${GO_VERSION:-1.21}"
FRAMEWORK="${FRAMEWORK:-gin}"
DATABASES="${DATABASES:-none}"

echo "Setting up Go development environment..."
echo "Go Version: $GO_VERSION"
echo "Framework: $FRAMEWORK"

# Download and install Go if not already present
if ! command -v go &> /dev/null || [ "$(go version | awk '{print $3}')" != "go$GO_VERSION" ]; then
    echo "Installing Go $GO_VERSION..."
    
    # Detect architecture
    ARCH="amd64"
    if [ "$(uname -m)" = "aarch64" ]; then
        ARCH="arm64"
    fi
    
    # Download Go
    GO_FILE="go$GO_VERSION.linux-$ARCH.tar.gz"
    GO_URL="https://go.dev/dl/$GO_FILE"
    
    echo "Downloading from $GO_URL..."
    curl -L "$GO_URL" -o "/tmp/$GO_FILE"
    
    # Remove existing Go installation if present
    rm -rf /usr/local/go
    
    # Extract to /usr/local
    tar -C /usr/local -xzf "/tmp/$GO_FILE"
    rm "/tmp/$GO_FILE"
fi

# Set Go environment
export PATH="/usr/local/go/bin:$PATH"
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# Add to bashrc
if ! grep -q "export PATH=\"/usr/local/go/bin" $HOME/.bashrc; then
    echo 'export PATH="/usr/local/go/bin:$PATH"' >> $HOME/.bashrc
    echo 'export GOPATH="$HOME/go"' >> $HOME/.bashrc
    echo 'export PATH="$GOPATH/bin:$PATH"' >> $HOME/.bashrc
fi

# Verify installation
echo ""
echo "Installed tools:"
go version
GOBIN=$(go env GOBIN)
if [ -z "$GOBIN" ]; then
    GOBIN="$GOPATH/bin"
fi
echo "GOPATH: $GOPATH"
echo ""

# Install VSCode extensions on first startup
if [ -f "$HOME/install-vscode-extensions.sh" ] && [ ! -f "$HOME/.vscode-extensions-installed" ]; then
    echo "Installing VSCode extensions for Go development..."
    bash "$HOME/install-vscode-extensions.sh"
    touch "$HOME/.vscode-extensions-installed"
fi

echo "Starting Go Development Environment..."
echo "User: $(whoami)"
echo "Home: $HOME"
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

# ============================================================================
# Handle database configurations
# ============================================================================

if [ "$DATABASES" != "none" ]; then
    echo ""
    echo "Configuring databases..."
    mkdir -p $HOME/project/.docker
    
    # Create docker-compose.yml for selected databases
    cat > $HOME/project/docker-compose.yml <<'EOFDOCKER'
version: '3.8'

services:
EOFDOCKER

    # Add PostgreSQL if selected
    if echo "$DATABASES" | grep -q "postgresql"; then
        cat >> $HOME/project/docker-compose.yml <<'EOFPOSTGRES'
  postgres:
    image: postgres:16-alpine
    container_name: go_postgres
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: appdb
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5

EOFPOSTGRES
        echo "    ✓ PostgreSQL configured on port 5432"
    fi

    # Add MongoDB if selected
    if echo "$DATABASES" | grep -q "mongodb"; then
        cat >> $HOME/project/docker-compose.yml <<'EOFMONGO'
  mongodb:
    image: mongo:7-alpine
    container_name: go_mongodb
    environment:
      MONGO_INITDB_ROOT_USERNAME: root
      MONGO_INITDB_ROOT_PASSWORD: password
    ports:
      - "27017:27017"
    volumes:
      - mongodb_data:/data/db
    healthcheck:
      test: echo 'db.runCommand("ping").ok' | mongosh localhost:27017/test --quiet
      interval: 10s
      timeout: 5s
      retries: 5

EOFMONGO
        echo "    ✓ MongoDB configured on port 27017"
    fi

    # Add Redis if selected
    if echo "$DATABASES" | grep -q "redis"; then
        cat >> $HOME/project/docker-compose.yml <<'EOFREDIS'
  redis:
    image: redis:7-alpine
    container_name: go_redis
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

EOFREDIS
        echo "    ✓ Redis configured on port 6379"
    fi

    # Add volumes section
    cat >> $HOME/project/docker-compose.yml <<'EOFVOLUMES'
volumes:
EOFVOLUMES

    if echo "$DATABASES" | grep -q "postgresql"; then
        echo "  postgres_data:" >> $HOME/project/docker-compose.yml
    fi

    if echo "$DATABASES" | grep -q "mongodb"; then
        echo "  mongodb_data:" >> $HOME/project/docker-compose.yml
    fi

    if echo "$DATABASES" | grep -q "redis"; then
        echo "  redis_data:" >> $HOME/project/docker-compose.yml
    fi

    echo "✓ docker-compose.yml created with selected databases"
fi

# ============================================================================
# Initialize Go project structure based on framework
# ============================================================================

if [ ! -f "go.mod" ]; then
    echo ""
    echo "Creating default $FRAMEWORK project structure..."
    
    # Create base project structure
    mkdir -p cmd/server internal/handlers tests
    
    # Initialize Go module
    go mod init github.com/user/$FRAMEWORK-app
    
    if [ "$FRAMEWORK" = "gin" ]; then
        # Gin web framework
        echo "Setting up Gin framework..."
        go get -u github.com/gin-gonic/gin
        
        cat > go.sum.init <<'EOFGOSUM'
EOFGOSUM
        
        cat > cmd/server/main.go <<'EOFGO'
package main

import (
	"github.com/gin-gonic/gin"
	"net/http"
)

func main() {
	r := gin.Default()

	// Routes
	r.GET("/", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"message": "Welcome to Gin in Coder!",
			"docs":    "Visit /api/docs for API documentation",
		})
	})

	r.GET("/api/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"status": "healthy",
		})
	})

	r.POST("/api/echo", func(c *gin.Context) {
		var json map[string]interface{}
		if err := c.BindJSON(&json); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusOK, gin.H{
			"received": json,
			"endpoint": "/api/echo",
		})
	})

	// Start server
	if err := r.Run(":8000"); err != nil {
		panic(err)
	}
}
EOFGO

    elif [ "$FRAMEWORK" = "echo" ]; then
        # Echo framework
        echo "Setting up Echo framework..."
        go get github.com/labstack/echo/v4
        
        cat > cmd/server/main.go <<'EOFGO'
package main

import (
	"github.com/labstack/echo/v4"
	"net/http"
)

func main() {
	e := echo.New()

	// Routes
	e.GET("/", func(c echo.Context) error {
		return c.JSON(http.StatusOK, map[string]interface{}{
			"message": "Welcome to Echo in Coder!",
			"docs":    "Check /api endpoints for documentation",
		})
	})

	e.GET("/api/health", func(c echo.Context) error {
		return c.JSON(http.StatusOK, map[string]interface{}{
			"status": "healthy",
		})
	})

	e.POST("/api/echo", func(c echo.Context) error {
		var json map[string]interface{}
		if err := c.Bind(&json); err != nil {
			return c.JSON(http.StatusBadRequest, map[string]interface{}{"error": err.Error()})
		}
		return c.JSON(http.StatusOK, map[string]interface{}{
			"received": json,
			"endpoint": "/api/echo",
		})
	})

	// Start server
	e.Logger.Fatal(e.Start(":8000"))
}
EOFGO

    elif [ "$FRAMEWORK" = "chi" ]; then
        # Chi router
        echo "Setting up Chi router..."
        go get github.com/go-chi/chi/v5
        
        cat > cmd/server/main.go <<'EOFGO'
package main

import (
	"encoding/json"
	"github.com/go-chi/chi/v5"
	"log"
	"net/http"
)

func main() {
	r := chi.NewRouter()

	// Middleware
	r.Use(func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			w.Header().Set("Content-Type", "application/json")
			next.ServeHTTP(w, r)
		})
	})

	// Routes
	r.Get("/", func(w http.ResponseWriter, r *http.Request) {
		json.NewEncoder(w).Encode(map[string]interface{}{
			"message": "Welcome to Chi in Coder!",
			"docs":    "Check /api endpoints for documentation",
		})
	})

	r.Get("/api/health", func(w http.ResponseWriter, r *http.Request) {
		json.NewEncoder(w).Encode(map[string]interface{}{
			"status": "healthy",
		})
	})

	r.Post("/api/echo", func(w http.ResponseWriter, r *http.Request) {
		var data map[string]interface{}
		if err := json.NewDecoder(r.Body).Decode(&data); err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}
		json.NewEncoder(w).Encode(map[string]interface{}{
			"received": data,
			"endpoint": "/api/echo",
		})
	})

	// Start server
	log.Println("✓ Server running on http://localhost:8000")
	log.Fatal(http.ListenAndServe(":8000", r))
}
EOFGO

    else
        # Standard library
        echo "Setting up standard library HTTP server..."
        
        cat > cmd/server/main.go <<'EOFGO'
package main

import (
	"encoding/json"
	"log"
	"net/http"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(map[string]interface{}{
			"message": "Welcome to Go in Coder!",
			"docs":    "Check /api endpoints for documentation",
		})
	})

	http.HandleFunc("/api/health", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(map[string]interface{}{
			"status": "healthy",
		})
	})

	http.HandleFunc("/api/echo", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		var data map[string]interface{}
		if err := json.NewDecoder(r.Body).Decode(&data); err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}
		json.NewEncoder(w).Encode(map[string]interface{}{
			"received": data,
			"endpoint": "/api/echo",
		})
	})

	log.Println("✓ Server running on http://localhost:8000")
	log.Fatal(http.ListenAndServe(":8000", nil))
}
EOFGO
    fi

    # Create a simple test file
    cat > tests/main_test.go <<'EOFTEST'
package tests

import (
	"testing"
)

func TestBasic(t *testing.T) {
	if 1+1 != 2 {
		t.Error("Expected 2")
	}
}
EOFTEST

    # Create Makefile
    cat > Makefile <<'EOFMAKE'
.PHONY: build run test clean fmt lint

build:
	go build -o bin/server cmd/server/main.go

run:
	go run cmd/server/main.go

dev:
	@command -v air > /dev/null || go install github.com/cosmtrek/air@latest
	air

test:
	go test ./...

test-verbose:
	go test -v ./...

coverage:
	go test -cover ./...

fmt:
	go fmt ./...

vet:
	go vet ./...

lint:
	@command -v golangci-lint > /dev/null || go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
	golangci-lint run

clean:
	rm -f bin/server

deps:
	go get -u ./...

tidy:
	go mod tidy
EOFMAKE

    # Create .gitignore
    cat > .gitignore <<'EOFGIT'
# Binaries
bin/
*.exe
*.dll
*.so
*.dylib

# Vendor
vendor/

# IDE
.vscode/
.idea/
*.swp
*.swo
*~
.DS_Store

# Go build
*.o
*.a
*.test

# Go coverage
*.out

# Go modules
go.sum
EOFGIT

    # Create README
    cat > README.md <<'EOFREADME'
# Go Application

Go application running on Coder with $FRAMEWORK framework.

## Development

### Build

```bash
make build
```

### Run

Development with hot reload (requires air):
```bash
make dev
```

Production:
```bash
make run
# or
go run cmd/server/main.go
```

### Testing

```bash
make test
make test-verbose
make coverage
```

### Code Quality

Format:
```bash
make fmt
```

Lint:
```bash
make lint
```

Vet:
```bash
go vet ./...
```

## HTTP Server

Server listens on `http://localhost:8000`

Endpoints:
- `GET /` - Welcome message
- `GET /api/health` - Health check
- `POST /api/echo` - Echo request body

## Dependencies

Add dependencies:
```bash
go get github.com/user/package
```

Update dependencies:
```bash
make deps
go mod tidy
```

## Structure

- `cmd/` - Entry points
- `internal/` - Internal packages
- `tests/` - Test files
EOFREADME

    echo "✓ $FRAMEWORK project structure created"
    
    # Download dependencies
    echo ""
    echo "Downloading Go dependencies..."
    go mod tidy
    echo "✓ Dependencies ready"
fi

echo ""
echo "========================================"
echo "✓ Go Development Environment Ready!"
echo "========================================"
echo "Location: ~/project"
echo ""
echo "Framework: $FRAMEWORK"
echo ""
echo "Quick start:"
echo "  cd ~/project"
echo "  make dev                    # Development with hot reload"
echo "  # or"
echo "  go run cmd/server/main.go   # Direct run"
echo ""
echo "Server will be available at: http://localhost:8000"
echo ""
echo "Available commands:"
echo "  make build    - Build binary"
echo "  make run      - Run server"
echo "  make dev      - Run with hot reload (air)"
echo "  make test     - Run tests"
echo "  make fmt      - Format code"
echo "  make lint     - Lint code"
echo "  make clean    - Clean binaries"
echo ""
echo "Go version and tools:"
echo "  go version"
echo "  go env"
echo "========================================"
