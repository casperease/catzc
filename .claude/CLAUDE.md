# pwsh

PowerShell 7.4+ module system with zero-ceremony module authoring.

## Terminology

- **catzc** — the reserved, source-code-level name of the system: the `Catzc.*` module prefix, the C# `Catzc.*` namespaces, the `Catzc.`
  type-accelerator prefix, and the literal product token. Use it in code and in precise references
  ([PDR-CATS-CATZCISSOURCENAME](../docs/drs/principles/cats-and-catzc.md#rule-pdr-cats-catzcissourcename)).
- **cats** (plural) — the conversational cover term for the catzc system as a whole: the human-friendly name used in prose and docs and when
  talking to or about the system ("ask cats"). It stands in for the complicated, code-level catzc
  ([PDR-CATS-CATSISPERSONNAME](../docs/drs/principles/cats-and-catzc.md#rule-pdr-cats-catsispersonname)).
- **"domain rules" / "DRS rules"** — the sanctioned terms for this repository's conventions and decision records. Never say "house rules";
  it is not a domain-sanctioned term.

## Project structure

- `importer.ps1` — root script that imports all modules; always **dot-sourced** (`.\importer.ps1` is dot-sourcing), so it runs in the
  caller's scope and its global state (the prompt hook, `$env:RepositoryRoot`, `$isConsoleSession`, …) takes effect
- `pwsh/` — module folders containing `.ps1` function files
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
rule-citation code (e.g. `ADR-PWSH-ERROR-THROWNOTWRITEERROR`) and the **authoring conventions**. The ADRs define the design principles
behind this codebase and must be followed when writing or reviewing code. **Read `docs/drs/index.md` at the start of every session**, then
read in full the ADRs that govern the files a task touches, and cite their rules by code. The whole corpus is far larger than a context
window, so never sweep it, and never sweep `research/`, which is reference material, not rules.

## Inspiration

If `C:\projects\eac` is available (the same project family, a sibling checkout), you may read it for **inspiration on every aspect**: module
and command design, docs and ADR structure, contracts, specs, testing, pipelines, tooling. It is **not a reference implementation**. It is a
similar model built in Go, so never copy its structure or code as the answer, and never cite it as an authority. Catzc's own ADRs decide.
Treat what you read there as an idea to weigh against the domain rules here, and say so when an idea came from it. If it is absent, carry on
without it.

Which catzc ADR decides each aspect you might take an idea for:

- **Module and command design:** [ADR-PWSH-ONEFUNC](../docs/drs/automation/pwsh/one-function-per-file.md),
  [ADR-PWSH-PARAM](../docs/drs/automation/pwsh/parameter-design.md), and the one resolution order of a setting,
  [ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../docs/drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder).
- **Docs and ADR structure:** the [authoring conventions](../docs/drs/index.md#authoring-conventions).
- **Contracts:** [ADR-REPO-CONTRACT](../docs/drs/repository/api-contracts.md).
- **Testing:** [ADR-AUTO-TEST](../docs/drs/automation/test-automation.md).
- **Pipelines:** [FDR-CD](../docs/drs/flow/cd-discipline-and-promotion-flow.md) and
  [FDR-CD-RUNNER](../docs/drs/flow/pipeline-runner-pattern.md).
- **Tooling:** [ADR-AUTO-PKGMGR](../docs/drs/automation/use-proper-package-managers.md) and
  [ADR-AUTO-UVPY](../docs/drs/automation/uv-python-handler.md).
- **Go itself:** [ADR-AUTO-GO](../docs/drs/automation/go/go-test-artifacts.md): Go in catzc is test artifacts only. A Go idea from eac
  beyond that scope opens a question for the user. It is never a precedent.
- **Copying anything across:** [PDR-ONELIVE](../docs/drs/principles/one-living-version.md). Catzc carries one living version of each
  behaviour, so an idea is rebuilt here to catzc's rules, never ported alongside.

## Sub-agents

Each agent is `.claude/agents/<name>.md`, registered in `pwsh/Base.Docs/configs/agents.yml`; `Test-AgentDefinitions` keeps the files, the
registry and this list in step ([agent-definitions](../docs/drs/repository/agent-definitions.md)). Every agent and its capabilities read
[ADR-REPO-AI](../docs/drs/repository/ai-agent-contract.md) first.

- **`catzc-drone`** — the standard agent for one delegated task, when no specialised agent fits.
- **`drawio-diagram-waves`** — authors new draw.io diagrams in bounded parallel waves.
- **`edit-diagram-yml`** — changes a diagram by its `<name>.drawio.yml` and re-renders it.
- **`2020-hindsight`** — keeps the hindsight log, each lesson checked against the tree.
- **`its-a-chore-but-i-will-do-better`** — plans the hindsight log's debt reductions.
- **`diagram-review`** — reviews the diagrams one slide at a time with the user.
- **`print-artifacts`** — republishes the diagram review artifact.
- **`build-inspiration-module`** — creates or extends the inspiration module.
- **`session-cost-audit`** — measures what a session cost and proposes the changes.
- **`plan-clear`** — cleans the plans to the plan rules.
- **`plan-intake`** — lands a pasted continuation prompt in the plans.
- **`plan-decide`** — runs a decision round over the plans' open questions.
- **`gate-runner`** — runs one gate or test file and brings its verdict back.
- **`link-fixer`** — repairs the links of named markdown files.
- **`drs-reviewer`** — reviews a file set against the rules that govern it.
- **`fact-checker`** — checks one statement against the tree and the glossary.
- **`listen-very-carefully-to-doc-changes`** — the listen mode's processor.
- **`doc-pattern-scout`** — finds one pattern in a listen session's reference.
- **`glossary-keeper`** — keeps the glossary in step with the rules.
- **`test-optimization`** — makes the tests faster without weakening any.
- **`implementation-orchestrator`** — drives plan-master's chunks through the live sessions.
- **`devbox-vscode-diagnostics`** — finds why pwsh or VS Code misbehaves on this devbox.

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
- **Run PowerShell yourself — and actually run a gate before claiming it passed**: `pwsh` (7.4+) is available and permitted via the Bash
  tool, so run the importer, Pester, `Test-Automation`, and any `.ps1` directly — e.g.
  `timeout <s> pwsh -NoProfile -File pwsh/.internal/assets/Invoke-CatzcCommand.ps1 "<cmd>"` or `pwsh -NoProfile -File out/<name>.ps1`.
  Remember the importer is **dot-sourced** and C# type edits need a fresh `pwsh` process to recompile (a prior long-lived session won't pick
  them up). The discipline that remains: **never claim a test/gate passed unless you ran it and saw the result** — run it, read the output,
  report faithfully (failures included). A reusable script in `out/` (the gitignored output dir) is still preferred over a sprawling inline
  one-liner when the thing is worth rerunning or reviewing, but you no longer hand it off — you execute it.
