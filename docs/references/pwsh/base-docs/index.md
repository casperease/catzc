# Catzc.Base.Docs

The generated-README module. It owns the rule that a `README.md` in a conventional folder is a **generated copy** of one authored docs
source, never a hand-kept one (see [generated-readmes](../../../drs/repository/generated-readmes.md)): the source's relative links are
rebased to the README's folder, so every link works where the README is opened, and its head holds only the generated-file warning. What it deliberately does **not** own is the prose itself — that lives in the authored sources under `docs/` — nor the write
primitive, which is `Write-FileIfChanged` ([Catzc.Base.Files](../base-files/index.md)); the importer keeps every README current on every
load. The module also generates the repository's front page, `.github/README.md`, from `frontpage.yml` and the section articles it names
(`Build-FrontPage`, `Get-FrontPageSection`), and generates the glossary from the modules' glossary sources and answers "ask cats", the
offline browser over the ADRs, modules, and verbs. The ADR registry, and the index generated from it, are
[Catzc.Base.Drs](../base-drs/index.md).

## Responsibilities

| Responsibility   | Area       | Name                                                               |
| ---------------- | ---------- | ------------------------------------------------------------------ |
| responsibility:1 | copy       | [README materialisation](#responsibility1--readme-materialisation) |
| responsibility:2 | map        | [README map](#responsibility2--readme-map)                         |
| responsibility:3 | markers    | [Managed .gitkeep files](#responsibility3--managed-gitkeep-files)  |
| responsibility:4 | vocabulary | [Controlled vocabulary](#responsibility4--controlled-vocabulary)   |
| responsibility:5 | ask        | [Ask cats](#responsibility5--ask-cats)                             |
| responsibility:6 | agents     | [Sub-agent registry](#responsibility6--sub-agent-registry)         |
| responsibility:7 | markdown   | [Generated markdown](#responsibility7--generated-markdown)         |
| responsibility:8 | logs       | [Rolling logs](#responsibility8--rolling-logs)                     |

### responsibility:1 — README materialisation

Keeping each mapped folder's README a current copy of its authored source. This responsibility composes the README — the source's text with
every relative link rebased from the source's folder to the README's (`MarkdownLinkRebaser`), under a line naming the source — and writes it
through `Write-FileIfChanged` ([Catzc.Base.Files](../base-files/index.md)): a current README is a no-op, and a stale one is rewritten by
delete-then-write, so a README that is still a filesystem link is severed, never written through into its source. That idempotence is what
lets the importer regenerate every README on each load at no steady-state cost (see
[generated-readmes](../../../drs/repository/generated-readmes.md)). A quality gate
([ADR-AUTO-TEST-QUALITYGATE](../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)), `Test-GeneratedReadmes`, checks
the result: every generated README is gitignored, untracked, and current with its source.

### responsibility:2 — README map

Which folder is generated from which source. The map is `readme.yml`: a glob `patterns` list whose every matched folder derives its source
by convention (the folder's leaf name, kebab-cased — `pwsh/*` → `docs/references/pwsh/<kebab>.md`), plus explicit `mappings` for the folders
that follow no convention (an explicit mapping wins over a pattern). It is validated when it loads so a malformed or duplicated entry can
never produce a run, and its patterns are expanded against the filesystem to the concrete folder-to-source list before generation. The map
is the single place the folder-to-source pairing is stated; the generator reads it through [Catzc.Base.Config](../base-config/index.md) and
never hard-codes a path.

The map is also the **opt-in switch** for the generated README. Listing a folder here opts it in: its `README.md` becomes a derived copy of
the source the map names, gitignored and out of the markdown and spelling quality gates' scope (the source under `docs/` is what those
quality gates check). A folder _not_ listed opts out — it keeps a hand-authored, committed `README.md` that is un-ignored in `.gitignore`
and checked like any other doc. Two details keep the opt-in safe: a `patterns` glob supports only a trailing `/*` and matches just the
immediate, non-dot-prefixed subdirectories of its prefix (so `.vendor`, `.internal`, and other dot-folders can never be swept in), and a
matched folder whose derived source does not exist yet is skipped rather than generated — so a module with no reference article is fine; it
simply has no generated README until its source lands.

### responsibility:3 — Managed .gitkeep files

Reproducing every `.gitkeep` from the one generic authored source (`assets/gitkeep`). The folder is the registration — a filesystem walk
(skipping `.git`, the vendored modules, and the output root's contents) finds the set, so there is no list to maintain. The generic text
points the reader at the folder's `README.md`, and an integrity test makes that pointer binding: every `.gitkeep` folder must be a
readme-mapped target (responsibility:2), so dropping a `.gitkeep` anywhere demands its reference article. Unlike the gitignored READMEs, the
`.gitkeep` copies stay committed — tracking the folder is their purpose — so a source change lands as a reviewable, repo-wide diff.

### responsibility:4 — Controlled vocabulary

The glossary: every defined term, merged from the modules' `configs/glossary.yml` sources (see
[controlled-vocabulary](../../../drs/repository/controlled-vocabulary.md)). This responsibility returns the merged vocabulary, generates the
glossary page from it, and checks it — every term anchored on its one defining rule, and no avoided phrasing used within a source's scope.

### responsibility:5 — Ask cats

"Ask cats": an offline, deterministic browser over what the repository already knows — the ADR codes and rules, the modules and their public
functions, and the approved verbs in use. It prints only; it returns nothing.

### responsibility:6 — Sub-agent registry

Which sub-agents exist and why (see [agent-definitions](../../../drs/repository/agent-definitions.md)). The registry is `agents.yml`: one
entry per `.claude/agents/<name>.md` definition, with the rule citations that support the agent and the gate and check functions it runs or
guards, plus the one standard agent for delegated work. Beside it, `capabilities.yml` registers the capabilities the agents load, each with
its model floor. Both are validated when they load. A quality gate, `Test-AgentDefinitions`, keeps the agent and capability files, the
registries, and the `## Sub-agents` list in `.claude/CLAUDE.md` in step, resolving every citation to a real rule and every check to an
existing command.

### responsibility:7 — Generated markdown

Reading wrapped markdown back: a list item with the continuation lines the formatter wrapped it onto is read back whole by one command,
which every checker that reads list items calls. The writing side, a paragraph filled at the 140-column width the way the formatter fills it
(see [uniform-formatting](../../../drs/repository/uniform-formatting.md#rule-adr-repo-format-generatedformatted)), is
[Catzc.Base.MarkdownMeta](../base-markdown-meta/index.md).

### responsibility:8 — Rolling logs

The session logs a robot reads and appends to: the learnings log in `.claude/learnings/` and the hindsight log in `.claude/hindsight/`. Each
log is one config (`learnings.yml`, `hindsight.yml`) naming its folder, file prefix and title, with every omitted key taking the default
declared once on its config type, and one writer, `Add-SessionLearning`, appends a line to the log it names with `-Log`, wrapped as the
markdown formatter wraps it, so formatting never rewrites a log.

## What the module does

The module's core is the generated README: every conventional folder's README is a copy of one authored source, readable where it is opened.
The source of truth is the docs file; the README is a derived artifact, gitignored like the generated module manifests and out of the
markdown and spelling quality gates' scope (those check the source at its own location). Because the README sits in a different folder from
its source, its relative links are rebased to that folder, so following a link from the README lands where the same link lands from the
source.

Materialisation is designed to run unattended from the importer tail, so it is idempotent by construction: a current README is a no-op and a
stale one is rewritten through the shared `Write-FileIfChanged` primitive. The map and its record types (`DocsConfig`, `DocMapping`,
`DocPattern`) are validated at load, then the glob patterns are expanded against the filesystem to the concrete folder-to-source list, so a
bad entry fails fast rather than producing a broken README.

The glossary follows the same pattern: an authored source (the modules' glossary sources) and a generated page reproduced from it, which
`Test-GeneratedFiles` ([Catzc.Base.QualityGates](../base-quality-gates/index.md)) checks for drift.

## Division

The module's public surface, sorted into the responsibilities above.

| Responsibility                            | Function                |
| ----------------------------------------- | ----------------------- |
| responsibility:1 — README materialisation | `Build-Readme`          |
|                                           | `Test-GeneratedReadmes` |
|                                           | `Build-FrontPage`       |
|                                           | `Get-FrontPageSection`  |
| config                                    | `frontpage.yml`         |
| responsibility:2 — README map             | `readme.yml`            |
| responsibility:3 — Managed .gitkeep files | `Build-GitKeep`         |
| responsibility:4 — Controlled vocabulary  | `Get-Glossary`          |
|                                           | `Build-Glossary`        |
|                                           | `Test-Glossary`         |
| responsibility:5 — Ask cats               | `Show-Catzc`            |
| responsibility:6 — Sub-agent registry     | `Test-AgentDefinitions` |
| config                                    | `agents.yml`            |
|                                           | `capabilities.yml`      |
| responsibility:7 — Generated markdown     | `Get-MarkdownListItem`  |
| responsibility:8 — Rolling logs           | `Add-SessionLearning`   |
| config                                    | `learnings.yml`         |
|                                           | `hindsight.yml`         |
