---
plan:
  status: active
  reviewed: 2026-10-21
  rule: value first, then needed docs and tests; job size never ranks
---

# Value of each plan

Every live plan, ordered by value. Job size is not a factor. The two things that order a plan are the value it delivers and how much
doctrine (ADRs, glossary, CLAUDE.md) and proof (gates, Pester tests) it needs before it counts as landed.

## Naming and sorting

A file name is a stable semantic locator: `plan-<topic>.md`, never a rank or order prefix. This table is the sorting overlay; each head's
`value` key carries the same signal. The delivered default sort of the folder is the semantic name order. Meta plans live here; feature
plans stay as drafts in `out/`. Done plans are deleted, and done steps are pruned from the plans that stay: git holds the history.

## Intake rule for continuation prompts

Every item, idea or signal in a pasted continuation prompt lands in exactly one meta plan here. An item no plan covers gets a new plan at
the value it earns. What is reported done is checked against the tree, ticked, and then pruned. Nothing open in a paste is discarded; a
stale or superseded item is recorded as such, with the reason.

## Meta plans by value (how the repository describes and governs itself)

| Value   | Plan                         | Why                                                                                                                       | Needed docs                                         | Needed tests                                                                        | State                                                 |
| ------- | ---------------------------- | ------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------- | ----------------------------------------------------------------------------------- | ----------------------------------------------------- |
| highest | plan-master                  | The one executable order over every open step of every plan; task files are its disposable executables.                   | ADR-REPO-PLANS names the task files (the plans ADR) | Test-Plans over the folder (the plans ADR)                                          | nineteen chunks; the user's and the sweep last        |
| high    | plan-listen-internal-readers | The editor's note 0001: the glossary, track registry, how-to and CLAUDE.md say nothing internal reads the unordered part. | TDR-NORMALFORM, DDR-TRACK-UNORDEREDTRACK            | Test-Glossary, the Variants track-type tests, Test-Links                            | one step left, the user's CLAUDE.md edit              |
| medium  | plan-claude-diet             | Every session stops reading about 3500 bytes that agents.yml, each description and the DRS index already hold.            | none (the agents registry holds the text)           | Test-AgentDefinitions, Test-Links on CLAUDE.md                                      | the user's CLAUDE.md edit, then four capability lines |
| medium  | plan-language-lamps          | A languages button picks language lamps into the title row, each a full lamp, from the languages config.                  | DDR-FILTER-TOTALUNION names language lamps          | node tests of the engine, catzc-track-lamps.Tests.ps1, New-VSCodeSettings.Tests.ps1 | planned                                               |
| medium  | plan-vscode-extensions       | The recommendations shrink to vendor languages and known linters; cats tooling replaces the rest, icons included.         | none                                                | the VSCode module's tests, Test-Plans                                               | icons, offline schemas done; small extensions open    |

## Feature plans (a capability of cats), here with class: feature in the head

