# CloudWatch

---

AWS CloudWatch Logs


## Folder Structure Conventions

---

```
/
├── Computer                # The Computer
└── README.md
```


## Logs

---



### Logs Insights

#### Filter Query

```shell
[(w1="*ERROR*" || w1="*Exception*") && w1!="*WARN*"]
```


##### Find all logs for a given request ID or X-Ray trace ID
```shell
fields @timestamp, @message
| filter @message like /REQUEST_ID_GOES_HERE/
```

Note: ```/REQUEST_ID_GOES_HERE/``` is a placeholder for the actual request ```ID/xRayTraceId``` you want to search for. Bear in mind that ```/something/``` is a regular expression.

- Find 50 most recent errors
```shell
fields Timestamp, LogLevel, Message
| filter LogLevel == "ERR"
| sort @timestamp desc
| limit 50
```

OR

```shell
fields @timestamp, @message
| display @timestamp, @message, errorMessage, status!="200" as ERROR
| sort @timestamp desc
| limit 50
```

OR

```shell
fields @timestamp, @message
| filter status != "200"
| display @timestamp, @message, @status_code
| sort @timestamp desc
| limit 50
```

OR

```shell
fields @timestamp, @message, @requestId, @duration, @xrayTraceId, @logStream, @logStream
| filter
@message like /fail/ or
@message like /timed/ or
@message like /X-Amz-Function-Error/ or
@message like /status: 4/ or
@message like /status: 5/
| sort @timestamp desc
```


latest_charge_status

```shell
fields @timestamp, @message, @logStream
| filter @message like "[ERROR]"
| sort @timestamp desc
| limit 10
```

```shell
fields @timestamp, @message, @logStream
| filter @message like "154e2e3cf3b34bc09a3389662e400db8"
| sort @timestamp desc
| limit 10
```

##### Find logs containing a given ID

```
fields @timestamp, @message, @logStream, @log
| filter strcontains(@message, "42ae41edec1c4954904c276c3a60a645")
| sort @timestamp desc
| limit 100
```

##### Find logs containing a given ID and status

```shell
fields @timestamp, @message, @logStream
| filter strcontains(@message, "/42ae41edec1c4954904c276c3a60a645/status")
| sort @timestamp desc
| limit 100
```

##### Find logs containing a given project_id

```shell
fields @timestamp, @message, @logStream, @log
| filter @message like /Cannot create service request, no free or purchased tokens/
| parse @message "'project_id': '*'" as project_id
| sort @timestamp desc
```

##### Find logs containing an error message

```shell
fields @timestamp, @message, @logStream, @log
| filter @message like /MySQLInterfaceError/
| sort @timestamp desc
```

##### Find logs containing an error message and project_id

```shell
FIELDS @timestamp, @message, @logStream
| filter @message like /MySQLInterfaceError/
| parse @message "'project_id': '*'" as project_id
| SORT @timestamp desc
```


# Reference

---

- [Logs Insights](https://cloudash.dev/blog/cloudwatch-logs-insights-examples)


# Author

---

- [Rohtash Lakra](https://github.com/rslakra)

