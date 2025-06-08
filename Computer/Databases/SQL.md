# SQL



## SQL Execution Order

### SQL Execution Order (Logical Processing Order)
```text
1️⃣ FROM – Identifies the tables involved in the query.
2️⃣ JOIN – Combines data from multiple tables if specified.
3️⃣ WHERE – Filters rows before aggregation.
4️⃣ GROUP BY – Groups data into subsets.
5️⃣ HAVING – Filters aggregated data.
6️⃣ SELECT – Determines which columns or expressions are returned.
7️⃣ DISTINCT – Removes duplicate records.
8️⃣ ORDER BY – Sorts the results.
9️⃣ LIMIT/OFFSET – Restricts the number of rows returned.
```



## SQL Commands

### Create SQL User & Grant Permissions
```shell
CREATE USER 'mysql-user'@'localhost' IDENTIFIED BY 'Local!MySql!User';
GRANT ALL PRIVILEGES ON *.* TO 'mysql-user'@'localhost';
FLUSH PRIVILEGES;
SHOW GRANTS FOR 'mysql-user'@'localhost';
```

- Create SQL Example User & Grant Permissions
```shell
CREATE USER 'rslakra'@'localhost' IDENTIFIED BY 'MySql!Password';
GRANT ALL PRIVILEGES ON posts.* TO 'rslakra'@'localhost';
FLUSH PRIVILEGES;
SHOW GRANTS FOR 'rslakra'@'localhost';
```



# Reference




# Author

---

- Rohtash Lakra