| Value  | Plan                          | Needed docs                                                                                                      | Needed tests                                                                                               | State                                            |
| ------ | ----------------------------- | ---------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- | ------------------------------------------------ |
| high   | plan-repo-filters             | none (filters are a tool view; DDR-ASPECT already holds the units it gates)                                      | Pester for FiltersConfig, Get-RepositoryFilter, Get-ModuleGlobSet, Get-AspectCover, the lamps              | landed; the user's look, one step left           |
| high   | plan-reference-normal-form    | comments-in-docs.md and the head policy (the derived page path, no docs links)                                      | Pester for Get-CommentPage both ways; the page-mapping gate; Test-Comments, Test-FileMeta                  | open; five steps, after module-namespace         |
| high   | plan-module-types-contracts   | api-contracts.md and caching.md (a types contract per module group)                                              | Write-TypesContract, Get-TypesContractDrift, Test-Contracts                                                | open; one step                                   |
| high   | plan-track-model              | DDR-TRACK (members, root files), DDR-TRACKTYPE (output type, vendors), FDR-CD-GLOBS (globsets from tracks)       | Pester for VariantTrack, Get-Track, Test-TrackDeclaration, Get-GeneratedTarget, Get-GlobSetTrigger         | decided; eighteen steps, naming examples awaited |
| medium | plan-session-learnings        | the session-finalize skill (the learning definition)                                                             | Pester for Add-SessionLearning and LearningsConfig                                                         | decided; one step                                |
| high   | plan-agent-shortcuts          | the plans ADR names New-Plan                                                                                     | Pester for the gate runner and New-Plan, Test-AgentDefinitions                                             | one step left, the user's CLAUDE.md line         |
| high   | plan-idiomatic-names          | ADR-AUTO-IDIOM (written), the command-contracts and api-contracts rules (written)                                | Test-IdiomaticNames, Pester for the naming types, Test-Contracts                                           | folders renamed; wiring and the normal form open |
| high   | plan-agent-friction           | ADR-REPO-PLANS gains the three-part plan rule; a how-to for a head fact                                          | Pester for Test-Plans and Test-Formatting, the hook test, Test-ParameterConsistency                        | the head how-to and drawing, the user's trim     |
| medium | plan-bcl-language             | the BCL reference-set rule in ADR-AUTO-TYPES, the narrowed ADR-PWSH-TYPES rules, the bcl domain                  | Test-Links on the moved pages, Pester for the host-binding gate and config, Test-DrsRegistry               | one step left, the user's CLAUDE.md line         |
| high   | plan-drs-system               | the DRS rule in ADR-REPO-DRSCODE, glossary entries for DRS, decision record and record kind                      | Catzc.Base.Docs Pester, Update-DrsCitation dry run, Test-DrsRegistry, Test-Links, Test-GeneratedFiles      | one step left, the user's CLAUDE.md edit         |
| high   | plan-debt-agent-traffic       | the catzc-run, report-fixed, catzc-drone and plans-orchestrate lines; the entry script page                      | the entry script test, Test-Plans tests, the hook test, Test-AgentDefinitions                              | three steps                                      |
| high   | plan-debt-full-run-failures   | none (test reruns)                                                                                               | one Invoke-TestFile per failing file                                                                       | one step                                         |
| medium | plan-debt-format-cache        | none (Base.QualityGates code and tests)                                                                          | Format-Code.Tests, red then green per step                                                                 | two steps                                        |
| medium | plan-debt-test-speed          | none (test files only)                                                                                           | the measured test files, twice each                                                                        | two steps                                        |
| high   | plan-debt-tier-tripwire       | none (ADR-AUTO-TEST-PROCESSTRIPWIRE decides)                                                                     | each failing file at -MaxLevel 1, the tripwire's test, both tiers alone                                    | new                                              |
| high   | plan-types-contract           | ADR-AUTO-CACHE-COMPILEDTYPEPREBUILD rewritten (nothing tracked in .compiled; the types surface a 0.1.0 contract) | Write-TypesContract, Import-CSharpTypes, stamp check L0 tests; a fresh full import                         | new                                              |
| high   | plan-types-build-local        | ADR-AUTO-CACHE-COMPILEDTYPEPREBUILD rewritten (the manifest committed, the DLL per machine)                      | Import-TypesAssembly, Build-CombinedTypeAssembly, Invoke-ModuleBuild, policy L0 tests; a fresh full import | new                                              |
| medium | plan-diagram-review           | the visual-design rules each answer changes                                                                      | Test-Diagrams after every answer, the kit suite                                                            | new                                              |
| medium | plan-vscode-session-binding   |                                                                                                                  |                                                                                                            | new                                              |
| high   | plan-comment-insights         | ADR-REPO-COMMENTS text: the one-line insight a long comment leaves                                               | Test-Comments and each module's tests                                                                      | new                                              |
| high   | plan-comment-articles         | ADR-REPO-COMMENTS-PAGEISAUTHORED text: sections folded into the page article                                     | Test-Comments, Test-Links, Test-Spelling, Test-Markdownlint per module                                     | new                                              |
| high   | plan-slim-agents              | ADR-REPO-AGENTS rewrite                                                                                          | Test-AgentDefinitions                                                                                      | new                                              |

## Pending deletion

A done plan, task file or landed prompt is deleted from disk directly (the user, 2026-10-19: "just delete done plans"); the user commits the
deletion. A plan holds only planned work that is not yet implemented (the user, 2026-10-20): no Done section, no proof of built work, no
explanation of how the tool behaves when a team uses it; that belongs in the docs.

Deleted 2026-10-21, every step landed (ADR-REPO-PLANS-DONEPLANDELETED):

