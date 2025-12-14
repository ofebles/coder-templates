# Node.js Frontend Development Template for Coder

A complete, production-ready development environment for frontend applications with React, Vue, Angular, or any modern JavaScript framework. Includes development tools, debugging capabilities, and flexible package manager selection.

## Features

- **Flexible Node.js Versions** - Choose Node.js 20 LTS, 18 LTS, or 21 at workspace creation
- **Multiple Package Managers** - npm, yarn, or pnpm (selectable at creation)
- **Git Repository Cloning** - Automatically clone your frontend project on startup
- **React + Vite Template** - Modern frontend stack with instant reload
- **VS Code Server** - Web-based VS Code IDE with frontend extensions
- **ESLint & Prettier** - Code quality and formatting pre-configured
- **JetBrains IDEs** - WebStorm and Fleet for advanced frontend development
- **Docker-in-Docker** - Build and run containers within workspace

## Features

- **Flexible Node.js Versions** - Choose Node.js 20 LTS (recommended), 18 LTS, or 21
- **Package Manager Selection** - npm (default), yarn, or pnpm
- **Git Repository Cloning** - Automatically clone your project repo on startup
- **React + Vite Boilerplate** - Modern development stack with hot module replacement
- **VS Code Server** - Web-based IDE with frontend extensions pre-installed
- **ESLint & Prettier** - Code linting and formatting
- **JetBrains IDEs** - WebStorm and Fleet support
- **Docker Support** - Build and run containers from workspace

## Getting Started

### 1. Create a Workspace

In your Coder instance:

1. Click **Create Workspace**
2. Select **nodejs-frontend** template
3. **Configure parameters**:
   - **Node.js Version**: Select 20.11.0 (default), 18.19.0, or 21.6.0
   - **Package Manager**: Select npm (default), yarn, or pnpm
   - **Git Repository (Optional)**: Paste your repo URL
   - **Git Branch (Optional)**: Specify branch (default: main)
4. Click **Create Workspace**

### 2. Access Your Environment

Once running, you'll see applications:
- **VS Code** - Browser-based editor
- **WebStorm** - Full-featured frontend IDE
- **Fleet** - Lightweight IDE alternative

### 3. Start Developing

```bash
cd ~/project

# Development server (auto-reload)
npm run dev

# Build for production
npm run build

# Run linter
npm run lint

# Format code
npm run format
```

## Template Parameters

### Node.js Version
- **Node.js 20 LTS** (Recommended - Latest LTS)
- **Node.js 18 LTS** (Stable)
- **Node.js 21** (Cutting edge)

### Package Manager
- **npm** (Default - Included with Node.js)
- **yarn** (Better dependency management)
- **pnpm** (Faster, space-efficient)

### Git Repository (Optional)
Paste a Git repository URL to auto-clone on startup:
```
https://github.com/yourorg/your-frontend-app.git
```

### Git Branch (Optional)
Specify branch to checkout (default: `main`):
```
develop
feature/new-design
v1.2.3
```

## Supported Frameworks

This template includes React + Vite by default, but works with any JavaScript framework:

- **React** - Facebook's UI library
- **Vue** - Progressive framework
- **Angular** - Enterprise framework
- **Svelte** - Compiler-focused
- **Next.js** - React with SSR/SSG
- **Remix** - Modern web framework
- **Astro** - Static site generator
- **Nuxt** - Vue meta-framework

## Project Structure (Default React + Vite)

```
project/
├── src/
│   ├── App.jsx           # Main React component
│   ├── main.jsx          # Entry point
│   └── ...
├── public/
│   └── index.html        # HTML entry point
├── package.json          # Dependencies and scripts
├── vite.config.js        # Vite configuration
├── .eslintrc.json        # Linting rules
├── .prettierrc.json      # Code formatting
└── .gitignore
```

## Available Commands

### Development
```bash
npm run dev       # Start development server with HMR
npm run build     # Production build
npm run preview   # Preview production build locally
```

