# ☸️ Kubernetes (K8S)

---

The ```Kubernetes (K8S)``` contains various learning materials.



## Table of Contents

---

- [Main Kubernetes Components](#main-kubernetes-components)
- [Basic kubectl Commands](#basic-kubectl-commands)
  - [CRUD Commands](#crud-commands)
  - [Status of Different K8s Components](#status-of-different-k8s-components)
  - [Debugging Pods](#debugging-pods)
  - [Use Configuration File for CRUD](#use-configuration-file-for-crud)
- [Connecting Services to Deployments](#connecting-services-to-deployments)



## Main Kubernetes Components

---

Main Kubernetes components summarized:

| | Component | Purpose |
| :-: | :--- | :--- |
| 📦 | **Pod** | The smallest deployable unit. It runs one or more containers. |
| 🔀 | **Service** | A stable network endpoint that load balances traffic to a set of Pods. |
| 🌐 | **Ingress** | Routes external HTTP/HTTPS traffic to Services. |
| 🚀 | **Deployment** | Manages stateless Pods: replicas, rolling updates and rollbacks. |
| 🗄️ | **StatefulSet** | Manages stateful Pods that need a stable identity and storage. |
| 💾 | **Volumes** | Storage that Pods can mount. |
| ⚙️ | **ConfigMap** | External, non-sensitive configuration for Pods. |
| 🔐 | **Secrets** | Sensitive data such as passwords, tokens and keys. |

> The component list comes from the original image. The "Purpose" column and the diagram below are added explanations.

### How the Components Fit Together

```mermaid
flowchart LR
    User(["👤 User / Client"])

    subgraph Cluster["☸️ Kubernetes Cluster"]
        direction LR
        Ingress["🌐 Ingress"]
        Service["🔀 Service"]
        Pod["📦 Pod"]
        Deployment["🚀 Deployment<br/>(stateless apps)"]
        StatefulSet["🗄️ StatefulSet<br/>(stateful apps)"]
        ConfigMap["⚙️ ConfigMap"]
        Secrets["🔐 Secrets"]
        Volumes["💾 Volumes"]

        Ingress ==> Service ==> Pod
        Deployment -. manages .-> Pod
        StatefulSet -. manages .-> Pod
        ConfigMap -. configuration .-> Pod
        Secrets -. credentials .-> Pod
        Volumes -. storage .-> Pod
    end

    User ==> Ingress

    classDef net fill:#d6e9ff,stroke:#2b6cb0,stroke-width:2px,color:#102a43;
    classDef workload fill:#d9f5dd,stroke:#2f855a,stroke-width:2px,color:#12361f;
    classDef config fill:#ffe8cc,stroke:#dd6b20,stroke-width:2px,color:#4a2a07;
    classDef pod fill:#ead9ff,stroke:#6b46c1,stroke-width:3px,color:#2d1b55;

    class Ingress,Service net;
    class Deployment,StatefulSet workload;
    class ConfigMap,Secrets,Volumes config;
    class Pod pod;

    style Cluster fill:#f5f9fb,stroke:#4a6fa5,stroke-width:2px,stroke-dasharray: 5 3
```

| Color | Meaning |
| :-: | :--- |
| 🟦 | Networking: Ingress and Service |
| 🟩 | Workload controllers: Deployment and StatefulSet |
| 🟧 | Configuration and storage: ConfigMap, Secrets and Volumes |
| 🟪 | The Pod that everything else connects to |



## Basic kubectl Commands

---

Create and debug Pods in a minikube cluster.

```mermaid
flowchart TB
    A["➕ Create<br/>kubectl create deployment"] --> B["📊 Check status<br/>kubectl get ..."]
    B --> C["🐞 Debug<br/>logs / exec / describe"]
    C --> D["✏️ Edit<br/>kubectl edit deployment"]
    D --> B
    D --> E["🗑️ Delete<br/>kubectl delete deployment"]

    F["📄 YAML file"] -. "kubectl apply -f" .-> B
    F -. "kubectl delete -f" .-> E

    classDef create fill:#d9f5dd,stroke:#2f855a,stroke-width:2px,color:#12361f;
    classDef view fill:#d6e9ff,stroke:#2b6cb0,stroke-width:2px,color:#102a43;
    classDef debug fill:#ffe8cc,stroke:#dd6b20,stroke-width:2px,color:#4a2a07;
    classDef edit fill:#ead9ff,stroke:#6b46c1,stroke-width:2px,color:#2d1b55;
    classDef delete fill:#ffd9d9,stroke:#c53030,stroke-width:2px,color:#4a1111;
    classDef file fill:#fff3bf,stroke:#b7791f,stroke-width:2px,color:#3d2c05;

    class A create;
    class B view;
    class C debug;
    class D edit;
    class E delete;
    class F file;
```

### CRUD Commands

| Action | Command |
| :--- | :--- |
| ➕ Create deployment | `kubectl create deployment [name]` |
| ✏️ Edit deployment | `kubectl edit deployment [name]` |
| 🗑️ Delete deployment | `kubectl delete deployment [name]` |

### Status of Different K8s Components

```bash
kubectl get nodes | pod | services | replicaset | deployment
```

> `|` means "or": run the command with one resource type at a time, for example `kubectl get pod`.

| Resource | Command |
| :--- | :--- |
| 🖥️ Nodes | `kubectl get nodes` |
| 📦 Pods | `kubectl get pod` |
| 🔀 Services | `kubectl get services` |
| 🔁 ReplicaSets | `kubectl get replicaset` |
| 🚀 Deployments | `kubectl get deployment` |

### Debugging Pods

| Action | Command |
| :--- | :--- |
| 📜 Log to console | `kubectl logs [pod name]` |
| 💻 Get interactive terminal | `kubectl exec -it [pod name] -- bin/bash` |
| 🔍 Get info about pod | `kubectl describe pod [pod name]` |

### Use Configuration File for CRUD

| Action | Command |
| :--- | :--- |
| ✅ Apply a configuration file | `kubectl apply -f [file name]` |
| 🗑️ Delete with configuration file | `kubectl delete -f [file name]` |



## Connecting Services to Deployments

---

The Service's `selector` (`app: nginx`) must match the labels of the Deployment's Pods, so the Service knows which Pods to route traffic to. In the original diagram, the arrows point from the Service's `app: nginx` selector to the Deployment's `app: nginx` labels (lines 6 and 15).

```mermaid
flowchart LR
    Client(["👤 Client"]) ==> Svc

    subgraph SvcBox["🔀 Service: nginx-service"]
        Svc["selector:<br/>app: nginx"]
    end

    subgraph DepBox["🚀 Deployment: nginx-deployment (replicas: 2)"]
        direction TB
        Dep["metadata.labels:<br/>app: nginx<br/><br/>selector.matchLabels:<br/>app: nginx"]
        Tpl["template.metadata.labels:<br/>app: nginx"]
        Dep --> Tpl
    end

    Tpl -. creates .-> Pod1["📦 Pod 1<br/>app: nginx"]
    Tpl -. creates .-> Pod2["📦 Pod 2<br/>app: nginx"]

    Svc == "label match: app: nginx" ==> Pod1
    Svc == "label match: app: nginx" ==> Pod2

    classDef svc fill:#d6e9ff,stroke:#2b6cb0,stroke-width:2px,color:#102a43;
    classDef dep fill:#d9f5dd,stroke:#2f855a,stroke-width:2px,color:#12361f;
    classDef pod fill:#ead9ff,stroke:#6b46c1,stroke-width:2px,color:#2d1b55;

    class Svc svc;
    class Dep,Tpl dep;
    class Pod1,Pod2 pod;

    style SvcBox fill:#f2f8ff,stroke:#2b6cb0,stroke-width:2px,stroke-dasharray: 5 3
    style DepBox fill:#f3fcf4,stroke:#2f855a,stroke-width:2px,stroke-dasharray: 5 3
```

**Deployment**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx                # <-- label (line 6)
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx            # <-- Pod label (line 15)
    spec: ...   # collapsed in the original image
```

**Service**

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx                # <-- must match the labels above
  ports: ...   # collapsed in the original image
```



# Author

---

- [Rohtash Lakra](https://github.com/rslakra)
