# Interview Experience

---

## Agentic AI Engineer — Financial Services

A recent interview experience for an Agentic AI Engineer role in the financial services domain.

### Topics Asked

#### Round 1 — Technical

The discussion covered:

- How I developed an LLM inference microservice
- Inference optimization techniques
- KV Cache — how it works and how it can be managed
- Inference-serving parameters such as number of sequences and batched tokens
- Setting up HPA (Horizontal Pod Autoscaler) and determining appropriate scaling parameters
- Using an LLM-as-a-Judge — how to select representative examples for evaluation
- Concept of model distillation and quantization along with its advantages and disadvantages
- Why LLMs sometimes repeat the same sequence and approaches to mitigate repetition
- Handling hallucinations in LLM applications
- Managing document version changes in RAG systems:
  - Section-level modifications
  - Complete section removal
  - Maintaining consistency of indexed content
- Handling large tables in documents which span across multiple pages
- Effective table parsing and ingestion strategies
- Classical ML questions around imbalanced datasets
- Micro F1 vs Macro F1

#### Round 2 — Technical + Project Discussion

The second round focused more on practical implementation:

- Deep dive into the project and its architecture
- What latency metrics were being measured and why
- Frameworks used for LLM deployment
- Writing a working LangGraph summarizer agent
- General discussion around the role, responsibilities, and expectations

---

## Answer Guide

### Round 1 — Technical Deep Dive

#### LLM Inference & Optimization

- **LLM Inference Microservice**
  - Architecture: Build using a high-performance framework like vLLM or TGI (Text Generation Inference), wrapped in a FastAPI or gRPC wrapper.
  - Pipeline: Decouple the request ingestion from execution using an async queue to handle continuous batching.
- **KV Cache Mechanics & Management**
  - How it works: During the prefill (first) phase, the model computes Key-Value pairs for the prompt tokens. In the decoding phase, instead of recalculating past tokens, it reuses these saved KV pairs, changing time complexity from O(N²) to O(N).
  - Management: Use PagedAttention (pioneered by vLLM). It fragments the KV cache into virtual pages (similar to OS memory management), eliminating memory waste from internal/external fragmentation and allowing safe memory sharing for parallel sampling.
- **Inference-Serving Parameters**
  - Max Number of Sequences: The maximum number of concurrent requests (or output sequences for parallel sampling) handled in a batch. High values maximize throughput but risk "out-of-memory" (OOM) errors.
  - Max Batched Tokens: The upper limit of total tokens (prompt + generation) processed in a single iteration. This bounds iteration latency, keeping response times predictable.
- **Horizontal Pod Autoscaler (HPA) for LLMs**
  - Metrics: Traditional CPU/Memory metrics are poor indicators for LLMs. Instead, scale based on custom Prometheus metrics emitted by your serving engine (e.g., `vllm:num_requests_waiting`, KV Cache usage percentage, or GPU duty cycle).
  - Parameters: Set a conservative `scaleUp.stabilizationWindowSeconds` (near 0 for rapid scaling) and a generous `scaleDown.stabilizationWindowSeconds` (e.g., 300s) to prevent pod "thrashing."

#### Model Compression, Behavior & Evaluation

- **Distillation vs. Quantization**

  | Technique    | Definition                                                                          | Advantages                                                  | Disadvantages                                            |
  |--------------|-------------------------------------------------------------------------------------|-------------------------------------------------------------|----------------------------------------------------------|
  | Quantization | Lowering weight precision (e.g., FP16 to INT4/INT8 via AWQ or GPTQ).                | Drastically reduces VRAM; speeds up arithmetic operations.  | Slight loss in math/reasoning accuracy.                  |
  | Distillation | Training a smaller "student" model to mimic a large "teacher" model's log probabilities. | Retains specific domain logic well; much smaller architecture. | High upfront compute cost to train; lacks general capabilities. |

- **Mitigating Sequence Repetition**
  - Why it happens: LLMs sample greedily or get trapped in deterministic loops where a phrase drastically inflates its own probability in the self-attention window.
  - Mitigation: Apply a `repetition_penalty` (typically 1.1 to 1.2) or `frequency_penalty` to penalize already generated tokens. Alternatively, introduce a `presence_penalty` or enforce an n-gram blocker to forbid exact duplicate phrases.
