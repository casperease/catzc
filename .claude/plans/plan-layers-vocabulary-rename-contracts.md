---
plan:
  status: active
  value: high
  reviewed: 2026-10-16
  waits_on: plan-module-kinds-tracks implemented (Q8); P4 folder move waits for the user's explicit go
  targets: [automation, docs/adr/automation, docs/adr/repository, contracts, automation/Catzc.Base.Docs/configs, .catzc]
---

# Automation is the abstract term; the PowerShell track is named pwsh; public commands get contracts

Three drafts form one series: the master plan and rename, the layer model with its vocabulary and ADRs, and command contracts with
the contract language. A fourth file is the evidence worklist, every use of the word classified with file and line. Every decision
is made (2026-10-16). Nothing is built or renamed. The continuation prompt for a fresh session is written.

## Why its value is high

It fixes what automation, language, engine, importer, command and contract mean across every file, and makes contracts/ the only
public API by naming which of the 439 public functions are contracted. Every later plan speaks this vocabulary.

## Decided, and why (all took the recommendation, 2026-10-16)

- Q1 folder and track are pwsh; rejected powershell, modules, catzc. A track is named by its stack, parallel to go, python, bash.
- Q2 keep invoke-automation.yaml and release-automation.yml: they invoke and release the automation, the abstract thing.
- Q3 keep Test-Automation, its 16 helpers and test-automation/: the name is already accurate; a 470-line rename buys nothing.
- Q4 other automation doc folders are classified page by page: a pwsh topic moves, an abstract topic stays. docs/adr/automation stays.
- Q5 consumer overlay becomes .catzc/pwsh/<Module>/ with no fallback (one living version); consumer-visible, note it for the release.
  This repo's own .catzc/<track>/ is also a source-mode config-fragment root (config defaults plan), so P4 renames the folder only.
- Q6 build outputs become out/pwsh/built and out/pwsh/packages.
- Q7 Edit tool only, one file at a time, each verified; no permanent rename tool.
- Q8 the module model lands first: it deletes Get-AutomationModules and Get-BaseModule and gives the one resolver; then P2, then P4.
- Q9 command contracts as plan 3 wrote them: <Module>/<Verb-Noun>.command.yml, grammar shape A (one string per parameter), closed type
  set, pilot set first, cats validation in C5, no errors key in 0.0.0 (Q-C1 to Q-C6 as recommended).
- Q10 concern automation and value-chain row AUTO keep their names; ADR-AUTO-* is never re-coded (about 10,450 citations).
- Q11 bash, python and go stay test-artifact languages; the importer throws NotImplemented for any other configured language.
- Layer plan Q-L1 to Q-L5 as recommended. Late rename at P6: ci-automation, ci-automation-expected-failures and the globset; the user
  re-points the Azure DevOps and GitHub bindings outside git.

## Done, and why

- The master plan carries a status line (<TRACK> means pwsh), section 8 rewritten as decisions, the Q1 map row marked decided, so a
  fresh session never re-asks.
- The two companions each carry a "Decided 2026-10-16" line and their question sections are retitled as decisions.
- The worklist fixes <TRACK> to pwsh. The module-model and k8s plans carry a sequencing note (see plan-module-kinds-tracks).
- out/prompt-automation-layers-continue.md written: read order, final decisions, standing constraints, order of work, stop conditions,
  report shape. The two module-model prompts and the other out/ plans were not touched; they do not mention this work.
- The note was copied to the user's memory file.

## Needed docs

- ADR-AUTO-LAYERS, ADR-AUTO-IMPORTER, ADR-REPO-CMDCONTRACT, all new.
- Glossary: automation, importer, command, bare engine, language, module, role, run mode, command contract, contract language, layer.
  Avoid-phrasings for the new meanings now, for the retired folder meaning at P6.
