---
plan:
  status: active
  value: highest
  reviewed: 2026-10-17
  role: master
  targets: [.claude/plans]
catzc:
  immutable:
    with_body_sha: "81ed10b4583e"
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

- T011 -> task011.md (open; D01 to D05 first, steps 3, 4, 6 can start): module model close-out, rule 6 code, infrastructure track, the
  Modules reference page, the csproj first-line imprint, waits_on cleared.
- T012 -> task012.md (open; after T011): kind becomes role through the registry and generators; tracks.md rule 19 one primary language;
  WorldMapBuilder links; Test-ShippedTypes; the namespace line.
- T013 -> task013.md (open): minimal robots Phase 5 measure, the seven shape rules reconciled with ADR-REPO-AGENTS 6 to 10, the three plans
  deleted. The waves maker question is already answered in the agent file.
- T014 -> task014.md (open; after T011): config defaults Phase 1, VariantsConfig constants, getters lose -Default.
- T015 -> task015.md (open; after T006 and T014): the .catzc fragment, config without a shipped file, Build-ConfigDefaultsContract.
- T016 -> task016.md (open; after T015): every typed config into a posture, the NoLiteralDefault analyzer rule, five ADR amendments, the
  assert ladder, three glossary terms.

- T017 -> task017.md (open): layers P0 baseline and P1 doctrine: ADR-AUTO-LAYERS, ADR-AUTO-IMPORTER, ten glossary terms, the four term
  collisions, engines renamed formatters, Test-AdrEngineNeutrality.
- T018 -> task018.md (open; after T011): layers P2 funnel: one bootstrap constant, about 45 sites onto the resolvers, S4 identifiers, the
  NoTrackRootLiteral guard.
- T019 -> task019.md (open; P4 and P6 on the user's go, D10): P3 classification table and ADR wording drafts; P4 the flip by the user; P5
  retired-phrase guards; P6 pipeline names with the user's external re-pointing.
- T020 -> task020.md (open; never inside the P4 window): command contracts C1 to C6: ADR-REPO-CMDCONTRACT, the Command asset kind and
  checker, pilot contracts, reader, cats validation, public functions made internal.
- T021 -> task021.md (open; after T007): class selectors one kind at a time with a zero-change dry-run proof, the overlaps list and the
  strengthened reachability test, head.schema.json with tracktype and vendor.
- T022 -> task022.md (open; D13 for one step): file head leftovers: note term, ASSETDEP reading, .compiled formatting, module-types.yml
  typo, spelling, four gate reports attributed.

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
