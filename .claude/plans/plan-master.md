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
- The order is the position of a pointer line in the Chunks list below, and nothing else (ADR-REPO-PLANS-MASTERANDTASKS,
  ADR-REPO-FOLDERS-STABLEFILENAMES). A task name says what the task does; no name, head key or reference carries a number, so reordering the
  list renames nothing.
- Clear and restart: delete `task-*.md`, reset every pointer line here to its chunk from the source plans, re-stamp `reviewed`. Nothing else
  is touched. The plans themselves are never deleted by a clear.
- The planner edits only this folder. It runs no gate and no code; a check named in a step is for the executor.
- Blocked chunks stay in order but carry `blocked_on`; the executor skips them and moves on.
- The user's steps (a commit, a remote run, a `git mv`) are gathered in one task, task-user-runs-and-commits, so that one list is the whole
  ask of the user; every other task names the step there it waits on.
- Checks are small and direct: one test file under `Invoke-TestFile`, one gate on named paths, a grep, a file read. No step runs
  `Test-Automation`, a gate over the whole tree, or anything larger than the file it proves. The one full-repo proof is the last step of
  task-user-runs-and-commits: a final new session dot-sources `importer.ps1` and runs `Test-Automation` once, by hand; every plan that
  closes on green closes on that run and on nothing earlier.
- The typed DLL under `pwsh/.compiled` changes as many agents work in the repository; no plan, step or check depends on it or on its commit.
- A plan file edited by a task for its own reason loses its bare vocabulary terms in that edit (plan-clear-actions, D15); no sweep.
- The order below: first the decision round that unblocks the most, then the user's commits and runs that close the most plans, then the
  agent work by value (value-of-plan.md), dependencies first, the closing sweep after every batch and last.

## Chunks

Done, task files deleted:

- Plans-folder hygiene, the decision round of 2026-10-18, ADR-REPO-AI, ADR-PRIN-CATS, body-sha Phase 0, the .unordered audit, the plans ADR,
  minimal robots, layers doctrine, class selectors, assets leftovers, comment pages, skip unchanged generators, idle compaction: done
  2026-10-17 and 2026-10-18, as the plans' Done sections and value-of-plan.md record.
- import-landing-zone, kind-becomes-role, config-defaults-variants, config-defaults-fragment, config-defaults-postures, layers-funnel,
  file-head-leftovers, lazy-types-load, adr-auto-material, adr-link-cleanup, unboxing-closeout: every step in the tree or closed by
  2026-10-18; value-of-plan.md records each deletion.

Open, in execution order:

State at the round-up of 2026-10-18 (full restart next; no session holds anything). Done that day, task files kept only until the user's
`git rm`: decision-round, command-contracts, loose-ends, assert-wait (one box waits on the reachability `git mv`) and diagram-folders.
`out/delete-done-plans.ps1` lists plan-assets-gallery-pdf, plan-diagram-folders, the done task files (diagram-folders, decision-round,
command-contracts, loose-ends) and the continuation prompts whose work has landed. No plan holds an open question: every question asked by
2026-10-18 is answered and recorded as Decided.

- adr-code-language -> plan-adr-code-language.md (done 2026-10-18 bar its `git rm`): steps 1 to 7 landed (149/149 subtitles, chip legends
  on slide-local keys, 0 numbered codes in the models, decisions in ADR-REPO-ADRCODE; Test-AdrRegistry, Test-Links, Test-Spelling,
  Test-Comments 0). Its deletion is the last line of `out/delete-done-plans.ps1`.
- explanation-drift-gaps -> task-explanation-drift-gaps.md (open): the code move, the slides brief, the five slides and the aspects drift
  landed 2026-10-18; open are the Q1 to Q3 proofs from the user's runs, the `only-pwsh-compiles-its-aspects` rename (the user said yes;
  after the subtitle re-render) and two Supports lines.
- automation-word-residue -> plan-automation-word-residue.md (open): every code, comment, docs and slide step landed 2026-10-18; open is the
  references asset folder `git mv` (task-user-runs-and-commits step 8a) and its four follow-ups.
- promotion-ladder -> plan-promotion-ladder.md (open): steps 1 to 5 and the rung configs landed 2026-10-18; open are the `<unit>-dev` to
  `<unit>-main-uat` rename and the certifying record, both after the user's CD proof run.
- layers-classification-flip -> task-layers-classification-flip.md (open): P5 landed 2026-10-18; open is P6, the `ci-automation` pipeline
  rename on a day the user re-points the external definitions (task-user-runs-and-commits step 8).
- test-run-budget -> task-test-run-budget.md (open): the shard check, the analyzer cache split and the one-pool scheduler landed 2026-10-18;
  open is reading the next full run's wall clock against the 347 s table.
- module-model-closeout -> task-module-model-closeout.md (open; closes on the final full run).
- root-config-fixtures -> task-root-config-fixtures.md (open; closes on the user's Push-Dirty run).
- bounded-enumeration-closeout -> task-bounded-enumeration-closeout.md (open; closes on the final full run, then the plan and its prompt are
  deleted).
- out-artifacts -> task-out-artifacts.md (open; closes on the user's two probe deletions).
- user-runs-and-commits -> task-user-runs-and-commits.md (open; the user's steps, the only list of them): steps 5, 6b and 8b done
  2026-10-18; open are the gitattributes template commit (1), the `git mv` of the reachability test (2), the probe deletions (3), the
  keybinding and real Push-Dirty run (4), the environment-approvals apply with a real approver (6), the CD and CI proof runs (7), the
  external re-pointing after P6 (8), the references asset folder `git mv` (8a), running `out/delete-done-plans.ps1`, and the final full run
  (9). Closes plan-fast-push-followups and the user-owned steps of five more.
- closing-sweep -> task-closing-sweep.md (open; runs after every batch): done plans deleted with one line each in value-of-plan.md. The
  sweep of 2026-10-18 found plan-assets-gallery-pdf and plan-diagram-folders; the round-up added the done task files and landed prompts.
- final-full-run -> task-user-runs-and-commits.md, its last step (open; after every chunk above): a new session, `. ./importer.ps1`, then
  `Test-Automation` once over the whole repository, by hand; the one place the tree is tested. Closes plan-bounded-folder-enumeration,
  plan-file-head-immutable-edges-classes, plan-module-model-closeout and plan-test-run-budget's shard check.
- closing-sweep, last -> task-closing-sweep.md step 6: the plans that closed on green deleted; the master and the task files deleted when
  every chunk is done.

Every chunk is a task file, apart from adr-code-language, automation-word-residue and promotion-ladder, whose plans are the executable. A
new plan or paste adds its chunk as a pointer line at the position its dependencies and value give it.
