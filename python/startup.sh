#!/bin/bash

# Initialize pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# ============================================================================
# Handle Python version and framework parameters
# ============================================================================

PYTHON_VERSION="${PYTHON_VERSION:-3.11}"
FRAMEWORK="${FRAMEWORK:-fastapi}"
DATABASES="${DATABASES:-none}"

echo "Setting up Python development environment..."
echo "Python Version: $PYTHON_VERSION"
echo "Framework: $FRAMEWORK"

# Install Python version if not already installed
if ! pyenv versions | grep -q "$PYTHON_VERSION"; then
    echo "Installing Python $PYTHON_VERSION..."
    pyenv install "$PYTHON_VERSION"
fi

# Set Python version as local
pyenv local "$PYTHON_VERSION"
pyenv rehash

# Verify installation
echo ""
echo "Installed tools:"
python --version
pip --version
echo ""

# Install VSCode extensions on first startup
if [ -f "$HOME/install-vscode-extensions.sh" ] && [ ! -f "$HOME/.vscode-extensions-installed" ]; then
    echo "Installing VSCode extensions for Python development..."
    bash "$HOME/install-vscode-extensions.sh"
    touch "$HOME/.vscode-extensions-installed"
fi

echo "Starting Python Development Environment..."
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
    container_name: python_postgres
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
    container_name: python_mongodb
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
    container_name: python_redis
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
# Initialize project structure based on framework
# ============================================================================

if [ ! -f "requirements.txt" ] && [ ! -f "setup.py" ] && [ ! -f "pyproject.toml" ]; then
    echo ""
    echo "Creating default $FRAMEWORK project structure..."
    
    # Create base project structure
    mkdir -p src tests .github/workflows
    
    if [ "$FRAMEWORK" = "fastapi" ]; then
        # FastAPI project
        cat > requirements.txt <<'EOFREQ'
fastapi==0.109.0
uvicorn[standard]==0.27.0
pydantic==2.5.3
pydantic-settings==2.1.0
sqlalchemy==2.0.23
python-dotenv==1.0.0
pytest==7.4.3
pytest-asyncio==0.21.1
httpx==0.25.2
EOFREQ

        cat > pyproject.toml <<'EOFPYPROJ'
[build-system]
requires = ["setuptools>=65", "wheel"]
build-backend = "setuptools.build_meta"

[project]
name = "fastapi-app"
version = "0.1.0"
description = "FastAPI application created with Coder"
requires-python = ">=3.9"
dependencies = [
    "fastapi==0.109.0",
    "uvicorn[standard]==0.27.0",
    "pydantic==2.5.3",
    "python-dotenv==1.0.0",
]

[project.optional-dependencies]
dev = [
    "pytest==7.4.3",
    "pytest-asyncio==0.21.1",
    "ruff==0.1.13",
    "black==23.12.1",
]
EOFPYPROJ

        mkdir -p src
        
        cat > src/main.py <<'EOFPYFAST'
from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI(
    title="FastAPI App",
    description="FastAPI application running in Coder",
    version="0.1.0",
)

class Item(BaseModel):
    message: str
    value: int = None

@app.get("/")
async def read_root():
    return {
        "message": "Welcome to FastAPI in Coder!",
        "docs": "Visit /docs for interactive API documentation"
    }

@app.get("/api/health")
async def health_check():
    return {"status": "healthy"}

