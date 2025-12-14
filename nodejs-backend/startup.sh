#!/bin/bash

# Initialize NVM for interactive shells
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# ============================================================================
# Handle version parameters
# ============================================================================

NODE_VERSION="${NODE_VERSION:-20.11.0}"
PACKAGE_MANAGER="${PACKAGE_MANAGER:-npm}"

echo "Setting up tools with user-selected versions..."
echo "Node.js Version: $NODE_VERSION"
echo "Package Manager: $PACKAGE_MANAGER"

# Install Node.js version if not already installed
if ! nvm list | grep -q "$NODE_VERSION"; then
    echo "Installing Node.js $NODE_VERSION..."
    nvm install "$NODE_VERSION"
fi

# Set default Node.js version
nvm use "$NODE_VERSION"
nvm alias default "$NODE_VERSION"

# Verify installations
node --version
npm --version
echo "✓ Node.js and npm ready"

# Install or update package manager
if [ "$PACKAGE_MANAGER" = "yarn" ]; then
    echo "Ensuring yarn is installed..."
    npm install -g yarn
    echo "✓ yarn: $(yarn --version)"
elif [ "$PACKAGE_MANAGER" = "pnpm" ]; then
    echo "Ensuring pnpm is installed..."
    npm install -g pnpm
    echo "✓ pnpm: $(pnpm --version)"
fi

# Install VSCode extensions on first startup
if [ -f "$HOME/install-vscode-extensions.sh" ] && [ ! -f "$HOME/.vscode-extensions-installed" ]; then
    echo "Installing VSCode extensions for backend development..."
    bash "$HOME/install-vscode-extensions.sh"
    touch "$HOME/.vscode-extensions-installed"
fi

echo "Starting Node.js Backend Development Environment..."
echo "User: $(whoami)"
echo "Home: $HOME"

echo ""
echo "Installed tools:"
echo "Node.js: $(node --version)"
echo "npm: $(npm --version)"
if [ "$PACKAGE_MANAGER" = "yarn" ]; then
    echo "yarn: $(yarn --version)"
elif [ "$PACKAGE_MANAGER" = "pnpm" ]; then
    echo "pnpm: $(pnpm --version)"
fi
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

DATABASES="${DATABASES:-none}"

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
    container_name: nodejs_postgres
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
    container_name: nodejs_mongodb
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
    container_name: nodejs_redis
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

# Initialize default project structure if empty
if [ ! -f "package.json" ]; then
  echo "Creating default Express backend project structure..."
  
  cat > package.json <<'EOFPKG'
{
  "name": "backend-app",
  "version": "1.0.0",
  "description": "Backend application created with Coder",
  "type": "module",
  "main": "src/index.js",
  "scripts": {
    "dev": "node --watch src/index.js",
    "start": "node src/index.js",
    "test": "jest",
    "test:watch": "jest --watch",
    "lint": "eslint src --ext .js,.ts",
    "lint:fix": "eslint src --ext .js,.ts --fix",
    "format": "prettier --write ."
  },
  "dependencies": {
    "express": "^4.18.2",
    "cors": "^2.8.5",
    "dotenv": "^16.3.1"
  },
  "devDependencies": {
    "eslint": "^8.54.0",
    "prettier": "^3.1.0",
    "jest": "^29.7.0",
    "nodemon": "^3.0.2",
    "@types/express": "^4.17.21",
    "@types/node": "^20.10.0"
  }
}
EOFPKG

  mkdir -p src

  cat > src/index.js <<'EOFJS'
import express from 'express';
import cors from 'cors';

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.get('/', (req, res) => {
  res.json({
    message: 'Welcome to Node.js Backend!',
    environment: process.env.NODE_ENV || 'development',
    version: '1.0.0',
  });
});

app.get('/api/health', (req, res) => {
  res.json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
  });
});

app.post('/api/echo', (req, res) => {
  res.json({
    received: req.body,
    timestamp: new Date().toISOString(),
  });
});

