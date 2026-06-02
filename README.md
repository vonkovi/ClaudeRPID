# The RPID Template for Claude Code

**A golden-standard opinionated project scaffold that turns Claude Code from a fast coder into a disciplined engineer.**

![working with claude](image.png)

Stack-agnostic · Solo or team · Research → Plan → Implement → Debug [RPID]

---

> ℹ️ **You're looking at the template's front page.** This README exists to explain what the
> template *is*. When you instantiate the template for a real project (see [Get started](#-get-started)),
> this file gets **rewritten** into your project's own README. The permanent how-to-use guide
> lives in **[`START_HERE.md`](START_HERE.md)** — read that first if you just want to get going.

---

## Why this exists

Claude Code is a brilliant coder. Left unstructured, though, a long project drifts into the two
failure modes that sink *every* AI-assisted codebase:

- **Lost context** — a new session has no idea what was decided, what was tried, or why. It
  re-litigates settled questions and rebuilds things that already exist.
- **Outdated context** — the docs say one thing, the code does another, and nobody knows which to
  trust. Every decision after that is built on sand.

This template is an opinionated answer to both. It gives Claude (and you) a **living memory** and a
**repeatable loop**, so session #40 is as grounded as session #1.

> **The whole methodology is downstream of one idea: lost context and outdated context are the
> only real enemies. Every rule here prevents one of them.**

---

## What you get

| Asset | What it does for you |
|-------|----------------------|
| 🧭 **`CLAUDE.md`** | The operating manual every Claude session reads first. Encodes the rules, the loop, and how this repo works — so behavior is consistent across sessions and machines. |
| 🔁 **The RPID loop** | A four-track **Research → Plan → Implement → Debug** cycle that forces decisions to happen *before* code, and separates "thinking" commits from "doing" commits. |
| 📚 **A living doc backbone** | `STATUS`, `DECISIONS` (ADRs), `ARCHITECTURE`, `DATA_MODEL`, `PLANNING`, and more under `docs/` — the project's durable memory. `STATUS.md` is read at the start of every session and updated at the end. |
| 📋 **A prompt library** | Copy-paste prompts in [`prompts/`](prompts/) that drive each step of any task — from project init to research, planning, implementation, testing, and debugging. |
| ✅ **A CI test gate** | A GitHub Actions skeleton ([`.github/workflows/test.yml`](.github/workflows/test.yml)) that makes the full test suite a *required* check on every PR — your second reviewer, especially when working solo. |
| 👥 **Solo *and* team modes** | Ships in **SOLO mode** (one dev + Claude). Flip a flag and the full team model — roles, branch hierarchy, shared-contract process — wakes up. Nothing is rewritten; it's just dormant. |
| 🧱 **Stack-agnostic core** | No language, framework, or runner is assumed. Works for a CLI, a web app, a backend service, a research codebase, or a library. Stack-specific tooling is an opt-in overlay in [`profiles/`](profiles/). |

---

## What is RPID?

Every task — a feature, a bug fix, anything — runs the same loop. Each track is one focused Claude
session that you review before the next begins:

```
Track 1 — Feature   R → P → I     research the problem, plan the change, implement it
Track 2 — Tests     R → P → I     research edge cases, plan the cases, write the tests
Track 3 — Run       run the suite locally + the required CI check on the PR
                      ├─ all green ──────────────► docs update → merge → next task
                      └─ anything red ──┐
Track 4 — Debug     R → P → I  ◄────────┘  root-cause, plan the fix, fix it → back to Track 3
```

The point isn't ceremony — it's that **design decisions get made in Research and Planning, and are
merely executed in Implementation.** If you ever catch Claude making an architectural choice while
coding, that's the signal to stop and go back a track. Code commits (`impl:`) and doc commits
(`docs:`) are never combined, so the history stays legible.

**New to this?** Two terms worth knowing up front:

- A **North Star metric** is the single thing every decision is weighed against — e.g. *"Lower cost,
  higher speed,"* or *"Sub-100ms p99 latency,"* or *"One-command deploy, no ops."* You pick yours in
  Phase 0, and it anchors every trade-off after.
- **Phase 0 is always vision alignment** — an interview between you and Claude about *exactly* what
  you're building and what you're deliberately **not** building, before a single line of code.
  Uncertainties get logged (as open decisions or open questions), never guessed.

---

## 🚀 Get started

Use this repo as a GitHub template (or clone it), open a Claude Code session in the new repo, then:

### Option A — Let Claude fill it in (recommended)

Paste **[`prompts/PROJECT_INIT_PROMPT.md`](prompts/PROJECT_INIT_PROMPT.md)** into the session. It
runs the Phase 0 vision interview (starting with your North Star), then scaffolds every doc — and
rewrites *this* README into your project's real front page.

### Option B — Fill it in by hand

Work top-down, starting with [`CLAUDE.md`](CLAUDE.md):
1. **`CLAUDE.md`** — replace every `{{PLACEHOLDER}}`, starting with **Project** and **North Star**.
2. **`docs/version1/STATUS.md`** — set Current Phase, North Star, and Next Actions.
3. **`docs/version1/PLANNING.md`** — lay out your phases.
4. **`docs/version1/DECISIONS.md`** — record your first ADR.
5. Fill `ARCHITECTURE.md` and `DATA_MODEL.md` as the design solidifies.

Either way, **[`START_HERE.md`](START_HERE.md)** is the canonical walkthrough — read it first.

> 💡 A `{{...}}` token means *not yet filled in*. While placeholders remain, that part of the project
> isn't real yet — Claude is instructed to surface the gap rather than invent build commands,
> architecture, or status to paper over it.

---

## What's in the box

```
CLAUDE.md         ← the operating manual Claude reads first (fill in the placeholders)
START_HERE.md     ← permanent how-to-use-this-template guide — read this first
README.md         ← this file (your project's future front page)
MISSION.md        ← purpose + success metrics (optional; for goal-driven/research projects)
prompts/          ← the RPID prompt library (modes/ + one prompt per track)
docs/version1/    ← the living doc backbone: STATUS, DECISIONS, ARCHITECTURE, DATA_MODEL, PLANNING…
  └── phases/     ← phase + task scaffolding for the collaboration model
profiles/         ← opt-in stack overlays (test runner, CI, isolation) — pick one at init, then delete
src/              ← your code root (rename to frontend/, backend/, app/… as needed)
.github/workflows ← Claude action, auto-review, and the Track 3 CI test gate
```

## Key docs

| File | Read it for |
|------|-------------|
| [`START_HERE.md`](START_HERE.md) | How to actually use this template — the first thing to read |
| [`CLAUDE.md`](CLAUDE.md) | The full methodology: RPID loop, commit discipline, doc rules, solo/team modes |
| [`docs/version1/STATUS.md`](docs/version1/STATUS.md) | Where the project is right now — read at session start, update at session end |
| [`docs/version1/DECISIONS.md`](docs/version1/DECISIONS.md) | The Architectural Decision Log (ADRs) — authoritative for every locked decision |
| [`docs/version1/PLANNING.md`](docs/version1/PLANNING.md) | The phased checklist with numbered tasks |
| [`prompts/`](prompts/) | The copy-paste prompt for each step of every task |

---

*Built for [Claude Code](https://claude.com/claude-code). Stack-agnostic by design — bring your own language.*
