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

- Sources: `plan-*.md` and `value-of-plan.md`; decisions live in their ADRs. Never a signal lost: a step leaves a plan
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

Open, in execution order. Nothing below is held by a session; every chunk that an agent can take without the user has landed, and done
work is pruned (git holds it). `out/delete-done-plans.ps1` holds the `git rm` lines of the done plans, task files and prompts.

- adr-code-runtime-residue -> plan-adr-code-runtime-residue.md: gates that still compose numbered ADR citations at runtime (no user
  step).
- explanation-drift-gaps -> task-explanation-drift-gaps.md: the Q1 to Q3 proofs from the user's runs; the `only-pwsh-compiles-its-aspects`
  rename once the user has run its two `Move-Diagram` calls (a session then re-points what is left and runs the checks).
- automation-word-residue -> plan-automation-word-residue.md (blocked on the user's references asset folder `git mv`): then link-fixer
  over the pages that link into it.
- diagram-folders-rest -> plan-diagram-folders-rest.md: the 18 flat slides outside docs/explanation; the prepared Move-Diagram
  script (the user runs it, after the references asset `git mv`), then `Build-Diagrams -Path` per new folder.
- promotion-ladder -> plan-promotion-ladder.md: the `<unit>-dev` to `<unit>-main-uat` rename and the certifying record, after the user's
  CD proof run.
- layers-classification-flip -> task-layers-classification-flip.md: P6, the `ci-automation` pipeline rename and the `automation` layer
  form's retirement, on the day the user re-points the external definitions.
- test-run-budget -> task-test-run-budget.md: read the next full run's wall clock against the 347 s table.
- module-model-closeout -> task-module-model-closeout.md: closes on the final full run.
- root-config-fixtures -> task-root-config-fixtures.md: closes on the user's Push-Dirty run.
- bounded-enumeration-closeout -> task-bounded-enumeration-closeout.md: closes on the final full run, then the plan and its prompt are
  deleted.
- out-artifacts -> task-out-artifacts.md: closes on the user's two probe deletions.
- user-runs-and-commits -> task-user-runs-and-commits.md: the user's steps, the only list of them. Closes plan-fast-push-followups and the
  user-owned steps of the plans above.
- closing-sweep -> task-closing-sweep.md: runs after every batch; done plans deleted, done steps pruned.
- final-full-run -> task-user-runs-and-commits.md, its last step, after every chunk above: a new session, `. ./importer.ps1`, then
  `Test-Automation` once over the whole repository, by hand; the one place the tree is tested. Closes plan-bounded-folder-enumeration,
  plan-file-head-immutable-edges-classes, plan-module-model-closeout and plan-test-run-budget's shard check.
- closing-sweep, last -> task-closing-sweep.md, its last step: the plans that closed on green deleted; the master and the task files
  deleted when every chunk is done.

Every chunk is a task file, apart from adr-code-runtime-residue, automation-word-residue, diagram-folders-rest and promotion-ladder, whose plans are the executable. A new plan or paste
adds its chunk as a pointer line at the position its dependencies and value give it.