### Code Quality
```bash
npm run lint      # Run ESLint
npm run lint:fix  # Fix ESLint issues automatically
npm run format    # Format code with Prettier
```

## Pre-installed VS Code Extensions

- **ESLint** - JavaScript linting
- **Prettier** - Code formatting
- **Debugger for Chrome** - Browser debugging
- **TypeScript** - TypeScript support
- **Tailwind CSS** - Utility-first CSS
- **Docker** - Docker integration
- **GitLens** - Git visualization
- **HTML/CSS** - HTML and CSS support
- **Auto Rename Tag** - Rename paired tags

## Development Workflow

### Local Development
```bash
cd ~/project
npm install              # Install dependencies
npm run dev             # Start dev server
# Visit http://localhost:5173
```

### Production Build
```bash
npm run build           # Create optimized build
npm run preview         # Test production build locally
```

### Code Quality
```bash
npm run lint            # Check for issues
npm run lint:fix        # Auto-fix issues
npm run format          # Format all files
```

### Using Different Package Managers

If you chose **yarn**:
```bash
yarn install
yarn dev
yarn build
```

If you chose **pnpm**:
```bash
pnpm install
pnpm dev
pnpm build
```

## Troubleshooting

### Port Already in Use
Edit `vite.config.js`:
```javascript
server: {
  port: 5174,  // Change port
}
```

### Node Modules Issues
```bash
# Clear cache and reinstall
rm -rf node_modules package-lock.json
npm install
```

### Memory Issues
If you run out of memory during build:
```bash
# Increase Node memory limit
NODE_OPTIONS="--max-old-space-size=4096" npm run build
```

### VSCode Extensions Not Installing
```bash
# Manually install extension
code-server --install-extension <extension-id>
```

## Performance Tips

1. **Use npm ci instead of npm install** in CI/CD
2. **Cache node_modules** in your build system
3. **Use dynamic imports** for code splitting
4. **Enable production mode** during builds
5. **Monitor bundle size** with Vite plugins

## Environment Variables

Create a `.env` file for local development:
```
VITE_API_URL=http://localhost:3000
VITE_DEBUG=true
```

Access in your code:
```javascript
const apiUrl = import.meta.env.VITE_API_URL
```

## NVM (Node Version Manager)

Manage Node.js versions:
```bash
nvm list                 # List installed versions
nvm list-remote          # List available versions
nvm install <version>    # Install specific version
nvm use <version>        # Switch to version
nvm alias default <ver>  # Set default version
```

## Git Integration

```bash
# Initialize git
cd ~/project
git init
git config user.name "Your Name"
git config user.email "your@email.com"

# Or clone existing repo
git clone https://github.com/yourorg/repo.git
cd repo
```

Environment variables are auto-configured:
```bash
echo $GIT_AUTHOR_NAME
echo $GIT_AUTHOR_EMAIL
```

## Workspace Persistence

Your project files in `/home/coder/project` persist across workspace rebuilds using Docker volumes. Your work is safe!

## Support & Documentation

- [Node.js Documentation](https://nodejs.org/en/docs/)
- [npm Documentation](https://docs.npmjs.com/)
- [Vite Documentation](https://vitejs.dev/)
- [React Documentation](https://react.dev/)
- [ESLint Documentation](https://eslint.org/)
- [Prettier Documentation](https://prettier.io/)
- [Coder Documentation](https://coder.com/docs)
- [VS Code Web Documentation](https://code.visualstudio.com/docs/editor/vscode-web)

## Tips & Tricks

- Use **Cmd/Ctrl + Shift + P** in VS Code for command palette
- Use **Cmd/Ctrl + `** to toggle terminal
- Enable dark mode in VS Code settings
- Install additional extensions from marketplace
- Use workspace-local `.npmrc` for project-specific npm config
- Set up Git hooks with husky for code quality

## Contributing

Found an issue or want to improve this template? Visit:
https://github.com/ofebles/coder-templates

---

**Happy frontend development!** 🚀

For questions or feedback: https://github.com/ofebles/coder-templates
