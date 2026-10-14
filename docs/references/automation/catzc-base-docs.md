# docs/references/automation/catzc-base-docs.md

`Catzc.Base.Docs`

The generated-README module. It owns the rule that a `README.md` in a conventional folder is a **generated copy** of one authored docs
source, never a hand-kept one (see [generated-readmes](../../adr/repository/generated-readmes.md)): the source's relative links are rebased
to the README's folder, so every link works where the README is opened, and a line under the title names the source as the one place to
edit. What it deliberately does **not** own is the prose itself — that lives in the authored sources under `docs/` — nor the write
primitive, which is `Write-FileIfChanged` ([Catzc.Base.Files](catzc-base-files.md)); the importer keeps every README current on every load.
The module also generates the other derived documentation pages from their authored sources — the ADR index from `adrs.yml` and the glossary
from the modules' glossary sources — and answers "ask cats", the offline browser over the ADRs, modules, and verbs.

## Responsibilities

| Responsibility   | Area       | Name                                                               |
| ---------------- | ---------- | ------------------------------------------------------------------ |
| responsibility:1 | copy       | [README materialisation](#responsibility1--readme-materialisation) |
| responsibility:2 | map        | [README map](#responsibility2--readme-map)                         |
| responsibility:3 | markers    | [Managed .gitkeep files](#responsibility3--managed-gitkeep-files)  |
| responsibility:4 | adr        | [ADR registry](#responsibility4--adr-registry)                     |
| responsibility:5 | vocabulary | [Controlled vocabulary](#responsibility5--controlled-vocabulary)   |
| responsibility:6 | ask        | [Ask cats](#responsibility6--ask-cats)                             |
| responsibility:7 | agents     | [Sub-agent registry](#responsibility7--sub-agent-registry)         |
| responsibility:8 | markdown   | [Generated markdown](#responsibility8--generated-markdown)         |

### responsibility:1 — README materialisation

Keeping each mapped folder's README a current copy of its authored source. This responsibility composes the README — the source's text with
every relative link rebased from the source's folder to the README's (`MarkdownLinkRebaser`), under a line naming the source — and writes it
through `Write-FileIfChanged` ([Catzc.Base.Files](catzc-base-files.md)): a current README is a no-op, and a stale one is rewritten by
delete-then-write, so a README that is still a filesystem link is severed, never written through into its source. That idempotence is what
lets the importer regenerate every README on each load at no steady-state cost (see
[generated-readmes](../../adr/repository/generated-readmes.md)). A quality gate
([ADR-AUTO-TEST#35](../../adr/automation/test-automation.md#rule-adr-auto-test35)), `Test-GeneratedReadmes`, checks the result: every
generated README is gitignored, untracked, and current with its source.

### responsibility:2 — README map

Which folder is generated from which source. The map is `readme.yml`: a glob `patterns` list whose every matched folder derives its source
by convention (the folder's leaf name, kebab-cased — `automation/*` → `docs/references/automation/<kebab>.md`), plus explicit `mappings` for
the folders that follow no convention (an explicit mapping wins over a pattern). It is validated when it loads so a malformed or duplicated
entry can never produce a run, and its patterns are expanded against the filesystem to the concrete folder-to-source list before generation.
The map is the single place the folder-to-source pairing is stated; the generator reads it through [Catzc.Base.Config](catzc-base-config.md)
and never hard-codes a path.

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

### responsibility:4 — ADR registry

The ADR domain structure as data: `adrs.yml` declares each domain, its role and dependencies, and each ADR's citation code. This
responsibility generates the committed ADR index from it on every import, reads the declared rule-sets, the flat set of rule ids, and the
citation map every rule reference resolves through, and renders the domain dependency graph as typed edges or a diagram. A quality gate
keeps the registry and the ADR files in step: one rule file per declared rule-set, headed by its citation code, and no rule file left
unregistered.

### responsibility:5 — Controlled vocabulary

The glossary: every defined term, merged from the modules' `configs/glossary.yml` sources (see
[controlled-vocabulary](../../adr/repository/controlled-vocabulary.md)). This responsibility returns the merged vocabulary, generates the
glossary page from it, and checks it — every term anchored on its one defining rule, and no avoided phrasing used within a source's scope.

### responsibility:6 — Ask cats

"Ask cats": an offline, deterministic browser over what the repository already knows — the ADR codes and rules, the modules and their public
functions, and the approved verbs in use. It prints only; it returns nothing.

### responsibility:7 — Sub-agent registry

Which sub-agents exist and why (see [agent-definitions](../../adr/repository/agent-definitions.md)). The registry is `agents.yml`: one entry
per `.claude/agents/<name>.md` definition, with the rule citations that support the agent and the gate and check functions it runs or
guards, plus the one standard agent for delegated work. It is validated when it loads. A quality gate, `Test-AgentDefinitions`, keeps the
agent files, the registry, and the `## Sub-agents` list in `.claude/CLAUDE.md` in step, resolving every citation to a real rule and every
check to an existing command.

### responsibility:8 — Generated markdown

The one way generated markdown wraps its prose: a paragraph or list item filled at the 140-column width the way the formatter fills it, so a
page a generator writes is the page the formatter leaves alone (see
[uniform-formatting](../../adr/repository/uniform-formatting.md#rule-adr-repo-format5)). Every generator that writes markdown wraps through
it, in this module or another.

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

The ADR index and the glossary follow the same pattern: an authored source (`adrs.yml`, the glossary sources) and a generated page
reproduced from it, which `Test-GeneratedFiles` ([Catzc.Base.QualityGates](catzc-base-qualitygates.md)) checks for drift.

## Division

The module's public surface, sorted into the responsibilities above.

| Responsibility                            | Function                     |
| ----------------------------------------- | ---------------------------- |
| responsibility:1 — README materialisation | `Build-Readme`               |
|                                           | `Test-GeneratedReadmes`      |
| responsibility:2 — README map             | `readme.yml`                 |
| responsibility:3 — Managed .gitkeep files | `Build-GitKeep`              |
| responsibility:4 — ADR registry           | `Build-AdrIndex`             |
|                                           | `Get-AdrRuleSet`             |
|                                           | `Get-CatsAdrRuleIds`         |
|                                           | `Get-AdrCitationMap`         |
|                                           | `Get-AdrDomainEdges`         |
|                                           | `ConvertTo-AdrDomainDiagram` |
|                                           | `Test-AdrRegistry`           |
| config                                    | `adrs.yml`                   |
| responsibility:5 — Controlled vocabulary  | `Get-Glossary`               |
|                                           | `Build-Glossary`             |
|                                           | `Test-Glossary`              |
| responsibility:6 — Ask cats               | `Show-Cats`                  |
| responsibility:7 — Sub-agent registry     | `Test-AgentDefinitions`      |
| config                                    | `agents.yml`                 |
| responsibility:8 — Generated markdown     | `Format-MarkdownParagraph`   |
