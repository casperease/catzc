---
task:
  status: open
  plans: [plan-master]
  value: highest
  blocked_on: nothing; every step is the user's own commit, git operation or command, and the last is the final session's full run
  targets: [.claude/plans, out, docs]
---

# Task: the user's commits, git operations, and the one final full run

Every step here is one the user does by hand, because agents never run mutating git and never run all tests (ADR-REPO-AI;
`.claude/CLAUDE.md`, No mutating git operations). A check is one test file under `Invoke-TestFile`, one gate on named paths, a grep or a
file read. The one full-repo proof is the last step, a final new session that dot-sources `importer.ps1` and runs `Test-Automation` once
over the whole repository. The typed DLL under `pwsh/.compiled` is ignored by every step. Order: the commits and git operations first, the
final full run last.

## Steps

1. The final full run, in a fresh session, when the chunks in plan-master have landed. Once it is green and committed, the work is done and
   every plan, task and prompt in `.claude/plans` is deleted (the user, 2026-10-20). Check: `.claude/plans` is empty.

## Report

As report-fixed: which steps the user reported done, with each verdict line.
