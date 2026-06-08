# GitHub ↔ Claude Setup & Verification

One-time setup for the four shipped workflows (`claude.yml`, `claude-issue-to-pr.yml`,
`claude-code-review.yml`, `test.yml`). Two layers: an **automated plumbing check** and a
**manual smoke test** for the parts that can't be verified without a live run.

## 1. Add the secret

The three Claude workflows need one repo secret: **`CLAUDE_CODE_OAUTH_TOKEN`**.

1. Generate it locally: `claude setup-token` (or use the GitHub App install flow).
2. Add it under **Settings → Secrets and variables → Actions → New repository secret**.

## 2. Run the automated plumbing check

**Actions tab → "Connection Self-Check" → Run workflow.** Zero side effects — it spends no
Claude tokens and changes nothing. It confirms: the secret is present, the GitHub API is
reachable, the workflows declare the write permissions they need, and the pinned action tag
resolves. Green ⇒ the wiring is correct.

It deliberately does **not** prove the token is valid or that the loop behaves — that's step 3.

## 3. Manual smoke test (the part that can't be automated)

These each cause real side effects (a live Claude run, a real PR), so they're manual and one-time.

- [ ] **`@claude` mention** — comment `@claude say hello` on any issue or PR. A run should appear
      in Actions and Claude should reply. _(Only mentions from users with **write** access fire it.)_
- [ ] **Issue → PR loop** — open a test issue, then add the **`claude`** label. `claude-issue-to-pr`
      should run and open a PR that says "Closes #<n>". Merge or close it when done.
- [ ] **Auto code review** — open any PR. `claude-code-review` should post a review comment.
- [ ] **Test gate** — confirm `test.yml` is a required check (Settings → Branches → branch
      protection). Until you fill its placeholder command (`prompts/TEST_SETUP_PROMPT.md`), it
      fails by design.

## Troubleshooting

| Symptom | Likely cause |
|---------|--------------|
| No workflow run appears at all | Actions disabled for the repo, or the trigger didn't match (e.g. label name isn't exactly `claude`) |
| Run starts then errors on the Claude step | `CLAUDE_CODE_OAUTH_TOKEN` missing, invalid, or expired — re-run `claude setup-token` and update the secret |
| `@claude` comment ignored | Commenter lacks **write** access to the repo (by design) |
| Loop runs but no PR opens / can't push | Write permissions weakened in `claude.yml` / `claude-issue-to-pr.yml` — re-run the self-check, which asserts them |
| Self-check warns it can't resolve the action tag | Network blip, or the pinned `anthropics/claude-code-action@v1` tag moved — check the action's releases page |
