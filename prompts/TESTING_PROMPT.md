# Testing Run Phase Prompt — RPID Loop (Track 3)

Copy into a new Claude Code session after the `test` commit exists.
Also re-entered after every debug iteration.

```
You are beginning the TESTING RUN — Track 3 of the RPID loop.
Tests are written and committed. Your only job: run them and report the result.
Do NOT add tests. Do NOT fix anything. Do NOT interpret failures — report verbatim.
Default assumption: something fails.

STEP 0: Read CLAUDE.md. Confirm test and build commands.

STEP 1: Load Context
- TEST_PLAN_PHASE[N]_TASK[NN].md (what tests cover and why)
- SESSION_LOG_PHASE[N]_TASK[NN].md if it exists (prior run history)
One sentence: how many test cases are expected and what tracks they cover.

STEP 2: Run Static Analysis
Run build checks from CLAUDE.md. Paste verbatim output.
RULE: Do NOT summarize. Paste error sections verbatim; truncate passing output only.
If static analysis fails: STOP. Report verbatim. Do not proceed.

STEP 3: Run the Full Test Suite
Run the full test command from CLAUDE.md. Paste verbatim output.
RULE: Do NOT summarize. "Tests passed" without output is rejected.
RULE: Always run the full suite — never only the previously failing test.

STEP 4: Decision

ALL tests pass:
- Append "Run [N] — PASS" to SESSION_LOG_PHASE[N]_TASK[NN].md:
  - Run number and date
  - Verbatim output
  - Outcome: PASS
- NOTE: the same suite also runs as a required CI check on the PR. A local PASS with a
  red CI check is NOT a pass — the PR cannot merge until CI is green.
- Use DOCUMENTATION_PROMPT.md in a new session for the docs commit + PR.
- Stop.

ANY test fails:
- Append "Run [N] — FAIL" to SESSION_LOG_PHASE[N]_TASK[NN].md:
  - Run number and date
  - Verbatim failing output
  - Which test cases failed (names from TEST_PLAN)
  - Outcome: FAIL
- Tell user: "Run [N]: [test name] failed. See SESSION_LOG. Entering debug track."
- Stop. Do not attempt a fix. Debug track begins with DEBUG_RESEARCH_PROMPT.md.
```
