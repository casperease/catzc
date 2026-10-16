---
plan:
  status: active
  value: medium-high
  reviewed: 2026-10-16
  targets: [automation/Catzc.Base.QualityGates/configs/file-meta.yml, automation/Catzc.Base.QualityGates, automation/Catzc.Base.Globs/configs/file-kinds.yml, automation/Catzc.Base.Variants/configs/module-types.yml, contracts/catzc/0.0.0, docs/adr/repository/file-meta.md]
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

## Done, and why: the file-kinds registry work (session catzc-c1 and follow-up, 2026-10-16)

Reconstructed from the continuation paste of 15:22 and the first lines of out/plan-file-kinds-registry.md, which was deleted today on
the approved list before this paste arrived. One kinds registry drives file heads, the contract and .gitattributes.

- ADR code minimal form: Catzc.Base.Docs.AdrCodeForm (ADR-X#{1,3-5}, bare ADR-X is the whole ADR, no globs); 4,753 items became 1,685.
- Head keys: path, folder, name, filetype, kind, subkind, language, track, module, moduletype, catzc_bundle, generator, body_sha;
  generator names the generator file on every generated head; relatives is page plus test only.
- File-kinds registry Catzc.Base.Globs/configs/file-kinds.yml (role-only kinds, subkinds, first match wins, fallback other, extendable by
  a consumer fragment); Get-FileKind; selectors in file-meta.yml name kinds.
- Module types Catzc.Base.Variants/configs/module-types.yml; Get-PathModule returns name and type.
- Provided contract draft contracts/catzc/0.0.0: the file-kinds fragment (incl. contract-asset, note, fixture subkind), head.sample.yml,
  head.schema.json, Format-FileMeta.Contract.Tests.ps1. Freezes at the first unit release.
- Glossary concepts kind, subkind, file type, module type, bundle; ADR-REPO-FILEMETA#11 and #12.
- Glob-list migration: comments.yml exclude keyed by kind; the other lists stay on purpose (they say where something applies).
- Generated .gitattributes classes and the glossary-scan fix: done and verified (paste).

## Done, and why: formatter crash rule and kinds tuning (catzc-c1 follow-up, 2026-10-16)

Reconstructed from the continuation paste of 15:22 and my earlier read of out/plan-file-kinds-and-formatting.md, deleted today on the
approved list. That file continued out/continuation-prompt-markerless.md (markerless comments, done and verified, also deleted today).

- Formatter crash: Invoke-Formatter throws "Operation is not valid due to the current state of the object" on a one-line hashtable
  literal holding an if/else, with or without a subexpression; one such file stopped Format-Code and Test-Formatting for the whole tree.
  Fixed in Get-FileExtensionFileMetaFact, Get-ModuleNameFileMetaFact and Get-FileTypeFileMetaFact by binding the value first.
- Rule against it: Measure-NoOneLineHashtableIfElse in automation/.scriptanalyzer, ADR-PWSH-FORMAT#10 with its "One-line hashtables"
  section in docs/adr/pwsh/powershell-formatting.md, a CatzcRules entry, the analyzer-adr-map mapping, a fixture line and rule id in
  CustomRuleWiring.Tests.ps1, and NoOneLineHashtableIfElse.Tests.ps1. 27 tests passed; Test-AnalyzerAdrMap, Test-FileMeta, Test-Links clean.
- Help text: Get-AdrUsage, Get-AdrUsageRow and Group-AdrUsage outputs say pscustomobject, matching their OutputType.
- Peer findings cleared: Test-Links on output-formats.yml; dora-explains.md "the test suite" is now "all tests"; Test-Glossary clean.
- File kinds tuned: drawio-kit precedes script (it was hidden by it); fixture/asset is fixture/input; skill removed; diagram is a new
  kind; asset-description narrowed to .md. FileKindReachability.Tests.ps1 requires every kind to claim a file. 94 kind tests passed.

## Open leftovers from that follow-up (left open)

- [ ] Test-Formatting not re-run since those edits; last run flagged only the compiled types .json under automation/.compiled. Check
  whether Format-Code should skip that folder and fix it only if the ADR says so.
- [ ] Test-Comments: 6 findings, all in other sessions' files: PropertyHead.cs.md section 1, MarkdownMetaBlock.cs.md sections 1 and 2,
  file-meta.yml.md section 5 (orphan sections, the code line under a moved comment changed), PathParts.cs:67 and ModulePlace.cs:68
  (a 2-line comment still in the file, Export-Comments). Owners decide; left alone unless asked.
- [ ] Untracked page Get-AutomationSourceFiles.ps1.md, restored from git history; staging it is the user's git call.
- [ ] Reachability test gap: it proves each kind claims a file, not that a kind is not mostly shadowed by an earlier one (how drawio-kit
  hid). Strengthening it needs the intended overlaps written down: the user's decision, before anything is written.
- [ ] The visibility head key: undecided, and redundant with the kinds. asset kept as a top-level kind (matches ADR-AUTO-ASSETDEP; that
  match was not re-read).
- Rule to keep from that session: peers edit the same tree, grep to confirm an edit still holds before building on it; no git writes.

## Done, and why: head path split, module-type ids, catzc_bundle (2026-10-16)

Reconstructed from the continuation paste of 15:22 and my earlier read of out/plan-head-path-split.md, deleted today on the approved
list. Request: module type ids lose the redundant -module suffix; the head key bundle takes the catzc bundler's own name; path is split
into asserted parts. Decisions: key catzc_bundle (kind id catzc-bundle; key names allow no hyphen); exporter bundles full, azure and
minimal unchanged; path stays; new keys folder, name, filetype (subkind keeps its file-kinds meaning); no legacy alias ("we need no l...",
ADR-PRIN-ONELIVE).

- Module type ids: pwsh-folder, pwsh-psm1, python, go, bash, bicep, pipeline, settings (module-types.yml, Get-PathModule tests,
  Format-GeneratedFileHead test, docs and comments).
- Variants: ModulePlace.TailOf, PathModule.tail, ModuleTypesConfig.Resolve passes the tail; test added.
- Languages: new PathParts type (folder, name, filetype; asserts the parts rebuild the path as kebab); Get-PathFileType delegates to it.
- QualityGates: Get-FileNameFileMetaFact (kind file-name) with test; Get-BundleFileMetaFact renamed Get-CatzcBundleFileMetaFact with
  test; file-meta.yml kind order; Test-FileMetaProcessors fixture and counts (17 kinds, 18 processors).
- Contracts: head.schema.json and head.sample.yml. ADR docs/adr/repository/file-meta.md rules 11 and 12.

## Open leftovers from the path split (all optional, left open)

- [ ] Spelling gate: run it; add catzc_bundle to the coined words only if it flags it.
- [ ] Test-FileMeta gate and the full Test-Automation: the user's runs.
- [ ] Decision: do generated-file heads also carry folder and name? Today they do not.
- [ ] Glossary: no entry for the renamed key.

## Open leftovers from the registry work (checks and questions, left open)

- [ ] Checks not run since its last edits: Test-Spelling, Test-FileMeta, Test-Glossary, Test-Contracts, Test-GeneratedFiles, one by one
  in the background with scripts under out/; report what is that work's. Not the full Test-Automation. Last known findings, none from
  that work: Spelling 5 (Unspan x3, nfunction x2 in CommentEngine files), ScriptAnalyzer about 37 (mostly .internal), markdownlint about
  39 (docs/explanation tables), Test-Formatting flagging .compiled/*.json.
- [ ] PowerShell versus Powershell: open question for the user, where does the mismatch show. The census found one literal Powershell,
  in the vendored dotnet-install.ps1:368; everything else is legitimate. Possibly powershell versus pwsh naming (language id, engine,
  folder), which is a decision, not a typo. Then make it one form.
- [ ] Typo: module-types.yml pwsh-folder definition reads "under ex. automation"; peer-edited file, left alone; message before touching.
- [ ] Memory file-head-vocabulary.md was updated for the rename to immutable; one derived mention remains, stale or deliberate unchecked.
- Not extended, by choice: glossary entries for individual kinds (only the concepts kind and subkind are terms); note becomes a term
  only if the user wants it. contracts/.gitkeep resolves to other and is left alone.

## Refs

- carried below in order: the immutable and edges draft, the class selectors draft (formerly out/)
- prompt-file-kinds-registry-continue.md (beside this file; its reading list names a deleted out/ plan, this file holds that state)
- prompt-file-kinds-and-formatting-continue.md (beside this file; same, and its pasted text is cut mid-sentence)
- prompt-head-path-split-continue.md (beside this file; same)
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
