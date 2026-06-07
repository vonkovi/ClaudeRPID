# profiles/ — opt-in stack overlays

The base template is **stack-agnostic** — it ships no language, framework, runner, or VM
config. That invariant is what lets one template serve a CLI, a web service, a research repo,
or a native app. Concrete test/build tooling does **not** belong in the repo root; it belongs
here, as an **opt-in overlay** chosen at initialization.

## How it works

Each subfolder is a self-contained overlay for one target stack. During project
initialization (`prompts/PROJECT_INIT_PROMPT.md`, once the stack is known):

1. Pick the one profile matching your stack.
2. Copy its files into the repo root — it may overwrite `.github/workflows/test.yml`, add a
   runner config, a `Vagrantfile`, etc.
3. **Delete the entire `profiles/` folder.** Like `START_HERE.md`, it has done its job; leaving
   it behind reintroduces the misleading-context problem it exists to prevent (a clone reading a
   `Vagrantfile` it does not actually use).
4. Record the choice as **ADR-002 (Test Infrastructure)** in `docs/version1/DECISIONS.md`, and
   fill the real test command into both `.github/workflows/test.yml` and the "run a SINGLE test"
   line of `CLAUDE.md`.

## What a profile may contain

- A filled `.github/workflows/test.yml` — real `run:` command, and a swapped `runs-on` if the
  target needs it (e.g. `windows-latest`).
- Runner / build config: `vitest.config.*`, `pytest.ini`, `go.mod`, `CMakeLists.txt`, …
- Isolation config **only when the target is OS-native**: a `Vagrantfile` or `Dockerfile` — e.g.
  a `windows-native/` profile that runs `.exe` smoke tests on `windows-latest` or inside Vagrant.
  Pick the lightest isolation that faithfully reproduces the production target (see ADR-002).
- A short `NOTES.md` listing host prerequisites — the binaries CI and developers must install
  (Vagrant, Docker, a JDK, …). Those are machine-level installs, never repo artifacts.

## Suggested layout

```
profiles/
  README.md            ← this file
  node/                ← vitest/jest + setup-node test.yml
  python/              ← pytest + setup-python test.yml
  go/                  ← go test + setup-go test.yml
  windows-native/      ← .exe testing: windows-latest runner and/or Vagrantfile
```

No profile ships populated by default — add the one(s) you need, or let `PROJECT_INIT` generate
one from your stack answer. **Keeping the base empty is the point.**

## GStack tool-bound overlays (the executable half of the methodology)

The GStack integration (v2.0) ports the *methodology* of Garry Tan's GStack as stack-agnostic
prompts in `prompts/reviews/` and `prompts/`. The parts of GStack that need **real executables**
are intentionally left out of the base and belong here as opt-in overlays:

| Overlay | Powers | Needs |
|---------|--------|-------|
| `web/` (browser QA) | live `/qa`, `/canary`, visual `/design-review` execution | a headless browser (e.g. Playwright) |
| `deploy/` | `/land-and-deploy`, post-deploy `/canary` | a PaaS/CI deploy target (Fly, Render, Vercel, …) |
| `cross-model/` | an independent second opinion in reviews | a second model CLI (e.g. Codex) |

The prompts degrade gracefully without these — the review *rubrics* run as pure markdown; only the
live execution needs the overlay. Simplest path for the executable bits: install GStack itself
(`github.com/garrytan/gstack`) alongside this project and let its `/qa`, `/canary`, etc. handle the
browser/deploy work while these prompts cover the methodology and gates.
