# Python Development Template for Coder

A complete, production-ready development environment for Python projects with flexible versioning, framework selection (FastAPI, Flask, Django), integrated IDE support, Docker-in-Docker, and developer tools.

## Features

- **Flexible Python Versions** - Choose Python 3.12, 3.11, 3.10, or 3.9 at workspace creation
- **Framework Selection** - Choose FastAPI (modern async), Flask (lightweight), Django (full-featured), or plain Python
- **Optional Databases** - Auto-configure PostgreSQL, MongoDB, and/or Redis via docker-compose
- **Git Repository Cloning** - Automatically clone your project repo on startup
- **VS Code Server** - Web-based VS Code IDE with Python extensions
- **JetBrains PyCharm** - Full-featured Python IDE
- **JetBrains Fleet** - Lightweight JetBrains IDE
- **Docker-in-Docker** - Build and run containers within workspace
- **Code Server Extensions** - Pre-installed Python, Pylance, Docker, and Git extensions
- **Package Management** - Built-in pip with virtual environment support

## Getting Started

### 1. Create a Workspace from Template

In your Coder instance at https://coder.ofebles.dev/:

1. Click **Create Workspace**
2. Select **Python** template
3. **Configure parameters** (optional):
   - **Python Version**: Select 3.12 (default), 3.11, 3.10, or 3.9
   - **Framework**: Select FastAPI (default), Flask, Django, or None
   - **Databases (Optional)**: Select PostgreSQL, MongoDB, Redis, or combinations
   - **Git Repository (Optional)**: Paste URL of repo to clone
   - **Git Branch (Optional)**: Specify branch (default: `main`)
4. Click **Create Workspace**

The workspace will be provisioned in 2-3 minutes.

### Customization Examples

**Example 1: FastAPI with PostgreSQL**
```
Python Version:  Python 3.11
Framework:       FastAPI
Databases:       PostgreSQL Only
Git Repo:        (leave empty)
```
→ Modern async API with PostgreSQL database

**Example 2: Flask with No Databases**
```
Python Version:  Python 3.12
Framework:       Flask
Databases:       None
Git Repo:        (leave empty)
```
→ Lightweight web framework for rapid development

**Example 3: Django Full Stack**
```
Python Version:  Python 3.11
Framework:       Django
Databases:       PostgreSQL Only
Git Repo:        https://github.com/yourorg/django-app.git
```
→ Full-featured Django application with PostgreSQL

**Example 4: Plain Python with All Databases**
```
Python Version:  Python 3.11
Framework:       None
Databases:       All (PostgreSQL + MongoDB + Redis)
Git Repo:        (leave empty)
```
→ Plain Python with access to all database services

### 2. Access Your Development Environment

Once running, you'll see three applications:

- **VS Code** - Click to open VS Code Server
- **JetBrains PyCharm** - Click to open PyCharm (requires Coder Desktop)
- **JetBrains Fleet** - Click to open Fleet (lightweight alternative)

### 3. Start Developing

```bash
# Navigate to your project
cd ~/project

# Install dependencies (if not auto-installed)
pip install -r requirements.txt

# Run your application
# FastAPI
uvicorn src.main:app --reload --host 0.0.0.0 --port 8000

# Flask
python -m flask run --host 0.0.0.0 --port 8000

# Django
python manage.py runserver 0.0.0.0:8000

# Plain Python
python src/main.py
```

## Project Structure

When you create a workspace without a Git repository, a default project structure is created based on your selected framework:

### FastAPI Project

```
workspace/
├── Dockerfile              # Container image definition
├── main.tf                 # Coder workspace configuration
├── startup.sh              # Environment initialization script
├── project/                # Your Python project
│   ├── src/
│   │   └── main.py        # FastAPI app with sample endpoints
│   ├── tests/
│   │   └── test_main.py   # Pytest tests
│   ├── requirements.txt    # Dependencies
│   ├── pyproject.toml      # Project metadata
│   ├── .env.example        # Environment template
│   └── README.md           # Project README
└── README.md              # This file
```

### Flask Project

```
workspace/
├── project/                # Your Python project
│   ├── src/
│   │   └── app.py         # Flask app with sample routes
│   ├── tests/
│   │   └── test_app.py    # Flask tests
│   ├── requirements.txt
│   ├── pyproject.toml
│   ├── .env.example
│   └── README.md
```

### Django Project

```
workspace/
├── project/                # Your Python project
│   ├── manage.py          # Django management script
│   ├── requirements.txt
│   ├── pyproject.toml
│   ├── .env.example
│   └── config/            # Created after django-admin startproject
```

