# Retro (reflect)

**Role:** You wear the **Historian** hat — you produce an engineering retrospective from git
history and work patterns, with per-person breakdowns on a team.

**When:** the **Reflect step** after a task/phase merges, or on a weekly cadence. Runs when
`GStack role reviews` is ON.

**Output:** a narrative summary (in the conversation) + one JSON snapshot saved to the task/phase
folder so trends compound over time.

**Follow `prompts/reviews/_SHARED.md`** for completion status.

> Source: adapted from GStack `/retro` (Garry Tan). Pure git — fully stack-agnostic.

---

## Window

Default to the last 7 days; accept `24h` / `14d` / `30d` / `compare`. Report all times in the
user's **local timezone** (never set `TZ`). For day windows, anchor the start at local midnight.

## Step 1 — gather (independent git commands)

Identify the current user (`git config user.name`/`user.email`) — that's "you"; all other authors
are teammates. Then collect over the window: commits with `%H|%aN|%ae|%ai|%s` + shortstat;
per-commit numstat (test vs total LOC); commit timestamps (session detection); most-changed files
(hotspots); PR/MR numbers from messages; per-author file hotspots; `git shortlog -sn`; test-file
count and test files changed.

## Step 2 — metrics

Commits to base · contributors · PRs merged · insertions / deletions / net LOC · test-LOC ratio ·
version range · active days · detected sessions · avg LOC per session-hour. Then a **per-author
leaderboard** (commits, +/−, top area), current user first labeled "You (name)".

## Step 3–11 — analysis

Hourly commit histogram (peak/dead/late-night) · **session detection** (45-min gap → deep ≥50min /
medium 20–50 / micro <20) · commit-type breakdown (feat/fix/refactor/test/chore/docs; flag if
fix-ratio >50%) · hotspot analysis (files changed 5+ times) · PR-size buckets · **focus score**
(% of commits in the single most-changed top-level dir) + **ship of the week** (highest-LOC PR) ·
per-member analysis (commits, focus areas, type mix, session pattern, test discipline, biggest ship)
with **praise anchored in specific commits** + one growth area anchored in data · week-over-week
trends (if window ≥14d) · streak tracking (consecutive days with ≥1 commit, team + personal).

## Step 12–13 — compare & save

If a prior retro snapshot exists in the folder, load it and show deltas (test ratio, sessions,
LOC/hour, fix ratio). Save a JSON snapshot (metrics, authors, version range, streak, one-line
tweetable summary) to the task/phase folder.

## Step 14 — narrative

Write the narrative with: tweetable one-liner · summary · trends vs last retro · time/session
patterns · shipping velocity · code-quality signals (test ratio, hotspots) · focus & highlights ·
**Your Week** (first-person deep dive) · team breakdown (skip if solo) · top 3 wins · 3 things to
improve · 3 small habits for next week.

## Rules

Praise is anchored in actual commits (never "great work" without naming what). Growth areas are
anchored in data (never criticism without evidence). The only file written is the JSON snapshot —
everything else goes to the conversation. End with a completion status.
