---
plan:
  status: active
  value: highest
  reviewed: 2026-10-18
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
chunk is written out as `task-<topic>.md`, a detailed step-by-step executable, and the chunk here shrinks to one pointer line. The source
plans stay the durable record; task files and this master are derived from them and can be cleared at any time and rebuilt.

## Process (the planner's own rules)

- Sources: `plan-*.md`, `value-of-plan.md`, `decisions-2026-10-16.md`. Never a signal lost: a step leaves a plan only when its task file
  carries it, and the plan keeps the checkbox until the work lands in the tree.
- A task file is `task-<topic>.md`, at most 50 in the folder, one chunk each: head (`task:` with status, plans, value, blocked_on, targets),
  then numbered steps. Every step names one file, the exact edit, and the check that proves it. One file per step, verified before the next.
- The order is the position of a pointer line in the Chunks list below, and nothing else (ADR-REPO-PLANS#8, ADR-REPO-FOLDERS#12). A task
  name says what the task does; no name, head key or reference carries a number, so reordering the list renames nothing.
- Clear and restart: delete `task-*.md`, reset every pointer line here to its chunk from the source plans, re-stamp `reviewed`. Nothing else
  is touched. The plans themselves are never deleted by a clear.
- The planner edits only this folder. It runs no gate and no code; a check named in a step is for the executor.
- Blocked chunks stay in order but carry `blocked_on`; the executor skips them and moves on.
- The order below: first the hygiene of this folder, then the decision round that unblocks the most, then by value (value-of-plan.md),
  dependencies first.

## Chunks

Done, task files deleted:

- Plans-folder hygiene: done 2026-10-17 (links re-pointed, a check on every step, value rows, prompts deleted).
- The decision round: done 2026-10-18 (D01 to D20 asked four at a time, every recommendation taken, recorded in decisions-2026-10-18.md and
  folded into the owning plans; D14 had been answered 2026-10-17).
- ADR-AI, ADR-CATS, body-sha Phase 0, the .unordered audit: done 2026-10-17 (ADR-AI registered and the agent-contracts page folded in;
  ADR-CATS; body-sha Phase 0 with the stamp check in Test-GeneratedFiles; the .unordered audit and its deletion, run by the user).
- The plans ADR: done 2026-10-17 (ADR-REPO-PLANS, ADR-REPO-FOLDERS#12, ADR-REPO-VOCAB#9, the Test-Plans gate); one clause is left and
  follows task-import-landing-zone: the CLAUDE.md plans line cites the landing-zone terms.
- Minimal robots: done 2026-10-17 (Phase 5 measured, the three robot plans deleted).
- Layers doctrine: done 2026-10-17 (P0 baseline and P1: ADR-AUTO-LAYERS, ADR-AUTO-IMPORTER, the glossary terms, engines renamed formatters;
  the retired forms wait for P6).
- Class selectors: done 2026-10-17 (proven by a zero-change dry run, the overlaps list and the strengthened reachability test, the head
  schema keys); the `note` kind no tracked file reaches goes (D20, 2026-10-18; task-file-head-leftovers step 10).
- Assets leftovers: done 2026-10-18 (gallery --assets reads the sidecar carrier and streams its pages, the carrier test passes as it stands,
  the old folder removed, the skill line, plan-assets-beside-articles deleted; D07 no --parts flag).
- Comment pages: done 2026-10-17 by session catzc-6c (the page entries, the sentences and the step loop were in the tree; two stale
  `.internal` page sections removed, Test-Comments 0 on both folders).
- Skip unchanged generators: done 2026-10-18 (Build-RootConfig stamp, Build-GitKeep bounded walk, Sync-SessionTools memo, Build-Readme not
  skippable per D12; janitors re-measured at 1.2 s first call and 0.4 s warm; plan-skip-unchanged-generators deleted).
- Idle compaction: done 2026-10-18 (D06 keeps idleCompaction in the local settings; plan-idle-compaction deleted).

Open, in execution order:

- import-landing-zone -> task-import-landing-zone.md (done 2026-10-18; the task file goes with the user's `git rm`, its plan keeps the
  user's Phase 2 steps): tracks.md rule 17 rewritten, four glossary terms, Import-RepositoryWithHistory with tests, the sorting how-to.
- module-model-closeout -> task-module-model-closeout.md (open; every step done by 2026-10-18 apart from step 9, the user's run of all
  tests): module model close-out, the rule 6 funnel (the tests entries in languages.yml), infrastructure track (a design step in
  plan-module-kinds-tracks), waits_on cleared.
- kind-becomes-role -> task-kind-becomes-role.md (open; ready, the closeout's steps 1 to 4 are done): kind becomes role through the registry
  and generators; tracks.md rule 19 one primary language; WorldMapBuilder links; Test-ShippedTypes; the namespace line.
- config-defaults-variants -> task-config-defaults-variants.md (open; ready): config defaults Phase 1, VariantsConfig constants, getters
  lose -Default.
- config-defaults-fragment -> task-config-defaults-fragment.md (open; after config-defaults-variants): the .catzc fragment, config without a
  shipped file, Build-ConfigDefaultsContract.
- config-defaults-postures -> task-config-defaults-postures.md (open; after config-defaults-fragment): every typed config into a posture,
  the NoLiteralDefault analyzer rule, five ADR amendments, the assert ladder, three glossary terms.
- layers-funnel -> task-layers-funnel.md (open; ready): layers P2 funnel: one bootstrap constant, about 45 sites onto the resolvers, S4
  identifiers, the NoTrackRootLiteral guard.
- layers-classification-flip -> task-layers-classification-flip.md (open; P4 and P6 on the user's go, D10): P3 classification table and ADR
  wording drafts; P4 the flip by the user; P5 retired-phrase guards; P6 pipeline names with the user's external re-pointing.
- command-contracts -> task-command-contracts.md (open; C1, C2 and C4 done 2026-10-17, C3 the 12 pilot assets done 2026-10-18; C5 and C6
  next, never inside the P4 window): ADR-REPO-CMDCONTRACT, the Command asset kind and checker, pilot contracts, reader, cats validation,
  public functions made internal.
- file-head-leftovers -> task-file-head-leftovers.md (done 2026-10-18; the task file goes with the user's `git rm`, its plan keeps the
  user's Test-FileMeta and Test-Automation runs): the binary class skips .compiled, the four tool candidates recorded as not needed, the
  note kind gone with its exemption moved to the unordered track type.
- assert-wait -> task-assert-wait.md (open; steps 1 to 6 done 2026-10-17; the ADR pair and the watchpoint retirement wait for the user's
  measured run, the one conventions finding left is the user's `git mv` of FileKindReachability.Tests.ps1): Assert-Wait defaults on
  TimeoutsConfig, the lateness explained and removed (sleep until due), ADR-AUTO-FAILFAST#8 and ADR-PWSH-ASSERT#7, watchpoints retired into
  limits.
- lazy-types-load -> task-lazy-types-load.md (done 2026-10-18; the task file goes with the user's `git rm`; the plan stays, since its open
  facts keep one question: the janitors' and drift guard's shadow-path assumption is unconfirmed on Unix): lazy types Phases 3 to 5: the
  hash memo, the ADR rule and exception, comment pages, the bundle and lazy tests in the tree, no second eager path, the janitors behind the
  console prompt hook.
- adr-auto-material -> task-adr-auto-material.md (done 2026-10-18; the plan's steps are all ticked, task-closing-sweep deletes both):
  ADR-AUTO-MATERIAL with seven rules, registry, dora-explains, glossary term.
- adr-link-cleanup -> task-adr-link-cleanup.md (open; steps 1 to 7 done by 2026-10-18 with the first slice; the remaining slices and Phase 2
  next): HELP#3 relaxed, TryParse test, five gates, ledger rebuilt, F8 bold rules, Phase 1 applied slice by slice with verification, Phase 2
  per D1 to D5.
- out-artifacts -> task-out-artifacts.md (open; done 2026-10-17 apart from the two probe batches, which the user confirms since their lists
  are gone): the areas were registered and the prune in the tree, the safeguard log never ages out, Clear-Output has its tests, out.md names
  the retention, the five tool candidates placed.
- test-run-budget -> task-test-run-budget.md (open; steps 1, 2, 4 and 5 done 2026-10-18; step 3 is the user's two runs, then step 6): the
  per-engine cache stamp with two tests, shard re-check, next three files by cost.
- root-config-fixtures -> task-root-config-fixtures.md (open; everything done 2026-10-18 apart from step 5, the user's keybinding and real
  Push-Dirty run): the four Build-RootConfig fixture-head tests, PropertyHead docs to the XML form, the user's keybinding and run.
- unboxing-closeout -> task-unboxing-closeout.md (open; steps 2 to 5 done; step 1 is the user's commit of the one DLL pair; D11 stay closed
  and D18 no sentence, 2026-10-18): unboxing closed: three leftover checks, two gate findings, P4 and P5 closed.
- bounded-enumeration-closeout -> task-bounded-enumeration-closeout.md (open; the level-2 rerun is green 2026-10-17; the user's run of all
  tests, then the plan and prompt deleted): bounded enumeration closed.
- closing-sweep -> task-closing-sweep.md (open; runs after every batch and last): done plans deleted with one line each, the master and task
  files deleted when every chunk is done.

Every chunk is now a task file. A new plan or paste adds its chunk as a pointer line at the position its dependencies and value give it.