### Plain Python

```
workspace/
├── project/                # Your Python project
│   ├── src/
│   │   └── main.py        # Sample Python script
│   ├── tests/
│   ├── requirements.txt
│   ├── pyproject.toml
│   └── README.md
```

## System Requirements

- **CPU**: 2+ cores
- **Memory**: 2+ GB (4GB recommended)
- **Disk**: 20+ GB free

## Template Parameters

When creating a workspace, you can customize:

### Python Version
- **Python 3.12** (Latest)
- **Python 3.11** (Recommended - stable)
- **Python 3.10**
- **Python 3.9**

Selected version is automatically installed via pyenv and set as local.

### Framework
- **FastAPI** (Recommended - Modern async framework, auto API docs)
- **Flask** (Lightweight and flexible for microservices)
- **Django** (Full-featured batteries-included framework)
- **None** (Plain Python for scripts and utilities)

Each framework comes with boilerplate code and testing setup.

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

### Python & Pyenv

```bash
# Check Python version
python --version
python3 --version

# List installed versions
pyenv versions

# Install additional version
pyenv install 3.12.1

# Switch version
pyenv local 3.12.1
pyenv global 3.12.1
```

### Virtual Environments

Create isolated environments for different projects:

```bash
# Create virtual environment
python -m venv venv

# Activate
source venv/bin/activate

# Deactivate
deactivate
```

### Package Management

```bash
# Install from requirements.txt
pip install -r requirements.txt

# Install development dependencies
pip install -e ".[dev]"

# Freeze dependencies
pip freeze > requirements.txt

# List installed packages
pip list
```

### VS Code Extensions

Pre-installed extensions:

- **Python** (`ms-python.python`) - Python language support
- **Pylance** (`ms-python.vscode-pylance`) - Fast Python language server
- **Python Debugger** (`ms-python.debugpy`) - Debugging support
- **Ruff** (`charliermarsh.ruff`) - Fast Python linter
- **Black Formatter** (`ms-python.black-formatter`) - Code formatting
- **Docker** (`ms-azuretools.vscode-docker`) - Docker integration
- **GitLens** (`eamodio.gitlens`) - Git integration
- **REST Client** (`humao.rest-client`) - API testing
- **Thunder Client** (`Thunder.cloud`) - Postman alternative

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

### FastAPI

#### Build and Run

```bash
cd ~/project

# Install dependencies
pip install -r requirements.txt

# Run development server with hot reload
uvicorn src.main:app --reload --host 0.0.0.0 --port 8000

# Run production server
uvicorn src.main:app --host 0.0.0.0 --port 8000
```

#### API Documentation

- **Interactive Docs** (Swagger UI): http://localhost:8000/docs
- **Alternative Docs** (ReDoc): http://localhost:8000/redoc
- **OpenAPI Schema**: http://localhost:8000/openapi.json

#### Testing

```bash
cd ~/project

# Run all tests
pytest

# Run with verbose output
pytest -v

# Run with coverage
pytest --cov=src

# Run specific test file
pytest tests/test_main.py
```

### Flask

#### Build and Run

```bash
cd ~/project

# Install dependencies
pip install -r requirements.txt

# Run development server
python -m flask run --host 0.0.0.0 --port 8000

# Run with auto-reload
export FLASK_ENV=development
python -m flask run --host 0.0.0.0 --port 8000 --reload
```

#### Testing

```bash
cd ~/project

# Run all tests
pytest

# Run with Flask test client
pytest tests/
```

### Django

#### Initial Setup

```bash
cd ~/project

# Create Django project (first time only)
pip install -r requirements.txt
django-admin startproject config .

# Apply migrations
python manage.py migrate

# Create superuser
python manage.py createsuperuser

# Collect static files
python manage.py collectstatic --noinput
```

#### Build and Run

```bash
cd ~/project

# Run development server
python manage.py runserver 0.0.0.0:8000

# Run tests
python manage.py test

# Create new app
python manage.py startapp myapp
```

#### Django Admin

- Access at: http://localhost:8000/admin
- Default user created with `createsuperuser`

### Plain Python

```bash
cd ~/project

# Run script
python src/main.py

# Run with arguments
python src/main.py --option value

# Run tests
pytest
```

---

## Database Usage

### PostgreSQL

Connection string:
```
postgresql://postgres:postgres@localhost:5432/appdb
```

Using with SQLAlchemy (FastAPI/Flask/Django):
```python
from sqlalchemy import create_engine
engine = create_engine("postgresql://postgres:postgres@localhost:5432/appdb")
```

