---
plan:
  status: active
  value: high
  reviewed: 2026-10-18
  waits_on: P6 pipeline renames wait for the user's go, the same day the user re-points Azure DevOps and GitHub
  targets: [pwsh, docs/adr/automation, docs/adr/repository, contracts, pwsh/Catzc.Base.Docs/configs]
---

# Automation is the abstract term; the PowerShell track is named pwsh; public commands get contracts

Three drafts form one series: the master plan and rename, the layer model with its vocabulary and ADRs, and command contracts with the
contract language. A fourth file is the evidence worklist, every use of the word classified with file and line. Every decision is made
(2026-10-16). P0 to P4 have landed: `automation/` is `pwsh/` since 2026-10-18. P5, P6 and P7 are open.

## Why its value is high

It fixes what automation, language, engine, importer, command and contract mean across every file, and makes contracts/ the only public API
by naming which of the 439 public functions are contracted. Every later plan speaks this vocabulary.

## Decided, and why (all took the recommendation, 2026-10-16)

- D10 (2026-10-18): P4, the folder move, held until task-module-model-closeout and task-layers-funnel were green; the user named the quiet
  window and the move landed the same day.
- Q1 folder and track are pwsh; rejected powershell, modules, catzc. A track is named by its stack, parallel to go, python, bash.
- Q2 keep invoke-automation.yaml and release-automation.yml: they invoke and release the automation, the abstract thing.
- Q3 keep Test-Automation, its 16 helpers and test-automation/: the name is already accurate; a 470-line rename buys nothing.
- Q4 other automation doc folders are classified page by page: a pwsh topic moves, an abstract topic stays. docs/adr/automation stays.
- Q5 consumer overlay becomes .catzc/pwsh/\<Module>/ with no fallback (one living version); consumer-visible, note it for the release. This
  repo's own .catzc/\<track>/ is also a source-mode config-fragment root (config defaults plan), so P4 renames the folder only.
- Q6 build outputs become out/pwsh/built and out/pwsh/packages.
- Q7 Edit tool only, one file at a time, each verified; no permanent rename tool.
- Q8 the module model lands first: it deletes Get-AutomationModules and Get-BaseModule and gives the one resolver; then P2, then P4.
- Q9 command contracts as plan 3 wrote them: `<Module>\<Verb-Noun>.command.yml`, grammar shape A (one string per parameter), closed type
  set, pilot set first, cats validation in C5, no errors key in 0.0.0 (Q-C1 to Q-C6 as recommended).
- Q10 concern automation and value-chain row AUTO keep their names; ADR-AUTO-\* is never re-coded (about 10,450 citations).
- Q11 bash, python and go stay test-artifact languages; the importer throws NotImplemented for any other configured language.
- Layer plan Q-L1 to Q-L5 as recommended. Late rename at P6: ci-automation, ci-automation-expected-failures and the globset; the user
  re-points the Azure DevOps and GitHub bindings outside git.
- Questionnaire round 2026-10-16 (Q22 to Q26, Q38): the user names the quiet window for P4 and runs the move; P8 diagrams are out of this
  plan (render nothing unasked); the session proposes the command-contract pilot list for approval (the cats entry point's commands the
  likely answer); the externally bound pipeline names are re-pointed the same day as P6; the planner re-points the prompts' out/ paths; P1
  (docs and glossary) runs beside the module model, code phases wait.
- The cats and catzc names are ruled by a new ADR-PRIN-CATS (plan-adr-cats); pwsh and automation stay strictly apart from it (F1): the folder
  rename is technical, automation is a subject and the big cross-cutter with design principles and pipelines, so ADR-AUTO-LAYERS rules those
  two names and the glossary terms pwsh and automation come from it.
