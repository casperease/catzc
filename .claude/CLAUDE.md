# .claude/CLAUDE.md

`pwsh`

PowerShell 7.4+ module system with zero-ceremony module authoring.

## Terminology

- **catzc** — the reserved, source-code-level name of the system: the `Catzc.*` module prefix, the C# `Catzc.*` namespaces, the `Catzc.`
  type-accelerator prefix, and the literal product token. Use it in code and in precise references.
- **cats** (plural) — the conversational cover term for the catzc system as a whole: the human-friendly name used in prose and docs and when
  talking to or about the system ("ask cats"). It stands in for the complicated, code-level catzc.
- **"domain rules" / "ADR rules"** — the sanctioned terms for this repository's conventions and decision records. Never say "house rules";
  it is not a domain-sanctioned term.

## Project structure

- `importer.ps1` — root script that imports all modules; always **dot-sourced** (`.\importer.ps1` is dot-sourcing), so it runs in the
  caller's scope and its global state (the prompt hook, `$env:RepositoryRoot`, `$isConsoleSession`, …) takes effect
- `automation/` — module folders containing `.ps1` function files
- `automation/.internal/` — internal infrastructure: the loader + shared libraries (`Catzc.Internal.{Loader,Types,TestKit}.psm1`, stay
  loaded) and the bootstrap (`Catzc.Internal.Bootstrap.psm1`, loaded first, removed after import), plus build `assets/`
- `automation/.vendor/` — third-party modules (checked in)
- `docs/adr/` — Architecture Decision Records (see below); `docs/references/` — reference articles (incl. the DORA research reference in
  `docs/references/dora/`); `docs/how-to/` — task guides; `docs/.assets/` — diagram assets

## ADRs

Architecture Decision Records live under `docs/adr/`, grouped into `principles/`, `design/`, `automation/`, `pipelines/`, `azure/`, and
`repository/`. See `docs/adr/index.md` for the index, the rule-citation codes (e.g. `ADR-AUTO-ERROR#3`), and the **authoring conventions**.
**Read all ADRs at the start of every session** — they define the design principles behind this codebase and must be followed when writing
or reviewing code.

## Inspiration

If `C:\projects\eac` is available (the same project family, a sibling checkout), you may read it for **inspiration on every aspect**: module
and command design, docs and ADR structure, contracts, specs, testing, pipelines, tooling. It is **not a reference implementation**. It is a
similar model built in Go, so never copy its structure or code as the answer, and never cite it as an authority. Catzc's own ADRs decide.
Treat what you read there as an idea to weigh against the domain rules here, and say so when an idea came from it. If it is absent, carry on
without it.

Which catzc ADR decides each aspect you might take an idea for:

