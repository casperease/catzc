---
name: plan-clear
description: >
  Clean one plan file in .claude/plans, or every plan when none is given, to the plan rules: a verdict per rule, acted on one at a time;
  never a plan that still has an open step deleted; input is the plan's repository path, or none.
user-invocable: false
allowed-tools: Bash, Read, Glob, Grep, Write, Edit
paths: .claude/plans/**
metadata:
  catzc:
    config:
      model_floor: sonnet
      needs: [pwsh]
---

# plan-clear

1. Glob the plans (the one given, or every `.claude/plans/plan-*.md`), skipping a peer-dirty one, and Read each in turn, head first: `plan:`
   with status, value, reviewed, targets; the name is `plan-<topic>.md`, no rank or order prefix.
2. One verdict per rule, each with the line it rests on: keep; trim (carried text whose data is in the tree); re-point (`out/plan-x.md` for
   a sibling, relative links written from out/); delete (no open step); intake (a pasted item no plan holds); write them to
   `out/plan-clear-<topic>.md`.
3. Act on one verdict at a time with Edit, re-reading the file after each; never delete a plan that still has an open step, never drop a
   signal.
4. A delete removes the done plan on disk, never a git command, listed for the user's commit; its row in `value-of-plan.md` becomes one line
   saying it was deleted and why (ADR-REPO-PLANS-DONEPLANDELETED), nothing else in that file touched.
5. Every plan edit ends with `Format-Code -Path <the plans touched>` then `Test-Plans`, through catzc-run, never a whole-tree format; then
   md-links on each edited file.
6. Report the verdict files, the plans touched and deleted, the link-check lines verbatim, and what was left undone and why.
