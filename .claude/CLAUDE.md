# pwsh

PowerShell 7.4+ module system with zero-ceremony module authoring.

## Terminology

- **catzc** — the reserved, source-code-level name of the system: the `Catzc.*` module prefix, the C# `Catzc.*` namespaces, the `Catzc.`
  type-accelerator prefix, and the literal product token. Use it in code and in precise references
  ([PDR-CATS-CATZCISSOURCENAME](../docs/drs/principles/cats-and-catzc.md#rule-pdr-cats-catzcissourcename)).
- **cats** (plural) — the conversational cover term for the catzc system as a whole: the human-friendly name used in prose and docs and when
  talking to or about the system ("ask cats"). It stands in for the complicated, code-level catzc
  ([PDR-CATS-ISPERSONNAME](../docs/drs/principles/cats-and-catzc.md#rule-pdr-cats-ispersonname)).
- **"domain rules" / "DRS rules"** — the sanctioned terms for this repository's conventions and decision records. Never say "house rules";
  it is not a domain-sanctioned term.

## Project structure

- `importer.ps1` — root script that imports all modules; always **dot-sourced** (`.\importer.ps1` is dot-sourcing), so it runs in the
  caller's scope and its global state (the prompt hook, `$env:RepositoryRoot`, `$isConsoleSession`, …) takes effect
- `pwsh/` — module folders containing `.ps1` function files, named without the catzc prefix (the track declares the namespace)
- `pwsh/.internal/` — internal infrastructure, the `Catzc.Internal.*.psm1` modules: `Loader`, `Types`, and `Vendor` stay loaded; `Bootstrap`
  and `Importer` load first and are removed after import; `Builder` and `TestKit` load when a build or a test run needs them; plus build
  `assets/`
- `pwsh/.vendor/` — third-party modules (checked in)
- `.unordered/` — the unordered track, where an import lands with its history at a landing address `.unordered/<name>`
  (`Import-RepositoryWithHistory`); sorting moves each file out with `git mv`, and nothing internal reads or defaults to the track
  ([DDR-TRACK-UNORDEREDTRACK](../docs/drs/design/tracks.md#rule-ddr-track-unorderedtrack))
- `pwsh/*/types/*.cs` — the C# types, written in BCL, a subset of .NET that pwsh hosts
- `docs/drs/` — the DRS, the decision records (see below); `docs/references/` — reference articles, where a design round starts from
  `docs/references/pwsh/index.md` (incl. the DORA research reference in `docs/references/dora/`); `docs/how-to/` — task guides;
  `docs/.assets/` — diagram assets

## DRS

The DRS holds the decision records, under `docs/drs/`, grouped into the domains that `docs/drs/index.md` lists. The index also holds every
rule-citation code (e.g. `ADR-PWSH-ERROR-THROWNOTWRITEERROR`) and the **authoring conventions**. The decision records define the design
principles behind this codebase and must be followed when writing or reviewing code. **Read `docs/drs/index.md` at the start of every
session**, then read in full the decision records that govern the files a task touches, and cite their rules by code. The whole corpus is
far larger than a context window, so never sweep it, and never sweep `research/`, which is reference material, not rules.

## Inspiration

If `C:\projects\eac` is available (the same project family, a sibling checkout), you may read it for **inspiration on every aspect**: module
and command design, docs and decision-record structure, contracts, specs, testing, pipelines, tooling. It is **not a reference
implementation**. It is a similar model built in Go, so never copy its structure or code as the answer, and never cite it as an authority.
Catzc's own decision records decide. Treat what you read there as an idea to weigh against the domain rules here, and say so when an idea
came from it. If it is absent, carry on without it.

The domain rules in [`docs/drs/index.md`](../docs/drs/index.md) decide each aspect you might take an idea for. Two need saying here:

- **Go itself:** [ADR-AUTO-GO](../docs/drs/automation/go/go-test-artifacts.md): Go in catzc is test artifacts only. A Go idea from eac
  beyond that scope opens a question for the user. It is never a precedent.
- **Copying anything across:** [PDR-ONELIVE](../docs/drs/principles/one-living-version.md). Catzc carries one living version of each
  behaviour, so an idea is rebuilt here to catzc's rules, never ported alongside.

## Sub-agents

Each agent is `.claude/agents/<name>.md`, registered in `pwsh/Base.Docs/configs/agents.yml`; `Test-AgentDefinitions` keeps the files, the
registry and this list in step ([agent-definitions](../docs/drs/repository/agent-definitions.md)). Every agent and its capabilities read
[ADR-REPO-AI](../docs/drs/repository/ai-agent-contract.md) first.

- **`drone-haiku`** — runs one job skill a brief names, on the haiku model.
- **`drone-sonnet`** — runs one job skill a brief names, on the sonnet model.
- **`drone-opus`** — runs one job skill a brief names, on the opus model.
- **`drone-fable`** — runs one job skill a brief names, on the fable model.

Every job is a skill registered in `pwsh/Base.Docs/configs/capabilities.yml`, its name `<domain>-<job>`: a brief names it as `skill: <name>`
and the skill's `model_floor` picks the drone; a job that needs the user or the session's peers is a user skill, run in the main session.

## Rules

### Automation

- **One function per file** (`Verb-Noun.ps1`): `Get-Foo.ps1` must contain exactly `function Get-Foo`
- **Folder = module**: A module is a folder under `pwsh/` containing `.ps1` files
- **Public/private by location**: `.ps1` files at the module root are PUBLIC (exported). `.ps1` files in `private/` are PRIVATE (loaded but
  not exported). Private functions are available to public functions via shared module scope (each `.ps1` dot-sourced into the module by the
  shared loader `pwsh/.internal/assets/Import-ModuleFiles.ps1`).
- `importer.ps1` handles loading all modules

### Editing

- **Never batch-edit multiple files with scripts.** No `sed`, `-replace`, or `[regex]::Replace` sweeps across many files — they fail
  silently and repeatedly here (e.g. `[regex]::Replace`'s 4th arg is `RegexOptions`, not a count, so it replaces everything; `sed` escaping
  no-ops; Pester `$script:` scope surprises) and the mess takes far longer to unwind than the edit saved. **Edit one file at a time with the
  Edit tool, then verify that file (run its tests) before the next.** Slower, but it actually works.

### Time safeguard

- **Every call is bounded** (`ADR-AUTO-FAILFAST-BOUNDEVERYWAIT`); the `catzc-run` capability has the call shapes. The hook
  `.claude/hooks/Assert-BashTimeout/` denies an unbounded call, and the git topic commands, and logs each denial to
  `out/time-safeguard.log`. Bash calls use absolute paths. Work that legitimately needs longer gets its limit in
  `pwsh/Base.Timeouts/configs/timeouts.yml` or a command's `TimeLimit`, never a workaround; a denial is raised (to the user, or a subagent's
  coordinator), never retried larger.
- **Probe with the fastest runner that can answer:** the Grep tool for a recursive search, Read (with an offset for a large or persisted
  file) for a file, never `cat`; `pwsh -NoProfile` without the importer when only PowerShell is needed; a cats command through
  `Invoke-CatzcCommand.ps1`, in the background.

### Other

- **README.md must be generic**: do not hardcode module names, function lists, or other content that changes as modules are added/removed.
  Use placeholders and describe patterns, not instances.
- **No mutating git operations**: Never run git add, commit, push, reset, checkout, rebase, merge, or other state-changing git commands
  unless the user explicitly asks. Read-only commands (status, log, diff, blame) are fine.
- **One living version — never back-compat or legacy** (`PDR-ONELIVE`, [one-living-version](../docs/drs/principles/one-living-version.md)):
  the repo carries exactly one version of every behaviour. Never add backwards-compatibility shims, deprecated-alias fields, or migration
  fallbacks (e.g. when changing `azure.yml`, the data model, `options.yml`, or the `Get-Azure*`/`Get-Bicep*` resolvers); change the contract
  and every in-tree caller in the same change, and delete the old shape. No legacy/dead code parked in the tree, no versioned variants
  (`*V2`, `*_old`, `legacy/`), no long-lived version branches — trunk-based, one source of truth. All history lives in
  `git log`/`git blame`, never in retained files, commented-out blocks, or "we used to" notes (docs read present-tense too).
- **Plans are authored in `.claude/plans/plan-<topic>.md`** (`ADR-REPO-PLANS`, [plans](../docs/drs/repository/plans.md)): when asked to
  "make a plan", write that file — do not use plan mode or show a selection menu; the user wants a file to review. A plan holds the delta
  only, `plan-master.md` and the `task-<topic>.md` files are derived from the plans (the master's list carries the order, never a name), and
  a done plan is deleted.
- **Run PowerShell yourself, and claim a pass only after reading its verdict**: the `catzc-run` skill has the call shapes and the rules.
