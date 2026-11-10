# 🧭 HTTP Decision Diagram (v4.0.201410)

An activity diagram that describes how an HTTP response status code is resolved, given various methods and headers, implemented via semantic callbacks.

The original is one very wide diagram that starts at the bottom and moves up and to the right. Here it is split into **nine stages**, one for each colored region of the original. Every stage is a vertical diagram that reads from the top down. The first diagram shows how the stages connect.

## Table of Contents

- [How to Read the Diagrams](#how-to-read-the-diagrams)
- [Overview: How the Stages Connect](#overview-how-the-stages-connect)
- [1. System](#1-system)
- [2. Request](#2-request)
- [3. Accept](#3-accept)
- [4. Retrieve](#4-retrieve)
- [5. Precondition](#5-precondition)
- [6. Create](#6-create)
- [7. Process](#7-process)
- [8. Response](#8-response)
- [9. Alternative](#9-alternative)
- [Where Each Status Code Comes From](#where-each-status-code-comes-from)

---

## How to Read the Diagrams

| Shape or color | Meaning |
| :--- | :--- |
| 🟨 **Diamond** | A decision (a callback that returns `true` or `false`). The name is the callback name from the original. |
| **Edge label** `true` / `false` | Which way the flow goes. In the original, green arrows are `true` and orange arrows are `false`. |
| 🟦 / 🟩 / 🟪 / 🟧 / 🟥 | Result boxes: 1xx informational, 2xx success, 3xx redirect, 4xx client error, 5xx server error. |
| ⬜ **Rounded box** `➡️ Continue to ...` | The flow goes on to another stage. |

> The original uses the spelling `are_expect_extentions_implemented`. It is kept as written so you can match it to the source.

---

## Overview: How the Stages Connect

```mermaid
%%{init: {"themeVariables": {"fontSize": "22px"}, "flowchart": {"nodeSpacing": 50, "rankSpacing": 60, "padding": 20}}}%%
flowchart TB
    S(["⚫ start"]) --> SYS["<b>1. System</b><br/>B24 to B17<br/>service and protocol checks"]
    SYS --> REQ["<b>2. Request</b><br/>B12 to B2<br/>method, auth, content checks"]
    REQ --> ACC["<b>3. Accept</b><br/>C1 to E6<br/>content negotiation"]
    ACC --> RET["<b>4. Retrieve</b><br/>G7, H9, I7 to I4<br/>does the resource exist?"]
    RET -->|"resource exists"| PRE["<b>5. Precondition</b><br/>C9 to F14<br/>If-Match, If-None-Match, ..."]
    RET -->|"resource missing"| CRE["<b>6. Create</b><br/>K3 to M3<br/>create the resource"]
    PRE --> PRO["<b>7. Process</b><br/>J10 to L14<br/>GET, HEAD, DELETE, PUT, POST"]
    CRE --> RES["<b>8. Response</b><br/>N3 to N14<br/>choose the success code"]
    PRO --> RES
    RES --> ALT["<b>9. Alternative</b><br/>D21 to N24<br/>alternative representation"]
    ALT --> F(["⚫ finish"])

    classDef sys fill:#e6edf5,stroke:#4a5568,stroke-width:2px,color:#1a202c;
    classDef req fill:#d6e9ff,stroke:#2b6cb0,stroke-width:2px,color:#102a43;
    classDef acc fill:#eaf5c9,stroke:#6b8e23,stroke-width:2px,color:#27330b;
    classDef ret fill:#ffffff,stroke:#718096,stroke-width:2px,color:#1a202c;
    classDef pre fill:#ffe8cc,stroke:#dd6b20,stroke-width:2px,color:#4a2a07;
    classDef cre fill:#ead9ff,stroke:#6b46c1,stroke-width:2px,color:#2d1b55;
    classDef pro fill:#ffd9d9,stroke:#c53030,stroke-width:2px,color:#4a1111;
    classDef res fill:#d9f5dd,stroke:#2f855a,stroke-width:2px,color:#12361f;
    classDef alt fill:#e2e8f0,stroke:#4a5568,stroke-width:2px,color:#1a202c;
    classDef ends fill:#1a202c,stroke:#1a202c,color:#ffffff;

    class SYS sys;
    class REQ req;
    class ACC acc;
    class RET ret;
    class PRE pre;
    class CRE cre;
    class PRO pro;
    class RES res;
    class ALT alt;
    class S,F ends;
```

Most stages can also stop early by returning an error status code. Those exits are shown inside each stage.

---

## 1. System

Checks that the service and the request can be handled at all. In the original, this is the bottom-left part, read from the bottom up.

```mermaid
%%{init: {"themeVariables": {"fontSize": "22px"}, "flowchart": {"nodeSpacing": 50, "rankSpacing": 60, "padding": 20}}}%%
flowchart TB
    start(["⚫ start"]) --> B24{"is_service_available"}
    B24 -->|false| R503["503 Service Unavailable"]
    B24 -->|true| B23{"is_uri_too_long"}
    B23 -->|true| R414["414 URI Too Long"]
    B23 -->|false| B22{"are_headers_too_large"}
    B22 -->|true| R431["431 Request Header Fields Too Large"]
    B22 -->|false| B21{"is_method_implemented"}
    B21 -->|false| R501["501 Not Implemented"]
    B21 -->|true| B20{"are_content_headers_implemented"}
    B20 -->|false| R501
    B20 -->|true| B19{"is_functionality_implemented"}
    B19 -->|false| R501
    B19 -->|true| B18{"are_expect_extentions_implemented"}
    B18 -->|false| R417["417 Expectation Failed"]
    B18 -->|true| B17{"is_system_block_ok"}
    B17 -->|false| R500["500 Internal Server Error"]
    B17 -->|true| NEXT(["➡️ Continue to 2. Request (B12)"])

    classDef d fill:#fff3bf,stroke:#b7791f,stroke-width:2px,color:#3d2c05;
    classDef c fill:#ffe8cc,stroke:#dd6b20,stroke-width:2px,color:#4a2a07;
    classDef e fill:#ffd9d9,stroke:#c53030,stroke-width:2px,color:#4a1111;
    classDef n fill:#e2e8f0,stroke:#4a5568,stroke-width:2px,color:#1a202c;
    classDef ends fill:#1a202c,stroke:#1a202c,color:#ffffff;

    class B24,B23,B22,B21,B20,B19,B18,B17 d;
    class R414,R431,R417 c;
    class R503,R501,R500 e;
    class NEXT n;
    class start ends;
```

---

## 2. Request

Checks the method, authorization and the request body.

```mermaid
%%{init: {"themeVariables": {"fontSize": "22px"}, "flowchart": {"nodeSpacing": 50, "rankSpacing": 60, "padding": 20}}}%%
flowchart TB
    IN(["⬆️ From 1. System"]) --> B12{"is_method_allowed"}
    B12 -->|false| R405["405 Method Not Allowed"]
    B12 -->|true| B11{"is_authorized"}
    B11 -->|false| R401["401 Unauthorized"]
    B11 -->|true| B10{"expects_continue"}
    B10 -->|true| R100["100 Continue"]
    R100 --> B9
    B10 -->|false| B9{"has_content"}
    B9 -->|true| B8{"is_content_too_large"}
    B9 -->|false| B5{"is_forbidden"}
    B8 -->|true| R413["413 Payload Too Large"]
    B8 -->|false| B7{"is_content_type_accepted"}
    B7 -->|false| R415["415 Unsupported Media Type"]
    B7 -->|true| B6{"from_content"}
    B6 -->|false| R400["400 Bad Request"]
    B6 -->|true| B5
    B5 -->|true| R403["403 Forbidden"]
    B5 -->|false| B4{"is_method_trace"}
    B4 -->|true| R200["200 OK"]
    B4 -->|false| B3{"is_method_options"}
    B3 -->|true| R200
    B3 -->|false| B2{"is_request_block_ok"}
    B2 -->|false| R400
    B2 -->|true| NEXT(["➡️ Continue to 3. Accept (C1)"])

    classDef d fill:#fff3bf,stroke:#b7791f,stroke-width:2px,color:#3d2c05;
    classDef i fill:#d6e9ff,stroke:#2b6cb0,stroke-width:2px,color:#102a43;
    classDef s fill:#d9f5dd,stroke:#2f855a,stroke-width:2px,color:#12361f;
    classDef c fill:#ffe8cc,stroke:#dd6b20,stroke-width:2px,color:#4a2a07;
    classDef n fill:#e2e8f0,stroke:#4a5568,stroke-width:2px,color:#1a202c;

    class B12,B11,B10,B9,B8,B7,B6,B5,B4,B3,B2 d;
    class R100 i;
    class R200 s;
    class R405,R401,R413,R415,R400,R403 c;
    class IN,NEXT n;
```

---

## 3. Accept

Content negotiation: `Accept`, `Accept-Language`, `Accept-Charset` and `Accept-Encoding`. Any mismatch goes to the `ignore_accept_block_mismatches` decision.

```mermaid
%%{init: {"themeVariables": {"fontSize": "12px"}, "flowchart": {"nodeSpacing": 20, "rankSpacing": 25, "padding": 6}}}%%
flowchart TB
    IN(["⬆️ From 2. Request"]) --> C1{"has_accept"}
    E6{"ignore_accept_block_mismatches"}

    C1 -->|true| C2{"accept_matches"}
    C1 -->|false| D2{"has_accept_language"}
    C2 -->|true| D2
    C2 -->|false| E6

    D2 -->|true| D3{"accept_language_matches"}
    D2 -->|false| E3{"has_accept_charset"}
    D3 -->|true| E3
    D3 -->|false| E6

    E3 -->|true| E4{"accept_charset_matches"}
    E3 -->|false| F4{"has_accept_encoding"}
    E4 -->|true| F4
    E4 -->|false| E6

    F4 -->|true| F5{"accept_encoding_matches"}
    F4 -->|false| NEXT(["➡️ Continue to 4. Retrieve (G7)"])
    F5 -->|true| NEXT
    F5 -->|false| E6

    E6 -->|false| R406["406 Not Acceptable"]
    E6 -->|true| NEXT

    classDef d fill:#fff3bf,stroke:#b7791f,stroke-width:2px,color:#3d2c05;
    classDef c fill:#ffe8cc,stroke:#dd6b20,stroke-width:2px,color:#4a2a07;
    classDef n fill:#e2e8f0,stroke:#4a5568,stroke-width:2px,color:#1a202c;

    class C1,C2,D2,D3,E3,E4,F4,F5,E6 d;
    class R406 c;
    class IN,NEXT n;
```

---

## 4. Retrieve

Decides whether the resource exists. If it exists, the flow goes to the preconditions. If it is missing, the flow checks for a precondition and then for a redirect or "gone" result.

```mermaid
%%{init: {"themeVariables": {"fontSize": "12px"}, "flowchart": {"nodeSpacing": 20, "rankSpacing": 25, "padding": 6}}}%%
flowchart TB
    IN(["⬆️ From 3. Accept"]) --> G7{"missing"}
    G7 -->|false| NEXTP(["➡️ Continue to 5. Precondition (C9)"])
    G7 -->|true| H9{"missing_has_precondition"}
    H9 -->|true| R412["412 Precondition Failed"]
    H9 -->|false| I7{"moved"}
    I7 -->|true| I6{"moved_permanently"}
    I7 -->|false| NEXTC(["➡️ Continue to 6. Create (K3)"])
    I6 -->|true| R308["308 Permanent Redirect"]
    I6 -->|false| I5{"moved_temporarily"}
    I5 -->|true| R307["307 Temporary Redirect"]
    I5 -->|false| I4{"gone_permanently"}
    I4 -->|true| R410["410 Gone"]
    I4 -->|false| NEXTC

    classDef d fill:#fff3bf,stroke:#b7791f,stroke-width:2px,color:#3d2c05;
    classDef r fill:#ead9ff,stroke:#6b46c1,stroke-width:2px,color:#2d1b55;
    classDef c fill:#ffe8cc,stroke:#dd6b20,stroke-width:2px,color:#4a2a07;
    classDef n fill:#e2e8f0,stroke:#4a5568,stroke-width:2px,color:#1a202c;

    class G7,H9,I7,I6,I5,I4 d;
    class R308,R307 r;
    class R412,R410 c;
    class IN,NEXTP,NEXTC n;
```

---

## 5. Precondition

Conditional request headers for an existing resource: `If-Match`, `If-Unmodified-Since`, `If-None-Match` and `If-Modified-Since`.

```mermaid
%%{init: {"themeVariables": {"fontSize": "12px"}, "flowchart": {"nodeSpacing": 20, "rankSpacing": 25, "padding": 6}}}%%
flowchart TB
    IN(["⬆️ From 4. Retrieve (resource exists)"]) --> C9{"has_if_match"}

    C9 -->|true| E9{"if_match_matches"}
    C9 -->|false| C10{"has_if_unmodified_since"}
    E9 -->|true| E11{"has_if_none_match"}
    E9 -->|false| R412["412 Precondition Failed"]

    C10 -->|true| C11{"if_unmodified_since_matches"}
    C10 -->|false| E11
    C11 -->|true| E11
    C11 -->|false| R412

    E11 -->|true| F11{"if_none_match_matches"}
    E11 -->|false| E12{"has_if_modified_since"}
    F11 -->|true| NEXT(["➡️ Continue to 7. Process (J10)"])
    F11 -->|false| F14{"is_precondition_safe"}

    E12 -->|true| E13{"if_modified_since_matches"}
    E12 -->|false| NEXT
    E13 -->|true| NEXT
    E13 -->|false| F14

    F14 -->|true| R304["304 Not Modified"]
    F14 -->|false| R412

    classDef d fill:#fff3bf,stroke:#b7791f,stroke-width:2px,color:#3d2c05;
    classDef r fill:#ead9ff,stroke:#6b46c1,stroke-width:2px,color:#2d1b55;
    classDef c fill:#ffe8cc,stroke:#dd6b20,stroke-width:2px,color:#4a2a07;
    classDef n fill:#e2e8f0,stroke:#4a5568,stroke-width:2px,color:#1a202c;

    class C9,E9,C10,C11,E11,F11,E12,E13,F14 d;
    class R304 r;
    class R412 c;
    class IN,NEXT n;
```

---

## 6. Create

For a resource that does not exist: decides whether it can be created (for example by `PUT` or `POST`).

```mermaid
%%{init: {"themeVariables": {"fontSize": "12px"}, "flowchart": {"nodeSpacing": 20, "rankSpacing": 25, "padding": 6}}}%%
flowchart TB
    IN(["⬆️ From 4. Retrieve (missing, not moved, not gone)"]) --> K3{"create_is_method_put"}
    K3 -->|true| L3{"create_partial_put"}
    K3 -->|false| K2{"is_method_create"}

    K2 -->|true| L2{"create_path"}
    K2 -->|false| R404["404 Not Found"]

    L2 -->|true| M2{"create"}
    L2 -->|false| R500["500 Internal Server Error"]
    M2 -->|true| NEXT(["➡️ Continue to 8. Response (N3)"])
    M2 -->|false| R500

    L3 -->|true| R400["400 Bad Request"]
    L3 -->|false| M3{"create_has_conflict"}
    M3 -->|true| R409["409 Conflict"]
    M3 -->|false| NEXT

    classDef d fill:#fff3bf,stroke:#b7791f,stroke-width:2px,color:#3d2c05;
    classDef c fill:#ffe8cc,stroke:#dd6b20,stroke-width:2px,color:#4a2a07;
    classDef e fill:#ffd9d9,stroke:#c53030,stroke-width:2px,color:#4a1111;
    classDef n fill:#e2e8f0,stroke:#4a5568,stroke-width:2px,color:#1a202c;

    class K3,L3,K2,L2,M2,M3 d;
    class R404,R400,R409 c;
    class R500 e;
    class IN,NEXT n;
```

---

## 7. Process

For an existing resource: handles `GET`/`HEAD`, `DELETE`, `PUT` and other processing methods such as `POST`.

```mermaid
%%{init: {"themeVariables": {"fontSize": "12px"}, "flowchart": {"nodeSpacing": 20, "rankSpacing": 25, "padding": 6}}}%%
flowchart TB
    IN(["⬆️ From 5. Precondition"]) --> J10{"is_method_head_get"}
    J10 -->|true| NEXTG(["➡️ Continue to 8. Response (N10)"])
    J10 -->|false| J11{"is_method_delete"}

    J11 -->|true| K11{"process_delete"}
    J11 -->|false| J13{"is_method_put"}
    K11 -->|true| NEXTD(["➡️ Continue to 8. Response (N14)"])
    K11 -->|false| R500["500 Internal Server Error"]

    J13 -->|true| K13{"process_partial_put"}
    J13 -->|false| J14{"is_method_process"}
    K13 -->|true| R400["400 Bad Request"]
    K13 -->|false| K14{"process_has_conflict"}

    J14 -->|true| K14
    J14 -->|false| R500

    K14 -->|true| R409["409 Conflict"]
    K14 -->|false| L14{"process"}
    L14 -->|true| NEXTD
    L14 -->|false| R500

    classDef d fill:#fff3bf,stroke:#b7791f,stroke-width:2px,color:#3d2c05;
    classDef c fill:#ffe8cc,stroke:#dd6b20,stroke-width:2px,color:#4a2a07;
    classDef e fill:#ffd9d9,stroke:#c53030,stroke-width:2px,color:#4a1111;
    classDef n fill:#e2e8f0,stroke:#4a5568,stroke-width:2px,color:#1a202c;

    class J10,J11,K11,J13,K13,J14,K14,L14 d;
    class R400,R409 c;
    class R500 e;
    class IN,NEXTG,NEXTD n;
```

---

## 8. Response

Chooses the final success or redirect code. There are three entry points, one from each earlier path.

```mermaid
%%{init: {"themeVariables": {"fontSize": "22px"}, "flowchart": {"nodeSpacing": 50, "rankSpacing": 60, "padding": 20}}}%%
flowchart TB
    FC(["⬆️ From 6. Create"]) --> N3{"is_create_done"}
    FD(["⬆️ From 7. Process<br/>(delete, put, process)"]) --> N14{"is_process_done"}
    FG(["⬆️ From 7. Process<br/>(HEAD or GET)"]) --> N10{"see_other"}

    N3 -->|false| R202["202 Accepted"]
    N3 -->|true| N4{"create_see_other"}
    N4 -->|true| R303["303 See Other"]
    N4 -->|false| R201["201 Created"]

    N14 -->|false| R202
    N14 -->|true| N10

    N10 -->|true| R303
    N10 -->|false| N9{"has_multiple_choices"}
    N9 -->|true| R300["300 Multiple Choices"]
    N9 -->|false| N8{"to_content"}
    N8 -->|false| R204["204 No Content"]
    N8 -->|true| R200["200 OK"]

    R202 --> NEXT(["➡️ Continue to 9. Alternative"])
    R303 --> NEXT
    R201 --> NEXT
    R300 --> NEXT
    R204 --> NEXT
    R200 --> NEXT

    classDef d fill:#fff3bf,stroke:#b7791f,stroke-width:2px,color:#3d2c05;
    classDef s fill:#d9f5dd,stroke:#2f855a,stroke-width:2px,color:#12361f;
    classDef r fill:#ead9ff,stroke:#6b46c1,stroke-width:2px,color:#2d1b55;
    classDef n fill:#e2e8f0,stroke:#4a5568,stroke-width:2px,color:#1a202c;

    class N3,N4,N14,N10,N9,N8 d;
    class R202,R201,R204,R200 s;
    class R303,R300 r;
    class FC,FD,FG,NEXT n;
```

> The last arrows to "Continue to 9. Alternative" are added to show the flow between stages. The original does not draw a connection from the response boxes to the Alternative region.

---

## 9. Alternative

Decides whether an alternative representation of the response applies. After this, the flow reaches `last` and then `finish`.

```mermaid
%%{init: {"themeVariables": {"fontSize": "12px"}, "flowchart": {"nodeSpacing": 20, "rankSpacing": 25, "padding": 6}}}%%
flowchart TB
    D21{"is_response_alternative"}
    D21 -->|true| ALT["Alternative"]
    D21 -->|false| NOT["NOT Alternative"]

    ALT --> N22{"alternative_has_accept"}
    N22 -->|true| N23{"alternative_accept_matches"}
    N22 -->|false| LAST
    N23 -->|true| N24{"alternative_to_content"}
    N23 -->|false| LAST
    N24 --> LAST

    NOT --> LAST{"last"}
    LAST --> FIN(["⚫ finish"])

    classDef d fill:#fff3bf,stroke:#b7791f,stroke-width:2px,color:#3d2c05;
    classDef a fill:#e2e8f0,stroke:#4a5568,stroke-width:2px,color:#1a202c;
    classDef ends fill:#1a202c,stroke:#1a202c,color:#ffffff;

    class D21,N22,N23,N24,LAST d;
    class ALT,NOT a;
    class FIN ends;
```

---

## Where Each Status Code Comes From

A reverse lookup of the diagrams above. For each status code, it lists the decision that returns it.

| Code | Name | Returned when |
| :-: | :--- | :--- |
| **100** | Continue | `expects_continue` is `true` (the flow then goes on to `has_content`) |
| **200** | OK | `is_method_trace` is `true`, `is_method_options` is `true`, or `to_content` is `true` |
| **201** | Created | `create_see_other` is `false` |
| **202** | Accepted | `is_create_done` is `false`, or `is_process_done` is `false` |
| **204** | No Content | `to_content` is `false` |
| **300** | Multiple Choices | `has_multiple_choices` is `true` |
| **303** | See Other | `create_see_other` is `true`, or `see_other` is `true` |
| **304** | Not Modified | `is_precondition_safe` is `true` |
| **307** | Temporary Redirect | `moved_temporarily` is `true` |
| **308** | Permanent Redirect | `moved_permanently` is `true` |
| **400** | Bad Request | `is_request_block_ok` is `false`, `from_content` is `false`, `create_partial_put` is `true`, or `process_partial_put` is `true` |
| **401** | Unauthorized | `is_authorized` is `false` |
| **403** | Forbidden | `is_forbidden` is `true` |
| **404** | Not Found | `is_method_create` is `false` |
| **405** | Method Not Allowed | `is_method_allowed` is `false` |
| **406** | Not Acceptable | `ignore_accept_block_mismatches` is `false` |
| **409** | Conflict | `create_has_conflict` is `true`, or `process_has_conflict` is `true` |
| **410** | Gone | `gone_permanently` is `true` |
| **412** | Precondition Failed | `if_match_matches` is `false`, `if_unmodified_since_matches` is `false`, `is_precondition_safe` is `false`, or `missing_has_precondition` is `true` |
| **413** | Payload Too Large | `is_content_too_large` is `true` |
| **414** | URI Too Long | `is_uri_too_long` is `true` |
| **415** | Unsupported Media Type | `is_content_type_accepted` is `false` |
| **417** | Expectation Failed | `are_expect_extentions_implemented` is `false` |
| **431** | Request Header Fields Too Large | `are_headers_too_large` is `true` |
| **500** | Internal Server Error | `is_system_block_ok` is `false`, `create_path` is `false`, `create` is `false`, `process_delete` is `false`, `is_method_process` is `false`, or `process` is `false` |
| **501** | Not Implemented | `is_method_implemented` is `false`, `are_content_headers_implemented` is `false`, or `is_functionality_implemented` is `false` |
| **503** | Service Unavailable | `is_service_available` is `false` |

See [HTTP STATUS DETAILS](HTTP%20STATUS%20DETAILS.md) for what each status code means.