Using psycopg2:
```python
import psycopg2
conn = psycopg2.connect("dbname=appdb user=postgres password=postgres host=localhost")
```

### MongoDB

Connection string:
```
mongodb://root:password@localhost:27017/
```

Using with PyMongo:
```python
from pymongo import MongoClient
client = MongoClient("mongodb://root:password@localhost:27017/")
db = client.appdb
```

Using with Motor (async):
```python
from motor.motor_asyncio import AsyncMongoClient
client = AsyncMongoClient("mongodb://root:password@localhost:27017/")
db = client.appdb
```

### Redis

Connection string:
```
redis://localhost:6379
```

Using with redis-py:
```python
import redis
r = redis.Redis(host='localhost', port=6379, db=0)
r.set('key', 'value')
```

Using with aioredis (async):
```python
import aioredis
redis = await aioredis.create_redis_pool('redis://localhost:6379')
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

Use the integrated terminal in VS Code or PyCharm to run commands:

- Python scripts and applications
- Pip package installation
- Git operations
- Docker commands
- Testing and linting commands

## Troubleshooting

### Application Won't Start

Check Python version and dependencies:

```bash
python --version
pip list
pip install -r requirements.txt
```

### ModuleNotFoundError

Ensure dependencies are installed:

```bash
pip install -r requirements.txt
pip install -e ".[dev]"
```

### Port Already in Use

Change port in your application:

**FastAPI:**
```bash
uvicorn src.main:app --port 8001
```

**Flask:**
```bash
python -m flask run --port 8001
```

**Django:**
```bash
python manage.py runserver 0.0.0.0:8001
```

Then access at http://localhost:8001

### Virtual Environment Issues

Clear and recreate:

```bash
rm -rf venv
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### Pyenv Installation Issues

If Python installation fails:

```bash
# Verify pyenv is initialized
eval "$(pyenv init -)"

# List available versions
pyenv versions

# Force reinstall
pyenv install --force 3.11.0
```

---

## Performance Tips

1. **Use async where possible** - FastAPI + async databases
2. **Enable code reloading** - Faster development with auto-restart
3. **Use pyenv for quick version switching** - No reinstall needed
4. **Keep dependencies minimal** - Fewer packages = faster startup
5. **Use pip caching** - Already configured in container
6. **Profile code** - Use cProfile for optimization

## Python Frameworks Supported

This template works with any Python framework:

### Popular Options

- **FastAPI** - Modern async framework with auto-generated API docs
- **Flask** - Microframework for building web applications
- **Django** - Full-featured framework with ORM, admin, migrations
- **Fastify** - Alternative async framework (via pip)
- **Starlette** - ASGI framework foundation for FastAPI
- **Bottle** - Single-file microframework
- **CherryPy** - Object-oriented web framework
- **Tornado** - Async networking library
- **Pyramid** - Web framework with flexibility and power

Each requires different setup in `requirements.txt`, which you control.

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
cp .env.example .env
# Edit .env with your configuration
```

## Support & Documentation

- [Python Documentation](https://docs.python.org/3/)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Flask Documentation](https://flask.palletsprojects.com/)
- [Django Documentation](https://docs.djangoproject.com/)
- [SQLAlchemy Documentation](https://docs.sqlalchemy.org/)
- [Pytest Documentation](https://docs.pytest.org/)
- [Coder Documentation](https://coder.com/docs)
- [VS Code Python Guide](https://code.visualstudio.com/docs/languages/python)

## Template Information

- **Base Image**: Ubuntu 22.04
- **Python Versions**: 3.12 (latest), 3.11 (default), 3.10, 3.9
- **Version Manager**: Pyenv
- **Code Server**: Latest with Python extensions
- **Memory**: 4GB default
- **Disk**: 50GB default

## Tips & Tricks

- Use **Cmd/Ctrl + Shift + P** in VS Code to access command palette
- Use **Cmd/Ctrl + `** to toggle integrated terminal
- Enable dark mode in Code Server settings
- Use pytest markers for test organization: `@pytest.mark.asyncio`
- Set up `.gitignore` for Python: Include venv/, __pycache__/, *.pyc
- Use `black` for consistent code formatting
- Use `ruff` for fast linting
- Create `Makefile` for common commands

## Contributing

Found an issue or want to improve this template? Visit:
https://github.com/ofebles/coder-templates

---

**Happy coding!** 🚀

For questions or feedback about this template, visit: https://github.com/ofebles/coder-templates
