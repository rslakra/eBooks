# What’s Read Repair?

Read repair is a process that automatically corrects inconsistent or outdated data in a distributed database during a read request. It's an anti-entropy mechanism that ensures that replicas are updated with the most recent data.

## How Read Repair Works

1. The coordinator node sends a data request to one replica node.
2. The coordinator sends digest requests to other replica nodes for consistency level (CL) greater than ONE.
3. If all nodes return consistent data, the coordinator returns it to the client.
4. If there is a mismatch in the data returned to the coordinator, a read is requested from all replicas involved in the query.
5. The results are merged and the latest version is written back to only the replicas involved in the request.

### Read Repair Flow

```mermaid
sequenceDiagram
    autonumber
    participant C as Client
    participant Co as Coordinator
    participant R1 as Replica 1 (data)
    participant R2 as Replica 2 (digest)
    participant R3 as Replica 3 (digest)

    C->>Co: Read request
    Co->>R1: Data request
    Co->>R2: Digest request (CL > ONE)
    Co->>R3: Digest request (CL > ONE)
    R1-->>Co: Data
    R2-->>Co: Digest
    R3-->>Co: Digest

    alt Digests match
        Co-->>C: Return data
    else Digest mismatch
        Co->>R1: Full read request
        Co->>R2: Full read request
        Co->>R3: Full read request
        R1-->>Co: Data
        R2-->>Co: Data
        R3-->>Co: Data
        Note over Co: Merge results, pick latest version
        Co->>R1: Write latest version
        Co->>R2: Write latest version
        Co->>R3: Write latest version
        Note over Co,R3: Blocking: client waits until repair completes
        Co-->>C: Return latest data
    end
```

Decision flow:

```mermaid
flowchart TD
    A[Client read request] --> B[Coordinator sends data request to one replica]
    B --> C{CL greater than ONE?}
    C -- No --> G[Return data to client]
    C -- Yes --> D[Coordinator sends digest requests to other replicas]
    D --> E{All responses consistent?}
    E -- Yes --> G
    E -- No --> F[Read from all replicas involved in the query]
    F --> H[Merge results and pick latest version]
    H --> I[Write latest version back to the replicas involved]
    I --> G
```

Read repair is blocking, meaning that a response is not returned to the client until the read repair has completed.

## Why are NoSQL databases like Cassandra or Riak not good choices compared to MongoDB?

- NoSQL databases like Cassandra, Riak, and DynamoDB need read repair during the reading stage and will therefore provide slower reads to write performance.
- They are leaderless NoSQL databases that provide weaker atomicity upon concurrent writes. Being a single leader database, MongoDB provides a higher read throughput because we can read from either the leader replica or the follower replicas. The write operations have to pass through the leader replica. It ensures our system’s availability for reading-intensive tasks even in cases where the leader dies.

### Comparison at a Glance

| Aspect | Cassandra / Riak / DynamoDB (leaderless) | MongoDB (single leader) |
| --- | --- | --- |
| Write path | Any replica can accept a write | All writes go through the leader replica |
| Read path | May need read repair (digest compare, merge, write back) | Read from the leader or follower replicas |
| Read latency | Slower when replicas are inconsistent (repair is blocking) | Higher read throughput, no read repair on the read path |
| Atomicity on concurrent writes | Weaker | Stronger (writes are serialized by the leader) |
| If the leader dies | No leader, so no election is needed | Leader election runs, then reads continue from followers |
| Best suited for | Write-heavy, always-available workloads | Read-intensive workloads |

### Leaderless vs Single Leader

```mermaid
flowchart LR
    subgraph L["Leaderless (Cassandra / Riak / DynamoDB)"]
        direction TB
        LC[Client] --> LCo[Coordinator]
        LCo <--> LA[Replica A]
        LCo <--> LB[Replica B]
        LCo <--> LD[Replica C]
        LCo -. "mismatch: read repair (blocking)" .-> LA
    end

    subgraph S["Single Leader (MongoDB)"]
        direction TB
        SW[Client writes] --> SL[Leader replica]
        SL -- replicates --> SF1[Follower 1]
        SL -- replicates --> SF2[Follower 2]
        SR[Client reads] --> SL
        SR --> SF1
        SR --> SF2
    end
```

### Leader Failure in MongoDB

```mermaid
sequenceDiagram
    participant C as Client
    participant L as Leader (primary)
    participant F1 as Follower 1
    participant F2 as Follower 2

    C->>L: Write
    L-->>F1: Replicate
    L-->>F2: Replicate
    Note over L: Leader dies
    C->>F1: Reads continue from followers
    F1-->>C: Data
    F1->>F2: Leader election
    F2-->>F1: Vote
    Note over F1: F1 becomes the new leader
    C->>F1: Writes resume
```

> **Note:** Since Cassandra inherently ensures availability more than MongoDB, choosing MongoDB over Cassandra might make our system look less available. However, the time taken by the leader election algorithm is negligible compared to the time elapsed between short URL generation and its first usage, so it doesn’t hamper our system’s availability.