- languages.yml top-level engines renamed formatters; adrs.yml layer key; the four term collisions (tracks.md:209, tracks.md:57,
  ADR-AUTO-ENGINE#4, engines:); docs/references mirror follows the folder; Test-AdrEngineNeutrality extended so AUTO ADRs carry no pwsh syntax.

## Needed tests

- Test-Glossary, Test-AdrRegistry, Test-Terminology clean on touched files (P1 stop).
- A guard rule against track-root literals keeps the folder literal funnelled (P2 stop).
- Test-Contracts covers command contracts as the fifth asset kind; what it does with an unknown suffix is settled on a copy first.
- P0 baseline, recorded in the background: Test-GeneratedFiles, Test-Links, Test-Contracts, Test-WorldMap pass today. Known unrelated
  reds: Test-Spelling 5, Test-Glossary G4, Test-Formatting on .compiled/*.json, about 37 Test-ScriptAnalyzer.
- Edge fact on a copy: does a failed hook rebuild delete the existing Assert-BashTimeout binary.

## Order of work (from the continuation prompt)

1. Module model first (plan-module-kinds-tracks): its prepare prompt runs in a separate fresh session; no code below changes before it is implemented.
2. P0 baseline and the two checks on a copy.
3. P1 doctrine and vocabulary, docs and glossary only.
4. P2 funnel: one bootstrap constant, about 45 sites onto Get-CatzcModulesRoot and Get-Track, S4 identifiers renamed, guard rule.
5. P3 docs classified page by page, then stop and report. P4 (the folder move, git mv) waits for the user's explicit go, in a quiet window.
6. P5, P6, P7 beside P2 and P3 but never inside P4, P8 diagrams only on an explicit go.

## Open steps

- [ ] Copy the prompt, the four plan files and the two module-model prompts into the session scratchpad before pasting (out/ was wiped once).
- [ ] Paste out/prompt-automation-layers-continue.md into a fresh session after the module-model prepare prompt (check: the session reports P0 green).
- [ ] P1 (check: three terminology gates clean). P2 (check: guard rule gate). P3 (check: classification table, then stop).
- [ ] P4 on the user's go (check: full baseline green again). P5 to P8 per the master plan.

## Stop and ask when

- A plan fact is contradicted by the tree: record the correction in the plan and say so.
- A step needs an unsettled decision, any mutating git, an external binding, or P4.

## Refs

- prompt-automation-layers-continue.md (beside this file)
- the four drafts are carried below in order: the master (section 8 decisions, section 9 order, section 10 not in plan), the layer
  model, the command contracts, the rename worklist (formerly out/plan-automation-layers-rename.md and companions)
- memory: automation-layers-rename-plan.md (still says Q1-Q11 open; now decided)

## Carried: out/plan-automation-layers-rename.md (verbatim, absorbed 2026-10-16; headings below are the draft's own)

# Plan: automation becomes the terminology; the pwsh track gets its own name

Master plan. Companions: [plan-layers-importer-vocabulary.md](plan-layers-importer-vocabulary.md) (the layer model, vocabulary, ADRs, importer mix),
[plan-command-contracts.md](plan-command-contracts.md) (command contracts and the contract language),
[plan-rename-worklist.md](plan-rename-worklist.md) (the evidence: every use of the word, classified, with file:line). Existing plans this meets:
`out/plan-module-model.md`, `out/plan-k8s-kinds.md`. Facts were read on 2026-10-16 by six read-only crawls; nothing is built or renamed yet.

**Status 2026-10-16: all decisions are made (section 8).** Wherever this plan or a companion writes `<TRACK>`, read **`pwsh`**. The next step is the continuation prompt
[prompt-automation-layers-continue.md](prompt-automation-layers-continue.md).

## 1. What was asked, and how it is read

> Repository-wide, for all tracked files that are not products of a generator: rename AUTOMATION / automation / maybe auto. Automation (AUTO) is to
> become the terminology, implemented with a LANGUAGE, whose tools are used through an ENGINE, via an IMPORTER deciding the final mix of engines and
> languages. The call interface of public COMMANDS from different layers is defined in simple 0.0.0 CONTRACTS, used through a simple CONTRACT LANGUAGE.

Reading (say so if wrong; the plan is built so only the map in section 3 changes):

- **Automation** stays as the name of the abstract thing: the commands and behaviours and their doctrine (the ADR domain `automation`, code `AUTO`,
  `ADR-AUTO-*`). What leaves the word is everything that meant "the PowerShell implementation": the root folder `automation/`, the track key
  `automation`, "the automation modules / layer", `docs/references/automation/` (a mirror of that folder), the overlay path, build output folders.
- The renamed thing is a **track named by its stack**, like `go/`, `python/`, `bash/` (ADR-DSGN-TRACK#3: one stack per track).
- `auto` stays as the engine value that leaves a choice open (ADR-AUTO-ENGINE#7) and also becomes the value for the language and the mix.
- Generated files are not hand-edited. A change to their source plus a regeneration updates them (about 1,088 products, about 4,600 meta heads).

## 2. Findings that shape the plan

1. **Four meanings share one word**, and only one of them moves: folder/track (S1) moves; ADR domain/row (S2) and value-chain concern (S3) stay;
   `Test-Automation` (S5) stays; pipeline names (S6) move late. About 215 ADR lines are CAF/WAF/DORA English and 140 are
   `System.Management.Automation`: never swept.
2. **The registry exists but is bypassed.** `variants.yml` declares the track and `Get-CatzcModulesRoot` / `Get-Track` resolve it, yet about 45
   non-test sites, three analyzer regexes, three C# constants, the importer, builder and testkit re-spell `'automation'`. Renaming now means touching
   them all; funnelling them first turns the rename into a handful of data edits plus a regeneration.
3. **Most of the repository follows from sources**: `variants.yml:31`, `comments.yml`, `readme.yml`, `rootconfig.yml`, `file-meta.yml`, `contracts.yml`,
   `globs.yml`, `module-types.yml`, `file-kinds.yml`, then `Format-FileMeta`, `Export-Comments`, `Build-Readme`, `Build-RootConfig`. The hand work is prose,
   ADR rule text, tests that assert the literal, and about 15 edge files.
4. **Silent-failure edges**: the Bash-hook csproj (a failed rebuild denies every Bash call), `importer.ps1:37` (nothing loads), CI trigger paths (CI
   never fires), the agent shared-file list (protection quietly lapses), the drawio tile grouping. Full list in the worklist, section 6.
5. **The new concepts are mostly not in any rule.** Only ENGINE has one. LANGUAGE as a layer, the IMPORTER deciding the mix, the command contract and
   the contract language have no rule; "contract" even collides with `ADR-AUTO-ENGINE#4`. Doctrine comes first (companion plan 2).
6. **No machine-readable command description exists** (439 public commands, 280 private, 45 modules). A command contract is a fifth contract asset
   kind picked by file name (companion plan 3).
7. **The importer decides no language or engine today**; it loads every module in the root and the mix is a build-time bundle/profile outcome.

## 3. The rename map (decisions marked Q are in section 8)

| From | To | Why / note |
| --- | --- | --- |
| folder `automation/` | `<TRACK>/` = **`pwsh/`** (Q1, decided) | a track is named by its stack; PowerShell hosts the C# types (`ADR-PWSH-TYPES`); parallels `bash/ go/ python/`, `docs/adr/pwsh/`, `ADR-PWSH-*` |
| track key `automation` (`variants.yml`, every head's `track:`) | `<TRACK>` | rename key and root together |
| globset `automation`, `pipeline: ci-automation` | `<TRACK>`, `ci-<TRACK>` | late wave (S6) because of external bindings |
| `docs/references/automation/` | `docs/references/<TRACK>/` | generated mirror; `comments.yml` / `readme.yml` decide |
| `docs/explanation/automation`, `docs/how-to/automation`, `docs/how-to/getting-started/automation` | per page: pwsh topic -> `<TRACK>`, abstract topic -> stays | worker table, Q4 |
| `.catzc/automation/<Module>/` (consumer overlay) | `.catzc/<TRACK>/<Module>/` | mirrors the code root; no fallback (ADR-PRIN-ONELIVE); Q5 |
| `out/automation/built`, `out/automation/packages` | `out/<TRACK>/built`, `.../packages` | configured in `output-formats.yml`; Q6 |
| `-AutomationRoot`, `Get-AutomationModules`, `Get-AutomationFunctions`, `Get-AutomationSourceFiles`, `Copy-Automation` | `-ModulesRoot`, (module model), `Get-ModuleFunction`, `Get-ModuleSourceFile`, read first | worklist section 5 |
| `Test-Automation` family, `test-automation/` out folder | **unchanged** (Q3) | tests the automation across languages and engines |
| ADR domain `automation`, `AUTO`, `ADR-AUTO-*` (about 10,450 occurrences), `docs/adr/automation/` | **unchanged** | the abstract term; no re-coding |
| concern `automation`, row `AUTO` | unchanged (Q-L4) | |
| `invoke-automation.yaml`, `release-automation.yml` | unchanged | they invoke / release the automation |
| `engines:` key in `languages.yml` | `formatters` | frees "engine" |

## 4. Phases

Each phase ends with its own stop condition. "Per file" always means: edit one file with the Edit tool, then run that file's own Pester test or gate in
the background under `timeout` (CLAUDE.md: no batch edits; time safeguard). The user runs the full suite and handles commits (memory: user-handles-commits-and-tests);
this plan proposes no commit split.

### P0 Decide (nothing changes)

Answer section 8. Run the read-only prepare prompts of the module-model and k8s plans (they are independent). Freeze the baseline: record that
`Test-GeneratedFiles`, `Test-Links`, `Test-Contracts`, `Test-WorldMap` pass today, so a red result later is attributable (run by the user or in the
background; never claimed unrun).

### P1 Doctrine and vocabulary (docs and glossary only; no path changes)

Companion plan 2, sections 2-3, and companion plan 3 phase C1: `ADR-AUTO-LAYERS`, `ADR-AUTO-IMPORTER`, `ADR-REPO-CMDCONTRACT`, glossary entries
(automation, implementation language, importer, command, command contract, contract language, layer), the `engines:` -> `formatters` key rename, the
`ADR-AUTO-ENGINE#4` wording, `adrs.yml` `layer:`. Add avoid-phrasings now for the _new_ meanings only; the phrases that retire the old folder
meaning are added at P6 (they would fail the tree until the flip lands). Stop: `Test-Glossary`, `Test-AdrRegistry`, `Test-Terminology` clean on touched files.

### P2 Funnel (behaviour-preserving; the folder is still `automation/`)

Goal: after this phase the literal folder name is spelled in as few places as possible and a gate keeps it that way.

1. Shrink the bootstrap constants (worklist section 3): one constant in `Catzc.Internal.Importer.psm1`, from which `New-Importer` writes the shim's line 37
   (so the generated `importer.ps1` stops being a second place). The Bash hook keeps its own (no importer there): `BashSafeguard.ConfigRelativePath` and
   the csproj. **Unverified items first**: read `Build-BashTimeoutHook`, `Invoke-AgentHookJanitor`; learn whether a failed rebuild deletes the old binary;
   try the csproj change on a copy.
2. Move every site in worklist section 4 onto `Get-CatzcModulesRoot` / `Get-Track`, one file at a time, in module order (`Get-ModuleOrder` if the module
   model has landed, else `dependencies.yml` order, leaf modules first). C# constants (`GlobsConfig.ConfigPath`, `AdrsConfig` is S3 and stays) read the
   track root through the config type's own resolver where one exists. C# edits need a fresh `pwsh`.
3. Convert test fixtures that bake `<root>/automation` to a root from the resolver or a neutral root.
4. Rename the S4 identifiers (worklist section 5), one function at a time (file, test, call sites). Do this **after** the module model if it is imminent:
   it deletes `Get-AutomationModules` and `Get-BaseModule`; otherwise rename now.
5. Add the guard: a source-convention (or analyzer rule extending `NoScriptRootAnchor`) that reports a string literal equal to any track root in code
   outside `variants.yml` / the resolvers. It makes the funnel permanent and is also the post-flip regression net (poka-yoke, ADR-PRIN-POKAYOKE).

Stop: Grep for the literal in code outside the registry returns only the allowlist; the touched files' tests pass; `Test-GeneratedFiles` unchanged.

### P3 Content roots and docs classification (still no rename)

- Split S1 from S2 on the docs side: classify every hand page in `docs/explanation/automation`, `docs/how-to/automation`,
  `docs/how-to/getting-started/automation` and the 56 hand pages inside `docs/references/automation` (a table: page, topic, move or stay).
- List the ADR rules of worklist section 7 and draft their new wording against the placeholder `<TRACK>`; the edit itself waits for P4 so ADRs always
  describe the present tree.
- Prepare the diagram list (12 PNG names, sidecars) and ask for the go before any render.

### P4 The flip (one quiet window; this is the only phase that cannot be interleaved)

Preconditions: P1-P3 done and green on touched files; no other session has dirty files in the tree (parallel sessions edit and commit concurrently,
memory: parallel-sessions; the user decides the window); a hook-recovery path exists out of band (a Bash call is not available if the hook breaks).
`git mv` is a mutating git command: it runs only when the user explicitly says so (CLAUDE.md). A plain `mv` leaves a stale index (memory trap).

Order (it follows the boot dependency; the importer must work before any generator runs):

1. `git mv automation <TRACK>`; `git mv docs/references/automation docs/references/<TRACK>` (so regenerated pages land in place).
2. Edit the **bootstrap set** by hand: the importer constant, the hook csproj, `BashSafeguard` and `GlobsConfig` constants. Then restore `importer.ps1` line 37
   by hand once (it is generated; the generator cannot run until the importer loads). Smoke-test with a plain `pwsh -NoProfile` import in the background
   under `timeout`.
3. Edit the **data registries** (worklist section 3), one file each: `variants.yml` (key and root), `module-types.yml`, `file-kinds.yml`, `comments.yml` and
   `CommentsConfig.cs`, `readme.yml`, `file-meta.yml`, `contracts.yml`, `rootconfig.yml`, `gitignore.yml`, `vscode-settings.yml`, `languages.yml` paths,
   `output-formats.yml`, `source-conventions.yml`, `links.yml`, `terminology.yml:36`. Edit generators that hard-code the folder in their own source (worklist section 9).
4. Edit the **edge files** that are not regenerated (worklist section 6, items 1-5): CI trigger paths, `CLAUDE.md`, agent definitions, drawio scripts.
   The pipeline and workflow **names** wait for P6; their trigger paths change now.
5. **Regenerate** in the worklist section 9 order; then `Test-GeneratedFiles`. Heads, comment pages, READMEs, index, glossary, root files follow with zero hand edits.
6. **Hand waves** (section 5): per-module code, tests, ADR rule text, docs prose and links, contracts.
7. Stop: Grep for `automation/` over tracked files minus the allowlist (S2 paths, `.unordered`, S8) is empty; `Test-GeneratedFiles`, `Test-Links`,
   `Test-Contracts`, `Test-WorldMap`, `Test-FolderConventions` clean; every touched file's own test passes. The full suite is the user's.

### P5 Guards (makes the new meaning stick)

Avoid-phrasings with replacements in `glossary.yml` for the retired uses: "automation folder", "automation track", "automation modules",
"automation layer", "PowerShell automation" (G4 checks tracked prose and comments; backtick mentions are exempt). One analyzer/convention rule from P2 stays.
Extend `Test-AdrEngineNeutrality` so AUTO-layer ADRs carry no pwsh syntax.

### P6 Pipeline and unit names (late, separate, externally bound)

`ci-automation` -> `ci-<TRACK>`, `ci-automation-expected-failures` -> `ci-<TRACK>-expected-failures`, globset and `pipeline:` key, the workflow and pipeline
files, their contract fragments (file-name keyed), `docs/references/pipelines/*`, the README badge, `Test-GitHubWorkflowTriggerGlob` examples,
`Register-AdoPipeline` examples. **Outside git, by the user**: re-point the Azure DevOps pipeline definitions, GitHub required checks, any bookmark.
`invoke-automation` and `release-automation` stay (Q2). One atomic set, then verify triggers fire.

### P7 The new layers, built (can start after P1; independent of P4 unless noted)

Companion plan 2 phases L2-L6 (`ImporterConfig`, `Get-ImportMix`, module selection by language) and companion plan 3 phases C2-C6 (command contract kind,
checker, pilot contracts, reader, reference column, `cats` validation). Do each entirely before or entirely after P4, never inside the window. The
command-contract assets name modules, not the folder, so they are unaffected by the flip.

### P8 Diagrams (only with an explicit go)

`write-drawio-files` changes text inside the 12 named diagrams and re-renders; minimap sidecars rebuild from the kit. `drawio-diagram-waves` is not used.

## 5. Division of work (sub-agents, standard `catzc-worker`)

The coordinator (the main session) owns the shared files: `variants.yml`, `module-types.yml`, `globs.yml`, `rootconfig.yml`, `gitignore.yml`, `adrs.yml`,
`dependencies.yml`, `languages.yml`, `terminology.yml`, `contracts.yml`, `CLAUDE.md`, the agent definitions. A worker edits only the files its brief names and
asks for shared-file entries. Waves (each worker a disjoint set, one file at a time, per-file verification, fixed report):

| Wave | Owner set | Brief content |
| --- | --- | --- |
| W1 funnel | modules grouped by dependency layer (about 8 workers; leaf modules first) | worklist section 4 sites for its modules + fixtures; report the file and the test it ran |
| W2 ADR rules | `docs/adr/design`, `repository`, `automation`, `pwsh`, `azure`+`configuration`+`flow`+`pipelines`+`github` (5 workers) | worklist section 7 + the 160 path lines; never touch S2 links or S8 titles; edit once per rule |
| W3 docs prose | `docs/explanation`, `docs/how-to`, hand pages in `docs/references`, `docs/index.md`, READMEs | the P3 classification table; link rewrites |
| W4 tests | per module test folders | fixtures that assert the literal, test titles with the word |
| W5 edges | `.claude`, `.github`, `pipelines`, `contracts` | worklist section 6 |

Every brief carries: the do-not-sweep list (worklist section 10), "generated files are regenerated, never edited", the time safeguard (`timeout: 3000`
foreground, `timeout <s> <one command>` in the background), no mutating git, and "report instead of retrying a denied call".
A permanent per-file tool in the style of `Update-AdrCitation` (map-driven, one file per call, dry-run first) could speed W2/W3; the CLAUDE.md rule
against script sweeps makes that the user's call (Q7). The default is the Edit tool.

## 6. Verification, honestly scoped

- Per file: its Pester test or gate, read before the next file. Never claim a gate passed unless it ran and the result was read.
- Per phase: the stop conditions above, run in the background with `timeout`.
- End: the user runs the full suite. The plan names which gates must be green and which were red at P0 (so unrelated reds are not blamed on the rename):
  known unrelated reds from the last session notes are Test-Spelling 5, Test-Glossary G4, Test-Formatting `.compiled/*.json`, about 37 Test-ScriptAnalyzer.
- Keep a residue scan as a standing check: `rg -i automation` over tracked files with the do-not-sweep allowlist, to the zero the allowlist implies.

## 7. Risks

| Risk | Mitigation |
| --- | --- |
| Hook rebuild fails, every Bash call denied | P2 verifies on a copy; flip done by a session that can recover out of band; csproj in the same step as the move |
| Nothing loads after the move | importer constant + shim line edited first, smoke-tested before any generator |
| CI silently stops triggering | trigger paths edited in the same window as the move; P6 verifies a trigger fires |
| Parallel sessions collide on a mass change | user-chosen quiet window; message before editing a peer's dirty file; no worktree edits |
| A sweep rewrites S2/S8 text | classification first; do-not-sweep list in every brief; residue scan |
| Generated files regenerate from stale sources | strict order (worklist section 9); `Test-GeneratedFiles` after |
| `.compiled` DLL text-converted by a stale `.gitattributes` | regenerate `.gitattributes` in step 5 before any commit |
| Windows case-insensitive collision (`Get-FilekindX` overwrote `Get-FileKindX`) | function renames use distinct names, one at a time |
| The same word-change edited twice (ADR wording in P1 and again in P4) | one edit per rule, in P4, covering both |
| Scope creep into the module model or k8s kinds | those keep their plans; this plan only sequences against them (plan 2, section 5) |

## 8. Decisions (all made by the user on 2026-10-16; each took the recommendation)

- **Q1** The folder and track are named **`pwsh`**. (Rejected: `powershell`, `modules`, `catzc`.)
- **Q2** Keep `invoke-automation.yaml` and `release-automation.yml` (they invoke / release the automation).
- **Q3** Keep `Test-Automation`, its 16 helpers and `test-automation/` (a 470-line rename for a name that is already accurate).
- **Q4** Docs pages in the other `automation` doc folders are classified per page: a pwsh topic moves to `pwsh`, an abstract topic stays.
- **Q5** The consumer overlay path becomes `.catzc/pwsh/<Module>/`, **no fallback** (one living version). It is consumer-visible, so note it for the release. Note (2026-10-16, [plan-config-defaults.md](plan-config-defaults.md)): this repo's own `.catzc/<track>/` also becomes a source-mode config-fragment root and holds `variants.yml`'s data; the root lookup is resolver-based, so P4 renames the folder only.
- **Q6** Build outputs become `out/pwsh/built` and `out/pwsh/packages`.
- **Q7** Edit-tool-only: no permanent rename tool, one file at a time, each verified.
- **Q8** The module-model implementation lands first (it deletes `Get-AutomationModules`/`Get-BaseModule` and gives the one resolver), then P2, then P4.
- **Q9** The command contract design of plan 3 is accepted as written: `<Module>/<Verb-Noun>.command.yml`, grammar shape A, closed type set, pilot set first, `cats` validation in C5, no `errors:` in `0.0.0` (Q-C1..Q-C6 all as recommended).
- **Q10** Concern `automation` and row `AUTO` keep their names.
- **Q11** Bash, python and go stay test-artifact languages only (ADR-AUTO-GO/PY/BASH); the importer throws `NotImplemented` for any other configured language.
- **Layer plan** Q-L1..Q-L5 all as recommended (plan 2, section 6).

Not asked, still the working assumption: the reading of the request in section 1. If it is wrong, only the map in section 3 changes.

## 9. Recommended order

P0 (decide) -> module-model prepare + implement -> P1 -> P2 -> P3 -> **P4 in a quiet window** -> P5 -> P6 -> P8 on request. P7 runs beside, never inside P4.

## 10. Not in this plan

Re-coding `ADR-AUTO-*`; moving AUTO ADR files into layer sub-folders; renaming the Go/Python/Bash tracks; any change to `.unordered/`; rendering any diagram unasked;
the Azure DevOps and GitHub settings that live outside git; commit structure (the user's).

## Carried: out/plan-layers-importer-vocabulary.md (verbatim, absorbed 2026-10-16; headings below are the draft's own)

# Plan: the layer model (automation, language, engine, importer), its vocabulary and its ADRs

Part 2 of the layers series. Master plan and the rename: [plan-automation-layers-rename.md](plan-automation-layers-rename.md). Command contracts:
[plan-command-contracts.md](plan-command-contracts.md). Evidence worklist: [plan-rename-worklist.md](plan-rename-worklist.md). Related existing
plans: `out/plan-module-model.md` (Module, language x engine axes, registration is placement), `out/plan-k8s-kinds.md`. Facts read on
2026-10-16 from the surveys `out/survey-*.md` (they may be wiped; this plan carries what it needs). Nothing here is built.

**Decided 2026-10-16:** `<TRACK>` = `pwsh`; Q-L1..Q-L5 are all accepted as recommended (section 6).

## 1. The model

```text
 AUTOMATION   the abstract: the commands and behaviours the repository offers, and the doctrine for them (ADR-AUTO-*).
     |        Names no language, no shell, no folder.
     | is stated at its boundary by
 CONTRACT     the call interface of each PUBLIC command, in the contract language, versioned with its unit (0.0.0 draft).
     |        (plan-command-contracts.md)
     | is implemented in
 LANGUAGE     the language a command's source is written in: powershell (+ hosted csharp), later bash, python, go, bicep.
     |        One stack per track (ADR-DSGN-TRACK#3).
     | its tools run through
 ENGINE       the shell the code runs under: pwsh, bash, zsh (closed set, ADR-AUTO-ENGINE#1). `auto` leaves the choice open.
     | are brought into a session by
 IMPORTER     decides the final MIX of languages, engines and modules loaded, per session, from one config with sensible defaults.
```

Reading it top-down is "what, interface, how written, how run, how assembled". Each lower layer realises the one above and never redefines it
(the stance `docs/adr/automation/` already takes toward `docs/adr/pwsh/`, which says it "applies the engine-agnostic rules to one engine").

What each layer is **today** (survey, 2026-10-16):

| Layer | Today | Gap |
| --- | --- | --- |
| automation | the ADR domain `automation` (code AUTO, 35 coded ADRs, about 17 plain doctrine); the value-chain row `AUTO` and concern `automation`; also the folder `automation/`, `Test-Automation`, `ci-automation`, "the automation layer" | one word for four things; the folder and the pwsh meaning must leave it |
| contract | `ADR-REPO-CONTRACT#1-10`: file and payload contracts only (fragment, schema, sample, presence) | no command contract, no contract language |
| language | `languages.yml`: 17 **file** languages (extensions, formatter, checks, imprint). Implementation is implied: the importer hard-wires powershell + csharp; go/python/bash are test artifacts | "language" is only a file language; no notion of implementation language; no build/test/layout per language; the top-level key `engines:` there means formatter tools |
| engine | `ExecutionEngines` C# model (pwsh, bash, zsh) + `ADR-AUTO-ENGINE#1-7` | none for the model; only the clash with `languages.yml` `engines:` and "automation is the engine" (`tracks.md:209`) |
| importer | `importer.ps1` (generated shim) -> `Catzc.Internal.Importer.psm1` `Invoke-Importer`; `importer.sh` (the `cats` dispatcher); `Import-Catzc.ps1` for builds. It loads **every** module folder in the code root; language and engine are not inputs. The mix is decided at **build time** (`exporter.yml` bundle -> `profiles.yml` -> dependency closure) | the importer decides nothing about languages or engines; no ADR rule says it decides the mix (mentioned in about 30 ADRs, defined in none) |

## 2. Vocabulary (controlled, ADR-REPO-VOCAB)

New or redefined **defined terms** and what each needs (a rule that bolds it, a `glossary.yml` entry in the owning module, reciprocal contrasts,
avoid-phrasings with a replacement; spelling via `terminology.yml` + `Build-TerminologyDictionary` when a token is new):

| Term | Meaning (one sentence) | Owning module's `glossary.yml` | Contrasts | Avoid (say) |
| --- | --- | --- | --- | --- |
| **automation** | the commands and behaviours the repository offers and the doctrine for them, independent of language and engine | Docs (domain automation) | language, engine, importer, track | "the automation folder" (the `<track>` folder), "automation layer" (language layer), "automation modules" (modules) |
| **implementation language** | the file language a command's source is written in; a subset of the file languages | Languages | file language, engine | "automation language" |
| **engine** | keep the existing **execution engine**; the bare word means only that | Engines (exists) | language, importer | "the engine" for the core track, the Builder or a formatter (3 prose uses today: `tracks.md:209`, `build-verify-then-copy-the-folder.md:33`, `uniform-formatting.md:102`) |
| **importer** | the part that decides, per session, which languages, engines and modules are loaded (the mix); its per-engine entries are `importer.ps1` and `importer.sh` | ModuleSystem | bundle, run mode, engine | "loader" when the mix is meant |
| **command** | one public function of the module system, the unit a contract describes | Contracts | module, contract | "cmdlet", "script" for a command |
| **command contract**, **contract language** | see the command-contract plan | Contracts | contract, provided contract | "API", "interface file" |
| **layer** | redefine the existing term: one of the five levels above (automation, contract, language, engine, importer); remove the old forms `automation`, `PowerShell`, `implementation` from the `layer` family (`Docs/glossary.yml:129-163`) | Docs | track | "implementation layer" |

Collisions to resolve (each is a one-file edit in the P1 wave; file:line from the survey):

1. `languages.yml` top-level `engines:` (formatter tools: prettier, gofmt, ruff, psscriptanalyzer, dotnet-format, bicep) clashes with execution
   engine. Rename the key to `formatters` and the C# member that reads it (`FileLanguage`/`LanguagesConfig`, **unverified** which type; read
   first). Config and type change in one change.
2. `ADR-DSGN-TRACK` text "`automation` is the engine" (`tracks.md:209`) and "two automation layers (PowerShell and C#)" (`tracks.md:57`): reword
   to the track's name and "PowerShell, with C# types it hosts" (`ADR-PWSH-TYPES`).
3. `ADR-AUTO-ENGINE#4` "the black-box contract" is an env-var set, not a `contracts/` contract: rename it the **engine start environment**
   (the `CATZC_ENGINE*` set) and avoid-phrase "black-box contract".
4. `role`: `adrs.yml` `role: implementation` and the file-head `role`. Not touched here; note only.
5. `auto`: the engine value (`ADR-AUTO-ENGINE#7`) is also the build `-Version auto` (`Export-Catzc.ps1:62`, 8 lines). Different; unchanged. The
   `auto` of rule 7 gains a second place (language) in section 4.
6. `module`: no bare glossary entry. Defined by the module-model plan (`ADR-AUTO-MODULE`); depend on it, do not redefine.

## 3. ADR work (docs only, no path change; present tense, no history)

New ADRs (authoring conventions of `docs/adr/index.md`: rules registry first, rule codes, blank-line padding, DORA entry in the domain's
`dora-explains.md`, registration in `adrs.yml`, `Build-AdrIndex`, `Build-Glossary`):

| Code | File | Rules (summary) |
| --- | --- | --- |
| `ADR-AUTO-LAYERS` | `docs/adr/automation/layers.md` | 1 automation is the abstract and names no language, shell or folder. 2 a command is implemented in one language; the implementation languages are the file languages flagged as executable in `languages.yml`. 3 tools run through an engine (ADR-AUTO-ENGINE). 4 **the importer decides the mix**, from one config, per session, with `auto` (section 4). 5 a public command's interface is a command contract (ADR-REPO-CMDCONTRACT). 6 a lower layer realises the one above and never redefines it; a rule names the layer it belongs to. 7 `auto` leaves a layer's choice open (engine, language) and resolves by `ADR-AUTO-DEFAULT#6`. |
| `ADR-AUTO-IMPORTER` | `docs/adr/automation/importer.md` | the mix model of section 4: inputs, resolution order, result (`ImportMix`), entries per engine. Collects the scattered importer rules by citing them (`ADR-AUTO-ENGINE#6`, `ADR-AUTO-BUNDLE#3`, `ADR-DSGN-RUNMODE#1/#4`, `ADR-AUTO-CACHE#6`, `ADR-AUTO-EXTEND#3`, `ADR-AUTO-TYPES#7/#11-13`) and owns none of their content. May fold into `ADR-AUTO-LAYERS` if short. |
| `ADR-REPO-CMDCONTRACT` | `docs/adr/repository/command-contracts.md` | see the command-contract plan |
| `ADR-AUTO-MODULE` | from `out/plan-module-model.md` | not re-planned here; it must say a module's languages and engines are the two axes this model defines |

Amended rules (edit in place, one file at a time, citations unchanged because codes are stable):

- `ADR-AUTO-ENGINE#4` (rename the env-var set), `#7` (`auto` also for language; or leave #7 about engines and put the general `auto` in LAYERS#7).
- `ADR-DSGN-TRACK#3` (stack wording) and `#2` (core track wording) are also in the rename wave (they name the folder): do the wording here, the
  name there, so each edit is made once. Plan: **one edit per rule**, in the rename wave, covering both.
- `ADR-REPO-CONTRACT#6`, `#7` (fifth kind; direction by kind).
- Stray pwsh rules still in AUTO (survey): `ADR-AUTO-TEST` 4, 10, 25, 26, 32; `EXTEND` 4; `CACHE` 6-7 and the session-cache model; `CONSOLE`
  10-12; `NOPWD` 6. Move each to its `ADR-PWSH-*` twin or reword it engine-neutral (as the earlier split did). Rule numbers are never reused
  (the index says so), so a moved rule leaves a gap. `Test-AdrEngineNeutrality` already exists: extend it so AUTO text with pwsh syntax fails.

**No re-coding.** About 10,450 `ADR-AUTO-*` occurrences exist (TEST alone 6,519 over 733 files; TYPES 266 files). The codes are citations and
stay. Layer membership is recorded as data, not by moving files or changing codes: add an optional `layer:` to each ADR entry in `adrs.yml`
(domain default `automation`; override per ADR), validated by `AdrsConfig` (one of the five), shown by `Build-AdrIndex`. Survey verdicts to seed it:

| Layer | ADRs |
| --- | --- |
| automation (doctrine) | ZERO, ONEJOB, NONEST, IDEM, RETRY, PRELOG, FAILFAST, DEFAULT, DRYRUN, PARITY, PATH, XPLAT, GUIDS, SPELL, CONSOLE, ENVVAR, PKGMGR, ENTERP, DEPS, REMOVE, NOPWD, EXTEND |
| language | TYPES (C#), TRACKED (C#-backed, mislocated: its doctrine rules 1, 3-5, 8 are automation), GO, PY, BASH, UVPY |
| engine | ENGINE |
| importer | BUNDLE, OVERLAY, DEPM, ASSETDEP, CACHE (6-7), TEST (30, 31 run modes) |
| contract | none yet (REPO-CONTRACT, REPO-CMDCONTRACT live in `repository/`) |

A later regrouping of files into `docs/adr/automation/{language,importer}/` sub-folders (the `BCL/ go/ python/ bash/` precedent) changes link
paths only and is **not part of this plan** (Q-L3). The ADR split the user did earlier (pwsh out of AUTO) is the precedent for doing it when wanted.

## 4. The importer decides the mix

The user's phrase: "an IMPORTER deciding the final mix of engines and languages". The design, smallest first, all configuration with sensible
defaults and no new registry (ADR-PRIN-CONFIG, ADR-AUTO-DEFAULT#6, ADR-AUTO-OVERLAY for consumer differences):

- **Inputs** (resolution order of ADR-AUTO-DEFAULT#6: the caller's explicit value, else configuration, else the default declared once on the
  config type): `-Languages`, `-Engines` on the importer (an importer switch, like today's `-Bundle`), environment variables only where
  ADR-AUTO-ENVVAR allows an external contract (**read it first**), `importer.yml` (new, `Catzc.Base.ModuleSystem/configs/`, type
  `ImporterConfig` carries the defaults, with the posture and generated `defaults` contract of [plan-config-defaults.md](plan-config-defaults.md)), then the bundle/profile closure for modules. Run mode (source|build) and host (console|headless)
  stay orthogonal and keep choosing the types-load cell.
- **Values:** `auto` (default) or an explicit list. `auto` for **engines** = pwsh plus every POSIX engine whose executable exists (a missing
  zsh is skipped and reported, as the earlier decision says); for **languages** = the executable languages of the loaded modules.
- **Result:** one `ImportMix { Languages, Engines, Modules }` record kept for the session, readable by `Get-ImportMix`. The test runner reads
  engines from it instead of re-deciding (today every Go/Python test runs once per engine from the model), the builder reads modules.
- **Effects, in order of cost:**
  1. report only (`Get-ImportMix` states today's truth: engines [pwsh], languages [powershell, csharp], modules = all in the root);
  2. module selection by language (a module whose live languages are not in the mix is not loaded);
  3. entry files follow the mix (`importer.sh` is only generated and mentioned when a POSIX engine is in the mix);
  4. languages beyond powershell and csharp: **throw `NotImplemented` when configured** (the pattern of ADR-REPO-CONTRACT#8); switched on only
     once proven from every engine.
- **Per-language facts** that the importer and the module-model plan both need (`build`, `test`, `layout` handlers, the `executable` flag)
  belong in `languages.yml` beside `formatter` and `checks`, one file the formatter, checks and importer share (Q-F of the module-model plan).
  Whether `FileLanguage` rejects unknown keys is **unverified**; a new key needs the type edit first (C# change, fresh `pwsh`).

Phases (each a small, separately verified change; none requires the folder rename):

| Phase | Work |
| --- | --- |
| L0 | Read-only prepare: read `Catzc.Internal.Importer.psm1`, `Bootstrap`, `Builder`, `New-Importer`, `ADR-AUTO-ENVVAR`, `ADR-AUTO-BUNDLE`, `ADR-DSGN-RUNMODE`, `FileLanguage`/`LanguagesConfig`; confirm the module-model plan's layering result. |
| L1 | Vocabulary and ADRs (sections 2 and 3). Docs and glossary only. |
| L2 | `engines:` -> `formatters` rename in `languages.yml` and its type. |
| L3 | `ImporterConfig` + `importer.yml` (defaults on the type) + `Get-ImportMix` reporting today's mix. L0 tests with neutral fixtures. |
| L4 | `-Languages`/`-Engines` switches and module selection by language (effect 2); the importer shim is generated, so edit its source and regenerate. |
| L5 | Entry files follow the mix (effect 3); `Test-GeneratedFiles` covers it. |
| L6 | `adrs.yml` `layer:` key, `AdrsConfig`, index column. |

## 5. Order against the other plans

1. `plan-module-model.md` prepare prompt (read-only) can run now. Its implement step removes `Get-BaseModule`, `Get-AutomationModules`
   (a rename-worklist item) and makes `Get-CatzcModule` the one resolver; it should land **before** the funnel phase of the rename.
2. `plan-k8s-kinds.md`: kinds are tracks. The rename renames one track; the kind plan reads the track name from the registry, so no conflict.
3. L1 here and C1 in the command-contract plan are docs-only and can run before or after the rename; their text must not name the folder.
4. L3-L6 and C2-C5 touch `Catzc.Base.ModuleSystem`, `Languages`, `Contracts` and `RootConfig`: do them either entirely before the flip (they
   then ride the flip) or entirely after; do not interleave with the flip window.

## 6. Decisions (all accepted as recommended on 2026-10-16)

- **Q-L1** Executable flag: derive it (a language is executable when a track lists it and it is not a data language) or write
  `executable: true` in `languages.yml`. Recommend write it: a derived rule needs a data-language list, which is the same fact.
- **Q-L2** `ADR-AUTO-IMPORTER` as its own ADR or folded into LAYERS#4. Recommend own ADR: it is the rule that today has no home and cites 8.
- **Q-L3** Regroup AUTO files into `language/` and `importer/` sub-folders now or never. Recommend not now: data (`layer:`) gives the same view.
- **Q-L4** The value-chain concern `automation` ("loading the modules, reading configuration, selecting files") is the importer's job in the
  new model. Keep the concern name (recommended; it is a column of a published map, `ADR-DSGN-TRACK#15`) or rename it to `importer`. Keeping it
  means "automation" has one more meaning inside the abstract sense, which is consistent: the concern is the first stage of the automation.
- **Q-L5** Engines as config: `ExecutionEngines` stays a compiled C# model (closed set, no config), languages stay config. Keep the asymmetry
  (recommended: the set of engines is closed on purpose, ADR-AUTO-ENGINE#1; languages grow by entry).

## Carried: out/plan-command-contracts.md (verbatim, absorbed 2026-10-16; headings below are the draft's own)

# Plan: command contracts and the contract language

Part 3 of the layers series. Master plan: [plan-automation-layers-rename.md](plan-automation-layers-rename.md). Layers and importer:
[plan-layers-importer-vocabulary.md](plan-layers-importer-vocabulary.md). Facts below were read on 2026-10-16 (survey: `out/survey-layers.md`,
section 3-6); anything not read is marked **unverified**. Nothing here is built.

**Decided 2026-10-16:** the design below is accepted as written; Q-C1..Q-C6 are all as recommended (section 6). The module folder is `pwsh/` after the rename.

## 1. Goal, in the user's words made precise

The call interface of the **public commands** (functions) of the different layers is defined in simple `0.0.0` **contracts** and used through
a simple **contract language**.

- A **command** is one public function: one file at a module root, `Verb-Noun.ps1` containing exactly `function Verb-Noun`
  (ADR-PWSH-ONEFUNC). Today 439 public (and 280 private) across 45 modules. A private function is never contracted.
- A **command contract** is a contract asset (ADR-REPO-CONTRACT) that states the command's call interface. It is a **provided** contract: its
  consumers are callers in other layers (bash through `cats`, Go and Python black-box tests, a pipeline step, a consumer script). It joins
  the existing four asset kinds as a fifth. `contracts/` stays the only public API of the repository (ADR-REPO-CONTRACT#1), so a command is
  public exactly when a contract names it; the other 400-odd are internal and free to change under one living version.
- The **contract language** is the small notation a command contract is written in. It is YAML whose values are one short string per
  parameter. It states only what a caller needs and the source cannot say to a non-pwsh caller: names, types, mandatory, defaults, switch,
  pipeline, output type.
- Version `0.0.0` is the unit's mutable draft (ADR-REPO-CONTRACT#2, #5). A release freezes it; from then on the contracted commands are
  pinned (the one sanctioned back-compat, ADR-REPO-CONTRACT#3) and a signature change fails the frozen folder's test.

## 2. What exists (facts)

- Machine-readable description of a command outside its PowerShell source: **none**. Help is YAML in the file head
  (`catzc.config`, ADR-REPO-HELP) but holds parameter _text_ only; types, mandatory flags and defaults exist only in `param()`.
- `Catzc.Base.Contracts` has four kinds, picked by name alone (`Get-ContractAssetKind`): Presence, Fragment, Schema (`<path>.schema.json`),
  Sample (`<name>.sample.<ext>`). One findings function per kind. `Test-Contracts` is the gate. An unknown suffix today reads as a Fragment,
  so a `.command.yml` file added before the new kind exists would be mis-checked: add the kind first.
- Direction by convention (ADR-REPO-CONTRACT#7): an asset that constrains a real repo file is depended-on; a sample is provided.
  `contract.yml` overrides one asset. A command asset must be provided by convention (the kind decides), not by one override line per command.
- Layout `contracts/<unit>/<version>/<module>/<path>`, with `<path>` the real file's path under the module's target root, a per-module
  `target_roots` entry in `contracts.yml` (default: repository root).
- `cats` (importer.sh) passes every argument as a PowerShell single-quoted string; it knows nothing of a command's parameters. The `cats`
  output/exit-code contract exists only as ADR prose (ADR-AUTO-ENGINE#6).
- Idea only (eac, not an authority, ADR-REPO-INSPIRE): a closed, tiny type set (bool, string, int) for a command's flags; a closed verb
  list; an EBNF stating the command-line grammar. Catzc rebuilds these to its own rules.

## 3. Design

### 3.1 Placement: the name picks the kind, the folder picks the command

```text
contracts/catzc/0.0.0/Catzc.Base.Languages/Get-FileLanguage.command.yml
                      ^ owning module        ^ the command, by file name   ^ kind, by suffix
```

- Kind `Command` = suffix `.command.yml`. `<Verb-Noun>` is the command; the folder is the module that owns it. The real file is found by
  placement: `<module root>/<Verb-Noun>.ps1` (the public slot). **No target root and no `target_roots` line per module** (45 would be
  ceremony; ADR-AUTO-ZERO). `Get-PathModule` already knows each module's root.
- Rejected: `<Name>.ps1.command.yml` under a per-module target root (the survey's other option): it needs 45 `target_roots` entries to say what
  the module folder already says.
- Header comment per asset (ADR-REPO-CONTRACT#9): what the command promises that a signature does not (rare; a plain signature carries none).

### 3.2 The contract language (shape A, chosen)

```yaml
# contracts/catzc/0.0.0/Catzc.Base.Languages/Get-FileLanguage.command.yml
parameters:
  Path: string!                 # '!' = mandatory
  Strict: switch
  Engine: string = auto         # '= value' = default
  Item: string![] pipeline      # list; value comes from the pipeline
output: Catzc.Base.Languages.FileLanguage
errors: [PathNotFound]          # optional, named failure conditions
```

Grammar (EBNF; each parameter value is one string):

```text
spec    = type [ "!" ] [ "=" literal ] [ "pipeline" ]
type    = base [ "[]" ]
base    = "string" | "int" | "bool" | "switch" | TypeName      # closed set; TypeName = a Catzc.* type
output  = type | "void"                                         # default void
```

Defaults (ADR-AUTO-DEFAULT#6, declared once on the C# type `ContractCommand`): a parameter is optional unless `!`; a bare `switch` has no
default; output is `void`; errors empty. **Derived, never written** (placement says them): command name (file name), module (folder),
version (unit folder, `0.0.0` here), implementing language (the real file's language), engines (default: every engine, reached through
`cats` for the POSIX ones).

Why this shape: the survey compared three. B (a list of maps per parameter) is about three times the lines; C (one signature string per
module in a `commands.yml`) invents a larger grammar and breaks "one file per asset". A is the least ceremony, and a map keyed by parameter name
is order-free for the existing key-subset code. The cost is a mini-grammar per value; a JSON Schema for the file
(`command.schema.json`) validates each value with one regex, and one grammar is kept, no long form beside it (ADR-PRIN-ONELIVE).

Closed type set, on purpose: every checker (one per language) maps four base types and `Catzc.*` type names, nothing else. A richer type is
a decision for the contract-language ADR, not a value someone adds to a list (same stance as ADR-AUTO-ENGINE#1).

### 3.3 The check (a new checker, not a reuse of Fragment)

`Get-ContractCommandFindings` compares the contract with the command's real signature, **without importing the module**: parse the `.ps1`
AST (`[System.Management.Automation.Language.Parser]::ParseFile`), read the `param()` block and `[OutputType()]`. Findings:

| Finding | Meaning |
| --- | --- |
| command-missing | no public `Verb-Noun.ps1` in the module (or it is in `private/`) |
| parameter-missing / parameter-extra | the contract and the source disagree on the set (common parameters are ignored) |
| mandatory-mismatch, switch-mismatch, pipeline-mismatch | flag differs |
| type-mismatch | the declared PowerShell type does not map to the contract base type |
| default-mismatch | a constant default differs (non-constant defaults are reported as `computed`, not failed) |
| output-mismatch | `[OutputType()]` differs from `output:` |

Languages other than pwsh: the checker is a handler per language in `languages.yml` (the module-model plan, rule 6: operations are handlers by
language). Only `powershell` is built; any other language with a contracted command throws `NotImplemented` when configured, the pattern of
ADR-REPO-CONTRACT#8. Proven per engine (ADR-REPO-CONTRACT#8): for each contracted command, the engine's start resolves the command
(`Get-Command` through the engine's importer entry); a cheap L1/L2 test generated from the same enumeration as the checks.

### 3.4 Use (what makes it a language people _use_, not a document)

Each use is its own phase; none changes the contract file's shape.

1. **Reader:** `Get-CommandContract [-Name] [-Module]` returns typed `ContractCommand` objects (the C# type is the parser). One reader, no
   second parse anywhere.
2. **Reference:** `Build-ContractReference` already writes one page per unit listing assets; a Command row gets a signature column from the
   parsed contract. Nothing hand-written (ADR-REPO-CONTRACT#9).
3. **`cats` validates before it starts pwsh** (poka-yoke, ADR-PRIN-POKAYOKE): an unknown parameter, a missing mandatory one, or a value that
   is not an `int` is rejected in the POSIX shell with the contract's message, instead of failing after a pwsh start and an import (seconds).
   Needs the contract in a form bash/zsh can read without pwsh: a generated, committed lookup beside `importer.sh`, **unverified** whether
   that is one file per command or one file for all; decide in phase C5.
4. **Tests:** Go/Python black-box tests that call a contracted command take the call shape from the contract; a drift test fails when
   the contract changes and the test does not.
5. **Typed arguments across layers:** `cats` passes everything as a string today; with the contract it can coerce `int`/`bool`/`switch`
   correctly (a `switch` becomes a flag, not `-Strict 'true'`).

## 4. Phases (each file verified by its own tests before the next)

| Phase | Work | Output |
| --- | --- | --- |
| C0 | Settle Q-C1..Q-C6 (section 6). | decisions |
| C1 | ADR `ADR-REPO-CMDCONTRACT` (`docs/adr/repository/command-contracts.md`): rules 1 command contract (provided, a command is public exactly when named), 2 the contract language and its closed types, 3 derived facts, 4 one checker per language, 5 use (reader, reference, `cats`), 6 version and pinning. Amend `ADR-REPO-CONTRACT#6` (fifth kind), `#7` (direction by kind), and its enforcement list. Glossary entries: command, command contract, contract language, each with reciprocal contrasts (G1) and avoid-phrasings. `adrs.yml` registration, `Build-AdrIndex`, `Build-Glossary`. Docs only. | landed ADR |
| C2 | `Catzc.Base.Contracts`: `ContractAssetKind.Command`; one branch in `Get-ContractAssetKind`; C# `ContractCommand` + `ContractParameter` (parser, defaults on the type), L0 tests (neutral fixtures: widget/gadget, ADR-TEST#3); `Get-ContractCommandFindings` with L0 tests over fixture `.ps1` text; `command.schema.json`. C# edits need a fresh `pwsh`. | module change |
| C3 | Pilot contracts, provided, for a small coherent set: the 8 `Catzc.Base.Languages` commands and the 5 `Catzc.Base.Contracts` commands (self-hosting). One data-driven L1 test enumerates all `.command.yml` assets (the existing contract L1 test file generates one test per asset: extend, do not add a second). | 13 assets |
| C4 | `Get-CommandContract` reader; signature column in `Build-ContractReference`; `Test-GeneratedFiles` covers it. | reader + page |
| C5 | `cats` validation (3.4 item 3) and coercion (item 5): generator + committed lookup, edit through the `importer.sh` source in `Catzc.Base.RootConfig` (generated root file, never by hand), per-engine tests in `bash/tests` (bats) and the engine-case tables. | stricter `cats` |
| C6 | Widen: the 15 near-identical tool wrappers (`out/plan-help-registry-options.md`) as a second batch, since one family shares one grammar; then decide whether public means "contracted" for every module. | more assets |
| C7 | Other implementing languages: only when a real command exists in one (the ADRs make bash/go/python test artifacts today, ADR-AUTO-GO/PY/BASH). Until then `NotImplemented`. | none now |

## 5. Rules and traps to respect

- A contract asset is **bytes the check compares**: it is marked `catzc-contract` in `.gitattributes` so formatters leave it alone. No Format-Code
  pass may rewrite it (ADR-REPO-CONTRACT enforcement list).
- Released folders are frozen (`.frozen` SHA-256, `Publish-ContractRelease`). Pilot only in `0.0.0`.
- A signature change to a contracted command is now a contract change: the same commit edits the asset. This is the intended friction.
- The term collision: `ADR-AUTO-ENGINE#4` calls the env-var set a "black-box contract". After this plan "contract" means only the
  `contracts/` kind; reword the engine rule (name it the engine start environment) in C1, with its glossary avoid-phrasing.
- Do not store a version, a module, or a language in a command contract: placement says them (ADR-AUTO-ZERO, ADR-PRIN-CONFIG).
- Parallel sessions: `Catzc.Base.Contracts` had no dirty files in the 2026-10-16 status snapshot, but the repository has many sessions; message
  before touching a dirty file (memory: parallel-sessions).

## 6. Decisions (all accepted as recommended on 2026-10-16)

- **Q-C1** Placement: `<Module>/<Verb-Noun>.command.yml`, module folder as the command's owner (recommended) or `<path>.command.yml` under a
  per-module target root.
- **Q-C2** Grammar: shape A, one string per parameter (recommended); B or C rejected in 3.2.
- **Q-C3** Type set at `0.0.0`: string, int, bool, switch, `Catzc.*` type, `[]` (recommended). Add `path` (a string that is a repo path,
  ADR-AUTO-PATH) now or later? Recommend later: PowerShell cannot tell the two apart in an AST, so the checker could not prove it.
- **Q-C4** "Public equals contracted": only the pilot set at first (recommended), widening in C6. Alternative: contract all 439 at once (a
  generated first draft from the AST, then reviewed). Large, and it freezes things nobody chose to promise.
- **Q-C5** `cats` validation in C5 or never: recommend yes, it is the main reason the language is _used_; it costs one committed lookup.
- **Q-C6** Is `errors:` in `0.0.0`? Recommend no (cannot be checked from the AST; add when a checker exists), which keeps the language smaller.

## 7. Missing work before C1 (a read-only prepare pass)

1. Read `Get-ContractAssetKind`, `Get-ContractCheckResults`, `ContractAsset*` types, `Test-Contracts` tests to size C2 (survey read the names,
   not the bodies).
2. Confirm what `Test-Contracts` reports for an unknown suffix today (**unverified**).
3. Read `ADR-AUTO-ENVVAR`, `ADR-AUTO-DEFAULT`, `ADR-REPO-HELP` in full and `docs/adr/repository/controlled-vocabulary.md` rules for the new terms.
4. Decide with the module-model plan whether handlers-by-language live in `languages.yml` (its Q-F), since C2's checker registers there.

## Carried: out/plan-rename-worklist.md (verbatim, absorbed 2026-10-16; headings below are the draft's own)

# Rename worklist: every use of "automation", classified, with its disposition

Evidence appendix to [plan-automation-layers-rename.md](plan-automation-layers-rename.md). Compiled on 2026-10-16 from six read-only surveys
(`out/survey-rename-{code,adrs,docs,edges,vocab-generators}.md`, `out/survey-layers.md`); counts are matching lines or files from ripgrep and are
approximate on class totals (classified by pattern), exact on the named definitions. `<TRACK>` is the new folder name: **`pwsh`** (Q1, decided
2026-10-16; the other decisions are in section 8 of the master plan). Re-measure after the funnel phase: its whole point is to shrink these numbers.

## 1. The senses of the word

| Sense | Example | Disposition |
| --- | --- | --- |
| **S1 track folder** | `automation/`, `track: automation`, globset `automation`, `docs/references/automation/` mirror, `.catzc/automation/`, `out/automation/built` | **rename to `<TRACK>`** |
| **S2 ADR domain / row** | `docs/adr/automation/`, code `AUTO`, `ADR-AUTO-*` (about 10,450 occurrences), `adrs.yml` domain `automation`, stack row `AUTO` | **keep** (automation is the abstract term) |
| **S3 value-chain concern** | `concern: [automation, ...]`, `AdrsConfig.Concerns`, `ADR-DSGN-TRACK#15` | **keep** (Q-L4) |
| **S4 pwsh implementation** | `Get-AutomationModules`, `-AutomationRoot`, "the automation modules", "PowerShell automation" | **rename** to the module/track word |
| **S5 the test runner** | `Test-Automation` and 16 helpers, `test-automation/` output folder | **keep** (Q3): it tests the automation across languages and engines |
| **S6 unit / pipeline names** | `ci-automation`, `ci-automation-expected-failures`; `invoke-automation`, `release-automation` | rename the first two with the globset (late wave); keep the other two |
| **S7 engine value `auto`** | `ADR-AUTO-ENGINE#7`, Engines glossary | **keep** |
| **S8 not our word** | `System.Management.Automation` (140), "deployment automation", CAF/WAF/DORA titles (about 215 ADR lines), "Cloud Automation Toolkit" (Catzc's product expansion), Exporter `-Version auto`, `Get-AutoControlledGlobs` | **never sweep** |

## 2. Scale (hand-written tracked files; generated files follow their sources)

- 4,591 tracked files: docs 2,412, automation 2,028, infrastructure 43, .claude 26, bash 23, .unordered 20, contracts 15, pipelines 13, rest small.
- Generated ("product", head has `generator:`): about 1,088 files (1,083 comment pages under `docs/references/**` from `Export-Comments`, plus
  `docs/adr/index.md`, `docs/adr/glossary.md`, `importer.ps1`, `.gitignore`, `.vscode/*`, `go.work`/`go.mod`, `pyproject.toml`, the contracts reference).
  The meta heads (`catzc: derived:` with `path`, `track`, `module`, `relatives`) of about 4,600 code/doc files are rewritten by `Format-FileMeta`.
- Inside `automation/` (excluding `.vendor`): 1,819 files / 7,586 lines hold the word; about 5,400 lines are derived heads (not hand work).
  Hand lines: S1 about 1,370 (330 files), S2/S3 about 420, S4 about 680 (160 files, 472 of them the `Test-Automation` family = S5), S6 21, S7 3, S8 about 160,
  citations 1,546 mentions.
- Docs outside `docs/adr`: 2,214 files (1,083 generated, 1,131 hand: 864 are `.assets` diagram files and sidecars). 267 real prose files; 200 of them
  hold 1,937 hits, 79% paths. Four folders named `automation`: `docs/references/automation` (1,093 files, 1,037 generated), `docs/explanation/automation`
  (32), `docs/how-to/automation` (14), `docs/how-to/getting-started/automation` (16). 330 hand link targets contain the word, 217 of them into
  `docs/adr/automation` (S2, stay). `docs/references/automation/` is linked from 2,216 files (mostly derived `page:` heads).
- ADRs outside `docs/adr/automation/`: 994 hand lines: 325 domain links + 163 code citations (S2, stay), about 160 track paths (S1), about 215 S8,
  16 pipeline names (S6), 56 "PowerShell automation" phrases + 46 command names (S4/S5).
- Outside `automation/` and `docs/`: 131 tracked files, about 75 unit-name hits, 6 load-bearing trigger paths, 10 csproj paths, 1 importer path.
- `.unordered/`: 20 files, 188 hits. Frozen shelf (`ADR-DSGN-TRACK#17`): never touched.

## 3. Single sources to edit first (data), then regenerate

Bootstrap constants (cannot be derived; read before any registry loads), to be reduced by the funnel phase to the smallest set:

| Place | Fact |
| --- | --- |
| `automation/.internal/Catzc.Internal.Importer.psm1:71,208,212,218` | `$automationFolder = 'automation'`, `.catzc/automation` |
| `importer.ps1:37` (generated by `New-Importer.ps1:61,97,110` from the psm1) | `Import-Module (Join-Path $PSScriptRoot 'automation/.internal/Catzc.Internal.Loader.psm1')`: if stale, nothing loads |
| `Catzc.Base.Timeouts/types/BashSafeguard.cs:29`, `Catzc.Base.Globs/types/GlobsConfig.cs:33` | C# path constants for `timeouts.yml` and `globs.yml` (the Bash hook program has no importer) |
| `.claude/hooks/Assert-BashTimeout/Assert-BashTimeout.csproj:27-39` | 9 linked sources + YamlDotNet HintPath under `../../../automation/` |
| `Catzc.Internal.Builder.psm1:173,222,266-278,374,403-442,755,762`, `Catzc.Internal.TestKit.psm1:39,79,104`, `Bootstrap.psm1:508` | folder literals |

Data registries (the "single source" set; edit each file once, then regenerate):

| Registry | Where | Edit |
| --- | --- | --- |
| track | `Catzc.Base.Variants/configs/variants.yml:23` (aspects), `:31` (`tracks.automation: {root: automation, class: core, languages: [...]}`) | rename key and root together; the key is what every head's `track:` prints. After [plan-config-defaults.md](plan-config-defaults.md) Phase 2 the file no longer exists in `automation/`: the edit moves to `.catzc/<track>/Catzc.Base.Variants/configs/variants.yml` |
| module placement | `module-types.yml:18,20,21,25` | roots |
| globset | `Catzc.Base.Globs/configs/globs.yml:17-22` (`automation`, `pipeline: ci-automation`) | key + include + pipeline (S6, late) |
| file kinds | `file-kinds.yml:44,50,53,56,59,62,63,66,72,85,97` | 11 globs |
| comment pages | `Catzc.Base.QualityGates/configs/comments.yml:36-47`; `CommentsConfig.cs:62,65` (second copy) | source -> docs mapping |
| readme mapping | `Catzc.Base.Docs/configs/readme.yml:17-18` | `glob: automation/*` -> `docs/references/automation/{kebab}.md` |
| file meta | `file-meta.yml:57,77-78` | generator path, relatives patterns |
| contracts | `Catzc.Base.Contracts/configs/contracts.yml:20` | target root of `Catzc.Base.Globs` |
| root config | `Catzc.Base.RootConfig/configs/rootconfig.yml:18-133` (about 40 source paths) | source column |
| gitignore / vscode | `Catzc.Base.Git/configs/gitignore.yml:55,57,90,99,100`; `Catzc.Base.VSCode/configs/vscode-settings.yml:44,61-66` | patterns |
| languages | `languages.yml:21-68` (tool config paths), `:79,103,115,120` (`adr_folder: automation/BCL|python|go|bash` = S2, stays) | paths only |
| reports | `Catzc.Base.Reports/configs/output-formats.yml:36,66,72` (`test-automation/`, S5 stays), `:77-101` (`automation/built`, `automation/packages`) | build output folders (Q6) |
| other | `source-conventions.yml:18`, `links.yml` (18 per-file keys), `terminology.yml:36`, `build-validation.yml:18` (`globset: automation`), `exporter.yml:45` (`- automation` globset), QualityGates `glossary.yml:101` | patterns |
| overlay | `Get-CatzcOverlayRoot.ps1:19,44` (`.catzc/automation`), `Get-Config.ps1:35` doc | consumer-facing (Q5) |
| ADR registry (S2, stays) | `adrs.yml:115-126,164-174`, `adr-checks.yml:17`, `AdrsConfig.cs:43` | unchanged |

Keeping the track **key** `automation` while changing only `root` is possible (they are separate fields) and would make most heads unchanged,
but leaves `track: automation` meaning "the pwsh track", which is the confusion being removed. Rename both.

## 4. Code that bypasses the registry (funnel worklist)

About 45 non-test sites re-spell the folder instead of calling `Get-CatzcModulesRoot` / `Get-Track`. Each moves onto the resolver in the funnel phase,
one file at a time, tests run per file:

Globs `Get-ModuleGlobSet.ps1:68,82,122,124,169`; ModuleSystem `Get-BaseModule.ps1:94`, `Get-InternalAssetDependency.ps1:109,114`,
`private/Get-UncoveredInternalAssetDependency.ps1:52`, `Test-FolderConventions.ps1:58`, `New-Importer.ps1:61,97,110`; Variants `Get-Aspect.ps1:44,49,62`
(`$Track = 'automation'`), `Get-CatzcBundleFileMetaFact.ps1:63`, `Get-VisibilityFileMetaFact.ps1:23,51`; Repository `Get-CatzcRunMode.ps1:38`;
QualityGates `Format-Types.ps1:82`, private `Get-AutomationSourceFiles:31`, `Get-CommittedTypesDrift:39`, `Get-FixtureIdentityTokens:56`,
`Get-GuidScanFiles:42`, `Get-LanguageTestFolders:71`, `Get-ScriptAnalyzerInputs:62-63`, `Get-TestAutomationTestPaths:48`, `Get-TestFileModule:41`,
`Get-TestRunContext:77`, `ConvertTo-PesterRunTarget:64`, and `Test-{BuildArtifact:97, ConfigIdentityHygiene:73, GeneratedFiles:117-120, InIsolation:119,
LogicTestIdentity:74, ManagedGuids:60, ManualTestPlan:61, ParameterConsistency:56,71, ShellScripts:66, SourceConventions:81, Terminology:69, TestTitles:54}`;
Docs `private/Get-CatsRuleEnforcers.ps1:80`; Git `private/Get-AutoControlledGlobs.ps1:64`; Tooling.KeyHandler `Save-PSReadLineKeyHandlerSet.ps1:45`;
Exporter `Build-Modules:96`, `Export-Catzc:87`, `Install-Catzc:71`; Timeouts `Invoke-WithTimeout.ps1:77`; analyzer rules (`.scriptanalyzer/`)
`NoEnvRepositoryRoot:33`, `NoScriptRootAnchor:33`, `ParameterDesign:25`, `SpellOutIdentifiers:31,32,41` (regex `/automation/[^/.][^/]*/(private/)?[^/]+\.ps1$`);
`Catzc.Internal.{Builder,TestKit,Importer}.psm1` as above. The `$automationRoot` local appears in about 18 files (mostly joining the literal).

Tests bake the literal in fixtures (`<root>/automation`, `.catzc/automation`, `C:\repo\automation\Widget\...`): about 100 of 754 files with the word assert on it.
The funnel phase converts fixtures to a root built from the resolver or a neutral fixture root; the rest are edited in the flip wave.

## 5. Identifiers (S4 renames; S5 kept)

| Identifier | Defined in | Mentions / files | Proposed (confirm in the module-model plan) |
| --- | --- | --- | --- |
| `Get-AutomationModules` | Catzc.Base.TypesSystem | 44 / 14 | removed by the module model (`Get-CatzcModule`); if that is not yet built, `Get-ModuleFolder` |
| `Get-AutomationFunctions` | Catzc.Base.ModuleSystem | 13 / 2 | `Get-ModuleFunction` |
| `Get-AutomationSourceFiles` (private) | Catzc.Base.QualityGates | 7 / 3 | `Get-ModuleSourceFile` |
| `Copy-Automation` | Catzc.Base.ModuleSystem | 31 / 8 | **read first** (what it copies decides: `Copy-Modules`?); `terminology.yml:195` names it as a files.yml package name |
| `-AutomationRoot` / `$AutomationRoot` | 5 functions, 22 files | 64 + 41 | `-ModulesRoot` (matches `Get-CatzcModulesRoot`) |
| `$automationRoot`, `$automationFull`, `$automation`, `fake.Automation` | locals / fixtures | about 60 | `$modulesRoot` etc. |
| `Test-Automation` + 16 `*TestAutomation*` helpers + `test-automation/` out folder + `catzc-test-automation-` temp prefix + `Title = 'Test Automation'` | QualityGates, Reports | about 470 lines | **keep** (S5) |

A function rename is a file rename (one function per file) plus its test file plus every call site: one function at a time.

## 6. Edges (outside `automation/` and `docs/`): same-change hazards

1. `.claude/hooks/Assert-BashTimeout/*.csproj` 10 paths. A failed hook rebuild leaves `bin/Assert-BashTimeout` missing and `settings.json` then exits 1:
   **every Bash call is denied**. `source.sha256` (gitignored) hashes these paths, so the first import after the move triggers a rebuild. **Unverified:**
   whether a failed rebuild removes the old binary. Test on a copy first; keep the session that performs the flip free of needing Bash during it.
2. `importer.ps1:37` (and its generator's constant): if stale nothing loads, in any session or CI.
3. CI triggers fire silently never if stale: `.github/workflows/ci-automation.yml:23,26`, `pipelines/ci-automation.yaml:20,26`,
   `pipelines/ci-automation-expected-failures.yaml:20,26` (`paths: [automation/**]`). Their depended-on contract assets pin the file **names**, so renames move
   the fragments together: `contracts/catzc/0.0.0/Catzc.Tooling.Github/workflows/{ci,release}-automation.yml`, `Catzc.Azure.DevOps/pipelines/ci-automation*.yaml`.
4. Other contract assets: `Catzc.Base.Globs/configs/file-kinds.yml:1` (header), `Catzc.Base.QualityGates/head.sample.yml` (`track: automation`, 2 paths),
   `head.schema.json` (check the `track` pattern).
5. `.claude/agents/catzc-worker.md:73-78` (shared-file list: a stale path silently stops protecting), `test-optimization.md:31,39,46`, `session-cost-audit.md:74`,
   `.claude/CLAUDE.md` (lines 18,19,22,46,49,52-54,62,79,82,85,98,100,132), `.claude/drawio/minimaps/render.py:267-268,349,364`, `describe.py:43-44,291`,
   `STYLE.md:171,229,245,294,305,581`.
6. Generated root files must land in the same change (regenerate, never hand-edit): `.gitignore`, `.gitattributes` (`automation/.compiled/** binary`,
   `linguist-generated`, `automation/.vendor/** linguist-vendored`, the `catzc-meta` exemptions; a stale `.compiled` pattern can text-convert the committed DLL and
   break its byte-exact hash), `importer.ps1`, `importer.sh` prose, `.cspell/*`, `.gitkeep` heads, `go.work`, `go.mod`, `pyproject.toml`; untracked but regenerated
   on import: `.vscode/*`, `cspell.yml`, `catzc.sln` (`automation\.internal\assets\Catzc.Types.csproj`).
7. `README` badge `.github/README.md:13` and external bindings outside git: Azure DevOps pipeline definitions point at `pipelines/ci-automation.yaml`;
   GitHub required checks. Only the pipeline rename (S6) touches these.
8. Step template `pipelines/steps/invoke-automation.yaml` has 60 references: **kept** (S6), so no change.
9. `infrastructure/`, `bash/`, `go/`, `python/` hold no folder path (they go through the root importers); only two prose links into `docs/references/automation/`.

## 7. ADR rules that state the folder as a fixed fact (edit once each, cited by code)

`ADR-DSGN-TRACK` 1, 2, 3, 5 (and context lines 57, 199, 209, 225, 248, 302, 325); `ADR-DSGN-RUNMODE` 1, 4, 6, 7; `ADR-DSGN-ASPECT` 3, 5; `ADR-REPO-FOLDERS` 4
(48 hits: root table row 268, Level 2 section 359-434, 457, 476); `ADR-REPO-FILEMETA` 12; `ADR-REPO-CODEMETA` 2 (examples 112, 128); `ADR-AUTO-BUNDLE` 1 (and 139,
164, 178, 186); `ADR-AUTO-OVERLAY` 2, 3, 9 (and 125-126, 168); `ADR-AUTO-PARITY` 1 ("The `automation` track is a CLI"); `ADR-AUTO-DEPS` 1
(`tools.yml` fixed path); `ADR-REPO-CONTRACT` 2 and its layout example (pipeline names only). Plus about 160 path lines across `azure/`, `configuration/`, `flow/`,
`pwsh/` (`module-config-loading.md:37,89`, `azure-data-model.md:131`, ...). `ADR-DSGN-TRACK` 14 and 15 name S2/S3 and **stay**.

## 8. Docs (hand-written), by what to do

- Generated and follow their sources: `docs/references/automation/**` (1,037 of 1,093) via `comments.yml` + `readme.yml` + `Export-Comments`; every `page:` head.
  The folder must be moved (`git mv`) before regenerating so pages regenerate in place (the writer removes only pages it wrote).
- Hand pages inside it (56) and the other three `automation` doc folders (62 files): classify page by page (a worker table): pwsh-track topic -> move to
  `<TRACK>`, abstract topic -> keep the name (it is S2). `docs/how-to/getting-started/automation/faq.md:105-111` is real S4 prose.
- Link rewrite: 330 hand link targets with the word; 217 stay (S2); about 113 follow the moves.
- `docs/.assets`: 864 files; 12 diagram PNG names contain the word; up to 119 of 160 diagram sidecars embed it; minimap sidecars carry 26,430 hits (path lists).
  Diagram text is changed only by `write-drawio-files` (it re-renders the raster from the edited XML); minimaps rebuild from the kit. **Nothing is rendered
  without the user's go** (memory: render-nothing-without-asking).
- `docs/index.md` (hand-written, 112 hits), `docs/adr/README.md` (52, 35 domain links), `.github/README.md`, `contracts/README.md`.

## 9. Generators to run after the sources change, in this order

`Build-RootConfig` (importer.ps1, .gitignore, .gitattributes, vscode, go, python, cspell) -> `Format-FileMeta` (heads) -> `Export-Comments` + `Build-CommentView`
-> `Build-Readme` -> `Build-AdrIndex` -> `Build-Glossary` -> `Build-TerminologyDictionary` -> `Build-ContractReference` -> `Test-GeneratedFiles` (verifies all
registered writers in dry-run). Generators with the folder hard-coded in their **own** source (fix before running): `Build-AdrIndex.ps1:267`,
`Build-TerminologyDictionary.ps1:110`, `Build-EnglishDictionary.ps1:132`, `Test-GeneratedFiles.ps1:117,120`, `New-Importer.ps1`, `Format-Types.ps1:82`,
`Get-ReadmeMappings.ps1:67`, `Build-Readme.ps1:83` (comment), `Sync-GeneratedFile` help and `gitignore.yml:87-90` (`automation/.compiled`),
`Build-Modules:96`, `Export-Catzc:87`, `Install-Catzc:71`.

## 10. Do-not-sweep list

`System.Management.Automation` (140), `NoAutomaticVariableMisuse.psm1`, CAF/WAF/DORA titles and anchors (`#deployment-automation`,
`platform-automation-and-devops.md`, 94 hits), "Cloud Automation Toolkit", Exporter `-Version auto`, `jidoka`, `.markdownlint.yml` "auto-enable",
`Get-AutoControlledGlobs` (name keeps "Auto"; prose "the automation itself" there means the tooling: reword, do not rename), `docs/adr/automation/**` paths and
`ADR-AUTO-*` codes, `.unordered/**`, `docs/references/pipelines/*automation*` pages until S6.
