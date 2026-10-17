---
plan:
  status: active
  value: highest
  reviewed: 2026-10-17
  role: master
  targets: [.claude/plans]
catzc:
  immutable:
    with_body_sha: "34c02ae6ae36"
    repo_status: clean
    path: ".claude/plans/plan-master.md"
    folder: plans
    name: plan-master
    filetype: md
    kind: other
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
  edges:
    cites:
      - ADR-AUTO-DEFAULT#6
      - ADR-REPO-COMMENTS#5
      - ADR-REPO-FORMAT#8
      - ADR-REPO-HELP#3
---

# Master: every open step of every plan, in one executable order

This is the one long plan. It holds every open step of every `plan-*.md` in this folder, grouped into chunks and ordered for execution. A
chunk is written out as `taskNNN.md`, a detailed step-by-step executable, and the chunk here shrinks to one pointer line. The source plans
stay the durable record; task files and this master are derived from them and can be cleared at any time and rebuilt.

## Process (the planner's own rules)

- Sources: `plan-*.md`, `value-of-plan.md`, `decisions-2026-10-16.md`. Never a signal lost: a step leaves a plan only when its task file
  carries it, and the plan keeps the checkbox until the work lands in the tree.
- A task file is `taskNNN.md`, 001 to 050 at most, one chunk each: head (`task:` id, status, plans, value, blocked_on, targets), then
  numbered steps. Every step names one file, the exact edit, and the check that proves it. One file per step, verified before the next.
- Task numbers are execution order. This is the one place a file name carries an order; the stable-locators rule (ADR-REPO-PLANS, to be
  written in T010) governs plan names, and task files are disposable executables, not plans.
- Clear and restart: delete `task*.md`, reset every pointer line here to its chunk from the source plans, re-stamp `reviewed`. Nothing else
  is touched. The plans themselves are never deleted by a clear.
- The planner edits only this folder. It runs no gate and no code; a check named in a step is for the executor.
- Blocked chunks stay in order but carry `blocked_on`; the executor skips them and moves on.
- The order below: first the hygiene of this folder (T001 to T003), then the decision round that unblocks the most (T004), then by value
  (value-of-plan.md), dependencies first.

## Chunks

