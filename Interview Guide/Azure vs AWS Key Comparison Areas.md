# ☁️ Azure vs AWS Key Comparison Areas

Service Comparison for Data Science & AI: AWS, Azure and Google Cloud.

| Icon | Meaning |
| :-: | :--- |
| 🟠 | AWS |
| 🔵 | Azure |
| 🔴 | Google Cloud |
| ❌ | Not available (N/A) |

## Table of Contents

- [Storage](#-storage)
- [Database](#-database)

---

## 💽 Storage

| Service type | Description | 🟠 AWS | 🔵 Azure | 🔴 Google Cloud |
| :--- | :--- | :--- | :--- | :--- |
| 🪣 **Object storage** | For storing any files you regularly use | Simple Storage Service (S3) | Blob Storage | Cloud Storage Buckets |
| 🧊 **Archive storage** | Low cost (but slower) storage for rarely used files | S3 Glacier Instant, Glacier Flexible, Glacier | Blob Cool/Cold/Archive tiers | Cloud Storage Nearline, Coldline, Archive |
| 📁 **File storage** | For storing files needing hierarchical organization | Elastic File System (EFS), FSx | Avere vFXT, Files | Filestore |
| 🧱 **Block storage** | For storing groups of related files | Elastic Block Storage | Disk Storage | Persistent Disk |
| 🔀 **Hybrid storage** | Move files between on-prem & cloud | Storage Gateway | StorSimple, Migrate | Storage Transfer Service |
| 🚚 **Edge/offline storage** | Move offline data to the cloud | Snowball | Data Box | Transfer Appliance |
| 🛡️ **Backup** | Prevent data loss | Backup | Backup | Backup and Disaster Recovery |

## 🛢️ Database

| Service type | Description | 🟠 AWS | 🔵 Azure | 🔴 Google Cloud |
| :--- | :--- | :--- | :--- | :--- |
| 🗃️ **Relational DB management** | Standard SQL DB (PostgreSQL, MySQL, SQL Server, etc.) | Relational Database Service (RDS), Aurora | SQL, SQL Database | Cloud SQL, Cloud Spanner |
| 🔑 **NoSQL: Key-value** | Redis-like DBs for semi-structured data | DynamoDB | Cosmos DB, Table storage | Cloud BigTable, Firestore |
| 📄 **NoSQL: Document** | MongoDB/CouchDB-like DBs for hierarchical JSON data | DocumentDB | Cosmos DB | Firestore, Firebase Realtime Database |
| 📊 **NoSQL: Column store** | Cassandra/HBase-like DBs for structured hierarchical data | Keyspaces | Cosmos DB | Cloud BigTable |
| 🕸️ **NoSQL: Graph** | Neo4j-like DBs for connected data | Neptune | ❌ N/A | ❌ N/A |