// Error handling
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    error: 'Internal Server Error',
    message: err.message,
  });
});

// Start server
app.listen(PORT, () => {
  console.log(`✓ Backend server running on http://localhost:${PORT}`);
  console.log(`✓ API documentation at http://localhost:${PORT}/api`);
});
EOFJS

  cat > .env.example <<'EOFENV'
NODE_ENV=development
PORT=3000
LOG_LEVEL=info
EOFENV

  cat > .eslintrc.json <<'EOFESLINT'
{
  "env": {
    "node": true,
    "es2021": true
  },
  "extends": "eslint:recommended",
  "parserOptions": {
    "ecmaVersion": "latest",
    "sourceType": "module"
  },
  "rules": {
    "no-console": "off",
    "indent": ["error", 2],
    "quotes": ["error", "single"],
    "semi": ["error", "always"]
  }
}
EOFESLINT

  cat > .prettierrc.json <<'EOFPRETTIER'
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 80,
  "tabWidth": 2,
  "arrowParens": "always"
}
EOFPRETTIER

  cat > jest.config.js <<'EOFJEST'
export default {
  testEnvironment: 'node',
  coveragePathIgnorePatterns: ['/node_modules/'],
  testMatch: ['**/__tests__/**/*.js', '**/?(*.)+(spec|test).js'],
};
EOFJEST

  cat > .gitignore <<'EOFGIT'
# Dependencies
node_modules/
package-lock.json
yarn.lock
pnpm-lock.yaml

# Environment
.env
.env.local
.env.*.local

# Testing
coverage/
.nyc_output/

# Logs
logs/
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# IDE
.vscode/
.idea/
*.swp
*.swo
*~
.DS_Store

# Build
dist/
build/
EOFGIT

  echo "✓ Project structure created"
  echo ""
  echo "Installing dependencies with $PACKAGE_MANAGER..."
  
  if [ "$PACKAGE_MANAGER" = "yarn" ]; then
    yarn install
  elif [ "$PACKAGE_MANAGER" = "pnpm" ]; then
    pnpm install
  else
    npm install
  fi
  
  echo "✓ Dependencies installed"
fi

echo ""
echo "========================================"
echo "✓ Node.js Backend Environment Ready!"
echo "========================================"
echo "Location: ~/project"
echo ""
echo "Quick start:"
echo "  cd ~/project"

if [ "$PACKAGE_MANAGER" = "yarn" ]; then
    echo "  yarn dev"
elif [ "$PACKAGE_MANAGER" = "pnpm" ]; then
    echo "  pnpm dev"
else
    echo "  npm run dev"
fi

echo ""
echo "Backend will be available at: http://localhost:3000"
echo ""
echo "Available commands:"
if [ "$PACKAGE_MANAGER" = "yarn" ]; then
    echo "  yarn dev         - Start development server with hot reload"
    echo "  yarn start       - Start production server"
    echo "  yarn test        - Run Jest tests"
    echo "  yarn lint        - Run ESLint"
    echo "  yarn format      - Format code with Prettier"
elif [ "$PACKAGE_MANAGER" = "pnpm" ]; then
    echo "  pnpm dev         - Start development server with hot reload"
    echo "  pnpm start       - Start production server"
    echo "  pnpm test        - Run Jest tests"
    echo "  pnpm lint        - Run ESLint"
    echo "  pnpm format      - Format code with Prettier"
else
    echo "  npm run dev      - Start development server with hot reload"
    echo "  npm run start    - Start production server"
    echo "  npm test         - Run Jest tests"
    echo "  npm run lint     - Run ESLint"
    echo "  npm run format   - Format code with Prettier"
fi
echo ""
echo "API Endpoints:"
echo "  GET  /                 - Welcome message"
echo "  GET  /api/health       - Health check"
echo "  POST /api/echo         - Echo request body"
echo ""
echo "NVM available for version management:"
echo "  nvm list"
echo "  nvm install <version>"
echo "  nvm use <version>"
echo "========================================"
