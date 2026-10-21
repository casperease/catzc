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

Open, in execution order. A chunk without a task file is executed from its plan's open steps directly. Questions raised after the round of
2026-10-21 are open in agent-friction, claude-diet, truth-stores, session-learnings and test-signal-proposals; they wait on the next
plan-decide round, and only truth-stores and test-signal-proposals are blocked by them.

- idiomatic-names -> plan-idiomatic-names.md: wire the naming gate in (the three folder renames are tracked), then the repository normal
  form: helper and acronym renames, the repair command, and the `0.0.0` command contracts.
- listen-internal-readers -> plan-listen-internal-readers.md: one step left, the user's `.claude/CLAUDE.md` edit
  (task-user-runs-and-commits); the plan closes when it lands.
- agent-shortcuts -> plan-agent-shortcuts.md: one step left, the gate runner's CLAUDE.md line (the user's, task-user-runs-and-commits).
- truth-stores -> plan-truth-stores.md: the approved sample enters the product-thesis deck; blocked_on its Q1 (no slide pattern carries an
  image).
- bcl-language -> plan-bcl-language.md: one step left, the CLAUDE.md line (the user's, task-user-runs-and-commits).
- agent-friction -> plan-agent-friction.md: the head how-to and its drawing sample (free now that minimal-heads has landed); the CLAUDE.md
  trim (the user's).
- git-topic-commands -> plan-git-topic-commands.md: one check left, `Test-Formatting` on the module after plan-minimal-heads' whole-tree
  re-format.
- claude-diet -> plan-claude-diet.md: the user's CLAUDE.md edit only (Sub-agents cut, the pwsh index named; task-user-runs-and-commits).
- adr-authoring -> plan-adr-authoring.md: the glossary contrast declared once and the domain-deps memory deleted, the add-an-adr how-to
  after plan-agent-shortcuts' gate runner, the ADR-edit entry in plan-agent-friction's hook map.
- diagram-build-learnings -> plan-diagram-build-learnings.md: fix the Build-Diagrams help (the sample sequence included), one merged
  catzc-run item, quiet the legend's warning by role, measure then memo the minimap stage, one pipeline drawing for an explanation page.
- accosted-language -> plan-accosted-language.md: the ADR and the reserved word first, then the terminology gate, glossary, language row and
  resolver, the config and typed record, the reader, the run limit and runner, their contracts, the first accosted file.
- session-learnings -> plan-session-learnings.md: one learning reworded and catzc-49's lines appended; eight open questions wait on a
  plan-decide round.
- test-signal-proposals -> plan-test-signal-proposals.md: blocked_on its three questions for the user (the bridge's setup error, one
  spelled-types list, the RungsConfig case); a plan-decide round answers them.
- user-runs-and-commits -> task-user-runs-and-commits.md: the user's steps, the only list of them.
- closing-sweep -> task-closing-sweep.md: runs after every batch; done plans deleted, done steps pruned; last of all, after the user's full
  run, the master and the task files go with the last plan.

A new plan or paste adds its chunk as a pointer line at the position its dependencies and value give it.
