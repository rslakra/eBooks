# CloudWatch

---

The ```CloudWatch``` contains various .



## Folder Structure Conventions

---

```
    /
    ├── Cheatsheets             # The Cheatsheets
    ├── Computer                # The Computer
    ├── Cultural                # The Cultural
    ├── Interview Guide         # An Interview Guide
    └── README.md
```



## CloudWatch Log Filter Query

```
fields @timestamp, @message, @logStream, @log
| filter strcontains(@message, "42ae41edec1c4954904c276c3a60a645")
| sort @timestamp desc
| limit 100
```

---

```shell
fields @timestamp, @message, @logStream
| filter strcontains(@message, "/42ae41edec1c4954904c276c3a60a645/status")
| sort @timestamp desc
| limit 100
```

---

```shell
fields @timestamp, @message, @logStream, @log
| filter @message like /Cannot create service request, no free or purchased tokens/
| parse @message "'project_id': '*'" as project_id
| sort @timestamp desc
```

---

```shell
fields @timestamp, @message, @logStream, @log
| filter @message like /MySQLInterfaceError/
| sort @timestamp desc
```

---

```shell
FIELDS @timestamp, @message, @logStream
| filter @message like /MySQLInterfaceError/
| parse @message "'project_id': '*'" as project_id
| SORT @timestamp desc
```




# Author

---

- Rohtash Lakra

