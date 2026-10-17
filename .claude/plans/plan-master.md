---
plan:
  status: active
  value: highest
  reviewed: 2026-10-17
  role: master
  targets: [.claude/plans]
catzc:
  immutable:
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

- T001 -> task001.md (done 2026-10-17): re-point the dangling links in six plan files; the tree already held the re-pointed links, all
  six checks clean.
- T002 -> task002.md (done 2026-10-17): a check on every open step; plan-shape for the four numbered-step plans; small plan fixes.
- T003 -> task003.md (done 2026-10-17; the three prompt deletions are the user's git rm): value-of-plan.md rows for the unlisted plans;
  prompt deletions after diff; questionnaire trim (nothing removable under the rule).
- T004 -> task004.md (open): the decision round over every open question (plan-decide, items D01 to D16).
- T005 -> task005.md (done 2026-10-17; the agent-contracts page deletion is the user's git rm): register ADR-AI; fold the
  agent-contracts page into it. D14 answered by the user: keep ADR-AI; AdrsConfig now accepts one-segment codes, which ADR-CATS (T006) uses.
- T006 -> task006.md (done 2026-10-17): write ADR-CATS in principles with five rules; glossary cats and catzc; clear the two waits_on
  lines. The new ADR file is untracked until the user commits, so its head has no body sha yet and links to it report `[Untracked]`.
- T007 -> task007.md (done 2026-10-17): body-sha Phase 0, the hash only on generated tracked files; FILEMETA#3 and #7. The stamp check
  is in Test-GeneratedFiles; the 444 minimap pages and the compiled manifest are unstamped until their writers write a head (open steps in
  plan-plans-body-sha-landing-zone, the minimap re-render on the user's ask).
- T008 -> task008.md (done 2026-10-17 except step 4, the user's git rm, and the tick that follows it): the .unordered binding audit (12
  code files, 299 markdown mentions) and the deletion script `out/delete-unordered-15-10-2026.ps1` for the 20 finished plans.
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

- T023 -> task023.md (open; D07 for one step): assets leftovers: gallery --assets lookup or retirement, the FileCarrierResolver test, the
  old folder removed, the skill line, both plans deleted.
- T024 -> task024.md (open; ADR pair after the first measured run): Assert-Wait defaults on TimeoutsConfig, the suite file green, the 110 ms
  source, help, ADR-AUTO-FAILFAST#8 and ADR-PWSH-ASSERT#7, watchpoints retired into limits.
- T025 -> task025.md (open; D09 for one step): lazy types Phases 3 to 5: prompt hook, L1 test, stat-stamp memo, the ADR rule and exception,
  comment pages, bundle test, eager path deleted.
- T026 -> task026.md (open; D16): ADR-AUTO-MATERIAL with seven rules, registry, dora-explains, glossary term.
- T027 -> task027.md (open; after T007 and T008): HELP#3 relaxed, TryParse test, five gates, ledger rebuilt, F8 bold rules, Phase 1 applied
  slice by slice with verification, Phase 2 per D1 to D5.
- T028 -> task028.md (open; deletions are the user's runs): six out/ areas registered in Catzc.Base.Reports output-formats.yml, the prune in
  Clear-Output, OUTDIR amendments, the two probe batches, five tool candidates placed.
- T029 -> task029.md (open; D08, the user's two runs): the per-engine cache stamp with two tests, shard re-check, next three files by cost.
- T030 -> task030.md (open): comments.yml page entries for .scriptanalyzer and .internal, .vendor excluded, the export run, two ADR
  sentences.
- T031 -> task031.md (open; D12): Build-RootConfig and Build-GitKeep input sets, Sync-SessionTools skip, two janitors profiled, re-measure.
- T032 -> task032.md (open): the four Build-RootConfig fixture-head tests, PropertyHead docs to the XML form, the user's keybinding and run.
- T033 -> task033.md (open; the user's commit, D11): unboxing closed: three leftover checks, two gate findings, P4 and P5 only on a go.
- T034 -> task034.md (open; the user's full run): bounded enumeration level-2 rerun, then plan and prompt deleted.
- T035 -> task035.md (open; D06): idle compaction scope, then the plan deleted.
- T036 -> task036.md (open; runs after every batch and last): the closing sweep, done plans deleted with one line each, the master and task
  files deleted when every chunk is done.

Every chunk is now a task file. Numbers 037 to 050 are free for chunks that new plans or pastes bring; 050 is the cap.
