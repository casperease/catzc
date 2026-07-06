# pwsh

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
- `docs/adr/` — Architecture Decision Records (see below); `docs/notes/` — freeform working notes

## ADRs

Architecture Decision Records live under `docs/adr/`, grouped into `principles/`, `design/`, `automation/`, `pipelines/`, `azure/`, and
`repository/`. See `docs/adr/index.md` for the index, the rule-citation codes (e.g. `ADR-ERROR#3`), and the **authoring conventions**.
**Read all ADRs at the start of every session** — they define the design principles behind this codebase and must be followed when writing
or reviewing code.

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

### Other

- **README.md must be generic**: do not hardcode module names, function lists, or other content that changes as modules are added/removed.
  Use placeholders and describe patterns, not instances.
- **No mutating git operations**: Never run git add, commit, push, reset, checkout, rebase, merge, or other state-changing git commands
  unless the user explicitly asks. Read-only commands (status, log, diff, blame) are fine.
- **One living version — never back-compat or legacy** (`ADR-ONELIVE`, [one-living-version](../docs/adr/principles/one-living-version.md)):
  the repo carries exactly one version of every behaviour. Never add backwards-compatibility shims, deprecated-alias fields, or migration
  fallbacks (e.g. when changing `azure.yml`, the data model, `options.yml`, or the `Get-Azure*`/`Get-Bicep*` resolvers); change the contract
  and every in-tree caller in the same change, and delete the old shape. No legacy/dead code parked in the tree, no versioned variants
  (`*V2`, `*_old`, `legacy/`), no long-lived version branches — trunk-based, one source of truth. All history lives in
  `git log`/`git blame`, never in retained files, commented-out blocks, or "we used to" notes (docs read present-tense too).
- **Plans go in `out/`**: when asked to "make a plan", write a markdown file to `{repo}/out/plan-<topic>.md` (the gitignored output dir) —
  do not use plan mode or show a selection menu. The user wants a file to review.
- **Run PowerShell yourself — and actually run a gate before claiming it passed**: `pwsh` (7.4+) is available and permitted via the Bash
  tool, so run the importer, Pester, `Test-Automation`, and any `.ps1` directly — e.g. `pwsh -NoProfile -Command ". ./importer.ps1; <cmd>"`
  or `pwsh -NoProfile -File out/<name>.ps1`. Remember the importer is **dot-sourced** and C# type edits need a fresh `pwsh` process to
  recompile (a prior long-lived session won't pick them up). The discipline that remains: **never claim a test/gate passed unless you ran it
  and saw the result** — run it, read the output, report faithfully (failures included). A reusable script in `out/` (the gitignored output
  dir) is still preferred over a sprawling inline one-liner when the thing is worth rerunning or reviewing, but you no longer hand it off —
  you execute it.
