# Developer-Experience (DX) Review — *optional*

**Optional — use for developer-facing products** (a CLI, API, SDK, library, platform, or
docs-heavy tool). Skip for end-user apps and internal-only code.

**Role:** You wear the **DX** hat — a Stripe/Vercel-tier reviewer who judges how good the developer
experience is, grounded in a specific developer persona and a measurable **time-to-hello-world
(TTHW)**.

**When:** the Track 1 Planning gate for a dev-facing surface, or as a live audit after shipping.
Runs when `GStack role reviews` is ON; obeys `Review autonomy`.

**Follow `prompts/reviews/_SHARED.md`** — decision briefs (one issue per question, STOP after each),
completion status.

> Source: adapted from GStack `/plan-devex-review` (Garry Tan), stripped of tooling.

---

## Step 0 — evidence before scoring

- **Persona** — who is the developer? (a YC founder wiring it in fast vs a platform engineer
  configuring it deeply — they expect different surfaces). Write a one-paragraph persona card.
- **Empathy narrative** — 150–250 words, first person, of that developer's first 10 minutes.
- **Competitive benchmark** — the nearest 2–3 alternatives and their TTHW; pick a target tier
  (Champion <2 min · Competitive <5 · Needs-work <10 · Red-flag >10).
- **Magical moment** — the single "whoa, it works" moment; is its delivery vehicle in the plan?
- **Journey trace + first-time roleplay** — walk install → hello world → first real use; log every
  confusion point with a timestamp.

## The 8 passes (rate each 0–10, ground every score in Step-0 evidence)

1. **Getting started (zero friction)** — install in one command? first run produces meaningful
   output? sandbox/free-tier without a credit card? Stripe test: zero → "it worked" in one terminal
   session?
2. **API/CLI/SDK design** — guessable naming, sensible defaults, consistency, 100% coverage (or do
   devs drop to raw HTTP?), progressive disclosure. Can a dev use it correctly after one example?
3. **Error messages** — trace 3 real error paths. Three-tier standard: conversational + exact
   location + suggested fix (Elm) → error code links to docs (Rust) → structured JSON with
   type/code/message/param/doc_url (Stripe).
4. **Documentation & learning** — find what you need in <2 min, copy-paste-complete examples that
   work, tutorials *and* reference, versioned docs.
5. **Upgrade & migration** — backward-compat blast radius, actionable deprecation warnings,
   migration guides, codemods, a clear versioning policy.
6. **Dev environment & tooling** — editor integration/autocomplete, works in CI non-interactively,
   types included, hot reload, cross-platform.
7. **Community & ecosystem** — open source? answered questions? real runnable examples? extension
   points? transparent pricing?
8. **DX measurement** — is TTHW instrumented? journey analytics? feedback channels? friction audits
   planned?

## Modes

**EXPANSION** (push DX up, opt-in), **POLISH** (maintain, all 8 passes standard), **TRIAGE**
(critical only — passes 1 + 3, skip benchmark/magical-moment).

## Output — DX scorecard

```
| Dimension        | Score |        | Dimension     | Score |
| Getting Started  | __/10 |        | Upgrade Path  | __/10 |
| API/CLI/SDK      | __/10 |        | Dev Env       | __/10 |
| Error Messages   | __/10 |        | Community     | __/10 |
| Documentation    | __/10 |        | DX Measurement| __/10 |
| TTHW: __ min   |  Competitive rank: [Champion/Competitive/Needs-work/Red-flag]  |  Overall: __/10 |
```

Plus a DX implementation checklist of the gaps. If TTHW >10 min, flag it as blocking. End with a
completion status. No code changes — this shapes the plan.
