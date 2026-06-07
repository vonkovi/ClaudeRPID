# Test Setup (bootstrap the test gate)

**Role:** You set up the project's test framework and turn the **failing placeholder CI gate** into
a real, green one. This closes the open **ADR-002 (Test Infrastructure)** the template ships with.

**When:** once, at Phase 1 start (or any time the project still has no real test gate). The RPID
loop's Track 3 depends on this; `SHIP` and the Eng-review coverage audit read what this produces.

**Output:** an installed test framework, real first tests, a filled
`.github/workflows/test.yml`, a `TESTING.md`, and a `## Testing` + `## Test Coverage` section in
`CLAUDE.md`. Record the choice as **ADR-002 = Locked** in `docs/version1/DECISIONS.md`.

**Follow `prompts/reviews/_SHARED.md`** for decision briefs and completion status.

> Source: adapted from GStack `/ship` test-framework bootstrap (Garry Tan).

---

## Step 1 — detect runtime & existing tests

Detect the project runtime (presence of `package.json` / `Gemfile` / `pyproject.toml` /
`requirements.txt` / `go.mod` / `Cargo.toml` / `composer.json` / `mix.exs` / a `.csproj`/`.sln`) and
any existing test config or `test/`,`tests/`,`spec/`,`__tests__/` dirs.

- **Test framework already present** → read 2–3 existing test files to learn the conventions
  (naming, imports, assertions, setup), then **skip to Step 5** (just wire the gate + docs).
- **Runtime detected, no framework** → bootstrap (Steps 2–6).
- **No runtime detected** → ask the user which stack it is (offer the common options + "this
  project doesn't need tests" → record that and stop).

## Step 2 — choose a framework

If the project has no stated preference, recommend a sensible default and confirm via a `_SHARED.md`
decision brief. Reasonable defaults:

| Runtime | Default | Alternative |
|---------|---------|-------------|
| Node / TS | vitest + testing-library | jest |
| Python | pytest (+ pytest-cov) | unittest |
| Go | `go test` (stdlib) + testify | stdlib only |
| Rust | `cargo test` (built-in) | + mockall |
| Ruby/Rails | minitest + fixtures | rspec + factory_bot |
| PHP | phpunit | pest |
| Elixir | ExUnit (built-in) | + ex_machina |

(Pick the lightest isolation that faithfully reproduces the production target — see ADR-002 in
`DECISIONS.md`. Heavier isolation, e.g. a container or VM, only when the unit under test is an
OS-native artifact; that lives in `profiles/`.)

## Step 3 — install & configure

Install the chosen packages, create the minimal config, and create the test directory. Add one
example test that matches the project's actual code to verify the setup runs. If install fails,
debug once; if it still fails, revert and continue without tests (warn the user).

## Step 4 — write real first tests

Generate 3–5 real tests for existing code, prioritizing by risk: error handlers > business logic
with conditionals > endpoints > pure functions. Test what the code **does** — meaningful assertions,
never `expect(x).toBeDefined()`. Run each; keep passing ones, fix once, delete on persistent failure.

## Step 5 — fill the CI gate (the point of this prompt)

Replace the **failing placeholder** in `.github/workflows/test.yml` with the real command: set
`runs-on` (usually `ubuntu-latest`; `windows-latest` for a Windows-native target — see `profiles/`),
the runtime setup action, optional dependency install, and the verified test command as the "Run
the full test suite" step. Confirm it would run the **whole** suite, never a subset.

## Step 6 — docs

- **`TESTING.md`** — framework + version, how to run the full suite **and a single test in
  isolation**, the test layers (unit / integration / smoke / e2e), and conventions.
- **`CLAUDE.md` → `## Testing`** — the run command, the single-test command, the test directory, a
  pointer to `TESTING.md`, and the expectation (write a test with each new function; a regression
  test with each bug fix; both branches of each new conditional).
- **`CLAUDE.md` → `## Test Coverage`** — `Minimum:` and `Target:` percentages (defaults 60% / 80%)
  that `SHIP`'s coverage gate reads.
- **`docs/version1/DECISIONS.md`** — flip **ADR-002** to **Locked**, recording the runner +
  isolation choice.

End with a completion status. Commit the bootstrap separately: `chore: bootstrap test framework`.
