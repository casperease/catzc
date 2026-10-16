---
plan:
  status: active
  value: medium-high
  reviewed: 2026-10-16
  targets: [automation/Catzc.Base.QualityGates/configs/file-meta.yml, automation/Catzc.Base.QualityGates, contracts/catzc/0.0.0, docs/adr/repository/file-meta.md]
---

# The file head: immutable place facts plus declared edges, with globs spelled once as classes

Two drafts. The first splits derived into immutable (place facts read from registries) and edges (defines, cites, links, page, test,
fixed by the file's text). Its ADR text is edited; everything else is open. The second makes file-kind's ordered classes the only
place a glob lives, and every other kind selects by class. It waited on the relatives work, which has landed, so it is free.

## Why its value is medium-high

The head is the carrier every other plan writes into, and it is half moved. The same glob set is spelled in up to seven kinds today
and each copy can drift. Below the module model plan because that plan decides what some head keys mean before this one writes them.

## Needed docs

- ADR-REPO-FILEMETA rule 13 (edited): immutable is relative to the file at its place and body. Schema says with_body_sha is Markdown only.
- ADR-REPO-CODEMETA#2 note: code heads keep cites add-only; only its path changes.
- head.schema.json and head.sample.yml in the provided contract; the ADR's own heads re-imprinted (formatter-owned).
- Glossary: class (if it becomes a term), immutable, edge.

## Needed tests

- Format-FileMeta.Contract.Tests against the new shape; one re-imprint run leaves Test-FileMeta clean.
- Selector tests: first class wins; a kind selecting by class gets exactly the class's files; adding a class edits one list.
- Test-FileMetaProcessors counts after the move.

## Open steps

- [ ] Steps 2 to 8 of the immutable and edges draft (check: Test-FileMeta clean on the tree; contract tests pass).
- [ ] Class selectors in file-meta.yml, one kind at a time (check: that kind's processor test; Test-FileMeta clean).
- [ ] Update the memory note file-head-vocabulary (still says derived).

## Refs

- carried below in order: the immutable and edges draft, the class selectors draft (formerly out/)
- docs/adr/repository/file-meta.md

## Carried: out/plan-file-meta-immutable-edges.md (verbatim, absorbed 2026-10-16; headings below are the draft's own)

# Plan: `derived` becomes `immutable` + `edges`

Status: ADR text edited (step 1); everything else open. Decided with the user 2026-10-16.

## The model

A file is a node. Its meta block (`catzc:`) has three parts:

- **`immutable`** — place facts: what the repository's own configuration makes of the file's location (path and its parts, kind, language,
  track, module, …). Read from registries, never from the text. Opens, in Markdown, with `with_body_sha`.
- **`edges`** — outgoing, named relations the file itself declares: `defines`, `cites`, `links`, `page`, `test`. Fixed by the file's text,
  written on the source only, named for the relation (not the target type).
- **`config`** — authored, unchanged.

```yaml
catzc:
  immutable:
    with_body_sha: 70aac12bc0d5
    path: docs/adr/repository/file-meta.md
    folder: docs/adr/repository
    name: file-meta
    filetype: md
    kind: adr
    language: markdown
    track: docs
  edges:
    defines: [ADR-REPO-FILEMETA#{1-13}]
    cites: [ADR-AUTO-DEFAULT#6, …]
    links: [docs/adr/design/module-types.md, …]
```

## Rename map (old -> new)

| Old                                                                                                                                | New                                    |
| ---------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------- |
| `derived:`                                                                                                                         | split into `immutable:` and `edges:`   |
| `derived.body_sha` (value quoted)                                                                                                  | `immutable.with_body_sha` (first key)  |
| `derived.path/folder/name/filetype/kind/subkind/language/track/module/moduletype/catzc_bundle/tracktype/vendor/visibility/generator/source` | `immutable.<same key>`                 |
| `derived.defines`                                                                                                                  | `edges.defines`                        |
| `derived.adrs`                                                                                                                     | `edges.cites`                          |
| `derived.links`                                                                                                                    | `edges.links`                          |
| `derived.relatives.page` / `.test`                                                                                                 | `edges.page` / `edges.test` (flat)     |
| meta kind `relatives` (registry)                                                                                                   | `relative-edges`                       |
| meta kinds `adr-defines`, `adr-codes`, `links`                                                                                     | keep ids; add `section: edges`         |
| C# `MarkdownMetaBlock.DerivedKey`, `DerivedKeys`, `DerivedList`; `CodeMetaHead.DerivedKeys/DerivedList`; `PropertyHead.DerivedKeys` | `ImmutableKeys`, `EdgeKeys`, `EdgeList` (per part) |
| state props `DerivedKeys`, `DerivedLists` in `Get-MarkdownMetaState`, `Get-CodeMetaState`, `Get-PropertyMetaState`                 | `ImmutableKeys`, `EdgeKeys`, `EdgeLists` |

Section order in the file: `immutable`, `edges`, `config`. Key order inside each part is the registry order. An empty edge is left out; an
empty `edges` part is left out.

Which kinds write where (`file-meta.yml`, new `section:` setting, default `immutable`):

- `immutable`: file-path, file-name, file-type, file-kind, file-language, track, module-name, module-type, catzc-bundle, generator,
  body-sha (key renamed `with_body_sha`, ordered first), visibility, plus `tracktype`/`vendor`/`source` where present.
- `edges`: adr-defines, adr-codes (`cites`), links, relative-edges (`page`, `test`).

## Steps (one file at a time, each verified before the next)

1. **ADRs** (done: `file-meta.md` rules 1, 3, 5, 9, 10, new rule 13, Decision, examples; `code-file-meta.md` rules 2, 3, examples).
   Still to do: `markdown-config-contributions.md` (the `derived` mentions, 2), `controlled-vocabulary.md` / glossary sources
   (`Catzc.Base.Docs/configs/glossary.yml`: add terms `place facts` and `edge`; reword `meta head` / `meta kind` / `imprint step` entries
   that say "derived fact"), `uniform-formatting.md` (`derived` mentions, 6), `comments-in-docs.md` if it names the part. Glossary,
   `adrs.yml` and `terminology.yml` are dirty from another session: ask before editing them.
2. **Pure types** (`Catzc.Base.MarkdownMeta`, `Catzc.Base.CodeMeta`): `MarkdownMetaBlock` renders and parses three sections;
   `KeysAt(block, 4, …)` becomes per-section; `CodeMetaHead`, `PropertyHead` follow. Update the type tests
   (`MarkdownMetaBlock.Tests.ps1`, `CodeMetaHead.Tests.ps1`, `PropertyHead.Tests.ps1`) and `Get-*MetaState` tests. Fresh `pwsh` per C# edit.
3. **Registry** `Catzc.Base.QualityGates/configs/file-meta.yml` and its C# entry type: `section:` default declared once on the type;
   `body-sha` key rename; `relatives` kind becomes `relative-edges` writing flat edges. Update `Test-FileMetaProcessors.Tests.ps1`
   and the processor function names (`Get-<Kind>FileMetaFact` for the renamed kind).
4. **Engine** (`Format-FileMeta`, `Test-FileMeta`, `Format-PropertyMetaHead`, `Format-CodeMetaHead`): write/compare the three parts;
   a hand-written key under `immutable` or `edges` is a finding (rule 5).
5. **Generated-file head** (`Invoke-RootConfigGenerator.ps1`, `rootconfig.yml`, the one head function): `derived` -> `immutable`
   (`generator`, `source` are place facts). Regenerate, no hand edit.
6. **Contract** (the user's point, 2026-10-16: contracts are the type of the ADR documents, since an ADR defines a root concern as a
   contract, so the contract can be generated from it). `contracts/catzc/0.0.0/Catzc.Base.QualityGates/head.schema.json` and
   `head.sample.yml` pin the `derived` shape by hand today, a second statement of what `file-meta.yml` and ADR-REPO-FILEMETA already say.
   Make the draft (`0.0.0`, the only mutable folder, ADR-REPO-CONTRACT#5) a generated file: its writer composes the schema from the
   registry (parts `immutable`/`edges`/`config`, each kind's keys by `section:`, array vs scalar by kind, `visibility` enum), writes the
   `$comment` through the one head function with `generator` and `source` (the registry, ADR-REPO-FILEMETA#7), and the sample is composed
   from the same data, so the schema, the sample and the registry cannot drift. Change the contract and every caller in the same change; no
   second version (ADR-PRIN-ONELIVE); released `0.0.0` is not yet pinned, so no sanctioned back-compat folder is needed (ADR-REPO-CONTRACT#3).
   Check `docs/references/contracts.md` (generated by `Build-ContractReference`). Questions: does the ADR itself name the contract
   (a `contract:` edge from `file-meta.md` to the schema, via the `links` edge), and does the generated-head rule apply to a
   contract asset the tests compare byte for byte (ADR-REPO-FILEMETA#5 exempts `catzc-contract`)? Decide before building the writer.
7. **Agents and drawio kit** that read heads by text (`.claude/agents/*.md` heads, `.claude/drawio/STYLE.md`): they carry the block and are
   re-imprinted in step 8; check no tool there greps `derived:`.
8. **Re-imprint** every in-scope file (about 1,750) with the tool, not a script sweep: `Format-FileMeta` for Markdown, `Format-Code` for
   code heads, in the background with `timeout`. Then `Test-FileMeta`, `Test-Formatting`, `Test-FileMetaProcessors` clean.
9. **Sweep for leftovers**: grep for `derived:`, `body_sha`, `DerivedKey`, `relatives`, `.adrs` readers in `automation/`, `docs/`,
   `.claude/`. Every hit is a caller to change in this same change (no shim, no fallback reader).

## Progress (2026-10-16)

Done and verified (`out/run-meta-tests.ps1`): the three pure types, `Get-*MetaState` / `Format-*` wrappers and their tests —
`Catzc.Base.MarkdownMeta` and `Catzc.Base.CodeMeta` test folders, 108 passed, 0 failed.

Done, tests being verified: registry `section:` on `FileMetaKind` / `KeysOf` on `FileMetaConfig`, `file-meta.yml` (kinds `body-sha` first,
`relative-edges`, `section: edges` on adr-defines / adr-codes (`cites`) / links), `Get-FileMetaFact` (returns `@{ Immutable; Edges }`),
`Invoke-FileMetaEngine`, `Format-GeneratedFileHead`, `Get-AdrCodesFileMetaFact`, `Get-AdrUsageRow`, `Get-RelativeEdgesFileMetaFact`
(renamed from Relatives; file and test moved with plain `mv`, so the git index is stale for them).

Not done: contract (step 6), re-imprint (step 8), glossary / other ADR mentions, sweep (step 9), `MarkdownDocument` / `Remove-MarkdownFrontMatter`
test fixtures that still spell `derived:` (opaque text, harmless).

Re-imprint trap: every file on disk still has `derived:`. The engine reports it as an unowned section and leaves the file alone, so the
re-imprint needs the engine to treat `derived` as droppable for that one run (then delete that allowance in the same change).

## Open points

- `with_body_sha` is Markdown only (ADR-REPO-CODEMETA#2). Say so in the schema.
- Code heads' `cites` stays add-only (`held_classes`); only its path changes.
- The ADR's own heads (`file-meta.md`, `code-file-meta.md`) still show `derived:` until step 8 re-imprints them; the formatter owns them.
- Name check: `immutable` for a part whose values move when a file moves is relative (fixed *for the file at its place and body*); rule 13
  says this in the text.

## Carried: out/plan-meta-class-selectors.md (verbatim, absorbed 2026-10-16; headings below are the draft's own)

# Plan: one glob model for all front matter — globs once, classes everywhere else

2026-10-15. Status: **for review**. `file-meta.yml` is catzc-64's active area (the `relatives` work), so nothing is edited until that
session agrees or hands over.

## The problem, measured in `file-meta.yml` today

Globs are the only selector, so the same file sets are spelled again in every kind:

| Glob set                                                         | Spelled in                                                                                  |
| ---------------------------------------------------------------- | ------------------------------------------------------------------------------------------- |
| `automation/**/types/*.cs`                                       | `file-kind` (csharp-type), `module-name`, `relatives` (twice), `adr-codes` `files`, `domain_files`, `held_files` |
| `automation/Catzc.*/*.ps1` + `automation/Catzc.*/private/*.ps1`  | `file-kind` (automation-function), `module-name`, `visibility`, `relatives`, `adr-codes` `files`, `domain_files`, `held_files` |
| `**/*.md`                                                        | `body-sha`, `adr-codes`, `links`                                                            |
| `docs/adr/**`                                                    | `file-kind` (adr), `adr-defines` (`docs/adr/**/*.md`)                                       |

Each copy can drift from the others. Adding a function class, such as a new `*-function` role, means editing up to seven lists.

## The model

1. **Globs live in one place: `file-kind`'s ordered `classes`.** The first class whose glob matches a file is the file's class. The
   order is the precedence, and `other` is the default class. This is how it works today.
2. **Every other kind and setting selects by class, never by glob.** It uses `classes:`, and a class pattern may use one `*`
   (`*-function`, `*-test`, `csharp-type`). Class names are short and stable, so the pattern stays simple.
3. **Sensible defaults, declared once on `FileMetaKind`** (`ADR-AUTO-DEFAULT#6`):
   - With no `classes:`, a kind applies to every file the carriers give a head (`**`, today's `DefaultFiles`).
   - A setting that names files (today `domain_files`, `held_files`, a relative's `files`) becomes `*_classes`, and its default is the
     kind's own `classes`.
   - A kind about Markdown names the language, not a glob: `languages: [markdown]` reads `file-carriers.yml`, so `**/*.md` is not spelled
     again either.

## Before and after

```yaml
# before
module-name:
  keys: [module]
  files: ["automation/**/types/*.cs", "automation/Catzc.*/*.ps1", "automation/Catzc.*/private/*.ps1"]
adr-codes:
  keys: [adrs]
  files: ["**/*.md", "automation/**/types/*.cs", "automation/Catzc.*/*.ps1", "automation/Catzc.*/private/*.ps1"]
  settings:
    domain_files: ["automation/**/types/*.cs", "automation/Catzc.*/*.ps1", "automation/Catzc.*/private/*.ps1"]
    held_files: ["automation/**/types/*.cs", "automation/Catzc.*/*.ps1", "automation/Catzc.*/private/*.ps1"]

# after
module-name:
  keys: [module]
  classes: [csharp-type, "*-function"]
adr-codes:
  keys: [adrs]
  classes: [csharp-type, "*-function"]
  languages: [markdown]
  # domain_classes and held_classes default to the kind's classes, so neither is written
```

`relatives` keeps its `paths` templates and selects by class: `{ classes: [csharp-type], paths: ["automation/{module}/tests/types/{stem}.Tests.ps1"] }`.

## Where else the model applies

The same rule, "globs once, names everywhere else", fits the other registries that select files. Each is its own change:

- `comments.yml` `pages` (source globs to comment pages);
- `file-carriers.yml` class entries;
- `output-formats.yml` (it keeps its patterns, because output files have no class, but it could name an area's default folder once).

The first change stays inside `file-meta.yml`.

## Changes

1. `FileMetaKind` (type): add `classes` and `languages`, declared with their defaults. A kind has `files`, or `classes`/`languages`,
   never both. `files` goes away when no kind uses it (`ADR-PRIN-ONELIVE`).
2. `Invoke-FileMetaEngine` / `Get-FileMetaFact`: compute the file's class once per file, which `file-kind` already does, and select kinds
   by it.
3. `Get-AdrCodesFileMetaFact`: read `domain_classes` / `held_classes` against the file's class.
4. The `relatives` processor: a rule selects by `classes`.
5. `file-meta.yml`: rewrite each kind to the new selectors. The glob count drops from about 30 to the class list alone.
6. `ADR-REPO-FILEMETA#2` / `ADR-REPO-CODEMETA#3`: state that a kind selects by class, and `file-kind` is the one glob list.
7. Tests (L0, widget/gadget): class patterns with `*`, the defaults, and that `files` together with `classes` is rejected.
8. Proof: a whole-repo `Format-FileMeta -DryRun` before and after shows **zero** head changes, so the new selectors pick exactly the old
   sets.

## Decision for the user

- Who builds it: this session, after catzc-64 hands `file-meta.yml` over, or catzc-64 as part of its `relatives` work.
