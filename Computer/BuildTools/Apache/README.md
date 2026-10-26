# Apache Build Tools

Notes on build tools from the Apache Software Foundation.

## Table of Contents

- [Overview](#overview)
- [Apache Ant](#apache-ant)
- [Apache Maven](#apache-maven)
- [Ant vs Maven](#ant-vs-maven)
- [Resources](#resources)
- [Author](#author)

---

## Overview

| Tool | Approach | Config file | Best for |
|---|---|---|---|
| **Apache Ant** | Imperative: you script each build step | `build.xml` | Custom or legacy build scripts |
| **Apache Maven** | Declarative: convention over configuration | `pom.xml` | Standard Java projects with dependency management |
| **Apache Ivy** | Dependency manager that works with Ant | `ivy.xml` | Adding dependency management to Ant builds |

---

## Apache Ant

Ant is a Java-based build tool. A build file defines **targets** (steps) made of **tasks** (actions such as `javac`, `jar` and `copy`). Targets can depend on each other.

### Requirements

- A JDK installed, with `JAVA_HOME` set
- Ant installed, with its `bin` folder on your `PATH`

```bash
ant -version
```

### Example `build.xml`

```xml
<project name="hello" default="jar" basedir=".">

    <property name="src.dir"   value="src"/>
    <property name="build.dir" value="build"/>

    <target name="clean">
        <delete dir="${build.dir}"/>
    </target>

    <target name="compile">
        <mkdir dir="${build.dir}/classes"/>
        <javac srcdir="${src.dir}" destdir="${build.dir}/classes"
               includeantruntime="false"/>
    </target>

    <target name="jar" depends="compile">
        <jar destfile="${build.dir}/hello.jar" basedir="${build.dir}/classes"/>
    </target>

</project>
```

### Common commands

| Command | Description |
|---|---|
| `ant` | Run the default target |
| `ant clean` | Run a specific target |
| `ant clean jar` | Run several targets in order |
| `ant -projecthelp` | List the targets in the build file |
| `ant -f other.xml` | Use a different build file |
| `ant -Dname=value` | Set a property from the command line |

---

## Apache Maven

Maven builds projects from a `pom.xml` that describes the project, its dependencies and plugins. It uses a standard directory layout and a fixed build lifecycle.

### Common lifecycle commands

| Command | Description |
|---|---|
| `mvn clean` | Delete the `target/` directory |
| `mvn compile` | Compile the source code |
| `mvn test` | Run the unit tests |
| `mvn package` | Build the JAR or WAR |
| `mvn install` | Install the package into the local repository (`~/.m2`) |
| `mvn clean install` | Clean, then build and install |
| `mvn dependency:tree` | Show the dependency tree |

See the [Maven commands cheat sheet](../../Cheatsheet/Maven-Commands-Cheat-Sheet.png) for more.

---

## Ant vs Maven

| | Ant | Maven |
|---|---|---|
| Style | You script every step | Follows conventions and a lifecycle |
| Dependencies | Manual, or add Ivy | Built in |
| Flexibility | Very high | Moderate |
| Learning curve | Low, but scripts grow large | Moderate |
| Project layout | Any | Standard (`src/main/java`, `src/test/java`) |

---

## Resources

Local copies of the Ant documentation in this folder:

- [Ant - The Definitive Guide](Ant/Ant%20-%20The%20Definitive%20Guide.pdf)
- [Apache Ant User Manual Guide v1.6.0](Ant/Apache%20Ant%20User%20Manual%20Guide-v1.6.0.pdf)
- [Appendix E - Ant Task Reference](Ant/APPENDIXE%20-%20Ant%20Task%20Reference.pdf)

Online:

- [Apache Ant](https://ant.apache.org/)
- [Apache Maven](https://maven.apache.org/)
- [Apache Ivy](https://ant.apache.org/ivy/)

---

# Author
- Rohtash Lakra
