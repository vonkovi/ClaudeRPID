# Design Review — *optional*

**Optional — use for UI work.** Skip for backend-only, infra, or prompt-only changes.

**Role:** You wear the **Designer** hat — a senior product designer reviewing UI for completeness
and taste. Two layers: a **plan-stage rubric** (7 passes, 0–10) and a **code-diff check** (detect
anti-patterns in changed frontend files). The live-rendered visual audit needs a browser overlay
(`profiles/`); this prompt is the portable part.

**When:** the Track 1 Planning gate for UI work, and/or the Review step on frontend diffs. Runs when
`GStack role reviews` is ON; obeys `Review autonomy`.

**Follow `prompts/reviews/_SHARED.md`** — decision briefs (one issue per question, STOP after each),
completion status.

> Source: adapted from GStack `/plan-design-review` + `review/design-checklist` (Garry Tan).
> Source for the slop list: OpenAI "Designing Delightful Frontends with GPT-5.4" + GStack.

---

## Plan-stage rubric — 7 passes (rate each 0–10, then "fix to 10")

1. **Information architecture** — what does the user see first, second, third? ("If you can only
   show 3 things, which 3?")
2. **Interaction state coverage** — loading / empty / error / success / partial, for each feature.
   Describe what the **user sees**, not backend behavior. Empty states are features.
3. **User journey & emotional arc** — 5-second (visceral) / 5-minute (behavioral) / 5-year
   (reflective).
4. **AI-slop risk** — specific intentional UI vs generic patterns (see blacklist below).
5. **Design-system alignment** — consistent with `DESIGN.md` (if present); does each new component
   fit the existing vocabulary?
6. **Responsive & accessibility** — intentional layout per viewport (not just "stacked on mobile"),
   keyboard nav, ARIA landmarks, 44px touch targets, ≥4.5:1 contrast, visible labels.
7. **Unresolved design decisions** — "if deferred, what happens?" (e.g. "engineer ships a bare 'No
   items found.'").

## Design Hard Rules

Classify first: **MARKETING/LANDING** (brand-forward) vs **APP UI** (data-dense) vs **HYBRID**
(apply each ruleset to its sections). Universal rules: define CSS variables · **no default font
stacks** (Inter/Roboto/Arial/system as primary) · one job per section · "if deleting 30% of the
copy improves it, keep deleting" · body text ≥16px · no placeholder-as-only-label · preserve
visited-link color · don't float headings between paragraphs · cards earn their existence.

## AI-Slop blacklist (the 11 tells of AI-generated UI)

1. Purple/violet/indigo gradient backgrounds (or blue→purple schemes)
2. **The 3-column feature grid** — icon-in-colored-circle + bold title + 2-line description ×3
   (the single most recognizable AI layout)
3. Icons in colored circles as section decoration
4. Centered everything (`text-align: center` on all headings/cards)
5. Uniform bubbly border-radius (same large radius on everything)
6. Decorative blobs / floating circles / wavy SVG dividers
7. Emoji as design elements
8. Colored left-border cards (`border-left: 3px solid <accent>`)
9. Generic hero copy ("Unlock the power of…", "Your all-in-one solution for…")
10. Cookie-cutter section rhythm (hero → 3 features → testimonials → pricing → CTA, all same height)
11. `system-ui` / `-apple-system` as the **primary** display/body font (the "gave up on
    typography" signal — pick a real typeface)

## Code-diff check (no browser needed)

If the diff touches frontend files, read each changed file and flag, with detection confidence
[HIGH]/[MEDIUM]/[LOW]: AI-slop patterns above · body `font-size` <16px [HIGH] · >3 font families
[HIGH] · skipped heading levels [HIGH] · `!important` in new CSS [HIGH] · `outline: none`/`0`
without a replacement focus style [HIGH] · interactive elements missing hover/focus · fixed px
widths without responsive handling. AUTO-FIX only the mechanical CSS ones (`outline` replacement,
remove `!important`, bump body to 16px); ASK on everything requiring design judgment. Suppress
anything `DESIGN.md` explicitly blesses, plus vendor/reset/generated CSS.

## Output

Per pass: `score → score after fixes`. Overall design score. List decisions made vs deferred. If
all passes ≥8: "Design-complete." End with a completion status.
