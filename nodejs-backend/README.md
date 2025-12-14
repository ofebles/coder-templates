# Node.js Backend Development Template for Coder

A complete, production-ready development environment for backend applications with Express, Nest.js, Fastify, or any Node.js framework. Includes API debugging, database tools, and flexible package manager selection.

## Features

- **Flexible Node.js Versions** - Choose Node.js 20 LTS, 18 LTS, or 21 at workspace creation
- **Multiple Package Managers** - npm, yarn, or pnpm
- **Git Repository Cloning** - Automatically clone your backend project
- **Express.js Template** - Fast, unopinionated backend framework
- **API Debugging** - REST Client and Thunder Client extensions
- **Database Tools** - MongoDB and PostgreSQL integration
- **TypeScript Support** - Full type safety
- **Hot Reload** - Automatic restart with nodemon

## Getting Started

### 1. Create a Workspace

1. Click **Create Workspace**
2. Select **nodejs-backend** template
3. **Configure parameters**:
   - **Node.js Version**: Select 20.11.0 (default), 18.19.0, or 21.6.0
   - **Package Manager**: Select npm (default), yarn, or pnpm
   - **Git Repository (Optional)**: Paste your repo URL
   - **Git Branch (Optional)**: Specify branch
4. Click **Create Workspace**

### 2. Access Your Environment

- **VS Code** - Web-based editor
- **WebStorm** - Full-featured IDE for backend
- **Fleet** - Lightweight alternative

### 3. Start Developing

```bash
cd ~/project
npm install
npm run dev
# Server runs on http://localhost:3000
```

## Template Parameters

### Node.js Version
- **Node.js 20 LTS** (Recommended)
- **Node.js 18 LTS** (Stable)
- **Node.js 21** (Latest)

### Package Manager
- **npm** (Default)
- **yarn**
- **pnpm**

### Git Repository & Branch
Clone your repo automatically on startup.

## Supported Frameworks

- **Express** - Minimal and flexible
- **Nest.js** - Enterprise-grade framework
- **Fastify** - High-performance alternative
- **Koa** - Modern middleware composition
- **Hapi** - Robust framework
- **Strapi** - Headless CMS
- **Loopback** - API framework

## Default Project Structure (Express)

```
project/
├── src/
│   └── index.js         # Express server (port 3000)
├── package.json         # Dependencies
├── .env.example         # Environment variables template
├── .eslintrc.json       # Linting
├── .prettierrc.json     # Formatting
├── jest.config.js       # Testing
└── .gitignore
```

## Available Commands

```bash
npm run dev       # Start with hot reload
npm run start     # Production start
npm run test      # Run tests
npm run lint      # Check code quality
npm run lint:fix  # Fix issues
npm run format    # Format code
```

## Pre-installed VS Code Extensions

- **ESLint** - Code linting
- **Prettier** - Code formatting
- **TypeScript** - Type support
- **REST Client** - Test APIs
- **Thunder Client** - Postman alternative
- **MongoDB** - Database management
- **PostgreSQL** - Database extension
- **Docker** - Container support
- **GitLens** - Git integration

## API Development

### Testing Endpoints

Use REST Client extension (create `.rest` file):
```http
### Get health check
GET http://localhost:3000/health

### Echo endpoint
POST http://localhost:3000/api/echo
Content-Type: application/json

{
  "message": "hello"
}
```

Or use Thunder Client from VS Code extension.

## Database Integration

### MongoDB
```bash
npm install mongodb
```

### PostgreSQL
```bash
npm install pg
```

### Prisma ORM
```bash
npm install @prisma/client
npx prisma init
```

## Environment Variables

Create `.env`:
```
NODE_ENV=development
PORT=3000
DATABASE_URL=postgresql://user:password@localhost:5432/dbname
MONGODB_URI=mongodb://localhost:27017/dbname
```

Access in code:
```javascript
const port = process.env.PORT || 3000
```

## Testing

Default Jest setup:
```bash
npm run test              # Run tests
npm run test -- --watch   # Watch mode
npm run test -- --coverage # Coverage report
```

## Production Deployment

Build for production:
```bash
npm run build    # If using TypeScript
npm run start    # Start production server
```

## Troubleshooting

### Port Already in Use
```bash
# Change port in .env
PORT=3001
```

### Database Connection Issues
```bash
# Test connection
npm install -g mongodb-shell
mongosh "mongodb://localhost:27017"
```

### Module Not Found
```bash
rm -rf node_modules package-lock.json
npm install
```

## Performance Tips

1. **Use clustering** for multi-core systems
2. **Enable compression** middleware
3. **Cache responses** with Redis
4. **Use connection pooling** for databases
5. **Monitor with APM** (Application Performance Monitoring)

## NVM Management

```bash
nvm list                 # Installed versions
nvm install 20.11.0      # Install specific version
nvm use 20.11.0          # Switch version
nvm alias default 20.11.0 # Set default
```

## Git Integration

```bash
cd ~/project
git init
git config user.name "Your Name"
git config user.email "your@email.com"
```

Environment variables pre-configured:
```bash
echo $GIT_AUTHOR_NAME
echo $GIT_AUTHOR_EMAIL
```

## Workspace Persistence

Your project files in `/home/coder/project` persist across rebuilds via Docker volumes.

## Documentation

- [Node.js Documentation](https://nodejs.org/docs/)
- [npm Documentation](https://docs.npmjs.com/)
- [Express Documentation](https://expressjs.com/)
- [Nest.js Documentation](https://docs.nestjs.com/)
- [Fastify Documentation](https://www.fastify.io/)
- [TypeScript Documentation](https://www.typescriptlang.org/)
- [Prisma Documentation](https://www.prisma.io/docs/)

---

**Happy backend development!** 🚀
