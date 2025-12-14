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
    echo "Installing VSCode extensions for frontend development..."
    bash "$HOME/install-vscode-extensions.sh"
    touch "$HOME/.vscode-extensions-installed"
fi

echo "Starting Node.js Frontend Development Environment..."
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

# Initialize default project structure if empty
if [ ! -f "package.json" ]; then
  echo "Creating default React project structure..."
  
  cat > package.json <<'EOFPKG'
{
  "name": "frontend-app",
  "version": "1.0.0",
  "description": "Frontend application created with Coder",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview",
    "lint": "eslint . --ext .js,.jsx,.ts,.tsx",
    "lint:fix": "eslint . --ext .js,.jsx,.ts,.tsx --fix",
    "format": "prettier --write ."
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  },
  "devDependencies": {
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0",
    "@vitejs/plugin-react": "^4.2.0",
    "eslint": "^8.54.0",
    "prettier": "^3.1.0",
    "vite": "^5.0.0"
  }
}
EOFPKG

  mkdir -p src public

  cat > src/App.jsx <<'EOFJSX'
export default function App() {
  return (
    <div style={{ padding: "20px", fontFamily: "sans-serif" }}>
      <h1>Welcome to Frontend Development in Coder!</h1>
      <p>Edit src/App.jsx and save to reload.</p>
      <p>This is a React + Vite template.</p>
    </div>
  );
}
EOFJSX

  cat > src/main.jsx <<'EOFMAIN'
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.jsx'

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
)
EOFMAIN

  cat > public/index.html <<'EOFHTML'
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Frontend App</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.jsx"></script>
  </body>
</html>
EOFHTML

  cat > vite.config.js <<'EOFVITE'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    host: '0.0.0.0',
    port: 5173,
  },
})
EOFVITE

  cat > .eslintrc.json <<'EOFESLINT'
{
  "env": {
    "browser": true,
    "es2021": true
  },
  "extends": "eslint:recommended",
  "parserOptions": {
    "ecmaVersion": "latest",
    "sourceType": "module"
  },
  "rules": {}
}
EOFESLINT

  cat > .prettierrc.json <<'EOFPRETTIER'
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 80,
  "tabWidth": 2
}
EOFPRETTIER

  cat > .gitignore <<'EOFGIT'
# Vite
dist/
.vite/

# Dependencies
node_modules/
.pnp
.pnp.js

# Testing
coverage/

# Production
build/

# Misc
.DS_Store
.env.local
.env.*.local

# Logs
npm-debug.log*
yarn-debug.log*
yarn-error.log*
pnpm-debug.log*
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
echo "✓ Node.js Frontend Environment Ready!"
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
echo "Frontend will be available at: http://localhost:5173"
echo ""
echo "Available commands:"
if [ "$PACKAGE_MANAGER" = "yarn" ]; then
    echo "  yarn dev        - Start development server"
    echo "  yarn build      - Build for production"
    echo "  yarn lint       - Run ESLint"
    echo "  yarn format     - Format code with Prettier"
elif [ "$PACKAGE_MANAGER" = "pnpm" ]; then
    echo "  pnpm dev        - Start development server"
    echo "  pnpm build      - Build for production"
    echo "  pnpm lint       - Run ESLint"
    echo "  pnpm format     - Format code with Prettier"
else
    echo "  npm run dev     - Start development server"
    echo "  npm run build   - Build for production"
    echo "  npm run lint    - Run ESLint"
    echo "  npm run format  - Format code with Prettier"
fi
echo ""
echo "NVM available for version management:"
echo "  nvm list"
echo "  nvm install <version>"
echo "  nvm use <version>"
echo "========================================"
