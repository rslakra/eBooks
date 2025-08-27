System Design Interview
=======================

This repository contains all my electronic books, which are categorized based 
on the programming languages and usability. It might be some of the books have 
copyright as most of these are downloaded from the public links (and owner of 
those books, can send email to remove that book from this repository, and I'll 
remove that one) and for personal learning only, so if anyone either downloads 
or uses this repository AS IT IS with their own responsibility.



## Folder Structure Conventions

---

```
/
├── Computer                            # contains the computer ebooks
│    ├── BuildTools                     # contains the build-tools
│    │    ├── Gradle                    # contains the Gradle ebooks
│    │    ├── Maven                     # contains the Maven ebooks
│    │    ├── README.md
│    │    └── /
│    ├── Computer Languages             # Computer langauges ebooks
│    │    ├── Java                      # Java ebooks
│    │    ├── Mobile                    # Mobile ebooks
│    │    ├── Python                    # Python books
│    │    └── /
│    ├── Database                       # database ebooks
│    ├── IDEs                           # contains the IDE's ebooks
│    ├── Infrastructure                 # contains the infrastructure ebooks
│    │    ├── Docker                    # contains the docker ebooks
│    │    ├── GitHub                    # contains the GitHub ebooks
│    │    ├── VCS                       # contains the VCS (Verson Control System) ebooks
│    │    └── /
│    ├── Servers                        # contains the server ebooks
│    ├── README.md
│    └── /
├── Domains                             # contains the domain specific ebooks
├── Interpersonal Skills                # contains the interpersonal skills ebooks
├── Interview Guide                     # contains the interview ebooks
│    ├── Coding Interview               # contains the coding ebooks
│    │    ├── Data Structure            # contains the data structure ebooks
│    │    ├── README.md
│    ├── System Design Interview        # contains the python ebooks
│    │    ├── Elasticsearch
│    │    ├── README.md
│    ├── README.md
│    └── /
├── README.md
└── /
```


## System Design



## C4 Software Architecture Model

---

The C4 stands for ```context```, ```containers```, ```components```, and ```code``` — a set of hierarchical diagrams that you can use to describe your software architecture at different zoom levels, each useful for different audiences. 



### Daily User Actions (DUA)

---

Daily User Actions (DUA) is a metric that measures the number of actions taken by users on a website or mobile app within a specific time period, typically per day. It is used to measure engagement and activity on a website or mobile app.

The calculation formula for DUA is:

```DUA = Total Number of Actions / Total Number of Days```

For example, if a website has 100,000 total actions in a month and 30 days, the DUA would be:

```DUA = 100,000 / 30 = 3,333.33```


DUA can be calculated over different time intervals such as daily, weekly or monthly. And also, it's important to consider the specific actions that you're measuring, as different actions may have different values.

| Metric               | Description                                    | Example |
|:---------------------|:-----------------------------------------------|:--------|
| Profile views        | The number of times a user's profile is viewed | 3,000   |
| Posts created        | The number of posts created by users           | 1,500   |
| Comments made        | The number of comments made by users           | 500     |
| Likes given          | The number of likes given by users             | 2,000   |
| Shares made          | The number of shares made by users             | 200     |
| Direct messages sent | The number of direct messages sent by users    | 100     |
| Metric               | Metric                                         | Metric  |


# Reference

---

## System Design Solutions & Skills Builder