- T001 -> task001.md (open): re-point the dangling links in six plan files.
- T002 -> task002.md (open): a check on every open step; plan-shape for the four numbered-step plans; small plan fixes.
- T003 -> task003.md (open): value-of-plan.md rows for the unlisted plans; prompt deletions after diff; questionnaire trim.
- T004 -> task004.md (open): the decision round over every open question (plan-decide, items D01 to D16).
- T005 -> task005.md (open): register ADR-AI; fold the agent-contracts page into it. D14 answered by a read: AdrCodeForm accepts ADR-AI.
- T006 -> task006.md (open): write ADR-CATS in principles with five rules; glossary cats and catzc; clear the two waits_on lines.
- T007 -> task007.md (open): body-sha Phase 0, the hash only on generated tracked files; FILEMETA#3 and #7.
- T008 -> task008.md (open; step 4 is the user's git rm): the .unordered binding audit (12 code files, 283 markdown mentions) and the
  deletion script for the 20 finished plans.
- T009 -> task009.md (open; after T008): tracks.md rule 17 rewritten, four glossary terms, Import-RepositoryWithHistory with tests, the
  sorting how-to.
- T010 -> task010.md (open; gate and ADR now, CLAUDE.md wording after T009): ADR-REPO-PLANS with nine rules, stable-locator rule in
  ADR-REPO-FOLDERS, the PowerShell naming rule in ADR-REPO-VOCAB, the Test-Plans gate, plan-clear registry, CLAUDE.md line 145.

### T011 Module model close-out (plan-module-model-closeout, high; after T004 confirms D01 to D05)

- Rule 6 of ADR-AUTO-MODULE gets code: handler ids on the track built and tested, or the rule narrowed. Check: Test-AdrRegistry; a test
  names each handler id.
- Step 10 of the implement prompt, the infrastructure track. Check: Get-CatzcModule -TrackType returns it, or recorded out of scope.
- docs/references/automation/catzc-base-modules.md (absent 2026-10-17), listed in index.md. Check: Test-Links, Test-Spelling, Format-Code.
- Catzc.Types.csproj first line: find the imprint step that turned the catzc processing instruction name into a bare one. Check:
  Format-FileMeta then Format-Code leave the first line intact.
- Minimaps of the other slides: keep or revert (D05). Check: git status under docs/explanation/.assets lists only intended slides.
- Test-Comments 36 issues and Test-Glossary bare terms in plan text: assigned to owners' plans. Check: both gates report none.
- Copy-Automation default (full profile) confirmed (D04). Check: Copy-Automation.Tests.ps1.
- Clear the module-model part of waits_on in plan-config-defaults and plan-layers-vocabulary-rename-contracts. Check: grep waits_on.

### T012 Kind to role and the track rules (plan-module-kinds-tracks, high)

- Rename kind to role; kind takes the object meaning, partitioned by track. Check: Test-FileMeta, Test-FileKinds clean.
- ADR-DSGN-TRACK: a track has one primary language by default (Q35). Check: Test-AdrRegistry, Test-Links.
- Rerun Test-Links on WorldMapBuilder.cs. Check: zero findings.
- Namespace follow-up (Q36) recorded as a decided section. Check: the section exists.
- Test-ShippedTypes flags on TrackTypeEntry and VendorEntry (Q88, this plan's). Check: Test-ShippedTypes clean in a fresh process.

### T013 Minimal robots Phase 5 (plan-minimal-robots and siblings, high)

- session-cost-audit over a session that spawned each robot once; record context bytes per spawn and model mix. Check: report in out/.
- Reconcile the seven shape rules with ADR-REPO-AGENTS rules 6 to 10. Check: Test-AgentDefinitions; each rule cited.
- drawio-png as the maker inside drawio-diagram-waves (Q139 decided): confirm in the agent file. Check: Test-AgentDefinitions.
- Then delete the three plans if no open step remains; one line each in value-of-plan.md. Check: Test-Links clean on the folder.

### T014 Config defaults Phase 1 (plan-config-defaults, high; after T011)

- VariantsConfig.cs and VariantTrack.cs carry defaults once (have_customers false, ado_naming standard, git_workspace main-direct, aspects
  catch-all, tracks required with a throw naming key and fix); the five getters lose -Default. Check: VariantsConfig.Tests and getter tests.
- Dirty-file note: Get-Track.ps1 and its test were modified in the user's tree on 2026-10-16; re-check before editing.

### T015 Config defaults Phases 2 and 3 (after T006 names the folders)

- This repo's data moves to .catzc/\<track>/Catzc.Base.Variants/configs/variants.yml; shipped variants.yml deleted; a typed config with no
  file builds from an empty map plus the fragment. Check: overlay root tests; the shipped file gone.
- Get-CatzcOverlayRoot and Get-ConfigOverlayRoot read the repo's own fragments in source mode. Check: source-mode tests.
- Build-ConfigDefaultsContract writes contracts/catzc/0.0.0/<\Module>/configs/<\name>.yml; required keys in a header comment. Check:
  Test-Contracts, Test-GeneratedFiles; Build-ContractReference lists it.

### T016 Config defaults Phases 4 and 5

- One config type per change into a posture (defaulted, empty-is-valid, required); the audit script in out/ is the worklist; the analyzer
  rule flags a literal default in a function. Check: each config's own tests; the rule's test.
- ADR-AUTO-DEFAULT#6, OVERLAY#1 #8, CONTRACT#6, CONF-LOADING amended; the assert ladder section in ADR-AUTO-FAILFAST (Q21);
  Update-AdrCitation. Check: Test-Links, Test-AdrRegistry.

### T017 Layers P0 and P1 (plan-layers-vocabulary-rename-contracts, high; P1 may run beside the module model, Q38)

- P0 baseline in the background: Test-GeneratedFiles, Test-Links, Test-Contracts, Test-WorldMap; the two checks on a copy (hook rebuild edge
  fact). Check: the baseline report.
- P1 doctrine: ADR-AUTO-LAYERS and ADR-AUTO-IMPORTER new; glossary automation, importer, command, bare engine, language, module, role, run
  mode, layer, pwsh; the four term collisions; languages.yml engines renamed formatters; Test-AdrEngineNeutrality extended. Check:
  Test-Glossary, Test-AdrRegistry, Test-Terminology clean (P1 stop).

### T018 Layers P2 funnel (after T011)

- One bootstrap constant; about 45 sites onto Get-CatzcModulesRoot and Get-Track; S4 identifiers renamed; guard rule against track-root
  literals. Check: the guard gate clean (P2 stop).

### T019 Layers P3 classification; P4 flip waits for the user's go (D10)

- P3: docs classified page by page (pwsh topic moves, abstract stays); report and stop. Check: the classification table.
- P4: the folder move automation to pwsh by git mv in the user's quiet window; .catzc/pwsh/; out/pwsh/built and packages. Check: full
  baseline green again. blocked_on: the user's explicit go.
- P6 late rename of ci-automation names the same day the user re-points the external bindings. blocked_on: P4.

### T020 Command contracts (plan-layers-vocabulary-rename-contracts P5 to P7)

- ADR-REPO-CMDCONTRACT new; <\Module>/<\Verb-Noun>.command.yml, grammar shape A, closed type set; the checker; Test-Contracts covers the
  fifth asset kind (unknown suffix settled on a copy first); the pilot list proposed for approval (the cats entry point's commands). Check:
  Test-Contracts; the pilot contracts validate.
- Public API (F6, S5): most of the 439 public functions become internal, after the pilot. Check: Test-Contracts on the frozen set.

### T021 File head: class selectors and the schema (plan-file-head-immutable-edges-classes, medium-high)

- Class selectors in file-meta.yml, one kind at a time (Q50). Check: that kind's processor test; Test-FileMeta clean.
- Intended kind overlaps written; FileKindReachability strengthened so a shadowed kind fails (Q41). Check: the kinds tests.
- head.schema.json and head.sample.yml gain tracktype and vendor (hand-written, Q39). Check: Format-FileMeta.Contract.Tests.
- Test-Markdownlint findings in docs/adr/repository/file-meta.md. Check: clean on that file.

### T022 File head leftovers

- note as a glossary term (Q53). Check: Test-Glossary.
- ADR-AUTO-ASSETDEP re-read; asset kind confirmed or moved (Q54). Check: the kinds tests.
- Formatting ADR on automation/.compiled followed (Q47, D13): Format-Code skips the folder or the ADR is amended. Check: Test-Formatting
  names no .compiled file.
- module-types.yml pwsh-folder definition typo "under ex. automation" (present 2026-10-17; Q46). Check: grep finds nothing.
- Test-Spelling run; catzc_bundle added to coined words only if flagged. Check: the report.
- Test-FileMeta, Test-Glossary, Test-Contracts, Test-GeneratedFiles one by one in the background; findings attributed. Check: reports read.

### T023 Assets beside articles and the gallery PDF (plan-assets-beside-articles, plan-assets-gallery-pdf)

- gallery_pdf.py --assets learns the beside-the-article lookup or the mode is retired from STYLE.md. Check: a run on
  docs/explanation/.assets includes descriptions, or the mode is gone.
- FileCarrierResolver shipped-registry test (test-file exclusion line). Check: that test passes.
- Remove docs/.assets/explanation (two gitignored PDFs and an empty chain/ left). Check: the folder is gone.
- .claude/skills/drawio-waves/SKILL.md names --assets (line 44 does not yet). Check: the line says --assets.
- --parts <\n> split: D07; if yes, a flag and a run under 30 MiB per part. Check: recorded or built.
- Fixture run (two PNGs, one companion) if the kit gains a test home. Check: page count 3.
- Then delete both plans; one line each in value-of-plan.md.

### T024 Assert-Wait (plan-assert-wait, medium)

- wait map (seconds, millisecs; defaults 1 and 1) on TimeoutsConfig.cs with tests; literals in Assert-Wait.ps1 replaced by the config read.
  Check: TimeoutsConfig.Tests and Assert-Wait.Tests pass (fresh pwsh).
- Test-Automation.Tests.ps1 green (its failure is a peer's test name and "bash and zsh" wording in seven plans). Check: passes.
- Source of the fixed about 110 ms first-tick lateness: -DiagnoseBlocking and -DiagnoseLoadTime side by side. Check: named in the plan.
- Function help beyond the head blocks. Check: Test-Links.
- After the first measured run: ADR-AUTO-FAILFAST#8 and ADR-PWSH-ASSERT#7; each watchpoint that found a block becomes a timeouts.yml limit,
  the rest deleted. Check: Build-AdrIndex; no Assert-Wait call left without a finding.

### T025 Lazy types load Phases 3 to 5 (plan-lazy-types-load, medium-high)

- Phase 3 leftovers: console prompt hook; L1 test "not loaded after import" through the real importer; janitors decision (D09).
- Phase 4: stat-stamp memo in front of Get-CombinedTypeHash (hash 155 ms dominates). Check: a warm import measures the saving.
- Phase 5: ADR rule (importer never loads the DLL; first use does), the default-declaration exception recorded, comment pages, L1 tests,
  bundle lazy-install test, eager path deleted. Check: Test-Links, Test-AdrRegistry.

### T026 ADR-AUTO-MATERIAL (plan-materialization-of-knowledge, medium; choices decided Q66 to Q70, D16)

- Write the ADR next to ADR-AUTO-CACHE from the decided section; adrs.yml; dora-explains; index; glossary entry contrasting cache and
  persistence. Check: Test-AdrRegistry, Test-Glossary, Test-Links.
- The sha-marker companion memory plan says its marker is a commit-materialized resource. Check: its text names materialization.

### T027 ADR link cleanup (plan-adr-link-cleanup-prose-to-pages, medium; after T007 and T008)

- ADR-REPO-HELP#3 relaxed and its gate (only a bare citation line reported). Check: Test-Links, Test-AdrRegistry; the gate reports a bare
  line.
- TryParse regression test (Q58); the five gates on the usage code (Q59). Check: the test passes; gates clean.
- Ledger rebuilt without .unordered rows. Check: about 4,900 rows.
- F8: every rule statement in the principles ADRs bold. Check: Test-Glossary finds every defining rule.
- Steps 1.3 apply and 1.4 verify, one slice at a time; the two narrow fixes at no-gate-checks-rules-one-and-four.md lines 62 and 63. Check:
  Test-Links clean.
- Phase 2 per D1, one file at a time. Check: Test-Comments, Test-FileMeta clean.

### T028 Output artifacts (plan-out-artifacts, medium; decided Q71 to Q74)

- output-formats.yml registers the six areas with their numbers; sessions under out/sessions/<\session>/; time-safeguard.log never pruned.
  Check: config tests; Test-Links.
- The prune, only in Clear-Output, keeps N newest per registered run area. Check: its Pester file.
- ADR-REPO-OUTDIR amendments. Check: Test-AdrRegistry, Test-Links.
- Batch one (222 probes) and batch two (13) deletions: the user runs out/delete-probes-batch1.ps1. Check: listed files gone, keep list
  intact.
- The five tool candidates become open steps in their owning plans. Check: a grep finds each name in an open step.

### T029 Test run budget (plan-test-run-budget, medium)

- ADR-REPO-FORMAT sentence: an engine's cache stamp holds its own tool pin and settings files only (D08). Check: the sentence.
- The stamp change with two tests (unrelated pin leaves another engine warm; every declared input invalidates). Check: Test-Formatting tests
  cold and warm.
- Invoke-TestFile no longer shares a shard with Test-Formatting after two runs. Check: the shard table.
- Next three files by cost through test-optimization, one at a time. Check: same assertions, lower time.

### T030 Format step moves comments (plan-format-step-moves-comments, low-medium)

- Verified 2026-10-17: languages.yml top-level imprint lists comments and file-meta, so the step loop exists and the comments step is wired;
  the first open step closes with that fact.
- comments.yml pages gain automation/.scriptanalyzer and automation/.internal with reasons; exclude .vendor. Check: the config type accepts
  a dot-prefixed source; Format-Code moves the long header; Test-Comments clean on the dot-folders.
- One sentence each in ADR-REPO-FORMAT#8 and ADR-REPO-COMMENTS#5 if missing. Check: Test-Links.

### T031 Skip unchanged generators (plan-skip-unchanged-generators, medium)

- Build-Readme: D12; not skippable unless the README meta block gains the stamp. Check: recorded.
- Build-RootConfig and Build-GitKeep: full input set or a stamp over the scanned tree. Check: a missed input is proven impossible by test.
- Sync-SessionTools: its own skip check. Check: a warm run skips.
- Invoke-TypeCacheJanitor and Invoke-AgentHookJanitor profiled. Check: numbers in the plan.
- New files through Format-FileMeta, CatzcFiles regenerated, meta gates. Check: Test-FileMeta, Test-GeneratedFiles.
- Done when out/profile-janitors.ps1 is re-measured and every generator is wired or recorded.

### T032 Root-config fixture tests and the PropertyHead docs (plan-fast-push-followups, plan-csproj-xml-head)

- Build-RootConfig.Tests.ps1 lines 66, 71, 189, 206 see with_body_sha and repo_status in a generated head: find the change that moved the
  head; fix tests or head, one file at a time. Check: the file passes.
- PropertyHead reference page and the Format-PropertyMetaHead and Get-PropertyMetaState help describe the XML form. Check: Test-Links.
- By hand: a keybinding for the Push dirty task; one real Push-Dirty run. The user's.
- The Test-AdrRegistry ADR-AI finding closes with T005; the Test-Glossary findings in plans are D15.

### T033 Unboxing close (plan-unboxing, low-medium)

- .compiled holds one DLL (Catzc.Types.1d35234a, verified 2026-10-17); the commit is the user's. Check: git status clean for them.
- The three leftover checks of prompt-unboxing-continue.md in a fresh session; "full suite" wording and markdownlint in the article;
  Format-Links on TypeShape.cs. Check: the report.
- P4 and P5 only on the user's go (D11). Check: the 15 percent bar.

### T034 Bounded enumeration close (plan-bounded-folder-enumeration)

- Level-2 gate rerun in the background; fix only this feature's findings. Check: report shows the three tags accepted.
- On the user's green full run: delete the plan and its prompt. Check: both gone; a line in value-of-plan.md.

### T035 Idle compaction (plan-idle-compaction, low)

- D06; if checked in: move the line to .claude/settings.json. Then delete the plan. Check: no file in .claude/plans names it.

### T036 Closing sweep

- Every plan with no open step is deleted and value-of-plan.md keeps one "deleted, why" line; Test-Links clean on the folder.
