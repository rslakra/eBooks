# SQL

---



## SQL Execution Order

---

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

---

### Create SQL User & Grant Permissions
```shell
CREATE DATABASE posts CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'mysql-user'@'localhost' IDENTIFIED BY 'Password';
GRANT ALL PRIVILEGES ON *.* TO 'mysql-user'@'localhost';
FLUSH PRIVILEGES;
SHOW GRANTS FOR 'mysql-user'@'localhost';
```

- Create SQL Example User & Grant Permissions
```shell
CREATE DATABASE posts CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'post_user'@'localhost' IDENTIFIED BY 'Password';
GRANT ALL PRIVILEGES ON posts.* TO 'post_user'@'localhost';
FLUSH PRIVILEGES;
SHOW GRANTS FOR 'post_user'@'localhost';
```

- Revoke Privileges
```shell
REVOKE ALL PRIVILEGES ON posts.* FROM 'post_user'@'localhost';
DROP DATABASE IF EXISTS posts;
DROP USER IF EXISTS 'post_user'@'localhost';
FLUSH PRIVILEGES;
SHOW GRANTS FOR 'post_user'@'localhost';
```




# Reference

---



# Author

---

- [Rohtash Lakra](https://github.com/rslakra)