| Category                       | Name/Link Title                                   | External URL                                                                                                                         | Description                                                                                                                                                       |  
|--------------------------------|---------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| URL Shortener                  | How to Design URL Shortener like TinyURL          | https://bit.ly/3dZoQ2G                                                                                                               |                                                                                                                                                                   | 
| URL Shortener                  | Design URL Shortening Service                     | https://buff.ly/3WYT3Df                                                                                                              |                                                                                                                                                                   |  
| Twitter                        | Design Twitter                                    | https://buff.ly/3WVJbtD                                                                                                              |                                                                                                                                                                   |  
| CDN                            | Design Content Delivery Network (CDN)             | https://bit.ly/3dZoQ2G                                                                                                               |                                                                                                                                                                   | 
| Parking                        | Design Parking Garage                             | https://bit.ly/3eMUosX                                                                                                               |                                                                                                                                                                   | 
| Parking                        | Design an Efficient Parking Lot                   | https://buff.ly/46DplGW                                                                                                              |                                                                                                                                                                   |
| Vending Machine                | Design Vending Machine                            | https://lnkd.in/gSnhTCTk                                                                                                             |                                                                                                                                                                   | 
| Distributed Key-Value Store    | How to Design Distributed Key-Value Store         | https://bit.ly/3pMiO8g                                                                                                               |                                                                                                                                                                   |  
| Cache                          | Design Distributed Cache                          | https://bit.ly/3P3eqMN                                                                                                               |                                                                                                                                                                   | 
| Store and Share text Online    | How to Design Text Storage Service like Pastebin? | https://lnkd.in/gb3Ptkdu                                                                                                             | platform that allows users to store and share plain text online. Several alternatives to **Pastebin** includes **PrivateBin**, **GitHub Gists**, **JustPaste.it** | 
| TicketMaster                   | Design TicketMaster                               | https://buff.ly/4ci4fz8                                                                                                              |                                                                                                                                                                   | 
| -                              | -                                                 | -                                                                                                                                    | -                                                                                                                                                                 |
| Category                       | Title                                             | URL                                                                                                                                  |                                                                                                                                                                   |
| -                              | -                                                 | -                                                                                                                                    | -                                                                                                                                                                 |
| Distributed Key-Value DB Store | Dynamo -Highly Available Key-value Store          | https://www.designgurus.io/course-play/grokking-the-advanced-system-design-interview/doc/dynamo-introduction                         |                                                                                                                                                                   | 
| Distributed Messaging System   | Kafka                                             | https://www.designgurus.io/course-play/grokking-the-advanced-system-design-interview/doc/messaging-systems-introduction              | A Distributed Messaging System for Log Processing                                                                                                                 | 
| Hashing                        | Consistent Hashing                                | https://www.designgurus.io/course-play/grokking-the-advanced-system-design-interview/doc/2-consistent-hashing                        | Data distribution with minimal disruption during scaling.                                                                                                         | 
| Category                       | Paxos                                             | https://www.microsoft.com/en-us/research/wp-content/uploads/2016/12/paxos-simple-Copy.pdf                                            | Protocol for distributed consensus                                                                                                                                | 
| Distributed Storage System     | Bigtable                                          | https://www.designgurus.io/course-play/grokking-the-advanced-system-design-interview/doc/bigtable-introduction                       | A Distributed Storage System for Structured Data                                                                                                                  | 
| Protocols                      | Gossip protocol                                   | https://highscalability.com/using-gossip-protocols-for-failure-detection-monitoring-mess                                             | For failure detection and more.                                                                                                                                   | 
| Distributed Locking            | Chubby                                            | https://www.designgurus.io/course-play/grokking-the-advanced-system-design-interview/doc/chubby-introduction                         | Lock service for loosely-coupled distributed systems                                                                                                              | 
| Category                       | ZooKeeper                                         | https://www.designgurus.io/blog/apache-zookeeper-architecture-system-design                                                          | Wait-free coordination for Internet-scale systems                                                                                                                 | 
| Category                       | MapReduce                                         | https://static.googleusercontent.com/media/research.google.com/en//archive/mapreduce-osdi04.pdf                                      | Simplified Data Processing on Large Clusters                                                                                                                      | 
| Distributed File System        | HDFS                                              | https://www.designgurus.io/course-play/grokking-the-advanced-system-design-interview/doc/hadoop-distributed-file-system-introduction | A Distributed File System                                                                                                                                         | 
| Distributed NoSQL Database     | Cassandra                                         | https://www.designgurus.io/course-play/grokking-the-advanced-system-design-interview/doc/cassandra-introduction                      | A distributed, decentralized, scalable, and highly available NoSQL database.                                                                                      | 
| Social Media                   | Instagram                                         | https://www.designgurus.io/course-play/grokking-the-system-design-interview/doc/designing-instagram                                  | Instagram is a social networking service that enables its users to upload and share their photos and videos with other users.                                     | 
| -                              | -                                                 | -                                                                                                                                    | -                                                                                                                                                                 |
| Category                       | Title                                             | URL                                                                                                                                  |                                                                                                                                                                   | 



# Author

---

- [Rohtash Lakra](https://github.com/rslakra)
