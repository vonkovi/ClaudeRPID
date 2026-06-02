# Architectural Decision Log (v1)

The authoritative record of every significant architectural choice. ADRs are numbered
sequentially and never renumbered. "Locked" means no member changes it without admin sign-off.
"Open" means an active decision with a deadline phase.

> If a decision supersedes a prior one, say so explicitly in its text. Inherited decisions from
> a prior version go at the top under "Inherited from {{version}}".

---

## ADR Format

```
### ADR-NNN: Short Title

**Decision:** What was decided — one sentence.

**Why:** The reasoning. Include the prior baseline if this supersedes something.

**Options considered:**
| Option | Pros | Cons |
|--------|------|------|
| A | ... | ... |
| B | ... | ... |

**Status:** Locked. / Open — resolve before Phase N.
```

---

## ADR-001: {{First Architectural Decision}}

**Decision:** {{one sentence}}

**Why:** {{reasoning}}

**Options considered:**
| Option | Pros | Cons |
|--------|------|------|
| {{A}} | {{...}} | {{...}} |
| {{B}} | {{...}} | {{...}} |

**Status:** {{Locked. / Open — resolve before Phase N.}}

---

## ADR-002: Test Infrastructure and Isolation

> Shipped with the template as a pre-registered open decision. Resolve it during init — it is
> what fills `.github/workflows/test.yml`, the "run a SINGLE test" line in `CLAUDE.md`, and the
> `profiles/` overlay (if any). Delete this guidance line once the decision is locked.

**Decision:** {{Open — pick the test runner, and whether tests need OS/VM/container isolation.}}

**Why:** Track 3 makes the full suite a required CI check — the methodology calls it the solo
developer's only second reviewer, so the runner and any isolation layer must be chosen before
Phase 1. Choose the **lightest isolation that faithfully reproduces the production target**:
heavier isolation (a full VM) is only justified when the unit under test is an OS-native artifact
(an `.exe`, an installer, a driver). Bundling such tooling into the base template would break its
stack-agnostic invariant, so it lives in `profiles/`, selected here.

**Options considered:**
| Option | Pros | Cons |
|--------|------|------|
| In-process runner only (vitest / pytest / go test / cargo test) | Fastest; runs on stock GitHub runners; simplest CI | Cannot test OS-native behavior or install-time effects |
| Containerized (Docker) | Reproducible env; parity with deploy; still CI-cheap | Adds image build time; not a true OS boundary |
| Full VM (Vagrant / `windows-latest` runner) | Real OS isolation; required for `.exe` / installer / driver testing | Slow and heavy; overkill for library / web / service code |

**Status:** Open — resolve before Phase 1.
