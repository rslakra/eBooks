# 🔁 Reverse Proxy

A **reverse proxy** is a server that sits in front of one or more backend servers. Clients talk only to the reverse proxy, and the proxy forwards each request to the right backend and returns the response. The client never connects to the backend directly and usually doesn't know it exists.

## Table of Contents

- [How a Reverse Proxy Works](#how-a-reverse-proxy-works)
- [Forward Proxy vs Reverse Proxy](#forward-proxy-vs-reverse-proxy)
- [What a Reverse Proxy Does](#what-a-reverse-proxy-does)
- [Where Reverse Proxies Are Used](#where-reverse-proxies-are-used)
- [Popular Reverse Proxies](#popular-reverse-proxies)
- [Example: NGINX as a Reverse Proxy](#example-nginx-as-a-reverse-proxy)
- [Reverse Proxy in the Cloud and at Scale](#reverse-proxy-in-the-cloud-and-at-scale)
- [Related Notes](#related-notes)

---

## How a Reverse Proxy Works

```mermaid
flowchart LR
    Client(["👤 Client<br/>(browser or app)"]) ==> RP["🔁 Reverse Proxy<br/>example.com"]

    subgraph Backend["🏢 Private network (hidden from clients)"]
        direction TB
        S1["🖥️ Backend server 1"]
        S2["🖥️ Backend server 2"]
        S3["🖥️ Backend server 3"]
    end

    RP ==> S1
    RP ==> S2
    RP ==> S3

    classDef client fill:#d6e9ff,stroke:#2b6cb0,stroke-width:2px,color:#102a43;
    classDef proxy fill:#ffe8cc,stroke:#dd6b20,stroke-width:2px,color:#4a2a07;
    classDef server fill:#d9f5dd,stroke:#2f855a,stroke-width:2px,color:#12361f;

    class Client client;
    class RP proxy;
    class S1,S2,S3 server;

    style Backend fill:#f3fcf4,stroke:#2f855a,stroke-width:2px,stroke-dasharray: 5 3
```

Step by step:

1. 🌍 The client sends a request to a public address, for example `https://example.com/app`.
2. 🔁 The reverse proxy receives it. It can end the TLS (HTTPS) connection, check the request, and look in its cache.
3. 🧭 It picks a backend using its rules, such as the host name, the URL path, or a load-balancing algorithm.
4. ➡️ It forwards the request to that backend over the private network.
5. ⬅️ The backend responds to the proxy.
6. 📤 The proxy returns the response to the client, and may cache it, compress it or add headers on the way.

```mermaid
sequenceDiagram
    autonumber
    actor Client as 👤 Client
    participant Proxy as 🔁 Reverse Proxy
    participant Cache as 🗃️ Cache
    participant Backend as 🖥️ Backend Server

    Client->>Proxy: HTTPS request for example.com/app
    Proxy->>Proxy: Terminate TLS and apply rules
    Proxy->>Cache: Is there a cached copy?
    alt Cache hit
        Cache-->>Proxy: Cached response
    else Cache miss
        Proxy->>Backend: Forward the request over HTTP
        Backend-->>Proxy: Response
        Proxy->>Cache: Store the response
    end
    Proxy-->>Client: Response (compressed, with headers added)
```

## Forward Proxy vs Reverse Proxy

The two are often confused. The difference is **who the proxy works for**.

```mermaid
flowchart TB
    subgraph Fwd["➡️ Forward proxy: works for the client"]
        direction LR
        CF(["👤 Clients"]) ==> FP["🛡️ Forward Proxy"] ==> IF["🌍 Internet"]
    end

    subgraph Rev["🔁 Reverse proxy: works for the server"]
        direction LR
        IR["🌍 Internet"] ==> RP["🔁 Reverse Proxy"] ==> SR["🖥️ Backend servers"]
    end

    classDef proxy fill:#ffe8cc,stroke:#dd6b20,stroke-width:2px,color:#4a2a07;
    classDef other fill:#d6e9ff,stroke:#2b6cb0,stroke-width:2px,color:#102a43;

    class FP,RP proxy;
    class CF,IF,IR,SR other;

    style Fwd fill:#f2f8ff,stroke:#2b6cb0,stroke-width:2px,stroke-dasharray: 5 3
    style Rev fill:#fff8ef,stroke:#dd6b20,stroke-width:2px,stroke-dasharray: 5 3
```

| | ➡️ Forward proxy | 🔁 Reverse proxy |
| :--- | :--- | :--- |
| **Sits in front of** | Clients | Servers |
| **Hides** | The clients from the internet | The servers from clients |
| **Set up by** | The client side (user or company network) | The server side (site owner) |
| **Typical uses** | Content filtering, anonymity, access control for users | Load balancing, TLS termination, caching, protection |
| **Client knows about it?** | Yes, it must be configured | Usually not |

> A MITM proxy (see [MITM Proxy](../MITM%20Proxy/INSTALL_CA.md)) is a client-side proxy that also decrypts HTTPS traffic. A reverse proxy is on the server side and is run by the site owner, so clients don't need to install any certificate.

## What a Reverse Proxy Does

| | Function | What it means |
| :-: | :--- | :--- |
| ⚖️ | **Load balancing** | Spreads requests across several backend servers so no single server is overloaded. |
| 🔒 | **TLS termination** | Handles HTTPS in one place, so backends can use plain HTTP and certificates are managed centrally. |
| 🗃️ | **Caching** | Stores responses (such as images and static files) and serves them without asking the backend again. |
| 📦 | **Compression** | Compresses responses (for example with gzip) to save bandwidth. |
| 🛡️ | **Security** | Hides the backend servers and IPs, blocks bad requests, limits request rates and can add a web application firewall (WAF). |
| 🧭 | **Routing** | Sends `/app` to one service and `/api` to another, or sends different host names to different backends. |
| ❤️ | **Health checks and failover** | Stops sending traffic to a backend that is down and uses the healthy ones. |
| 🔗 | **One entry point** | Many services share a single public address and domain. |

## Where Reverse Proxies Are Used

```mermaid
flowchart LR
    RP["🔁<br/>Reverse<br/>Proxy"]

    RP --> W["🌐 Websites and web apps<br/>Load balancing, TLS, caching"]
    RP --> M["🧩 Microservices<br/>One entry point, path routing"]
    RP --> A["🚪 API gateways<br/>Auth, rate limiting, routing"]
    RP --> K["☸️ Kubernetes<br/>Ingress controllers"]
    RP --> C["☁️ CDNs and cloud load balancers<br/>Edge caching and protection"]
    RP --> L["🏚️ Legacy and internal apps<br/>Add HTTPS and access control"]

    classDef proxy fill:#ffe8cc,stroke:#dd6b20,stroke-width:3px,color:#4a2a07;
    classDef use fill:#d9f5dd,stroke:#2f855a,stroke-width:2px,color:#12361f;

    class RP proxy;
    class W,M,A,K,C,L use;
```

- 🌐 **Websites and web apps:** Put NGINX, HAProxy or similar in front of the application servers to handle HTTPS, caching and load balancing.
- 🧩 **Microservices:** One public domain, with the proxy sending each path or host name to the right service.
- 🚪 **API gateways:** Many API gateways are reverse proxies with extra features such as authentication and rate limiting.
- ☸️ **Kubernetes:** An Ingress controller is a reverse proxy that routes outside traffic to Services. See [ingress vs nginx](../../Infrastructure/ingress%20vs%20nginx.md).
- ☁️ **CDNs and cloud load balancers:** Services like Amazon CloudFront, Cloudflare and cloud application load balancers work as reverse proxies at the edge of the network.
- 🏚️ **Legacy and internal apps:** Add TLS, authentication or access rules in front of an app you can't or don't want to change.

## Popular Reverse Proxies

| Type | Examples |
| :--- | :--- |
| 🧰 **Software you run yourself** | NGINX, HAProxy, Envoy, Traefik, Caddy, Apache HTTP Server |
| ☁️ **Managed cloud services** | AWS Application Load Balancer and CloudFront, Google Cloud Application Load Balancer, Azure Application Gateway and Front Door, Cloudflare |
| ☸️ **Kubernetes ingress controllers** | NGINX Ingress Controller, Traefik, HAProxy Ingress, Envoy-based gateways |

## Example: NGINX as a Reverse Proxy

This configuration receives HTTPS requests for `example.com` and balances them across two backend servers:

```nginx
upstream app_servers {
    server 10.0.0.11:8080;
    server 10.0.0.12:8080;
}

server {
    listen 443 ssl;
    server_name example.com;

    ssl_certificate     /etc/nginx/certs/example.com.crt;
    ssl_certificate_key /etc/nginx/certs/example.com.key;

    location / {
        proxy_pass http://app_servers;

        # Pass the original client details to the backend
        proxy_set_header Host              $host;
        proxy_set_header X-Real-IP         $remote_addr;
        proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

| Setting | Purpose |
| :--- | :--- |
| `upstream` | The group of backend servers. NGINX balances requests across them (round robin by default). |
| `proxy_pass` | Forwards the request to the upstream group. |
| `ssl_certificate` and `ssl_certificate_key` | TLS is terminated at the proxy. |
| `X-Forwarded-For` and `X-Real-IP` | Keep the real client IP, which the backend would otherwise see as the proxy's IP. |
| `X-Forwarded-Proto` | Tells the backend that the client used HTTPS. |

## Reverse Proxy in the Cloud and at Scale

```mermaid
flowchart TB
    User(["👤 Users worldwide"]) ==> DNS["🔤 DNS"]
    DNS ==> CDN["☁️ CDN / edge<br/>caching and DDoS protection"]
    CDN ==> LB["⚖️ Cloud load balancer<br/>spreads traffic across zones"]

    subgraph ZoneA["Zone A"]
        P1["🔁 Reverse proxy 1"]
    end
    subgraph ZoneB["Zone B"]
        P2["🔁 Reverse proxy 2"]
    end

    LB ==> P1
    LB ==> P2

    P1 --> App["🖥️ Application servers<br/>(autoscaled)"]
    P2 --> App
    App --> DB[("🗄️ Database")]

    classDef edge fill:#d6e9ff,stroke:#2b6cb0,stroke-width:2px,color:#102a43;
    classDef proxy fill:#ffe8cc,stroke:#dd6b20,stroke-width:2px,color:#4a2a07;
    classDef app fill:#d9f5dd,stroke:#2f855a,stroke-width:2px,color:#12361f;

    class DNS,CDN,LB edge;
    class P1,P2 proxy;
    class App,DB app;

    style ZoneA fill:#f5f9fb,stroke:#4a6fa5,stroke-width:2px,stroke-dasharray: 5 3
    style ZoneB fill:#f5f9fb,stroke:#4a6fa5,stroke-width:2px,stroke-dasharray: 5 3
```

Tips for a reliable and scalable setup:

- ⚙️ **Run at least two proxy instances** so one failure doesn't take the site down.
- 🌍 **Spread them across zones** and put a cloud load balancer in front.
- 📈 **Autoscale** the proxies and the backends based on load.
- ❤️ **Use health checks** so traffic goes only to healthy backends.
- 🗃️ **Cache static content** at the edge (CDN) and at the proxy to reduce backend load.
- 🔒 **Keep TLS certificates in one place** and renew them automatically.
- 🔍 **Log and monitor** the proxy. It sees all traffic, so it is the best place to measure latency and errors.

## Related Notes

- 🗂️ [Proxy overview](../README.md)
- ➡️ [Forward Proxy](../Forward%20Proxy/README.md): the client-side counterpart.
- 🎭 [High Anonymity Proxy](../High%20Anonymity%20Proxy/README.md): a forward proxy that hides your identity.
- ☸️ [Ingress vs NGINX](../../Infrastructure/ingress%20vs%20nginx.md): how a reverse proxy is used as a Kubernetes Ingress controller.
- 🕵️ [MITM Proxy](../MITM%20Proxy/INSTALL_CA.md): a client-side proxy that decrypts HTTPS traffic.
