# Lambda

---

The ```Lambda``` contains various .



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


## Lambda


### Test Lambda Locally:
```shell
sam local start-api
```

- Open Web Browser and paste the following link:
````shell
http://127.0.0.1:3000/invokeLambda
````

OR

```shell
curl -v 'http://127.0.0.1:3000/invokeLambda' \
-H 'content-type: application/json' \
-d '{ "batch_id": "1424ca20821c44fcbda643f6a8894c5e" }'

```

- Directly Invoking ```lambda``` function
```shell
sam local invoke MyFunction1 --env-vars environment_variables.json -e event.json
```


# Reference

- 



# Author

---

- Rohtash Lakra