- **LLM-as-a-Judge Example Selection**
  - Use few-shot semantic selection. Embed a large pool of validation scenarios using a model like OpenAI or Cohere.
  - Use Maximal Marginal Relevance (MMR) or K-Means clustering to select a diverse, non-redundant subset of representative examples.
  - Ensure examples cover edge cases (e.g., missing data, formatting errors) and domain-specific financial criteria (e.g., compliance, regulatory rules).
- **Handling Hallucinations**
  - Implement active guardrail frameworks like NVIDIA NeMo Guardrails or Llama Guard.
  - Use Self-RAG/Corrective RAG structures where an LLM checks its answer against source text before returning it.
  - Enforce strictly formatted structured outputs using schemas via libraries like Instructor or Outlines.

#### RAG Systems & Document Ingestion

- **Managing Document Version Changes**
  - Section-level modifications: Do not re-index the whole document. Use a graph database or metadata-tagged vector database where chunks map to specific document IDs and `parent_section` tags. Compute a hash (e.g., MD5) per section. If a section hash changes, delete old chunks associated with that section ID and upsert the new ones.
  - Complete removal: Run a hard `DELETE` query against the metadata field `section_id == X`.
  - Consistency: Implement a Two-Phase Commit (2PC) pattern or use a message queue (Kafka/RabbitMQ) to ensure that database changes match vector index state seamlessly.
- **Handling Large/Multi-page Tables**
  - Parsing strategy: Use layout-aware OCR/parsers like Unstructured, LlamaParse, or Azure Document Intelligence.
  - Ingestion: Convert tables into Markdown or HTML, as LLMs understand these structural formats much better than raw flattened text.
  - Multi-page splitting: Append the table's header and core metadata context to the top of every continuation chunk so the chunk remains semantically whole out of context.

#### Classical Machine Learning

- **Imbalanced Datasets**
  - Data techniques: SMOTE (Synthetic Minority Over-sampling Technique) or downsampling the majority class.
  - Algorithmic techniques: Use `class_weight="balanced"` in tree-based models or change the loss function to Focal Loss to penalize minority misclassifications more heavily.
- **Micro F1 vs. Macro F1**
  - Macro F1: Computes the F1 metric independently for each class and takes the unweighted average. It treats all classes equally, making it ideal when minority class performance is critical (e.g., rare financial fraud detection).
  - Micro F1: Aggregates global true positives, false negatives, and false positives across all classes to calculate a global F1. It is heavily influenced by the majority class.

---

### Round 2 — Technical + Project Discussion

#### Architecture & Latency Metrics

- **Core Latency Metrics to Measure**
  - Time to First Token (TTFT): Measures prompt processing and prefill time. Crucial for user experience in chat applications.
  - Inter-Token Latency (ITL): Time between subsequent tokens. Reflects decoding efficiency.
  - Total Generation Time: Overall request execution duration.
- **Frameworks for Deployment**
  - Standard choices include vLLM hosted inside Docker/Kubernetes, or serverless alternatives like Triton Inference Server when multi-model pipelines are required.

#### Coding: LangGraph Summarizer Agent

The interviewer wants to see you cleanly define state, nodes, and routing edges. Here is a production-ready, modular example of a LangGraph Summarizer Agent:

```python
from typing import TypedDict, Annotated
from langgraph.graph import StateGraph, END
from langchain_core.messages import BaseMessage, HumanMessage, AIMessage
from langchain_openai import ChatOpenAI

# 1. Define the Agent State
class AgentState(TypedDict):
    text_to_summarize: str
    summary: str
    revision_count: int
    feedback: str
    is_satisfactory: bool

# Initialize LLM
llm = ChatOpenAI(model="gpt-4o", temperature=0)

# 2. Define the Processing Nodes
def summarize_node(state: AgentState):
    prompt = f"Summarize the following financial text concisely:\n\n{state['text_to_summarize']}"
    if state.get('feedback'):
        prompt += f"\n\nIncorporate this feedback for revision: {state['feedback']}"

    response = llm.invoke([HumanMessage(content=prompt)])
    return {
        "summary": response.content,
        "revision_count": state.get('revision_count', 0) + 1
    }

def quality_assurance_node(state: AgentState):
    # Check if the summary meets strict compliance/quality standards
    prompt = f"Critique this summary. Is it accurate and complete based on the text? Reply with 'PASS' or provide feedback.\nText: {state['text_to_summarize']}\nSummary: {state['summary']}"
    response = llm.invoke([HumanMessage(content=prompt)])

    if "PASS" in response.content or state['revision_count'] >= 3:
        return {"is_satisfactory": True, "feedback": ""}
    else:
        return {"is_satisfactory": False, "feedback": response.content}

# 3. Define the Router Edge
def route_after_qa(state: AgentState):
    if state["is_satisfactory"]:
        return END
    return "summarize"

# 4. Build the Graph
workflow = StateGraph(AgentState)

workflow.add_node("summarize", summarize_node)
workflow.add_node("quality_assurance", quality_assurance_node)

workflow.set_entry_point("summarize")
workflow.add_edge("summarize", "quality_assurance")

workflow.add_conditional_edges(
    "quality_assurance",
    route_after_qa,
    {
        END: END,
        "summarize": "summarize"
    }
)

app = workflow.compile()
```