- **Module and command design:** [ADR-AUTO-ONEFUNC](../docs/adr/automation/powershell/one-function-per-file.md),
  [ADR-AUTO-PSPARAM](../docs/adr/automation/powershell/parameter-design.md), and the one resolution order of a setting,
  [ADR-AUTO-DEFAULT#6](../docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6).
- **Docs and ADR structure:** the [authoring conventions](../docs/adr/index.md#authoring-conventions).
- **Contracts:** [ADR-REPO-CONTRACT](../docs/adr/repository/api-contracts.md).
- **Testing:** [ADR-AUTO-TEST](../docs/adr/automation/test-automation.md).
- **Pipelines:** [ADR-FLOW-CD](../docs/adr/flow/cd-discipline-and-promotion-flow.md) and
  [ADR-FLOW-CD-RUNNER](../docs/adr/flow/pipeline-runner-pattern.md).
- **Tooling:** [ADR-AUTO-PKGMGR](../docs/adr/automation/use-proper-package-managers.md) and
  [ADR-AUTO-UVPY](../docs/adr/automation/uv-python-handler.md).
- **Go itself:** the [Go automation ADRs](../docs/adr/automation/go/index.md) are reserved, and catzc has made no Go decisions yet. A Go
  idea from eac therefore opens a question for the user. It is never a precedent.
- **Copying anything across:** [ADR-PRIN-ONELIVE](../docs/adr/principles/one-living-version.md). Catzc carries one living version of each
  behaviour, so an idea is rebuilt here to catzc's rules, never ported alongside.

## Sub-agents

Sub-agent definitions live in `.claude/agents/<name>.md`. Every agent exists because an ADR rule supports it, and is mapped to the gates and
checks it runs or guards; the registry is `automation/Catzc.Base.Docs/configs/agents.yml`, and `Test-AgentDefinitions` keeps the files, the
registry, and this list in step (`ADR-REPO-AGENTS`, [agent-definitions](../docs/adr/repository/agent-definitions.md)).

- **`catzc-worker`** — the **standard** sub-agent for delegated work: one scoped task from a coordinator's brief, editing only the files it
  owns, verifying each file, and asking the coordinator for shared-file entries. Use it whenever work is delegated and no specialised agent
  fits.
- **`drawio-diagram-waves`** — authors new draw.io diagrams in bounded parallel waves for the user to approve.
- **`write-drawio-files`** — changes labels, text, or styles inside existing `.drawio.png` diagrams.
- **`print-artifacts`** — republishes the diagram review artifact from the files on disk.
- **`build-inspiration-module`** — creates or extends the inspiration module (`Get-Inspiration`).

## Rules

### Automation

- **One function per file** (`Verb-Noun.ps1`): `Get-Foo.ps1` must contain exactly `function Get-Foo`
- **Folder = module**: A module is a folder under `automation/` containing `.ps1` files
- **Public/private by location**: `.ps1` files at the module root are PUBLIC (exported). `.ps1` files in `private/` are PRIVATE (loaded but
  not exported). Private functions are available to public functions via shared module scope (`.ps1` in `NestedModules`).
- `importer.ps1` handles loading all modules

### Editing

- **Never batch-edit multiple files with scripts.** No `sed`, `-replace`, or `[regex]::Replace` sweeps across many files — they fail
  silently and repeatedly here (e.g. `[regex]::Replace`'s 4th arg is `RegexOptions`, not a count, so it replaces everything; `sed` escaping
  no-ops; Pester `$script:` scope surprises) and the mess takes far longer to unwind than the edit saved. **Edit one file at a time with the
  Edit tool, then verify that file (run its tests) before the next.** Slower, but it actually works.

### Time safeguard

- **ALL calls to bash and pwsh by agent/Claude execution MUST run within a time safeguard** (`ADR-AUTO-FAILFAST#7`,
  [fail-fast-with-asserts](../docs/adr/automation/fail-fast-with-asserts.md#rule-adr-auto-failfast7)). Every Bash tool call — the main
  session and every subagent — passes `timeout: 10000` (at most `default_seconds` in `automation/Catzc.Base.Timeouts/configs/timeouts.yml`,
  currently 10 s), or runs longer work with `run_in_background: true` and waits for its completion notification. The PreToolUse hook
  `.claude/hooks/Assert-BashTimeout/` (a C# program the importer publishes) denies a foreground call that breaks this. In code, bound work
  with `Invoke-WithTimeout` / `Assert-CompletesWithin`; `Invoke-Executable` already kills a process past its executable's limit. The limit
  is tight on purpose while blockers are tuned together: a call that legitimately needs longer goes to the background or gets a
  `timeouts.yml` entry — never a workaround around the safeguard.
- **Probe with the fastest runner that can answer.** Reading, listing, searching, and checking state (a file's content, whether a file
  exists, a count, `git status`/`log`/`diff`) use plain bash (`cat`, `ls`, `grep`, `git`) or the Read/Grep/Glob tools — milliseconds, well
  inside the limit. Use `pwsh -NoProfile -Command '…'` _without_ the importer when only PowerShell itself is needed (parse a file, evaluate
  an expression). Start `pwsh` with `. ./importer.ps1` only when a catzc command must run (a test, a gate, a generator) — the import alone
  takes seconds, so those calls go to the background.

### Other

- **README.md must be generic**: do not hardcode module names, function lists, or other content that changes as modules are added/removed.
  Use placeholders and describe patterns, not instances.
- **No mutating git operations**: Never run git add, commit, push, reset, checkout, rebase, merge, or other state-changing git commands
  unless the user explicitly asks. Read-only commands (status, log, diff, blame) are fine.
- **One living version — never back-compat or legacy** (`ADR-PRIN-ONELIVE`,
  [one-living-version](../docs/adr/principles/one-living-version.md)): the repo carries exactly one version of every behaviour. Never add
  backwards-compatibility shims, deprecated-alias fields, or migration fallbacks (e.g. when changing `azure.yml`, the data model,
  `options.yml`, or the `Get-Azure*`/`Get-Bicep*` resolvers); change the contract and every in-tree caller in the same change, and delete
  the old shape. No legacy/dead code parked in the tree, no versioned variants (`*V2`, `*_old`, `legacy/`), no long-lived version branches —
  trunk-based, one source of truth. All history lives in `git log`/`git blame`, never in retained files, commented-out blocks, or "we used
  to" notes (docs read present-tense too).
- **Plans go in `out/`**: when asked to "make a plan", write a markdown file to `{repo}/out/plan-<topic>.md` (the gitignored output dir) —
  do not use plan mode or show a selection menu. The user wants a file to review.
- **Run PowerShell yourself — and actually run a gate before claiming it passed**: `pwsh` (7.4+) is available and permitted via the Bash
  tool, so run the importer, Pester, `Test-Automation`, and any `.ps1` directly — e.g. `pwsh -NoProfile -Command ". ./importer.ps1; <cmd>"`
  or `pwsh -NoProfile -File out/<name>.ps1`. Remember the importer is **dot-sourced** and C# type edits need a fresh `pwsh` process to
  recompile (a prior long-lived session won't pick them up). The discipline that remains: **never claim a test/gate passed unless you ran it
  and saw the result** — run it, read the output, report faithfully (failures included). A reusable script in `out/` (the gitignored output
  dir) is still preferred over a sprawling inline one-liner when the thing is worth rerunning or reviewing, but you no longer hand it off —
  you execute it.