@app.post("/api/echo")
async def echo(item: Item):
    return {
        "received": item,
        "endpoint": "/api/echo"
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
EOFPYFAST

        cat > tests/test_main.py <<'EOFTEST'
import pytest
from fastapi.testclient import TestClient
from src.main import app

client = TestClient(app)

def test_read_root():
    response = client.get("/")
    assert response.status_code == 200
    assert "message" in response.json()

def test_health_check():
    response = client.get("/api/health")
    assert response.status_code == 200
    assert response.json()["status"] == "healthy"

def test_echo():
    response = client.post("/api/echo", json={"message": "test", "value": 42})
    assert response.status_code == 200
    assert response.json()["received"]["message"] == "test"
EOFTEST

        cat > .env.example <<'EOFENV'
ENVIRONMENT=development
DEBUG=True
EOFENV

    elif [ "$FRAMEWORK" = "flask" ]; then
        # Flask project
        cat > requirements.txt <<'EOFREQ'
Flask==3.0.0
Flask-SQLAlchemy==3.1.1
Flask-Cors==4.0.0
python-dotenv==1.0.0
pytest==7.4.3
pytest-flask==1.3.0
EOFREQ

        cat > pyproject.toml <<'EOFPYPROJ'
[build-system]
requires = ["setuptools>=65", "wheel"]
build-backend = "setuptools.build_meta"

[project]
name = "flask-app"
version = "0.1.0"
description = "Flask application created with Coder"
requires-python = ">=3.9"
dependencies = [
    "Flask==3.0.0",
    "Flask-SQLAlchemy==3.1.1",
    "python-dotenv==1.0.0",
]

[project.optional-dependencies]
dev = [
    "pytest==7.4.3",
    "ruff==0.1.13",
    "black==23.12.1",
]
EOFPYPROJ

        mkdir -p src

        cat > src/app.py <<'EOFPYFLASK'
from flask import Flask, jsonify, request

app = Flask(__name__)

@app.route('/')
def index():
    return jsonify({
        "message": "Welcome to Flask in Coder!",
        "docs": "Check /api endpoints"
    })

@app.route('/api/health', methods=['GET'])
def health():
    return jsonify({"status": "healthy"})

@app.route('/api/echo', methods=['POST'])
def echo():
    data = request.get_json()
    return jsonify({
        "received": data,
        "endpoint": "/api/echo"
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000, debug=True)
EOFPYFLASK

        cat > tests/test_app.py <<'EOFTEST'
import pytest
from src.app import app

@pytest.fixture
def client():
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def test_index(client):
    response = client.get('/')
    assert response.status_code == 200
    assert "message" in response.json

def test_health(client):
    response = client.get('/api/health')
    assert response.status_code == 200
    assert response.json['status'] == 'healthy'

def test_echo(client):
    response = client.post('/api/echo', json={"message": "test"})
    assert response.status_code == 200
    assert response.json['received']['message'] == 'test'
EOFTEST

        cat > .env.example <<'EOFENV'
FLASK_ENV=development
FLASK_APP=src/app.py
FLASK_DEBUG=True
EOFENV

    elif [ "$FRAMEWORK" = "django" ]; then
        # Django project
        cat > requirements.txt <<'EOFREQ'
Django==4.2.8
djangorestframework==3.14.0
django-cors-headers==4.3.1
python-dotenv==1.0.0
pytest==7.4.3
pytest-django==4.7.0
EOFREQ

        cat > pyproject.toml <<'EOFPYPROJ'
[build-system]
requires = ["setuptools>=65", "wheel"]
build-backend = "setuptools.build_meta"

[project]
name = "django-app"
version = "0.1.0"
description = "Django application created with Coder"
requires-python = ">=3.9"
dependencies = [
    "Django==4.2.8",
    "djangorestframework==3.14.0",
    "python-dotenv==1.0.0",
]

[project.optional-dependencies]
dev = [
    "pytest==7.4.3",
    "ruff==0.1.13",
    "black==23.12.1",
]
EOFPYPROJ

        cat > .env.example <<'EOFENV'
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1
DATABASE_URL=sqlite:///db.sqlite3
EOFENV

        echo "Note: Initialize Django project with 'django-admin startproject config . && python manage.py migrate'"

    else
        # Plain Python
        cat > requirements.txt <<'EOFREQ'
python-dotenv==1.0.0
pytest==7.4.3
EOFREQ

        cat > pyproject.toml <<'EOFPYPROJ'
[build-system]
requires = ["setuptools>=65", "wheel"]
build-backend = "setuptools.build_meta"

[project]
name = "python-app"
version = "0.1.0"
description = "Python application created with Coder"
requires-python = ">=3.9"
dependencies = []

[project.optional-dependencies]
dev = [
    "pytest==7.4.3",
    "ruff==0.1.13",
    "black==23.12.1",
]
EOFPYPROJ

        cat > src/main.py <<'EOFPYMAIN'
#!/usr/bin/env python3
"""
Plain Python application template for Coder
"""

def main():
    print("Hello from Python in Coder!")
    print(f"Python version: {__import__('sys').version}")

if __name__ == "__main__":
    main()
EOFPYMAIN

        chmod +x src/main.py
    fi

    # Common files for all frameworks
    cat > .gitignore <<'EOFGIT'
# Virtual environments
venv/
env/
ENV/
.venv

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg

# Testing
.pytest_cache/
.coverage
htmlcov/
.tox/

# IDE
.vscode/
.idea/
*.swp
*.swo
*~
.DS_Store

# Environment
.env
.env.local
.env.*.local

# Logs
*.log
EOFGIT

    cat > README.md <<'EOFREADME'
# Python Application

Python application running on Coder with $FRAMEWORK framework.

## Setup

1. Install dependencies:
```bash
pip install -r requirements.txt
```

2. Install development dependencies:
```bash
pip install -e ".[dev]"
```

## Running the Application

FastAPI:
```bash
uvicorn src.main:app --reload --host 0.0.0.0 --port 8000
```

Flask:
```bash
python -m flask run --host 0.0.0.0 --port 8000
```

Django:
```bash
python manage.py runserver 0.0.0.0:8000
```

Plain Python:
```bash
python src/main.py
```

## Testing

```bash
pytest
pytest -v
pytest --cov
```

## Linting & Formatting

```bash
ruff check .
black --check .
```

Fix issues:
```bash
ruff check . --fix
black .
```
EOFREADME

    echo "✓ $FRAMEWORK project structure created"
    
    # Install dependencies
    echo ""
    echo "Installing Python dependencies..."
    python -m pip install --upgrade pip setuptools wheel
    pip install -r requirements.txt
    echo "✓ Dependencies installed"
fi

echo ""
echo "========================================"
echo "✓ Python Development Environment Ready!"
echo "========================================"
echo "Location: ~/project"
echo ""
echo "Framework: $FRAMEWORK"
echo ""

if [ "$FRAMEWORK" = "fastapi" ]; then
    echo "Quick start:"
    echo "  cd ~/project"
    echo "  uvicorn src.main:app --reload --host 0.0.0.0 --port 8000"
    echo ""
    echo "Backend will be available at: http://localhost:8000"
    echo "API docs available at: http://localhost:8000/docs"
elif [ "$FRAMEWORK" = "flask" ]; then
    echo "Quick start:"
    echo "  cd ~/project"
    echo "  python -m flask run --host 0.0.0.0 --port 8000"
    echo ""
    echo "Backend will be available at: http://localhost:8000"
elif [ "$FRAMEWORK" = "django" ]; then
    echo "Quick start (first time):"
    echo "  cd ~/project"
    echo "  django-admin startproject config ."
    echo "  python manage.py migrate"
    echo "  python manage.py runserver 0.0.0.0:8000"
    echo ""
    echo "Backend will be available at: http://localhost:8000"
else
    echo "Quick start:"
    echo "  cd ~/project"
    echo "  python src/main.py"
fi

echo ""
echo "Available commands:"
echo "  pytest                 - Run tests"
echo "  ruff check .           - Lint code"
echo "  black .                - Format code"
echo "  pip install <package>  - Install packages"
echo ""
echo "Pyenv available for version management:"
echo "  pyenv versions"
echo "  pyenv install <version>"
echo "  pyenv local <version>"
echo "========================================"
