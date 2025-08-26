Jenkins
=======
---

The Jenkins helps to automate the build creation process (the CI/CD process).


## Folder Structure Conventions

---

```
/
├── Jenkins Host
│    ├── Jenkin
│    └── /
├── GitHub
│    ├── WebDemoRepo
│    └── /
├── AWS
│    ├── S3 Bucket
│    └── /
└── README.md
```


## Jenkin Setup Steps

1. Host Running
2. Download Jenkins
3. Download OpenJDK 11 and Install
4. Install Jenkins
4.1 Prerequisite: JDK
5. Login on Jenkins (as admin)
6. Install Dependencies
    - ```sudo apt-get install git```
    - 
7. Install Plugins
    - Blue Ocean
    - Pipeline AWS Steps
8. 


## Jenkin Dependencies
- JDK
- Git
- Maven
- Gradle
- Node
- Repo Specific Dependencies (like ```tidy``` for html)
- 