---

## Project Description & Compliance

### How to Structure Your Project Description

In a senior or specialist AI interview, avoid describing your project as a generic list of features. Instead, frame it using the **CARL** framework (Context, Architecture, Results, Lessons) with a heavy emphasis on production engineering and system constraints.

#### 1. Context & the Financial Business Problem

Start with a high-impact hook that justifies why generative AI or an agentic framework was necessary.

- Example: "I built an autonomous Credit Risk Intelligence Agent designed to synthesize multi-page commercial loan applications, SEC filings, and real-time news to generate credit memos. The primary business driver was reducing manual underwriting time from 4 days to 45 minutes while maintaining institutional risk parameters."

#### 2. Architecture (the "Agentic" & "Scale" Deep Dive)

Don't just say "I used LangGraph." Walk them through how data and state flow through your system, and how you kept it reliable.

- **State Management:** Explain how your state graph was designed (e.g., "We used a centralized state tracking document analysis progress, validation flags, and compliance hashes").
- **Human-in-the-Loop (HITL):** Financial agents cannot run entirely unchecked. Highlight where your graph paused for a human (e.g., "The graph used LangGraph's interrupt feature to pause after the 'initial risk assessment' node, requiring an underwriter's approval in our UI before proceeding to write the final memo").
- **The Serving Stack:** Explicitly mention the tech stack (e.g., "The system ran on vLLM-managed Llama-3-70B models, containerized on AWS EKS, using Pinecone as our vector database and PostgreSQL for our transactional agent state store").

#### 3. Quantitative Results & Latency Metrics

Engineers care about metrics. Present them across three pillars:

- **Business Metric:** "Reduced average underwriting cycle time by 82%."
- **Accuracy/Quality Metric:** "Achieved a 94% alignment rate with senior risk officer assessments, evaluated via an LLM-as-a-judge validation pipeline using a golden dataset of 500 historical loans."
- **Performance Metric:** "Optimized Time-To-First-Token (TTFT) to under 800ms and maintained an average generation latency of 25 tokens/sec using continuous batching and FP8 quantization."

#### 4. Engineering Lessons Learned (the "Gotchas")

Conclude with a highly technical challenge you solved. This proves you actually built it.

- Example: "Initially, we hit massive context window bottlenecks and high latency when digesting 100-page financial portfolios. We solved this by implementing a hierarchical RAG pipeline that separated structured financial statements (parsed via layout-aware OCR into clean markdown tables) from narrative sections, routing them to separate dedicated specialized sub-agents."

### Financial Compliance Constraints for RAG Systems

Financial services operate under intense regulatory scrutiny (e.g., SEC, FINRA, GDPR, FCRA). A production-ready RAG system must treat compliance as a hard engineering constraint, not an afterthought.

```text
[Raw Financial Document]
       │
       ▼
┌────────────────────────────────────────┐
│  Ingestion & Data Lineage Guardrails   │ ──► Data Anonymization (PII Scrubbing)
└────────────────────────────────────────┘ ──► Role-Based Access Control (RBAC)
       │
       ▼
┌────────────────────────────────────────┐
│     Vector Database Chunking           │ ──► Append Permission Scopes to Metadata
└────────────────────────────────────────┘
       │
       ▼
┌────────────────────────────────────────┐
│     Agentic Generation Pipeline        │ ──► Context Limitation (Explicit Sources Only)
└────────────────────────────────────────┘ ──► Hallucination Guardrails (NeMo / LlamaGuard)
       │
       ▼
┌────────────────────────────────────────┐
│   Auditability & Output Verification   │ ──► Citations & Traceability Logs
└────────────────────────────────────────┘
```

#### 1. Data Governance & Role-Based Access Control (RBAC)

