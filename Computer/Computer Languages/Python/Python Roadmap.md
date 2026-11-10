# 🐍 Getting Started with Python - Roadmap

## Table of Contents

- [Roadmap at a Glance](#roadmap-at-a-glance)
- [Roadmap Diagram](#roadmap-diagram)
- [Step-by-Step Details](#step-by-step-details)

## Roadmap at a Glance

The 17 steps follow the numbering of the original roadmap. The five phases below are only a grouping to make it easier to read.

| Phase | Steps | Focus |
| :--- | :--- | :--- |
| 🟦 **Phase 1 - Foundations** | #1 - #4 | Basics, data structures, algorithms, modules |
| 🟩 **Phase 2 - Core Language** | #5 - #8 | Advanced topics, OOP, package managers, comprehensions |
| 🟧 **Phase 3 - Building Apps** | #9 - #11 | Frameworks, concurrency, environments |
| 🟪 **Phase 4 - Code Quality** | #12 - #14 | Static typing, code formatting, documentation |
| 🟥 **Phase 5 - Delivery** | #15 - #17 | Common packages, testing, DevOps |

## Roadmap Diagram

```mermaid
flowchart TB
    subgraph P1["🟦 PHASE 1 - FOUNDATIONS"]
        direction LR
        S1["<b>🧱 #1 Learn the Basics</b><br/>• Basic Syntax<br/>• Variables #amp; Data Types<br/>• Conditionals #amp; Loops<br/>• Lists, Tuples, Sets #amp; Dictionaries<br/>• Functions<br/>• Exceptions"]
        S2["<b>🗂️ #2 Data Structures</b><br/>• Arrays #amp; Linked Lists<br/>• Heaps<br/>• Hash Tables<br/>• Stacks #amp; Queues<br/>• Trees"]
        S3["<b>🧮 #3 Algorithms</b><br/>• Sorting<br/>• Searching<br/>• Recursion"]
        S4["<b>🧩 #4 Modules</b><br/>• Built-in<br/>• Custom"]
        S1 --> S2 --> S3 --> S4
    end

    subgraph P2["🟩 PHASE 2 - CORE LANGUAGE"]
        direction LR
        S5["<b>🚀 #5 Advanced Topics</b><br/>• Lambdas<br/>• Decorators<br/>• RegEx<br/>• Iterators"]
        S6["<b>🧬 #6 OOP</b><br/>• Classes<br/>• Inheritance<br/>• Methods #amp; Dunder"]
        S7["<b>📦 #7 Package Managers</b><br/>• PyPI<br/>• Pip<br/>• Conda<br/>• Poetry"]
        S8["<b>🔗 #8 Comprehensions</b><br/>• For Lists<br/>• For Generators"]
        S5 --> S6 --> S7 --> S8
    end

    subgraph P3["🟧 PHASE 3 - BUILDING APPS"]
        direction LR
        S9["<b>🌐 #9 Frameworks</b><br/>• Synchronous (Django, Flask, Pyramid...)<br/>• Asynchronous (Gevent, Aiohttp...)<br/>• Sync + Async (Flask)"]
        S10["<b>⚡ #10 Concurrency</b><br/>• Global Interpreter Lock (GIL)<br/>• Threading<br/>• Multiprocessing<br/>• Asynchrony (Uvloop)"]
        S11["<b>🛠️ #11 Environments</b><br/>• Pipenv<br/>• Virtualenv<br/>• Pyenv<br/>• Pyproject.toml"]
        S9 --> S10 --> S11
    end

    subgraph P4["🟪 PHASE 4 - CODE QUALITY"]
        direction LR
        S12["<b>🏷️ #12 Static Typing</b><br/>• Pydantic<br/>• Mypy<br/>• Pyright<br/>• Pyre"]
        S13["<b>🎨 #13 Code Formatting</b><br/>• Ruff<br/>• Black<br/>• YAPF"]
        S14["<b>📝 #14 Documentation</b><br/>• Sphinx"]
        S12 --> S13 --> S14
    end

    subgraph P5["🟥 PHASE 5 - DELIVERY"]
        direction LR
        S15["<b>🎁 #15 Common Packages</b><br/>• Typing<br/>• Tox"]
        S16["<b>🧪 #16 Testing</b><br/>• Doctest<br/>• Nose<br/>• Pytest<br/>• Unittest / PyUnit"]
        S17["<b>☁️ #17 DevOps</b><br/>• Deploy #amp; Scale<br/>• CI/CD #amp; Docker"]
        S15 --> S16 --> S17
    end

    P1 ==> P2 ==> P3 ==> P4 ==> P5

    classDef c1 fill:#d6e9ff,stroke:#2b6cb0,stroke-width:2px,color:#102a43;
    classDef c2 fill:#d9f5dd,stroke:#2f855a,stroke-width:2px,color:#12361f;
    classDef c3 fill:#ffe8cc,stroke:#dd6b20,stroke-width:2px,color:#4a2a07;
    classDef c4 fill:#ead9ff,stroke:#6b46c1,stroke-width:2px,color:#2d1b55;
    classDef c5 fill:#ffd9d9,stroke:#c53030,stroke-width:2px,color:#4a1111;

    class S1,S2,S3,S4 c1;
    class S5,S6,S7,S8 c2;
    class S9,S10,S11 c3;
    class S12,S13,S14 c4;
    class S15,S16,S17 c5;

    style P1 fill:#f2f8ff,stroke:#2b6cb0,stroke-width:2px,stroke-dasharray: 5 3
    style P2 fill:#f3fcf4,stroke:#2f855a,stroke-width:2px,stroke-dasharray: 5 3
    style P3 fill:#fff8ef,stroke:#dd6b20,stroke-width:2px,stroke-dasharray: 5 3
    style P4 fill:#f8f3ff,stroke:#6b46c1,stroke-width:2px,stroke-dasharray: 5 3
    style P5 fill:#fff3f3,stroke:#c53030,stroke-width:2px,stroke-dasharray: 5 3
```

## Step-by-Step Details

| # | Step | What to learn |
| :-: | :--- | :--- |
| 1 | 🧱 **Learn the Basics** | Basic Syntax, Variables & Data Types, Conditionals & Loops, Lists, Tuples, Sets & Dictionaries, Functions, Exceptions |
| 2 | 🗂️ **Data Structures** | Arrays & Linked Lists, Heaps, Hash Tables, Stacks & Queues, Trees |
| 3 | 🧮 **Algorithms** | Sorting, Searching, Recursion |
| 4 | 🧩 **Modules** | Built-in, Custom |
| 5 | 🚀 **Advanced Topics** | Lambdas, Decorators, RegEx, Iterators |
| 6 | 🧬 **OOP** | Classes, Inheritance, Methods & Dunder |
| 7 | 📦 **Package Managers** | PyPI, Pip, Conda, Poetry |
| 8 | 🔗 **Comprehensions** | For Lists, For Generators |
| 9 | 🌐 **Frameworks** | Synchronous (Django, Flask, Pyramid...), Asynchronous (Gevent, Aiohttp...), Sync + Async (Flask) |
| 10 | ⚡ **Concurrency** | Global Interpreter Lock (GIL), Threading, Multiprocessing, Asynchrony (Uvloop) |
| 11 | 🛠️ **Environments** | Pipenv, Virtualenv, Pyenv, Pyproject.toml |
| 12 | 🏷️ **Static Typing** | Pydantic, Mypy, Pyright, Pyre |
| 13 | 🎨 **Code Formatting** | Ruff, Black, YAPF |
| 14 | 📝 **Documentation** | Sphinx |
| 15 | 🎁 **Common Packages** | Typing, Tox |
| 16 | 🧪 **Testing** | Doctest, Nose, Pytest, Unittest / PyUnit |
| 17 | ☁️ **DevOps** | Deploy & Scale, CI/CD & Docker |
