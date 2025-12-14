# Kotlin Development Template for Coder

A complete, production-ready development environment for Kotlin projects. Supports both JVM server applications and Kotlin multiplatform projects with Gradle as the build tool.

## Features

- **Flexible Kotlin Versions** - Choose Kotlin 1.9.21, 1.9.10, or 1.8.21
- **Gradle Build System** - Modern Gradle with Kotlin DSL support
- **Git Repository Cloning** - Automatically clone your Kotlin project
- **Spring Boot Integration** - Optional server-side development
- **Ktor Framework** - Lightweight async HTTP framework
- **Testing** - JUnit 5 pre-configured
- **VS Code Server** - Web-based IDE with Kotlin extensions
- **JetBrains IDEs** - IntelliJ IDEA and Fleet support
- **Hot Reload** - Automatic compilation on file changes

## Getting Started

### 1. Create a Workspace

1. Click **Create Workspace**
2. Select **kotlin** template
3. **Configure parameters**:
   - **Kotlin Version**: Select 1.9.21 (default), 1.9.10, or 1.8.21
   - **Gradle Version**: Select 8.5 (default), 8.4, or 8.3
   - **Git Repository (Optional)**: Paste your repo URL
   - **Git Branch (Optional)**: Specify branch
4. Click **Create Workspace**

### 2. Access Your Environment

- **VS Code** - Web editor with Kotlin support
- **IntelliJ IDEA** - Full-featured Kotlin IDE
- **Fleet** - Lightweight IDE alternative

### 3. Start Developing

```bash
cd ~/project
./gradlew build
./gradlew run
```

## Template Parameters

### Kotlin Version
- **Kotlin 1.9.21** (Recommended - Latest stable)
- **Kotlin 1.9.10** (Previous stable)
- **Kotlin 1.8.21** (Earlier LTS)

### Gradle Version
- **Gradle 8.5** (Recommended - Latest)
- **Gradle 8.4** (Stable)
- **Gradle 8.3** (Earlier version)

### Git Repository & Branch
Clone your Kotlin project on startup.

## Supported Use Cases

- **Spring Boot Applications** - Server-side development
- **Ktor Framework** - High-performance HTTP server
- **Kotlin Multiplatform** - Shared code across platforms
- **CLI Applications** - Command-line tools
- **Android Development** - Mobile apps (with Android SDK)
- **Backend Services** - Microservices and APIs
- **Kotlin/JS** - JavaScript compilation

## Default Project Structure

```
project/
├── src/
│   ├── main/
│   │   └── kotlin/
│   │       └── com/example/
│   │           └── App.kt
│   └── test/
│       └── kotlin/
│           └── com/example/
│               └── AppTest.kt
├── build.gradle.kts       # Gradle Kotlin DSL
├── settings.gradle.kts    # Project settings
└── gradle.properties      # Gradle properties
```

## Available Commands

### Build & Run
```bash
./gradlew build           # Compile and package
./gradlew run             # Run application
./gradlew clean           # Clean build
```

### Testing
```bash
./gradlew test            # Run all tests
./gradlew test --watch    # Watch mode (JUnit 5)
```

### IDE Integration
```bash
./gradlew idea            # Generate IntelliJ project files
./gradlew openIdea        # Open in IntelliJ IDEA
```

## Adding Dependencies

Edit `build.gradle.kts`:

### Spring Boot
```kotlin
plugins {
    kotlin("plugin.spring") version "1.9.21"
    id("org.springframework.boot") version "3.2.0"
}

dependencies {
    implementation("org.springframework.boot:spring-boot-starter-web")
    implementation("org.springframework.boot:spring-boot-starter-data-jpa")
}
```

### Ktor
```kotlin
dependencies {
    implementation("io.ktor:ktor-server-core:2.3.0")
    implementation("io.ktor:ktor-server-netty:2.3.0")
}
```

### Database
```kotlin
// H2 (embedded)
implementation("com.h2database:h2")

// PostgreSQL
implementation("org.postgresql:postgresql")

// MongoDB
implementation("org.mongodb.kotlin:mongodb-driver-kotlin-sync")
```