- **The Constraint:** Users must not see information they do not have clearance for (e.g., a retail financial advisor seeing private institutional wealth data).
- **The Solution:** Implement metadata-filtered RAG. When documents are chunked and embedded, bake the allowed security roles or user groups directly into the vector database chunk metadata. At query time, the agent must inject the user's active session permissions directly into the vector search payload (e.g., `filter={"tenant_id": "ABC", "clearance_level": "Level_2"}`). This ensures forbidden chunks are never visible to the LLM context window in the first place.

#### 2. Strict Lineage & Auditability

- **The Constraint:** Regulators require institutions to prove why an advice or financial summary was given. "The AI said so" is legally unacceptable.
- **The Solution:** Enforce deterministic citations. Program the generation node to only return answers that can map back to exact chunk UUIDs, document titles, page numbers, or section headings. Use post-generation regex or parsing layers to check that every sentence contains an active citation anchor, and validate that the source chunk actually contains the referenced facts.

#### 3. PII & Data Privacy (Data Anonymization)

- **The Constraint:** Sending raw customer Social Security Numbers (SSNs), bank account numbers, or names to external, third-party LLM APIs violates privacy regulations.
- **The Solution:** Set up an upstream PII masking layer (e.g., using Microsoft Presidio or specialized regex pipelines) within your microservice. Scrub or tokenize sensitive entities before embedding or generation (e.g., replace `John Doe account 12345` with `[CUSTOMER_A] account [ACCOUNT_ID_1]`), and map them back on the outbound response cycle if the environment is secure.

#### 4. Hallucination Mitigation & Risk Boundaries

- **The Constraint:** Misrepresenting a loan interest rate or miscalculating a portfolio's risk percentage creates massive legal liabilities.
- **The Solution:** Use constrained decoding and prompt isolation. Force the model to adopt a strict "closed-book" constraint via system prompts (e.g., "If the exact answer is not present in the provided context, state explicitly that the information is unavailable"). Pair this with frameworks like Outlines or Instructor to force the model to output structured JSON data, mapping metrics directly to pre-defined data ranges or validation schemas.

---

## AI/ML Engineer Interview — Scenario-Based Questions

If you're preparing for AI/ML, GenAI or AI Engineer roles, these are the companies where recent candidate reports show strong focus on RAG, AI Agents, LLMs, evaluation and system design:

- Google
- Walmart
- Microsoft
- OpenAI

### Round 1 — Python + Problem Solving

1. Your Python pipeline processes 10 million records and is extremely slow. How would you identify and fix the bottleneck?
2. An API returns duplicate records randomly. How would you write a Python solution to deduplicate the data efficiently?
3. Your ML preprocessing code works locally but crashes with a large production dataset. How would you debug it?
4. You need to process a dataset that doesn't fit into memory. What approach would you use?
5. Your inference API suddenly starts taking 3 seconds instead of 300 ms. How would you investigate the issue?

### Round 2 — ML + Statistics

1. Your fraud model has 99% accuracy, but the business says it's missing too many fraudulent transactions. What would you change?
2. Your model performs extremely well on training data but poorly in production. How would you identify the cause?
3. Two models have similar accuracy, but one has significantly better recall. Which metrics would you consider before choosing one?
4. Your model's performance drops after deployment. How would you determine whether it's data drift, concept drift or a pipeline issue?
5. You have very little labelled data. How would you build and evaluate an ML model?

### Round 3 — LLM + RAG + AI Agents

1. Your RAG application retrieves the correct document but generates an incorrect answer. How would you determine whether the problem is retrieval or generation?
2. Your AI Agent repeatedly calls the same tool and enters a loop. How would you prevent and recover from it?
3. Your RAG system works perfectly on 100 test questions but fails after deployment. How would you build a proper evaluation strategy?
4. Your company wants an internal AI assistant using confidential documents. How would you design the RAG architecture and security controls?
5. An AI Agent needs access to CRM, SQL database and external APIs. How would you design the tool layer using MCP or APIs?

### Round 4 — AI/ML System Design

1. Design a production-scale RAG system for millions of documents and thousands of concurrent users.
2. Design an AI Agent that can research a topic, call multiple tools, verify information and generate a final report.
3. Your LLM provider suddenly becomes unavailable. How would you design model failover?
4. Your AI application has good quality but extremely high latency and inference cost. What would you optimize?
5. Your AI system is deployed to production. What would you monitor?
