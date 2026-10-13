# docs/references/automation/catzc-base-docs.md

`Catzc.Base.Docs`

The generated-README module. It owns the rule that a `README.md` in a conventional folder is a **filesystem link** to one authored docs
source, never a hand-kept copy (see [generated-readmes](../../adr/repository/generated-readmes.md)): the README IS the source, so an edit
through either path lands in the one authored file and there is no second copy to drift. What it deliberately does **not** own is the prose
itself — that lives in the authored sources under `docs/` — nor the link mechanism, which is `Set-FileLink`
([Catzc.Base.Files](catzc-base-files.md)); the importer keeps every link current on every load. The module also generates the other derived
documentation pages from their authored sources — the ADR index from `adrs.yml` and the glossary from the modules' glossary sources — and
answers "ask cats", the offline browser over the ADRs, modules, and verbs.

## Domains

| Domain   | Area       | Name                                                       |
| -------- | ---------- | ---------------------------------------------------------- |
| domain:1 | link       | [README materialisation](#domain1--readme-materialisation) |
| domain:2 | map        | [README map](#domain2--readme-map)                         |
| domain:3 | markers    | [Managed .gitkeep files](#domain3--managed-gitkeep-files)  |
| domain:4 | adr        | [ADR registry](#domain4--adr-registry)                     |
| domain:5 | vocabulary | [Controlled vocabulary](#domain5--controlled-vocabulary)   |
| domain:6 | ask        | [Ask cats](#domain6--ask-cats)                             |

### domain:1 — README materialisation

Ensuring each mapped folder's README is a link to its authored source. This domain resolves the mapping's paths and hands them to
`Set-FileLink` ([Catzc.Base.Files](catzc-base-files.md)): an effective link is a no-op, and anything else — the old plain-file copy, a wrong
or orphaned link — is recreated with the running OS's best mechanism. That idempotence is what lets the importer re-materialise every README
on each load at no steady-state cost (see [generated-readmes](../../adr/repository/generated-readmes.md)). A quality gate
([ADR-AUTO-TEST#35](../../adr/automation/test-automation.md#rule-adr-auto-test35)) checks the result: every generated README is gitignored,
untracked, and an effective link to its source.

### domain:2 — README map

Which folder is generated from which source. The map is `readme.yml`: a glob `patterns` list whose every matched folder derives its source
by convention (the folder's leaf name, kebab-cased — `automation/*` → `docs/references/automation/<kebab>.md`), plus explicit `mappings` for
the folders that follow no convention (an explicit mapping wins over a pattern). It is validated when it loads so a malformed or duplicated
entry can never produce a run, and its patterns are expanded against the filesystem to the concrete folder-to-source list before generation.
The map is the single place the folder-to-source pairing is stated; the generator reads it through [Catzc.Base.Config](catzc-base-config.md)
and never hard-codes a path.

The map is also the **opt-in switch** for the generated README. Listing a folder here opts it in: its `README.md` becomes a derived link to
the named source, gitignored and out of the markdown and spelling gates' scope (the source under `docs/` is what those gates check). A
folder _not_ listed opts out — it keeps a hand-authored, committed `README.md` that is un-ignored in `.gitignore` and checked like any other
doc. Two details keep the opt-in safe: a `patterns` glob supports only a trailing `/*` and matches just the immediate, non-dot-prefixed
subdirectories of its prefix (so `.vendor`, `.internal`, and other dot-folders can never be swept in), and a matched folder whose derived
source does not exist yet is skipped rather than generated — so a module with no reference article is fine; it simply has no generated
README until its source lands.

### domain:3 — Managed .gitkeep files

Reproducing every `.gitkeep` from the one generic authored source (`assets/gitkeep`). The folder is the registration — a filesystem walk
(skipping `.git`, the vendored modules, and the output root's contents) finds the set, so there is no list to maintain. The generic text
points the reader at the folder's `README.md`, and an integrity test makes that pointer binding: every `.gitkeep` folder must be a
readme-mapped target (domain:2), so dropping a `.gitkeep` anywhere demands its reference article. Unlike the gitignored READMEs, the
`.gitkeep` copies stay committed — tracking the folder is their purpose — so a source change lands as a reviewable, repo-wide diff.

### domain:4 — ADR registry

The ADR domain structure as data: `adrs.yml` declares each domain, its role and dependencies, and each ADR's citation code. This domain
generates the committed ADR index from it on every import, reads the declared rule-sets, the flat set of rule ids, and the citation map
every rule reference resolves through, and renders the domain dependency graph as typed edges or a diagram. A quality gate keeps the
registry and the ADR files in step: one rule file per declared rule-set, headed by its citation code, and no rule file left unregistered.

### domain:5 — Controlled vocabulary

The glossary: every defined term, merged from the modules' `configs/glossary.yml` sources (see
[controlled-vocabulary](../../adr/repository/controlled-vocabulary.md)). This domain returns the merged vocabulary, generates the glossary
page from it, and gates it — every term anchored on its one defining rule, and no avoided phrasing used within a source's scope.

### domain:6 — Ask cats

"Ask cats": an offline, deterministic browser over what the repository already knows — the ADR codes and rules, the modules and their public
functions, and the approved verbs in use. It prints only; it returns nothing.

## What the module does

The module's core is the generated README: it makes every conventional folder's README the one authored source, by link. The source of truth
is the docs file; the README is a derived artifact, gitignored like the generated module manifests and out of the markdown and spelling
gates' scope (those check the source at its own location — which is also where the article's relative links are guaranteed to resolve; the
README is a pointer into that reading surface, not a second rendering).

Materialisation is designed to run unattended from the importer tail, so it is idempotent by construction: an effective link is a no-op and
a stale artifact is recreated, per OS, by the shared `Set-FileLink` primitive. The map and its record types (`DocsConfig`, `DocMapping`,
`DocPattern`) are validated at load, then the glob patterns are expanded against the filesystem to the concrete folder-to-source list, so a
bad entry fails fast rather than producing a broken README.

The ADR index and the glossary follow the same pattern: an authored source (`adrs.yml`, the glossary sources) and a generated page
reproduced from it, which `Test-GeneratedFiles` ([Catzc.Base.QualityGates](catzc-base-qualitygates.md)) checks for drift.

## Division

The module's public surface, sorted into the domains above.

| Domain                            | Function                     |
| --------------------------------- | ---------------------------- |
| domain:1 — README materialisation | `Build-Readme`               |
|                                   | `Test-ReadmeLinks`           |
| domain:2 — README map             | `readme.yml`                 |
| domain:3 — Managed .gitkeep files | `Build-GitKeep`              |
| domain:4 — ADR registry           | `Build-AdrIndex`             |
|                                   | `Get-AdrRuleSet`             |
|                                   | `Get-CatsAdrRuleIds`         |
|                                   | `Get-AdrCitationMap`         |
|                                   | `Get-AdrDomainEdges`         |
|                                   | `ConvertTo-AdrDomainDiagram` |
|                                   | `Test-AdrRegistry`           |
| config                            | `adrs.yml`                   |
| domain:5 — Controlled vocabulary  | `Get-Glossary`               |
|                                   | `Build-Glossary`             |
|                                   | `Test-Glossary`              |
| domain:6 — Ask cats               | `Show-Cats`                  |
