# Shared Review Primitives (`_SHARED.md`)

**What this is:** the rules every GStack-style review prompt in `prompts/reviews/` (and the
lifecycle prompts that review: SHIP, OFFICE_HOURS) shares. Defined once here so the behaviour is
identical across every review. Each review prompt says "follow `_SHARED.md`" instead of repeating
these blocks.

> Stack-agnostic. Adapted from Garry Tan's GStack (the `/review`, `/plan-*-review`, `/cso`
> rubric primitives), stripped of all tooling and reworded for the RPID template. No telemetry,
> no external binaries, no CLIs — pure copy-paste methodology.

---

## 1. Gate Behavior — when to stop for the user

Read the **Review autonomy** flag in `CLAUDE.md` → Project Settings (mirror of `CLAUDE.md` →
Ethos → Gate Behavior). Classify every decision first:

- **Mechanical** — obvious; a senior engineer would just do it (rename, dead-code removal, an
  unambiguous fix).
- **Taste** — reasonable people could differ (two valid architectures, a scope expansion).
- **User Challenge** — the review wants to change the user's *stated* direction.

| `Review autonomy` | Mechanical | Taste | User Challenge | Hard Gate |
|-------------------|-----------|-------|----------------|-----------|
| **full** (default) | ask | ask | ask | always stop |
| **milestone** | auto + log | hold; surface once at the task boundary | always stop | always stop |
| **auto** | auto + log | auto-decide by the Ethos principles + log | **always stop** | always stop |

- "auto + log" / "auto-decide + log" → apply it **and** record the decision in the task
  `SESSION_LOG` (a decision-audit-trail). Never decide silently.
- **Hard Gates — ALWAYS stop, even in `auto`:** destructive / irreversible ops (force-push,
  history rewrite, data deletion, production deploy) · architecture or shared-contract changes
  (new/changed ADR, `DATA_MODEL` change, frozen contract file) · a high-confidence security
  finding · a **User Challenge** · escalation after two failed debug iterations · anything you'd
  call a one-way door.

If you cannot determine the autonomy level, default to **full** (stop and ask).

---

## 2. How to ask — the decision brief

When a gate requires user input, ask **one issue per question**. Never batch multiple issues into
one question. Each question is a short decision brief:

```
D<n> — <one-line issue title>   (e.g. "2A — fail-open on Redis outage")
Plain English: <2–4 sentences a non-expert could follow; name the stakes>
If we choose wrong: <one sentence — what breaks, what the user sees, what's lost>
Recommendation: <option> because <one-line reason tied to an Ethos principle or a project rule>
Options:
  A) <option> (recommended)   — effort: <human: ~X / AI-assisted: ~Y>, risk: <L/M/H>
  B) <option>                 — ...
  C) Do nothing / defer to TODO
```

- **Coverage vs kind.** If the options differ in *coverage* (more tests vs fewer, full error
  handling vs happy-path), add `Completeness: A=N/10, B=M/10` (10 = all edge cases, 7 = happy path,
  3 = shortcut). If they differ in *kind* (two different architectures), write
  `Note: options differ in kind, not coverage — no completeness score.` Never fabricate a score.
- Label issues by NUMBER and options by LETTER (`3A`, `3B`) so the user can answer in seconds.
- **STOP after each question.** Do not proceed, edit downstream files, or assume an answer until
  the user responds (unless the autonomy dial authorizes auto-deciding this class).

---

## 3. Confidence Calibration (every finding carries a score)

Every finding MUST include a 1–10 confidence score that gates whether the user sees it:

| Score | Meaning | Display rule |
|-------|---------|--------------|
| 9–10 | Verified by reading the specific code. Concrete bug/exploit demonstrated. | Show normally |
| 7–8 | High-confidence pattern match. Very likely correct. | Show normally |
| 5–6 | Moderate. Could be a false positive. | Show with caveat: "Medium confidence — verify." |
| 3–4 | Low. Suspicious but may be fine. | Suppress from the main report; list in an appendix |
| 1–2 | Speculation. | Only report if the severity would be critical |

**Finding format:** `[SEVERITY] (confidence: N/10) file:line — description` (+ a one-line fix).

**Pre-emit verification gate.** Before promoting any finding, **quote the exact `file:line`(s) that
motivate it.** If the finding is "field X doesn't exist on Y", quote Y's definition. If you cannot
quote the motivating line, the finding is **unverified** → force its confidence to 4–5 (suppressed).
Do not invent a higher score to dodge this. (For framework-generated symbols — ORM models,
decorators, migrations — quote the construct that *creates* the symbol, not the class body.)

---

## 4. User Sovereignty & the Outside Voice

AI recommends; the user decides. Cross-model or cross-review agreement is a strong **signal**, never
**permission to act**.

If a review (or an optional second-opinion pass) wants to change the user's stated direction:
1. Present the tension neutrally: "The plan says X; this review argues Y. Here's what I might be
   missing: …"
2. Make it a **User Challenge** → a Hard Gate → always ask, even in `auto`.
3. Offer: A) accept the change · B) keep the current approach · C) investigate further · D) TODO.
4. **Never** default to accepting because you find the argument compelling. If the user keeps the
   current approach, it stands — do not re-argue.

---

## 5. Completeness (Boil the Lake)

When weighing options, prefer the **complete** one when the delta over the shortcut is small with
AI-assisted coding (full tests, all edge cases, every error path). Boil "lakes" (a module's full
coverage); flag "oceans" (multi-quarter rewrites, full-system rewrites) as explicitly out of scope.
A "ship the 90% shortcut" recommendation needs a real reason, not just "less code."

---

## 6. Completion Status (how a review ends)

End every review with one status line:

- **DONE** — completed, with evidence (what you examined; "no issues found" only after naming what
  was checked).
- **DONE_WITH_CONCERNS** — completed, but list the unresolved concerns.
- **BLOCKED** — cannot proceed; state the blocker and what you tried.
- **NEEDS_CONTEXT** — missing information; state exactly what you need.

Escalate (stop and hand back) after **three failed attempts**, on uncertain security-sensitive
changes, or on any scope you cannot verify.

---

## 7. Anti-shortcut rule (the failure mode to avoid)

The review's value is in **walking the user through findings at the gate**, not in dumping every
finding into a document and moving on. If you have any non-trivial finding, the path from "found
it" to "done" goes **through** a user decision (subject to the autonomy dial). Writing findings
into an artifact and skipping the gate is the exact failure this rule exists to prevent. Zero
findings is the only clean path that skips the question.