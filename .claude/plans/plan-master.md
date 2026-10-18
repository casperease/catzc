---
plan:
  status: active
  value: highest
  reviewed: 2026-10-18
  role: master
  targets: [.claude/plans]
---

# Master: every open step of every plan, in one executable order

This is the one long plan. It holds every open step of every `plan-*.md` in this folder, grouped into chunks and ordered for execution. A
chunk is written out as `task-<topic>.md`, a detailed step-by-step executable, and the chunk here shrinks to one pointer line. The source
plans stay the durable record; task files and this master are derived from them and can be cleared at any time and rebuilt.

## Process (the planner's own rules)

- Sources: `plan-*.md`, `value-of-plan.md`, `decisions-2026-10-16.md`, `decisions-2026-10-18.md`. Never a signal lost: a step leaves a plan
  only when its task file carries it, and the plan keeps the checkbox until the work lands in the tree.
- A task file is `task-<topic>.md`, at most 50 in the folder, one chunk each: head (`task:` with status, plans, value, blocked_on, targets),
  then numbered steps. Every step names one file, the exact edit, and the check that proves it. One file per step, verified before the next.
- The order is the position of a pointer line in the Chunks list below, and nothing else (ADR-REPO-PLANS#8, ADR-REPO-FOLDERS#12). A task
  name says what the task does; no name, head key or reference carries a number, so reordering the list renames nothing.
- Clear and restart: delete `task-*.md`, reset every pointer line here to its chunk from the source plans, re-stamp `reviewed`. Nothing else
  is touched. The plans themselves are never deleted by a clear.
- The planner edits only this folder. It runs no gate and no code; a check named in a step is for the executor.
- Blocked chunks stay in order but carry `blocked_on`; the executor skips them and moves on.
- The user's steps (a commit, a remote run, a `git mv`) are gathered in one task, task-user-runs-and-commits, so that one list is the
  whole ask of the user; every other task names the step there it waits on.
- Checks are small and direct: one test file under `Invoke-TestFile`, one gate on named paths, a grep, a file read. No step runs
  `Test-Automation`, a gate over the whole tree, or anything larger than the file it proves. The one full-repo proof is the last step of
  task-user-runs-and-commits: a final new session dot-sources `importer.ps1` and runs `Test-Automation` once, by hand; every plan that
  closes on green closes on that run and on nothing earlier.
- The typed DLL under `pwsh/.compiled` changes as many agents work in the repository; no plan, step or check depends on it or on its
  commit.
- A plan file edited by a task for its own reason loses its bare vocabulary terms in that edit (plan-clear-actions, D15); no sweep.
- The order below: first the decision round that unblocks the most, then the user's commits and runs that close the most plans, then the
  agent work by value (value-of-plan.md), dependencies first, the closing sweep after every batch and last.

## Chunks

Done, task files deleted or awaiting the user's `git rm` (task-user-runs-and-commits step 4):

- Plans-folder hygiene, the decision round of 2026-10-18, ADR-AI, ADR-CATS, body-sha Phase 0, the .unordered audit, the plans ADR, minimal
  robots, layers doctrine, class selectors, assets leftovers, comment pages, skip unchanged generators, idle compaction: done 2026-10-17
  and 2026-10-18, as the plans' Done sections and value-of-plan.md record.
- import-landing-zone, kind-becomes-role, config-defaults-variants, config-defaults-fragment, config-defaults-postures, layers-funnel,
  file-head-leftovers, lazy-types-load, adr-auto-material, adr-link-cleanup: every step in the tree by 2026-10-18; the task files still
  present go with the user's `git rm`.

Open, in execution order:

- decision-round -> task-decision-round.md (open; nothing blocks it): one `plan-decide` round over the six plans with a question only the
  user can answer: the promotion ladder Q1 to Q4, the command-contracts freeze (twelve exported functions nothing calls, 139 only docs
  name), the diagram-folders pilot approval, the out/test-links clearance, probe batch two, a test home for the drawio kit.
- user-runs-and-commits -> task-user-runs-and-commits.md (open; the user's ten steps, in the order they depend on each other; steps 1 to 9
  run early, step 10 is the last chunk of this list): the gitattributes template commit, the `git mv` of the reachability test, the
  `git rm` of done task files, the probe deletions, the keybinding and real Push-Dirty run, the cheap measured watchpoint run of the
  importer, the environment-approvals apply, the CD and CI proof runs, the external re-pointing after P6. Closes
  plan-plans-body-sha-landing-zone and plan-fast-push-followups and the user-owned steps of five more.
- explanation-drift-gaps -> task-explanation-drift-gaps.md (open; step 1 and the slides brief can start now, the three proofs are the
  user's runs): the Get-Aspect move into Catzc.Base.Variants, the Q1 to Q3 proofs read from the run logs, the brief for the five slides
  that draw retired claims, then the slides on the user's go.
- layers-classification-flip -> task-layers-classification-flip.md (open; P3 to P5's ADR edits done 2026-10-18; steps 6 and 7 next): P5 the
  avoid-phrasings for the retired layer forms and the rewording of the 68 pages that still say "automation layer", "implementation layer"
  or "PowerShell layer"; P6 the pipeline rename `ci-automation` to `ci-pwsh` as one atomic set, scheduled on a day the user re-points the
  external definitions (task-user-runs-and-commits step 12).
- command-contracts -> task-command-contracts.md (open; 65 commands contracted; after the decision round's freeze call): the frozen set
  contracted, made internal or deleted as decided, Test-Contracts clean; the later language step for gate results and parameter sets.
- assert-wait -> task-assert-wait.md (open; steps 1 to 6 done; steps 7 and 8 after the user's cheap importer watchpoint run): the ADR pair
  with the D17 rename to Watch-Blocking, then each watchpoint that found a block becomes a timeouts.yml limit and the rest are deleted.
- diagram-folders -> task-diagram-folders.md (open; kit tests and the two subtitle fixes can start now; the move command, the migration of
  all 150 diagrams one article folder at a time, `Build-Diagrams -Path`, the ADR restatements and the emptied folders after the pilot's
  approval).
- test-run-budget -> task-test-run-budget.md (open; step 3 reads the final full run's shard manifest, it starts no run): the shard
  re-check that Invoke-TestFile and Test-Formatting no longer share a shard, then the scheduling option step 4 names.
- loose-ends -> task-loose-ends.md (open; steps 1 to 3 now, 4 and 5 after the decision round): the two stale comment-page sections, the
  `executable` flag and ADR-AUTO-LAYERS rule 2, the vocabulary fixes riding on each edit, the gallery fixture or its drop, the pipelines
  README for the ladder with its ADR rules.
- module-model-closeout -> task-module-model-closeout.md (open; closes on the final full run and the loose-ends comment step).
- root-config-fixtures -> task-root-config-fixtures.md (open; closes on the user's Push-Dirty run).
- unboxing-closeout -> task-unboxing-closeout.md (closed 2026-10-18; the DLL step is ignored by the user's rule, so plan-unboxing has no
  open step and both go with the next closing sweep).
- bounded-enumeration-closeout -> task-bounded-enumeration-closeout.md (open; closes on the final full run, then the plan and its prompt
  are deleted).
- out-artifacts -> task-out-artifacts.md (open; closes on the user's two probe deletions).
- promotion-ladder -> plan-promotion-ladder.md (blocked on the decision round; its README step is task-loose-ends step 5; once Q1 to Q4 are
  answered the plan gains its build steps, main-uat, release-uat behind RC, pre-prod behind RBC, the DEPLOY pipeline, and a task file is
  written for them at this position).
- closing-sweep -> task-closing-sweep.md (open; runs after every batch): done plans deleted with one line each in value-of-plan.md, whose
  table still carries rows for plans already deleted (plan-assets-beside-articles, plan-adr-ai, plan-adr-cats) and lacks rows for
  plan-unboxing's siblings.
- final-full-run -> task-user-runs-and-commits.md, its last step (open; after every chunk above): a new session, `. ./importer.ps1`, then
  `Test-Automation` once over the whole repository, by hand; the one place the tree is tested. Closes plan-bounded-folder-enumeration,
  plan-file-head-immutable-edges-classes, plan-module-model-closeout and plan-test-run-budget's shard check.
- closing-sweep, last -> task-closing-sweep.md step 6: the plans that closed on green deleted; the master and the task files deleted when
  every chunk is done.

Every chunk is a task file, apart from the promotion ladder, which gets one when its questions are answered. A new plan or paste adds its
chunk as a pointer line at the position its dependencies and value give it.
