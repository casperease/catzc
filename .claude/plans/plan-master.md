---
plan:
  status: active
  value: highest
  reviewed: 2026-10-19
  role: master
  targets: [.claude/plans]
---

# Master: every open step of every plan, in one executable order

This is the one long plan. It holds every open step of every `plan-*.md` in this folder, grouped into chunks and ordered for execution. A
chunk is written out as `task-<topic>.md`, a detailed step-by-step executable, and the chunk here shrinks to one pointer line. The source
plans stay the durable record; task files and this master are derived from them and can be cleared at any time and rebuilt.

## Process (the planner's own rules)

- Sources: `plan-*.md` and `value-of-plan.md`; decisions live in their ADRs. Never a signal lost: a step leaves a plan only when its task
  file carries it, and the plan keeps the checkbox until the work lands in the tree.
- A task file is `task-<topic>.md`, at most 50 in the folder, one chunk each: head (`task:` with status, plans, value, blocked_on, targets),
  then numbered steps. Every step names one file, the exact edit, and the check that proves it. One file per step, verified before the next.
  A chunk gets a task file when its plan's open steps are not executable as written; otherwise the plan's open steps are the executable.
- A move of tracked files (`git mv`) is the user's, like every mutating git command: the plan's step names the move,
  task-user-runs-and-commits lists it, and the agent prepares the `git mv` lines in `out/run-user-git.ps1` for the user to run, then does
  the edits around the move.
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
  `Test-Automation`, a gate over the whole tree, or anything larger than the file it proves. The one full-repo proof is the user's: a fresh
  session dot-sources `importer.ps1` and runs `Test-Automation` once, by hand; every plan that closes on green closes on that run and on
  nothing earlier.
- The typed DLL under `pwsh/.compiled` changes as many agents work in the repository; no plan, step or check depends on it or on its commit.
- A plan file edited by a task for its own reason loses its bare vocabulary terms in that edit (D15); no sweep.
- The order below: first the chunks an agent can take without the user, by value (value-of-plan.md) with dependencies first; then the chunks
  that wait on the user's runs and commits; the closing sweep after every batch and last.

## Chunks

Open, in execution order. Held chunks (the orchestrator, 2026-10-19): generated-file-heads by catzc-64, ado-and-cicd-docs by catzc-2f,
rungs-registry by catzc-08 (importer-mix landed, its plan in `out/delete-done-plans.ps1`); iac-and-repo-placement waits while catzc-cc's isolated track holds `pwsh/Catzc.Base.Variants`; done work is pruned (git holds it). `out/delete-done-plans.ps1` holds the `git rm` lines of the done plans, task
files and prompts. A chunk without a task file is executed from its plan's open steps directly.

- generated-file-heads -> plan-generated-file-heads.md: the one warning string, the README generator's head-only provenance, the other
  tracked generators, the `Test-RootConfigFiles` branch, then the seven `copyAsLink` root files one at a time, `.editorconfig` the pilot.
- ado-and-cicd-docs -> plan-ado-and-cicd-docs.md: the `variants.yml` re-point and the caller sweep around the user's `git mv` of
  `pipelines/` to `.ado/pipelines/`; the 23 ado rules to `docs/adr/ado`, the four concept rules into the CI/CD concept ADR in
  `docs/adr/flow`, the ado wording.
- adr-automation-split -> plan-adr-automation-split.md: `docs/adr/pwsh/` into `docs/adr/automation/pwsh/` around the user's `git mv`, then
  the flat automation files by the plan's table, then the index and `adrs.yml`.
- layers-stray-rules -> plan-layers-vocabulary-rename-contracts.md, steps 2 and 3: the twelve stray pwsh rules to their twins and the
  contract drift test; after adr-automation-split's first step.
- iac-and-repo-placement -> plan-iac-and-repo-placement.md: the three IaC places in `variants.yml`, the literal paths re-pointed, and the
  two ADR rule sets; its five diagrams are the diagram track's.
- rungs-registry -> plan-promotion-ladder.md, step 1: the new `Catzc.Base.Flow` module with the four rungs, their gates and environment
  suffixes; takeable now, and the diagram track's last minimap reads it.
- explanation-drift-gaps -> task-explanation-drift-gaps.md: the Q1 to Q3 proofs from the user's runs (blocked_on task-user-runs-and-commits
  steps 1 and 2).
- promotion-ladder -> plan-promotion-ladder.md, steps 2 and 3: the `<unit>-dev` to `<unit>-main-uat` rename and the certifying check, after
  the user's CD proof run.
- layers-classification-flip -> task-layers-classification-flip.md: P6, the `ci-automation` pipeline rename and the `automation` layer
  form's retirement, on the day the user re-points the external definitions.
- user-runs-and-commits -> task-user-runs-and-commits.md: the user's steps, the only list of them.
- closing-sweep -> task-closing-sweep.md: runs after every batch; done plans deleted, done steps pruned; last of all, after the user's full
  run, the master and the task files go with the last plan.

A new plan or paste adds its chunk as a pointer line at the position its dependencies and value give it.

Isolated, outside the order above (the user, 2026-10-19): plan-diagram-engine.md is taken by its own session from its own open steps, in
their order; no chunk above waits on it, and it waits on nothing above except the rungs registry step of promotion-ladder for its last
minimap and the IaC rule steps for its last two diagrams. Its moves of tracked files are still listed in task-user-runs-and-commits.