- ADR-PRIN-CATS is written (2026-10-17, docs/adr/principles/cats-and-catzc.md): cats (ADR-PRIN-CATS#2) and catzc (ADR-PRIN-CATS#1) are glossary terms from
  it, so the layers glossary list excludes them and ADR-AUTO-LAYERS cites them where it needs the names.
- Public API (F6, S5): most of the 439 public functions become internal; the pilot contracts are hand-written; generating a contract from
  the ADR that defines it is a direction tried on the second set.

## Done, and why

- The master plan carries a status line (`<TRACK>` means pwsh), section 8 rewritten as decisions, the Q1 map row marked decided, so a fresh
  session never re-asks.
- The two companions each carry a "Decided 2026-10-16" line and their question sections are retitled as decisions.
- The worklist fixes `<TRACK>` to pwsh. The module-model and k8s plans carry a sequencing note (see plan-module-kinds-tracks).
- The note was copied to the user's memory file.

## Needed docs

- ADR-AUTO-LAYERS, ADR-AUTO-IMPORTER, ADR-REPO-CMDCONTRACT, all new.
- Glossary: automation, importer, command, bare engine, language, module, role, run mode, command contract, contract language, layer.
  Avoid-phrasings for the new meanings now, for the retired folder meaning at P6.
- languages.yml top-level engines renamed formatters; adrs.yml layer key; the four term collisions (tracks.md:209, tracks.md:57,
  ADR-AUTO-ENGINE#4, engines:); docs/references mirror follows the folder; Test-AdrEngineNeutrality extended so AUTO ADRs carry no pwsh
  syntax.

## P0 baseline (2026-10-17, layers doctrine)

- Test-GeneratedFiles: `[Write-QualityGateReport] No generated-files issues found.` (`out/test-generated-files/20261017-183227`).
- Test-Contracts: `[Write-QualityGateReport] No contracts issues found.` (`out/test-contracts/20261017-183223`).
- Test-Links: 2 issues (`out/test-links/20261017-183225`): one `[Untracked]` link from the automation index to the new, uncommitted
  catzc-base-modules.md page, and one `[Citation]` in plans.yml, a bare `ADR-REPO-PLANS` in a comment, fixed in the same hour
  (`out/test-links/20261017-183621` clean on the file).
- Test-WorldMap: 2 issues outside this plan (`out/test-world-map/20261017-183226`): a stack violation, `.claude/drawio/drawio.yml` is a yaml
  file in the `.claude` track whose languages are markdown only (ADR-DSGN-TRACK#3), and an undeclared root folder, `.vscode/` holds 3
  tracked files and no track names it (ADR-DSGN-TRACK#1). Both are peers' work of the same day.
- Edge fact, read from `Build-BashTimeoutHook` and the hook janitor of `Catzc.Internal.Importer.psm1`: a failed hook rebuild does not delete
  the published binary. Nothing removes `.claude/hooks/bin/` before `dotnet publish`, which only overwrites its output when the build
  succeeds, and the janitor wraps the build in try and catch and prints the failure in red. A Bash call stays available on the previous
  binary; a missing `dotnet` throws before any write.
- Known unrelated reds at the time: Test-Spelling 5, Test-Glossary 236 (G4 and G6, listed per file in plan-clear-actions), Test-Formatting
  on `.compiled/*.json`, Test-ScriptAnalyzer about 37, Test-Comments 11 (listed in plan-module-model-closeout).

## P7 prepare (2026-10-17, task-command-contracts)

- C2 sizing, read from the module: `Get-ContractAssetKind` picks one of four kinds from the name alone, `Resolve-ContractAsset` derives
  target and direction from the kind (a sample has no target and is provided; every other kind targets `<target root>/<path>` and is
  depended-on), `Get-ContractCheckResult` switches on the kind and throws for a kind no check covers, and `ContractAsset`'s constructor
  demands a target for every kind but Sample. A fifth kind touches those four places, and the command asset's target is the command's source
  file under the module's root, which `Resolve-ContractAsset` cannot derive from a target root alone.
- Unknown suffix, on a copy: a `Get-Thing.command.yml` under a unit's draft reads as
  `kind=Fragment direction=DependedOn target=Get-Thing.command.yml`, and the check fails it with
  `the target 'Get-Thing.command.yml' does not exist: the repository root holds no 'Get-Thing.command.yml'.`
  (`out/t020-unknown-suffix.ps1`). The kind lands before any asset.
- Handlers by language (task-module-model-closeout step 3): the checks of a changed file are resolved through the registry, `languages.yml`
  `checks:`, and the tests side still branches on the language, whose funnel follows D03. The command checker therefore registers nothing in
  `languages.yml` in C2: it selects by the command's file language, builds the PowerShell checker, and throws NotImplemented for any other
  language; the registry key for it is D03's scope.
- Correction (C1, read from `ContractSchema`): the bounded JSON Schema subset has no `pattern` keyword and takes `additionalProperties` as a
  boolean only, so a `command.schema.json` cannot hold the value grammar. The `ContractCommand` type is the one grammar (ADR-PRIN-ONELIVE),
  a value that does not parse is a finding, and no schema asset is written in C2.

## Needed tests

- Test-Glossary, Test-AdrRegistry, Test-Terminology clean on touched files (P1 stop).
- A guard rule against track-root literals keeps the folder literal funnelled (P2 stop).
- Test-Contracts covers command contracts as the fifth asset kind; what it does with an unknown suffix is settled on a copy first.
- P0 baseline, recorded in the background: Test-GeneratedFiles, Test-Links, Test-Contracts, Test-WorldMap pass today. Known unrelated reds:
  Test-Spelling 5, Test-Glossary G4, Test-Formatting on .compiled/\*.json, about 37 Test-ScriptAnalyzer.
- Edge fact on a copy: does a failed hook rebuild delete the existing Assert-BashTimeout binary.

## Order of work (from the continuation prompt)

1. Module model first (plan-module-kinds-tracks): its prepare prompt runs in a separate fresh session; no code below changes before it is
   implemented.
2. P0 baseline and the two checks on a copy.
3. P1 doctrine and vocabulary, docs and glossary only.
4. P2 funnel: one bootstrap constant, about 45 sites onto Get-CatzcModulesRoot and Get-Track, S4 identifiers renamed, guard rule.
5. P3 docs classified page by page, then P4, the folder move, in the user's quiet window. Both landed 2026-10-18.
6. P5, P6 and P7 follow. P8 is dropped (Q23).

## Open steps

- [x] The scratchpad copy and the paste of the continuation prompt are superseded: the task files of plan-master (layers doctrine,
      task-layers-funnel, task-layers-classification-flip, task-command-contracts) carry this plan's phases, and the module model landed
      first (2026-10-17).
- [x] P0 baseline and the two reads, recorded above (2026-10-17, layers doctrine).
- [x] P1 doctrine and vocabulary. Done 2026-10-17 (doctrine): ADR-AUTO-LAYERS (7 rules) and ADR-AUTO-IMPORTER (5 rules) written, registered
      with a `layer` key per automation ADR (AdrsConfig validates the five layers, default automation), dora-explains entries; glossary
      terms automation, command, implementation language, pwsh (Docs), importer (ModuleSystem), run mode (Docs, bolded in
      ADR-DSGN-RUNMODE#1), engine start environment (Engines, bolded in ADR-AUTO-ENGINE#4, avoid "black-box contract"), the layer family
      gains contract, engine, importer and the code segment AUTO; the four collisions: tracks.md lines 65 and 227 reworded,
      ADR-AUTO-ENGINE#4 and its section renamed in the engine ADR and the three test-artifact ADRs, `languages.yml` `engines:` renamed
      `formatters:` with LanguagesConfig, Format-Code, the root-config generator and their tests; Test-AdrEngineNeutrality gained the
      pipeline and item cmdlets and the engine's common parameters as tokens. Check: Test-AdrRegistry, Test-AdrEngineNeutrality,
      Test-Terminology clean; Test-Glossary reports no finding on the touched files (verdicts in the git history of the layers doctrine task
      file, deleted as done).
- [x] P2 done 2026-10-18 (task-layers-funnel): the NoTrackRootLiteral guard reports one file over 1,641 tracked PowerShell files, the orphan
      root-config `importer.ps1` template listed for the user's delete; Test-GeneratedFiles 0 issues, as at the P0 baseline.
- [x] P3 done 2026-10-18 (task-layers-classification-flip steps 1 and 2): the classification table in section 8, the wording drafts in
      section 7.
- [x] P4 on the user's go (check: full baseline green again). Done 2026-10-18: `automation/` is `pwsh/`, the baseline gates are green apart
      from the staged build output the user unstages (verdicts in task-layers-classification-flip steps 3 to 5). P5 to P8 per the master
      plan.
- [ ] P7 command contracts, task-command-contracts: C1 the ADR, C2 the kind and checker, C4 the reader and the signature column landed
      2026-10-17, C3 the pilot set landed 2026-10-18 (12 command assets, Test-Contracts clean; three commands outside the contract language
      wait for C6; verdicts in task-command-contracts), C5 the `cats` lookup and its checks landed 2026-10-18 (`importer-commands.sh`
      generated by New-CatsCommandLookup, six cats.bats cases pass), the C6 widening landed 2026-10-18 (the fifteen installers, 27
      contracted commands, Test-Contracts clean), and F6 under D21 the same day (internal is internal to its module: the uninstall and
      remove family contracted, 52 commands; two helpers moved to `private/`; verdicts in task-command-contracts). Open: the user's call on
      twelve exported functions nothing calls and on the 139 only docs name (check: Test-Contracts clean on the frozen set).
- [ ] P6 also retires the old layer forms `automation`, `PowerShell` and `implementation` from the layer family and adds the avoid phrasings
      "the automation folder", "automation modules" and "the loader": 68 pages say "automation layer", "implementation layer" or "PowerShell
      layer" today (pipelines/custom-template-discipline.md 15, docs/index.md 13, the pwsh ADRs most of the rest), so the retirement waits
      for the flip (check: Test-Glossary clean after the rewording).
- [ ] The ADR-AUTO-LAYERS rule 2 wording "the file languages its track declares" stands in for the `executable` flag of Q-L1, which is a
      LanguagesConfig key and so P2 or L3 code, not P1 (check: the flag exists and rule 2 names it).

## Stop and ask when

- A plan fact is contradicted by the tree: record the correction in the plan and say so.
- A step needs an unsettled decision, any mutating git, or an external binding.

## Refs

- what is still open from the four drafts (the master, the layer model, the command contracts, the rename worklist) is carried below; their
  full text is in git
- memory: automation-layers-rename-plan.md

## Carried: what is still open from the four drafts (absorbed 2026-10-16, trimmed 2026-10-18)

The drafts' P0 to P4 work, the rename map, the funnel worklist, the S4 identifier renames, the P3 classification table and wording drafts,
the vocabulary and ADR work of L1 and L2, and the command-contract design of C1 to C6 are in the tree; the full text is in git. What is
still open follows, verbatim where it was carried.

### From the master draft: P6 Pipeline and unit names (late, separate, externally bound)

`ci-automation` -> `ci-<TRACK>`, `ci-automation-expected-failures` -> `ci-<TRACK>-expected-failures`, globset and `pipeline:` key, the
workflow and pipeline files, their contract fragments (file-name keyed), `docs/references/pipelines/*`, the README badge,
`Test-GitHubWorkflowTriggerGlob` examples, `Register-AdoPipeline` examples. **Outside git, by the user**: re-point the Azure DevOps pipeline
definitions, GitHub required checks, any bookmark. `invoke-automation` and `release-automation` stay (Q2). One atomic set, then verify
triggers fire.

Edges for P6, from the worklist (section 6):

- CI triggers fire silently never if stale: `.github/workflows/ci-automation.yml`, `pipelines/ci-automation.yaml`,
  `pipelines/ci-automation-expected-failures.yaml`. Their depended-on contract assets pin the file **names**, so renames move the fragments
  together: `contracts/catzc/0.0.0/Catzc.Tooling.Github/workflows/{ci,release}-automation.yml`,
  `Catzc.Azure.DevOps/pipelines/ci-automation*.yaml`.
- `README` badge `.github/README.md` and external bindings outside git: Azure DevOps pipeline definitions point at
  `pipelines/ci-automation.yaml`; GitHub required checks. Only the pipeline rename (S6) touches these.
- ADR-DSGN-TRACK#5 (tracks.md): "as `ci-automation` binds the automation track" -> "as `ci-<TRACK>` binds the `<TRACK>` track"; lands with
  P6.

### From the master draft: not in this plan

Re-coding `ADR-AUTO-*`; moving AUTO ADR files into layer sub-folders; renaming the Go/Python/Bash tracks; any change to `.unordered/`;
rendering any diagram unasked; the Azure DevOps and GitHub settings that live outside git; commit structure (the user's).

### From the layer-model draft: amended rules still to check

- Stray pwsh rules still in AUTO (survey): `ADR-AUTO-TEST` 4, 10, 25, 26, 32; `EXTEND` 4; `CACHE` 6-7 and the session-cache model; `CONSOLE`
  10-12; `NOPWD` 6. Move each to its `ADR-PWSH-*` twin or reword it engine-neutral (as the earlier split did). Rule numbers are never reused
  (the index says so), so a moved rule leaves a gap. `Test-AdrEngineNeutrality` already exists: extend it so AUTO text with pwsh syntax
  fails.

### From the layer-model draft: the importer decides the mix (L3 to L5, not built)

The user's phrase: "an IMPORTER deciding the final mix of engines and languages". The design, smallest first, all configuration with
sensible defaults and no new registry (ADR-PRIN-CONFIG, ADR-AUTO-DEFAULT#6, ADR-AUTO-OVERLAY for consumer differences):

- **Inputs** (resolution order of ADR-AUTO-DEFAULT#6: the caller's explicit value, else configuration, else the default declared once on the
  config type): `-Languages`, `-Engines` on the importer (an importer switch, like today's `-Bundle`), environment variables only where
  ADR-AUTO-ENVVAR allows an external contract (**read it first**), `importer.yml` (new, `Catzc.Base.ModuleSystem/configs/`, type
  `ImporterConfig` carries the defaults, with the posture and generated `defaults` contract of plan-config-defaults), then the
  bundle/profile closure for modules. Run mode (source|build) and host (console|headless) stay orthogonal and keep choosing the types-load
  cell.
- **Values:** `auto` (default) or an explicit list. `auto` for **engines** = pwsh plus every POSIX engine whose executable exists (a missing
  zsh is skipped and reported, as the earlier decision says); for **languages** = the executable languages of the loaded modules.
- **Result:** one `ImportMix { Languages, Engines, Modules }` record kept for the session, readable by `Get-ImportMix`. The test runner
  reads engines from it instead of re-deciding (today every Go/Python test runs once per engine from the model), the builder reads modules.
- **Effects, in order of cost:**
  1. report only (`Get-ImportMix` states today's truth: engines [pwsh], languages [powershell, csharp], modules = all in the root);
  2. module selection by language (a module whose live languages are not in the mix is not loaded);
  3. entry files follow the mix (`importer.sh` is only generated and mentioned when a POSIX engine is in the mix);
  4. languages beyond powershell and csharp: **throw `NotImplemented` when configured** (the pattern of ADR-REPO-CONTRACT#8); switched on
     only once proven from every engine.
- **Per-language facts** that the importer and the module-model plan both need (`build`, `test`, `layout` handlers, the `executable` flag)
  belong in `languages.yml` beside `formatter` and `checks`, one file the formatter, checks and importer share (Q-F of the module-model
  plan). Whether `FileLanguage` rejects unknown keys is **unverified**; a new key needs the type edit first (C# change, fresh `pwsh`).

| Phase | Work                                                                                                                                             |
| ----- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| L3    | `ImporterConfig` + `importer.yml` (defaults on the type) + `Get-ImportMix` reporting today's mix. L0 tests with neutral fixtures.                |
| L4    | `-Languages`/`-Engines` switches and module selection by language (effect 2); the importer shim is generated, so edit its source and regenerate. |
| L5    | Entry files follow the mix (effect 3); `Test-GeneratedFiles` covers it.                                                                          |

Decisions of the layer model (all accepted as recommended on 2026-10-16), kept for L3 to L5 and the open executable-flag step:

- **Q-L1** Executable flag: write `executable: true` in `languages.yml` (a derived rule needs a data-language list, which is the same fact).
- **Q-L2** `ADR-AUTO-IMPORTER` is its own ADR.
- **Q-L3** No regrouping of AUTO files into `language/` and `importer/` sub-folders; data (`layer:`) gives the same view.
- **Q-L4** The value-chain concern `automation` keeps its name.
- **Q-L5** `ExecutionEngines` stays a compiled C# model (closed set, no config); languages stay config.

### From the command-contract draft: still open

- **C7** Other implementing languages: only when a real command exists in one (the ADRs make bash/go/python test artifacts today,
  ADR-AUTO-GO/PY/BASH). Until then `NotImplemented`.
- **Use 4, tests:** Go/Python black-box tests that call a contracted command take the call shape from the contract; a drift test fails when
  the contract changes and the test does not.
- Rules and traps to respect: a contract asset is **bytes the check compares** (marked `catzc-contract` in `.gitattributes`, no Format-Code
  pass may rewrite it); released folders are frozen (`.frozen` SHA-256, `Publish-ContractRelease`); a signature change to a contracted
  command is a contract change, and the same commit edits the asset; do not store a version, a module, or a language in a command contract
  (placement says them).

### From the worklist: do-not-sweep list

`System.Management.Automation` (140), `NoAutomaticVariableMisuse.psm1`, CAF/WAF/DORA titles and anchors (`#deployment-automation`,
`platform-automation-and-devops.md`, 94 hits), "Cloud Automation Toolkit", Exporter `-Version auto`, `jidoka`, `.markdownlint.yml`
"auto-enable", `Get-AutoControlledGlobs` (name keeps "Auto"; prose "the automation itself" there means the tooling: reword, do not rename),
`docs/adr/automation/**` paths and `ADR-AUTO-*` codes, `.unordered/**`, `docs/references/pipelines/*automation*` pages until S6.
