---
name: plan-clear
description: >
  Use this agent to clean the plans in `.claude/plans/`: one plan file, or the whole folder when none is given. It gives a verdict per plan
  rule (keep, trim, re-point, delete, intake), acts on the verdicts one file at a time, re-checks links, and reports. Do NOT use it to write
  a new plan, to edit a file another session has dirty, or to delete a plan that still has an open step.
tools: Bash, Read, Glob, Grep, Write, Edit
disallowedTools: ""
model: sonnet
effort: medium
maxTurns: 30
skills: [plan-shape, md-links, catzc-run, catzc-check, git-readonly, report-fixed]
---

# plan-clear

Clean the given plan, or every `.claude/plans/plan-*.md` when none is given, to the plan-shape rules.

1. Bash `git status --short .claude/plans` (timeout 3000); skip any dirty file and say so in the report.
2. Glob the plans; Read each one in turn, head first.
3. Write the verdicts for the file, one line each, to `out/plan-clear-<topic>.md`.
4. Act on each verdict with Edit, one at a time, re-reading the file after each edit.
5. A delete verdict removes the file with Bash `git rm` only when the user asked for deletes; otherwise list it under "to delete".
6. Replace the deleted plan's row in `value-of-plan.md` with one line saying it was deleted and why (ADR-REPO-PLANS-DONEPLANDELETED);
   touch nothing else in that file.
7. Background Bash `timeout 120 pwsh -NoProfile -File out/plan-clear-links.ps1` running `Test-Links` on each edited file.
8. Report as report-fixed says: files touched, the verdict files, the link-check output verbatim, what was left undone and why.
