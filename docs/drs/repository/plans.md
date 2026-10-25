# ADR-REPO-PLANS: plans that stay true

## Rules: ADR-REPO-PLANS

### Rule ADR-REPO-PLANS-ONETOPICONEFILE

A **plan** is one topic in one file, `.claude/plans/plan-<topic>.md`, authored directly there, and it holds the delta only: what is still
open, and what was decided and why. The tree, the decision records and git hold everything else, what landed included. A plan starts with
`New-Plan`, which writes its head, its open steps section, its value row and its master line, and refuses a topic that has a plan. The topic
is prose, spell-checked wherever `plan-master.md` or `value-of-plan.md` cites it, so a coined topic word goes into `terminology.yml` before
the plan is named.

- [The delta, not the record](#the-delta-not-the-record)

### Rule ADR-REPO-PLANS-PLANHEAD

The head carries a `plan:` block with `status` (`active` or `blocked`), `value`, `reviewed` (the date the cleaner last judged it) and
`targets` (the paths the plan changes, each one existing); `blocked_on` or `waits_on` names what blocks it when it is blocked. `value` is
one of the ranks `value-of-plan.md` orders by, and that file is the one sorting overlay.

- [One head, one overlay](#one-head-one-overlay)

### Rule ADR-REPO-PLANS-THREEPARTS

A plan is three parts: its file, its row in `value-of-plan.md` and its chunk line in `plan-master.md`, the line that points at the file
(`- <chunk> -> plan-<topic>.md: ...`). A plan missing either line is a finding, so no instruction has to say that a new plan needs them. A
step count that the chunk line or the row states equals the plan's open steps.

- [One head, one overlay](#one-head-one-overlay)

### Rule ADR-REPO-PLANS-ONESHAPE

A plan has one shape: the head, why its value, what is decided, the open steps, the refs; it has no section for what is done; text carried
verbatim from elsewhere sits below a "Carried" heading, after the shape. The open steps section is always present; the others are present
when they have content. There is no line roof: the cleaner shortens a plan only after its data is in the tree, never by dropping a signal.

- [The shape](#the-shape)

### Rule ADR-REPO-PLANS-OPENSTEP

An **open step** is a checkbox line that names one file, the edit, and the check that proves it, `(check: ...)` on the same item, in present
tense. A step that lands is deleted once the tree holds the work, never ticked and kept; its record is the tree and `git log`. A check names
commands that exist: `Test-Plans` resolves each through `Get-Command` in the session that runs it, so the answer depends on what that
session has imported.

- [The shape](#the-shape)

### Rule ADR-REPO-PLANS-DONEPLANDELETED

A plan with no open step is deleted, always, and `value-of-plan.md` keeps one line saying it was deleted and why. Git keeps the text; the
tree never does.

- [Done is deleted](#done-is-deleted)

### Rule ADR-REPO-PLANS-NOINUSEFILES

A plan never plans, asks about or counts a file that is in use: untracked, unstaged, or dirty in a peer's session. At most one context line
names such a file.

- [In-use files](#in-use-files)

### Rule ADR-REPO-PLANS-CONTINUATIONPROMPT

A **continuation prompt** is `prompt-<topic>-continue.md`, or `prompt-<topic>-<n>-<step>.md` for a numbered series, beside its plan, carried
verbatim, with a header that maps every path the paste names to where the text now lives.

- [Prompts beside their plans](#prompts-beside-their-plans)

### Rule ADR-REPO-PLANS-MASTERANDTASKS

The **master plan**, `plan-master.md`, and the **task files**, `task-<topic>.md` with at most 50 in the folder, are derived executables
rebuilt from the plans: the master holds every open step of every plan in one executable order, and a task file is one chunk of it, named by
its topic. The order is the master's list alone; no task name, head key or reference carries a number (ADR-REPO-FOLDERS-STABLEFILENAMES).
They are cleared and rebuilt; the plans are never deleted by a clear.

- [Derived executables](#derived-executables)

### Rule ADR-REPO-PLANS-DECISIONSBECOMERULES

Every constraining decision a plan records becomes a DRS rule in the same change that lands it; a decision with no ADR to hold it is
reopened, not kept as plan text.

- [Decisions become rules](#decisions-become-rules)

## Context

A plan is written for a reader who was not there: another session, a sub-agent on a small model, the same person a week later. Everything a
plan carries that the tree also carries is a second source of truth that drifts, and everything it carries that nothing checks is a claim.
The plans folder is tracked, so git keeps every version; the folder itself only has to hold what is still true and still open. Two agents
keep it so: the cleaner, `plan-clear`, judges each plan against the tree and acts, and the gate, `Test-Plans`, holds every file in the
folder to the shape this ADR states.

### The delta, not the record

A plan that narrates what happened grows without bound and is wrong a week later. A plan that holds the delta is short by construction: when
a step lands, it is deleted and the plan keeps only what is still open; when the last step lands, the plan goes. The record of what happened
is `git log` on the plan and on the files it changed
([one-living-version](../principles/one-living-version.md#rule-pdr-onelive-historyingit)).

### One head, one overlay

The head is what a tool reads without reading the plan: whether it is active or blocked, how much it is worth, when it was last judged, and
which paths it touches. `value-of-plan.md` orders the plans by value and by the doctrine and proof each needs before it counts as landed,
never by job size; each head's `value` carries the same rank, so a plan sorts the same from its head and from the overlay. A plan the
overlay or the master does not list is invisible to whoever reads them to pick the next job, so the gate holds a plan to all three parts.

### The shape

The sections answer the reader's questions in the order a reader asks them: why does this matter, what is settled, what is left, where do I
look. What is already there is the tree's to say, so a "done" section would be a second record that drifts (the user, 2026-10-20: a plan
holds only planned work). A reader who finds the open steps finds the whole remaining job, each step naming its file and its proof, so a
sub-agent can take one step cold. Carried text, a draft or a paste kept verbatim, sits last, so the shape is read before the material.

### Done is deleted

Keeping a finished plan "for the record" is the habit this repository does not have
([one-living-version](../principles/one-living-version.md#rule-pdr-onelive-nodeadcode)). The one line in `value-of-plan.md` says what was
deleted and why, so a reader who misses a plan finds the reason in one place and the text in git.

### In-use files

A file another session is editing, or a file not yet tracked, has no settled state to plan against. A plan that names it plans a moving
target and tempts the next session into a peer's work. One context line, "a peer holds this file", is all a plan says.

### Prompts beside their plans

A continuation prompt is the exact text a person pastes into a fresh session. It is kept verbatim because a rewritten prompt is a different
prompt; it is kept beside its plan because its reading list names that plan; and its header re-points the paths the paste names, since the
drafts it was written for have moved into the plans.

### Derived executables

The plans are the durable record; an executor wants one ordered list. The master plan and the task files are that list, derived from the
plans and disposable: a step leaves a plan only when its task file carries it, and the plan keeps the checkbox until the work is in the
tree. A task is named by what it does, so a reference to it reads the same after the master reorders its list, and a reader never has to
know where a task sits to find it ([conventional-folders](conventional-folders.md#rule-adr-repo-folders-stablefilenames)).

### Decisions become rules

A plan records what was decided so that work can proceed; the decision binds only once a DRS rule states it, cites its reason and is held by
a check. A decision that lives only in a plan is lost when the plan is deleted, which is why it is written as a rule in the same change or
reopened as a question.

## Decision

Plans are deltas with one shape and one head, judged by the cleaner and held by the gate; a done plan is deleted; the master and the task
files are derived; every decision a plan records becomes a DRS rule.

## Consequences

- `Test-Plans` holds every file in `.claude/plans` to these rules and names the rule each finding breaks; `plan-clear` acts on the verdicts.
- `.claude/CLAUDE.md` says where plans are authored and that a done plan is deleted.
- A continuation prompt and a plan are never merged; the prompt stays verbatim beside the plan.
