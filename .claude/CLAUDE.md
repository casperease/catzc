# pwsh

PowerShell 7.4+ module system with zero-ceremony module authoring.

## Terminology

- **catzc** — the reserved, source-code-level name of the system: the `Catzc.*` module prefix, the C# `Catzc.*` namespaces, the `Catzc.`
  type-accelerator prefix, and the literal product token. Use it in code and in precise references
  ([ADR-CATS#1](../docs/adr/principles/cats-and-catzc.md#rule-adr-cats1)).
- **cats** (plural) — the conversational cover term for the catzc system as a whole: the human-friendly name used in prose and docs and when
  talking to or about the system ("ask cats"). It stands in for the complicated, code-level catzc
  ([ADR-CATS#2](../docs/adr/principles/cats-and-catzc.md#rule-adr-cats2)).
- **"domain rules" / "ADR rules"** — the sanctioned terms for this repository's conventions and decision records. Never say "house rules";
  it is not a domain-sanctioned term.

## Project structure

- `importer.ps1` — root script that imports all modules; always **dot-sourced** (`.\importer.ps1` is dot-sourcing), so it runs in the
  caller's scope and its global state (the prompt hook, `$env:RepositoryRoot`, `$isConsoleSession`, …) takes effect
- `automation/` — module folders containing `.ps1` function files
- `automation/.internal/` — internal infrastructure, the `Catzc.Internal.*.psm1` modules: `Loader`, `Types`, and `Vendor` stay loaded;
  `Bootstrap` and `Importer` load first and are removed after import; `Builder` and `TestKit` load when a build or a test run needs them;
  plus build `assets/`
- `automation/.vendor/` — third-party modules (checked in)
- `.unordered/` — the unordered track, where an import lands with its history at a landing address `.unordered/<name>`
  (`Import-RepositoryWithHistory`); sorting moves each file out with `git mv`, and nothing reads or defaults to the track
  ([ADR-DSGN-TRACK#17](../docs/adr/design/tracks.md#rule-adr-dsgn-track17))
- `docs/adr/` — Architecture Decision Records (see below); `docs/references/` — reference articles (incl. the DORA research reference in
  `docs/references/dora/`); `docs/how-to/` — task guides; `docs/.assets/` — diagram assets

## ADRs

Architecture Decision Records live under `docs/adr/`, grouped into the domains that `docs/adr/index.md` lists. The index also holds every
rule-citation code (e.g. `ADR-PWSH-ERROR#3`) and the **authoring conventions**. The ADRs define the design principles behind this codebase
and must be followed when writing or reviewing code. **Read `docs/adr/index.md` at the start of every session**, then read in full the ADRs
that govern the files a task touches, and cite their rules by code. The whole corpus is far larger than a context window, so never sweep it,
and never sweep `research/`, which is reference material, not rules.

## Inspiration

If `C:\projects\eac` is available (the same project family, a sibling checkout), you may read it for **inspiration on every aspect**: module
and command design, docs and ADR structure, contracts, specs, testing, pipelines, tooling. It is **not a reference implementation**. It is a
similar model built in Go, so never copy its structure or code as the answer, and never cite it as an authority. Catzc's own ADRs decide.
Treat what you read there as an idea to weigh against the domain rules here, and say so when an idea came from it. If it is absent, carry on
without it.

Which catzc ADR decides each aspect you might take an idea for:

- **Module and command design:** [ADR-PWSH-ONEFUNC](../docs/adr/pwsh/one-function-per-file.md),
  [ADR-PWSH-PARAM](../docs/adr/pwsh/parameter-design.md), and the one resolution order of a setting,
  [ADR-AUTO-DEFAULT#6](../docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6).
- **Docs and ADR structure:** the [authoring conventions](../docs/adr/index.md#authoring-conventions).
- **Contracts:** [ADR-REPO-CONTRACT](../docs/adr/repository/api-contracts.md).
- **Testing:** [ADR-AUTO-TEST](../docs/adr/automation/test-automation.md).
- **Pipelines:** [ADR-FLOW-CD](../docs/adr/flow/cd-discipline-and-promotion-flow.md) and
  [ADR-FLOW-CD-RUNNER](../docs/adr/flow/pipeline-runner-pattern.md).
- **Tooling:** [ADR-AUTO-PKGMGR](../docs/adr/automation/use-proper-package-managers.md) and
  [ADR-AUTO-UVPY](../docs/adr/automation/uv-python-handler.md).
- **Go itself:** [ADR-AUTO-GO](../docs/adr/automation/go/go-test-artifacts.md): Go in catzc is test artifacts only. A Go idea from eac
  beyond that scope opens a question for the user. It is never a precedent.
- **Copying anything across:** [ADR-PRIN-ONELIVE](../docs/adr/principles/one-living-version.md). Catzc carries one living version of each
  behaviour, so an idea is rebuilt here to catzc's rules, never ported alongside.

## Sub-agents

Sub-agent definitions live in `.claude/agents/<name>.md`. Every agent exists because an ADR rule supports it, and is mapped to the gates and
checks it runs or guards; the registry is `automation/Catzc.Base.Docs/configs/agents.yml`, and `Test-AgentDefinitions` keeps the files, the
registry, and this list in step (`ADR-REPO-AGENTS`, [agent-definitions](../docs/adr/repository/agent-definitions.md)). Every agent is a
robot: a body of at most 20 lines on a named model, loading its shared know-how from capabilities, `.claude/skills/<domain>-<job>/SKILL.md`
files of at most 10 lines with a model floor, registered in `automation/Catzc.Base.Docs/configs/capabilities.yml`. Every robot and
capability reads the AI agent contract first, [ADR-AI](../docs/adr/repository/ai-agent-contract.md); it is named once, here and as
`contracts` in `agents.yml`, never in a file's front matter.

- **`catzc-worker`** — the **standard** sub-agent for delegated work: one scoped task from a coordinator's brief, editing only the files it
  owns, verifying each file, and asking the coordinator for shared-file entries. Use it whenever work is delegated and no specialised agent
  fits.
- **`drawio-diagram-waves`** — authors new draw.io diagrams in bounded parallel waves for the user to approve.
- **`drawio-png`** — takes a `.drawio.png` address and its markdown pages, re-renders the embedded model to `out/drawio/`, and reports what
  the raster hides or the sources say and the diagram lacks; lands nothing under `docs/`.
- **`write-drawio-files`** — changes labels, text, or styles inside existing `.drawio.png` diagrams and re-renders the raster from the
  edited model, so the picture and the embedded XML stay honest to each other.
- **`print-artifacts`** — republishes the diagram review artifact from the files on disk.
- **`build-inspiration-module`** — creates or extends the inspiration module (`Get-Inspiration`).
- **`session-cost-audit`** — measures what a session cost and why, against `out/plan-session-cost.md`, and proposes the changes.
- **`plan-clear`** — cleans the plans in `.claude/plans/` to the plan rules: a verdict per plan (keep, trim, re-point, delete, intake),
  acted on one file at a time, links re-checked.
- **`plan-intake`** — lands a pasted continuation prompt in the plans: every item in exactly one plan, done claims checked against the tree,
  open questions kept open.
- **`plan-decide`** — runs a decision round over the plans' open questions: a questionnaire, four items per ask with the recommendation
  first, every answer recorded with its projected outcome, then folded into the plans.
- **`gate-runner`** — runs one gate or test file in the background and brings its verdict back verbatim.
- **`link-fixer`** — repairs the links of a named set of markdown files, one file and one target at a time.
- **`adr-reviewer`** — read-only review of a file set against the rules that govern it, each finding with its rule code.
- **`glossary-keeper`** — keeps the glossary sources in step with the rules that bold each term, one term at a time.
- **`test-optimization`** — makes all tests faster under the `timeouts.yml` roofs, one measured file at a time, without removing or
  weakening any test.

## Rules

### Automation

- **One function per file** (`Verb-Noun.ps1`): `Get-Foo.ps1` must contain exactly `function Get-Foo`
- **Folder = module**: A module is a folder under `automation/` containing `.ps1` files
- **Public/private by location**: `.ps1` files at the module root are PUBLIC (exported). `.ps1` files in `private/` are PRIVATE (loaded but
  not exported). Private functions are available to public functions via shared module scope (each `.ps1` dot-sourced into the module by the
  shared loader `automation/.internal/assets/Import-ModuleFiles.ps1`).
- `importer.ps1` handles loading all modules

### Editing

- **Never batch-edit multiple files with scripts.** No `sed`, `-replace`, or `[regex]::Replace` sweeps across many files — they fail
  silently and repeatedly here (e.g. `[regex]::Replace`'s 4th arg is `RegexOptions`, not a count, so it replaces everything; `sed` escaping
  no-ops; Pester `$script:` scope surprises) and the mess takes far longer to unwind than the edit saved. **Edit one file at a time with the
  Edit tool, then verify that file (run its tests) before the next.** Slower, but it actually works.

### Time safeguard

- **ALL Bash tool calls and pwsh processes by agent/Claude execution MUST run within a time safeguard** (`ADR-AUTO-FAILFAST#7`,
  [fail-fast-with-asserts](../docs/adr/automation/fail-fast-with-asserts.md#rule-adr-auto-failfast7)). Every Bash tool call — the main
  session and every subagent — passes `timeout: 3000` (at most `limits.devbox.bash.foreground` in
  `automation/Catzc.Base.Timeouts/configs/timeouts.yml`, currently 3 s on a devbox). Longer work runs with `run_in_background: true` **and**
  starts with a GNU `timeout <seconds>` prefix around **one** command (at most `limits.devbox.bash.background`, currently 360 s): the Bash
  tool ignores its `timeout` parameter for background calls, so the prefix is the only bound. No `cd … &&`, pipes or `;` in a background
  call — use absolute paths, or put multi-step work in a script under `out/`; exit 124 means the safeguard stopped it. The PreToolUse hook
  `.claude/hooks/Assert-BashTimeout/` (a C# program the importer publishes) denies any call that breaks this, and logs it to
  `out/time-safeguard.log`. In code, bound work with `Invoke-WithTimeout` / `Assert-CompletesWithin` / `Test-CompletesWithin`;
  `Invoke-Executable` already kills a process past its executable's limit. The limits are tight on purpose while blockers are tuned
  together: a call that legitimately needs longer goes to the background, gets a `timeouts.yml` entry, or carries a `-Budget` GUID exempted
  in `timeout-exemptions.yml` — never a workaround around the safeguard. A denied main-session call is a blocker to raise with the user; a
  denied subagent call is reported to its coordinator, not retried with a larger limit.
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
- **Plans are authored in `.claude/plans/plan-<topic>.md`** (`ADR-REPO-PLANS`, [plans](../docs/adr/repository/plans.md)): when asked to
  "make a plan", write that file — do not use plan mode or show a selection menu; the user wants a file to review. A plan holds the delta
  only, `plan-master.md` and the `task-<topic>.md` files are derived from the plans (the master's list carries the order, never a name), and
  a done plan is deleted.
- **Run PowerShell yourself — and actually run a gate before claiming it passed**: `pwsh` (7.4+) is available and permitted via the Bash
  tool, so run the importer, Pester, `Test-Automation`, and any `.ps1` directly — e.g. `pwsh -NoProfile -Command ". ./importer.ps1; <cmd>"`
  or `pwsh -NoProfile -File out/<name>.ps1`. Remember the importer is **dot-sourced** and C# type edits need a fresh `pwsh` process to
  recompile (a prior long-lived session won't pick them up). The discipline that remains: **never claim a test/gate passed unless you ran it
  and saw the result** — run it, read the output, report faithfully (failures included). A reusable script in `out/` (the gitignored output
  dir) is still preferred over a sprawling inline one-liner when the thing is worth rerunning or reviewing, but you no longer hand it off —
  you execute it.
