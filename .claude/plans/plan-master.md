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
  edges:
    cites:
      - ADR-REPO-FOLDERS#12
      - ADR-REPO-PLANS#8
      - ADR-REPO-VOCAB#9
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
- Task numbers are execution order. This is the one place a file name carries an order (ADR-REPO-PLANS#8, ADR-REPO-FOLDERS#12); the
  stable-locator rule governs plan names, and task files are disposable executables, not plans.
- Clear and restart: delete `task*.md`, reset every pointer line here to its chunk from the source plans, re-stamp `reviewed`. Nothing else
  is touched. The plans themselves are never deleted by a clear.
- The planner edits only this folder. It runs no gate and no code; a check named in a step is for the executor.
- Blocked chunks stay in order but carry `blocked_on`; the executor skips them and moves on.
- The order below: first the hygiene of this folder (T001 to T003), then the decision round that unblocks the most (T004), then by value
  (value-of-plan.md), dependencies first.

## Chunks

- T001 to T003: done 2026-10-17, task files deleted (folder hygiene: links re-pointed, a check on every step, value rows, prompts deleted).
- T004: done 2026-10-18, task file deleted (the decision round: D01 to D20 asked four at a time, every recommendation taken, recorded in
  decisions-2026-10-18.md and folded into the owning plans; D14 had been answered 2026-10-17).
- T005 to T008: done 2026-10-17, task files deleted (ADR-AI registered and the agent-contracts page folded in; ADR-CATS; body-sha Phase 0
  with the stamp check in Test-GeneratedFiles; the .unordered audit and its deletion, run by the user).
- T009 -> task009.md (open; after T008): tracks.md rule 17 rewritten, four glossary terms, Import-RepositoryWithHistory with tests, the
  sorting how-to.
- T010: done 2026-10-17, task file deleted (ADR-REPO-PLANS, ADR-REPO-FOLDERS#12, ADR-REPO-VOCAB#9, the Test-Plans gate); one clause is left
  and follows T009: the CLAUDE.md plans line cites the landing-zone terms.

- T011 -> task011.md (open; steps 3 read, 4, 5, 6, 8 done 2026-10-17; D01 to D05 confirmed 2026-10-18; the user's run for the rest): module
  model close-out, the rule 6 funnel (D03 confirmed), infrastructure track (a design step in plan-module-kinds-tracks), waits_on cleared.
- T012 -> task012.md (open; after T011): kind becomes role through the registry and generators; tracks.md rule 19 one primary language;
  WorldMapBuilder links; Test-ShippedTypes; the namespace line.
- T013: done 2026-10-17, task file deleted (minimal robots Phase 5 measured, the three robot plans deleted).
- T014 -> task014.md (open; after T011): config defaults Phase 1, VariantsConfig constants, getters lose -Default.
- T015 -> task015.md (open; after T006 and T014): the .catzc fragment, config without a shipped file, Build-ConfigDefaultsContract.
- T016 -> task016.md (open; after T015): every typed config into a posture, the NoLiteralDefault analyzer rule, five ADR amendments, the
  assert ladder, three glossary terms.

- T017: done 2026-10-17, task file deleted (layers P0 baseline and P1 doctrine: ADR-AUTO-LAYERS, ADR-AUTO-IMPORTER, the glossary terms,
  engines renamed formatters; the retired forms wait for P6).
- T018 -> task018.md (open; after T011): layers P2 funnel: one bootstrap constant, about 45 sites onto the resolvers, S4 identifiers, the
  NoTrackRootLiteral guard.
- T019 -> task019.md (open; P4 and P6 on the user's go, D10): P3 classification table and ADR wording drafts; P4 the flip by the user; P5
  retired-phrase guards; P6 pipeline names with the user's external re-pointing.
- T020 -> task020.md (open; C1, C2 and C4 done 2026-10-17; C3 waits for the user's answer to the pilot list; C5 and C6 after it, never
  inside the P4 window): command contracts: ADR-REPO-CMDCONTRACT, the Command asset kind and checker, pilot contracts, reader, cats
  validation, public functions made internal.
- T021: done 2026-10-17, task file deleted (class selectors proven by a zero-change dry run, the overlaps list and the strengthened
  reachability test, the head schema keys); the `note` kind no tracked file reaches goes (D20, 2026-10-18; T022 step 10).
- T022 -> task022.md (open; step 3 the .compiled skip per D13 and step 10 the note kind's removal per D20, the rest done 2026-10-17): file
  head leftovers: note term, ASSETDEP reading, .compiled formatting, module-types.yml typo, spelling, four gate reports attributed.

- T023: done 2026-10-18, task file deleted (assets leftovers: gallery --assets reads the sidecar carrier and streams its pages, the carrier
  test passes as it stands, the old folder removed, the skill line, plan-assets-beside-articles deleted; D07 no --parts flag).
- T024 -> task024.md (open; steps 1 to 6 done 2026-10-17; the ADR pair and the watchpoint retirement wait for the user's measured run, the
  one conventions finding left is the user's `git mv` of FileKindReachability.Tests.ps1): Assert-Wait defaults on TimeoutsConfig, the
  lateness explained and removed (sleep until due), ADR-AUTO-FAILFAST#8 and ADR-PWSH-ASSERT#7, watchpoints retired into limits.
- T025 -> task025.md (open; done 2026-10-17 apart from the prompt hook, which D09 chose 2026-10-18: the janitors run after the first
  prompt): lazy types Phases 3 to 5: the hash memo, the ADR rule and exception, comment pages, the bundle and lazy tests in the tree, no
  second eager path.
- T026 -> task026.md (open; D16 confirmed 2026-10-18, ready): ADR-AUTO-MATERIAL with seven rules, registry, dora-explains, glossary term.
- T027 -> task027.md (open; after T007 and T008): HELP#3 relaxed, TryParse test, five gates, ledger rebuilt, F8 bold rules, Phase 1 applied
  slice by slice with verification, Phase 2 per D1 to D5.
- T028 -> task028.md (open; done 2026-10-17 apart from the two probe batches, which the user confirms since their lists are gone): the areas
  were registered and the prune in the tree, the safeguard log never ages out, Clear-Output has its tests, out.md names the retention, the
  five tool candidates placed.
- T029 -> task029.md (open; D08 decided 2026-10-18 so steps 1 and 2 are ready; the user's two runs for step 3): the per-engine cache stamp
  with two tests, shard re-check, next three files by cost.
- T030: done 2026-10-17 by session catzc-6c, task file deleted (the page entries, the sentences and the step loop were in the tree; two
  stale `.internal` page sections removed, Test-Comments 0 on both folders).
- T031: done 2026-10-18, task file deleted (Build-RootConfig stamp, Build-GitKeep bounded walk, Sync-SessionTools memo, Build-Readme not
  skippable per D12; janitors re-measured at 1.2 s first call and 0.4 s warm; plan-skip-unchanged-generators deleted).
- T032 -> task032.md (open): the four Build-RootConfig fixture-head tests, PropertyHead docs to the XML form, the user's keybinding and run.
- T033 -> task033.md (open; steps 2 to 5 done; step 1 is the user's commit of the one DLL pair; D11 stay closed and D18 no sentence,
  2026-10-18): unboxing closed: three leftover checks, two gate findings, P4 and P5 closed.
- T034 -> task034.md (open; the level-2 rerun is green 2026-10-17; the user's run of all tests, then the plan and prompt deleted): bounded
  enumeration closed.
- T035: done 2026-10-18, task file deleted (D06 keeps idleCompaction in the local settings; plan-idle-compaction deleted).
- T036 -> task036.md (open; runs after every batch and last): the closing sweep, done plans deleted with one line each, the master and task
  files deleted when every chunk is done.

Every chunk is now a task file. Numbers 037 to 050 are free for chunks that new plans or pastes bring; 050 is the cap.