### Testing
```kotlin
testImplementation("org.junit.jupiter:junit-jupiter:5.10.0")
testImplementation("io.kotest:kotest-runner-junit5:5.7.0")
```

## Code Examples

### Hello World
```kotlin
fun main() {
    println("Hello from Kotlin in Coder!")
}
```

### Spring Boot
```kotlin
@SpringBootApplication
class Application

fun main(args: Array<String>) {
    runApplication<Application>(*args)
}
```

### Ktor Server
```kotlin
fun main() {
    embeddedServer(Netty, port = 8080) {
        routing {
            get("/") {
                call.respondText("Hello, World!")
            }
        }
    }.start(wait = true)
}
```

## Pre-installed VS Code Extensions

- **Kotlin** - Language support
- **Gradle** - Build tool integration
- **Extension Pack for Java** - Java/Kotlin essentials
- **Debugger for Java** - Debugging support
- **Docker** - Container support
- **GitLens** - Git visualization

## Gradle Wrapper

The Gradle Wrapper (`./gradlew`) automatically downloads and uses the correct Gradle version.

```bash
./gradlew wrapper --gradle-version=8.5  # Update wrapper version
```

## SDKMAN Version Management

Manage Kotlin and Gradle versions:

```bash
sdk list kotlin           # Available Kotlin versions
sdk install kotlin 1.9.21 # Install version
sdk use kotlin 1.9.21     # Switch version

sdk list gradle           # Available Gradle versions
sdk install gradle 8.5    # Install version
sdk use gradle 8.5        # Switch version
```

## Properties & Configuration

### gradle.properties
```properties
kotlin.code.style=official
org.gradle.jvmargs=-Xmx2048m
org.gradle.daemon=true
```

### build.gradle.kts
```kotlin
tasks {
    compileKotlin {
        kotlinOptions {
            jvmTarget = "21"
            freeCompilerArgs = listOf("-Xjsr305=strict")
        }
    }
}
```

## IDE Integration

### IntelliJ IDEA
The template works seamlessly with IntelliJ IDEA. Just open the project directory.

### VS Code
Kotlin plugin provides syntax highlighting and basic language support.

### Fleet
Use JetBrains Fleet for a lightweight Kotlin development experience.

## Debugging

### IntelliJ IDEA
1. Set breakpoints in your code
2. Run → Debug (Shift+F9)
3. Use debugger controls

### VS Code
1. Install Debugger for Java extension
2. Create launch configuration
3. Start debugging with F5

## Troubleshooting

### Build Fails
```bash
./gradlew clean build --stacktrace
```

### Out of Memory
Edit `gradle.properties`:
```properties
org.gradle.jvmargs=-Xmx4096m
```

### Daemon Issues
```bash
./gradlew --stop  # Stop daemon
./gradlew build   # Rebuild
```

### Kotlin Not Found
```bash
sdk install kotlin <version>
sdk use kotlin <version>
```

## Performance Tips

1. **Use Gradle daemon** - Much faster incremental builds
2. **Enable parallel builds** - `org.gradle.parallel=true`
3. **Use build cache** - `org.gradle.build.cache=true`
4. **Reduce logging** - Change `org.gradle.logging.level=quiet`
5. **Use Kotlin compiler caching** - Enabled by default

## Git Integration

```bash
cd ~/project
git init
git config user.name "Your Name"
git config user.email "your@email.com"
```

Environment variables auto-configured:
```bash
echo $GIT_AUTHOR_NAME
echo $GIT_AUTHOR_EMAIL
```

## Workspace Persistence

Your project files in `/home/coder/project` persist across rebuilds via Docker volumes.

## Documentation

- [Kotlin Documentation](https://kotlinlang.org/docs/)
- [Gradle Documentation](https://docs.gradle.org/)
- [Spring Boot with Kotlin](https://spring.io/guides/tutorials/spring-boot-kotlin/)
- [Ktor Server](https://ktor.io/docs/welcome.html)
- [Kotlin Multiplatform](https://kotlinlang.org/docs/multiplatform.html)

---

**Happy Kotlin development!** 🚀
