# Gradle

Notes on installing and using Gradle, a build automation tool for Java, Kotlin, Groovy and other projects.

## Table of Contents

- [Installation](#installation)
- [Verify the installation](#verify-the-installation)
- [Common commands](#common-commands)
- [Gradle Wrapper](#gradle-wrapper)
- [Author](#author)

---

## Installation

The recommended way to install Gradle is with [SDKMAN!](https://sdkman.io), a tool for managing versions of SDKs. It works on macOS, Linux and Windows (via WSL or Git Bash).

### Step 1: Get SDKMAN

Go to [https://sdkman.io](https://sdkman.io).

### Step 2: Download and install SDKMAN

```bash
curl -s "https://get.sdkman.io" | bash
```

### Step 3: Add it to your path

The installer adds the SDKMAN setup lines to your shell profile (for example `~/.bashrc` or `~/.zshrc`). To use SDKMAN in the current terminal, either open a new terminal or run:

```bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
```

### Step 4: Install Gradle

```bash
sdk install gradle
```

To install a specific version, or list what is available:

```bash
sdk list gradle
sdk install gradle 8.5
```

---

## Verify the installation

```bash
sdk version
gradle -v
```

`gradle -v` prints the Gradle version, and the JVM and OS it runs on. Gradle needs a JDK, so check that `java -version` works too.

---

## Common commands

| Command | Description |
|---|---|
| `gradle init` | Create a new Gradle project |
| `gradle build` | Compile, test and package the project |
| `gradle clean` | Delete the `build/` directory |
| `gradle test` | Run the tests |
| `gradle tasks` | List the available tasks |
| `gradle dependencies` | Show the dependency tree |
| `sdk use gradle <version>` | Switch Gradle version in the current shell |
| `sdk default gradle <version>` | Set the default Gradle version |

---

## Gradle Wrapper

Most projects include the **Gradle Wrapper** (`gradlew` and `gradlew.bat`). It downloads and uses the Gradle version the project expects, so you don't need Gradle installed to build it.

```bash
./gradlew build        # macOS / Linux
gradlew.bat build      # Windows
```

To add the wrapper to a project, or update its version:

```bash
gradle wrapper --gradle-version 8.5
```

---

# Author
- Rohtash Lakra
