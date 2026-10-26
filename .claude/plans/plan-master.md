---
plan:
  status: active
  value: highest
  reviewed: 2026-10-21
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
- A move or delete of tracked files is the agent's, on disk (plain move, plain delete), with the edits around it in the same step; git stays
  the user's (the user, 2026-10-20): no `git mv`/`git rm` script, the user stages, commits and pushes.
- The order is the position of a pointer line in the Chunks list below, and nothing else (ADR-REPO-PLANS-MASTERANDTASKS,
  ADR-REPO-FOLDERS-STABLEFILENAMES). A task name says what the task does; no name, head key or reference carries a number, so reordering the
  list renames nothing.
- Clear and restart: delete `task-*.md`, reset every pointer line here to its chunk from the source plans, re-stamp `reviewed`. Nothing else
  is touched. The plans themselves are never deleted by a clear.
- The planner edits only this folder. It runs no gate and no code; a check named in a step is for the executor.
- Blocked chunks stay in order but carry `blocked_on`; the executor skips them and moves on.
- The user's steps (a commit, a remote run, an external binding) are gathered in one task, task-user-runs-and-commits, so that one list is
  the whole ask of the user; every other task names the step there it waits on.
- Checks are small and direct: one test file under `Invoke-TestFile`, one gate on named paths, a grep, a file read. No step runs
  `Test-Automation`, a gate over the whole tree, or anything larger than the file it proves. The one full-repo proof is the user's: a fresh
  session dot-sources `importer.ps1` and runs `Test-Automation` once, by hand; every plan that closes on green closes on that run and on
  nothing earlier.
- The typed DLL under `pwsh/.compiled` changes as many agents work in the repository; no plan, step or check depends on it or on its commit.
- A plan file edited by a task for its own reason loses its bare vocabulary terms in that edit (D15); no sweep.
- The order below: first the chunks an agent can take without the user, by value (value-of-plan.md) with dependencies first; then the chunks
  that wait on the user's runs and commits; the closing sweep after every batch and last.

## Chunks

Open, in execution order. A chunk without a task file is executed from its plan's open steps directly. The questions raised after the round
of 2026-10-21 are decided (the second round of that day) and folded into their plans.

- types-build-local -> plan-types-build-local.md: landed; blocked_on the user's untrack (task-user-runs-and-commits item 27)
- types-contract -> plan-types-contract.md: landed as pwsh.internal.types; blocked_on the user's untrack (task-user-runs-and-commits
  item 27)
- language-lamps -> plan-language-lamps.md: landed; blocked_on the user's editor check (task-user-runs-and-commits item 23)
- vscode-extensions -> plan-vscode-extensions.md: landed; blocked_on the user's editor check (task-user-runs-and-commits item 23)
- repo-filters -> plan-repo-filters.md: the filters landed (sets from the model, union of lit lamps, coverage asserted, docs and out lamps);
  one step left: the user's look at the lamps in VS Code (the `pipelines` and `infrastructure` lamps landed)
- track-model -> plan-track-model.md: tracks as members with generated and committed facts, catch-up vendor tracks and `out` for the root,
  globsets derived from tracks, a DDR-VENDOR for the vendor umbrella, normal-form track names, filter lamps per aspect plus a language
  field, minimaps and lamps out of the ADRs; eighteen steps, the first waiting on the user's example names
- reference-normal-form -> plan-reference-normal-form.md: reference pages at a derived path
  (`docs/references/<language>/<module>/<aspect path>/<file>.md`), no `docs:` links; steps 1 and 2 staged by catzc-2b in its scratchpad,
  then the step-3 rename script, then the user's rename
- module-types-contracts -> plan-module-types-contracts.md: each module group publishes its compiled type surface as `types.json` beside its
  command contracts, replacing the global sample; command contracts' types checked against it
- idiomatic-names -> plan-idiomatic-names.md: one step left, the naming gate wired into languages.yml once the user stages the folder moves
  (task-user-runs-and-commits).
- listen-internal-readers -> plan-listen-internal-readers.md: one step left, the user's `.claude/CLAUDE.md` edit
  (task-user-runs-and-commits); the plan closes when it lands.
- agent-shortcuts -> plan-agent-shortcuts.md: one step left, the gate runner's CLAUDE.md line (the user's, task-user-runs-and-commits).
- bcl-language -> plan-bcl-language.md: one step left, the CLAUDE.md line (the user's, task-user-runs-and-commits).
- agent-friction -> plan-agent-friction.md: the user's CLAUDE.md trims only (task-user-runs-and-commits).
- claude-diet -> plan-claude-diet.md: the user's CLAUDE.md edit (Sub-agents and Inspiration cuts, the pwsh index named;
  task-user-runs-and-commits), then the capability lines (catzc-run, catzc-verify, git-readonly, devbox-diagnose).
- session-learnings -> plan-session-learnings.md: catzc-49's lines only (waits on catzc-49).
- drs-system -> plan-drs-system.md: one step left, the user's CLAUDE.md edit (task-user-runs-and-commits).
- debt-tier-tripwire -> plan-debt-tier-tripwire.md: 165 L0/L1 tests launch git and fail only when a tier runs alone; seams mocked, the
  tripwire armed per container; blocked_on the user's case-only staging (task-user-runs-and-commits item 18), then the
  ConvertTo-NormalName.Tests.ps1 L1 rerun
- diagram-review -> plan-diagram-review.md: the diagrams reviewed with the user one named slide at a time (read, one question in context,
  one plan step from the written answer, a redraw after each); the user names the slides
- debt-agent-traffic -> plan-debt-agent-traffic.md: fewer messages and tool calls between the orchestrator and its workers (a run lock,
  one-line reports, pre-approved rule edits, derived step counts, an automatic log); blocked_on the user (task-user-runs-and-commits
  item 17)
- debt-full-run-failures -> plan-debt-full-run-failures.md: the last full run's failing files rerun one at a time, since a red test blocks
  the user's full run; one step (the rename)
- debt-test-speed -> plan-debt-test-speed.md: the slowest Pester files measured one at a time in the memory queue, and the import every test
  run pays; two steps
- debt-function-help -> plan-debt-function-help.md: the 29 functions whose help the ps-help step cannot repair, written on their comment
  pages, one module per step; four steps
- vscode-session-binding -> plan-vscode-session-binding.md: the one-instance-per-session decision observed in VS Code: the hang proven gone
  or caught from the inside, and the two janitors that talk to the editor and dotnet from inside its own session judged
- comment-insights -> plan-comment-insights.md: distilled one-line insight comments back in code at the line each comment page section
  names, below the export threshold
- comment-articles -> plan-comment-articles.md: every comment page pruned into a small reference article on its source file, gold back in
  source as one line, ready for the next export
- slim-agents -> plan-slim-agents.md: four model drones, every job a skill; 22 robots to 4, duplicates merged
- flow-lens -> plan-flow-lens.md: flow lens: CI/CD flow diagrams of the ADO and GitHub pipelines, drawn with a three-symbol glyph set
- user-runs-and-commits -> task-user-runs-and-commits.md: the user's steps, the only list of them.
- closing-sweep -> task-closing-sweep.md: runs after every batch; done plans deleted, done steps pruned; last of all, after the user's full
  run, the master and the task files go with the last plan.

A new plan or paste adds its chunk as a pointer line at the position its dependencies and value give it.