- plan-bicepparam: `.bicepparam` slots render, discover and build through one path; the six literal slots migrated.
- plan-debt-signals: twenty page lines, messages and commands that carry a declared fact to the session.
- plan-file-meta-cache: the help-page reword, the ADR-code stamp, the caching sentence and the strict-mode fix.
- plan-minimal-heads: minimal heads tree-wide; the comment-page map moved to `Catzc.Base.CodeMeta`.
- plan-session-finalize: the roof-count sentence, the gate message and the skill's glossary term.
- plan-debt-test-snapshot: a held test-run folder falls back to a snapshot that primes, and keeps its cause when it fails.
- plan-eac-normal-form: the explanation page embedding the approved sample.
- plan-adr-authoring: the glossary contrast declared once, the add-an-ADR how-to, the ADR-edit reminder.
- plan-git-topic-commands: `Get-SyncPoint`, `Save-Topic`, `Sync-Topic`, `Push-Topic`, the hook that denies an agent the three.
- plan-accosted-language: the accosted language, its reserved word, reader, runner and contracts; green under pwsh, bash and zsh.
- plan-test-signal-proposals: the bridge names a setup error, one spelled-types source, RungsConfig re-tiered.
- plan-truth-stores: the image slide pattern and the truth-stores slide in the product-thesis deck.
- plan-diagram-build-learnings: the Build-Diagrams help, the quiet legend, the minimap stage loaded once, the pipeline drawing.
- plan-debt-diagram-render: the renderer fails on an unresolved token; the glyph library renders through the one build.
- plan-xdr-codes: record-kind codes (TDR, PDR, WDR, RDR, DDR, FDR) across the tree.
- plan-debt-gate-messages: three gates name their own cause.
- plan-debt-run-and-report: the kit-test example, findings printed once, generated heads naming their source, code citing its rules.
- plan-debt-tooling: the terminology corpus reads `cspell.yml`'s one scope; the `uv.lock` clause in the rename how-to.
- plan-docs-edge-relative-link: a code head's `docs` edge is file-relative, and `Test-Links` checks it.
- plan-minimap-reasons-gate: every diagram declares its lit minimap cells in its yml, and the gate draws only those.
- plan-diagram-flat-files: every diagram is `.assets/<name>.drawio.png` and `.assets/<name>.drawio.yml`, no per-diagram folder.
- plan-debt-empty-path: an empty `-Path` is refused by `ValidatePathGiven` on the 21 whole-tree commands; the `catzc-run` path-list clause.
- plan-debt-diagram-names: the `drsonly` glyph kind and "DRS-only" prose, `-Stem`, `Rename-CodeName` listing skipped hits, the
  `Move-Diagram` deleted-page guard.
- plan-diagram-in-article: a diagram declared in its article in a `yml drawio` block above its image, `carriers:` in the kit's `drawio.yml`,
  `build-diagrams-runs-five-stages` as the proof; the `catzc-verify` staging clause and the `Build-Diagrams` page's two-call sentence.
- plan-debt-reference-pages: seven comment pages corrected to their code (contracts.yml, New-CatsCommandLookup,
  Get-GlossarySourceViolations, Invoke-TestFile, Test-Links, Update-DrsCitation, terminology.yml) and the NameCase type test pinning the
  DevOps kebab split.
- plan-debt-red-tests: the analyzer test green again (the `drs` term, 33 findings fixed file by file) and the glossary rule-code test green
  through a post-load `defined_by` check in `Get-GlossarySourceViolations` against `(Get-Config drs).CodeForm`.
- plan-debt-gate-findings: `Get-DrsUsage` skips a deleted indexed path, `Test-Plans` checks stated step counts (with the rule sentence in
  ADR-REPO-PLANS-THREEPARTS), and `Get-SlideOrderFinding` gives `Test-Slides` and `Build-SlideDeck` one deck order check.
- plan-debt-docs: two how-tos (adding a command contract, testing an agent hook), ADR-PWSH-PARAM-CASESENSITIVEPATTERN, and the read edge row
  in the kit template's legend (the edge itself was already in STYLE.md and the renderer).
- plan-debt-import-path: `Test-Parsing` parses ps1, psm1, psd1 and yml files without importing them, `importer.sh` passes a list parameter
  as one array, and `catzc-verify` names `Test-Parsing` before an import-path burst.
- plan-debt-python-tests: `Invoke-PythonTest` without `-Folder` runs a module's own `tests/` before the holder's, one case per layout.
- plan-debt-root-assets: `catzc-run` says a root asset edit starts with a HOLD, since every import's `Build-RootConfig` materialises it.
- plan-debt-build-artifact-cause: `Get-DynamicManifestContent.Tests.ps1` asserts the build issues before the module count, so a failed build
  names its `[build]` reason.
- plan-dense-yaml-flow: every diagram declaration prints a leaf node as one flow line when it fits the markdown `max_line_length`; all 176
  reflowed, the printer in Prettier's form, three diagrams' minimaps re-declared from the tree.
- plan-debt-hindsight-gaps: the 2026-10-22 hindsight gaps closed: the strict-clean index bullet, the `Catzc.Base.Drs` article, four
  reference and how-to pages, all 51 module articles checked against their modules, six capability lines; the Mock gap dropped as false.
- plan-debt-gate-sweep: links, generated files, glossary, contracts, parameters, names, formatting, analyzer and Python gates swept by
  slice; `Test-Spelling` now spells dot folders and names its findings, 21 stale comment sections rewritten to their code.
- plan-diagram-article-carrier: 166 diagram declarations moved into their articles as `yml drawio` blocks by `declaration.py carry`, the kit
  default carrier `article`, nine diagrams file-carried; `rekey` is the one `carriers:` editor and `Move-Diagram` is carrier-aware.
- plan-debt-gate-review: the dangling-code check honours fence length, `Test-Spelling` reports a run with no file count, and four records
  state the rules their gates apply (OPENSTEP, CODEISSELECTOR, QUALITYGATE, HEADPOLICY coverage).
