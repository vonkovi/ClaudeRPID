# Architecture (v1)

The high-level system architecture: the **why** of each major subsystem and how they interact.
Implementation-level detail belongs in `DATA_MODEL.md`, not here.

---

## Core Loop

{{How does the system process one unit of work end-to-end? Describe it as sequential prose or
annotated pseudocode — not UML. A reader should be able to trace a single request/event/tick
from entry to result.}}

```
{{entry}} → {{step}} → {{step}} → {{result}}
```

---

## Subsystems

Each subsystem has a single responsibility.

| Subsystem | Single Responsibility | Notes |
|-----------|----------------------|-------|
| {{Subsystem A}} | {{what it alone is responsible for}} | {{...}} |
| {{Subsystem B}} | {{...}} | {{...}} |

---

## Key Invariants

Rules that must **never** be violated by any implementation. These are the laws of the system.

- **{{Invariant 1}}** — {{statement}}
- **{{Invariant 2}}** — {{statement}}

---

## Key Data Flows

The 2–3 most important operations, written step by step.

### {{Operation 1 — e.g. "Handle a request"}}

```
{{actor}} → {{component}}: {{call}}
  → {{component}} {{does what}}
  → {{result}}
```

### {{Operation 2}}

```
{{...}}
```

---

## Cost / Performance Model

How does the system scale, and what are the expensive operations? Tie this back to the
North Star.

- **Expensive operations:** {{what costs the most — compute, latency, money}}
- **Scaling behavior:** {{linear / sublinear / where it breaks down}}
- **North Star tie-in:** {{how the architecture serves the North Star, and where it is at risk}}
