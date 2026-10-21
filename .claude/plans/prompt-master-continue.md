---
prompt:
  for: a fresh session that executes the master's chunks in order
  written: 2026-10-19
  plan: plan-master
---

# Prompt: execute the next chunk of the master plan

You work in `C:\projects\catzc`, one of several sessions on this repository. Read `.claude/CLAUDE.md`, then `docs/drs/index.md` (cite rules
by code, never sweep the corpus), then `docs/drs/repository/ai-agent-contract.md`, then `.claude/plans/plan-master.md`: its Process section
is the method, its Chunks list is the order. Take the first chunk whose plan has an open step an agent can take without the user; the
diagram track is not yours. Read that chunk's plan in full, head first, before any edit, and the ADRs that govern the files it touches.

Trust the tree over the plan: a step whose premise a read contradicts gets the correction recorded in the plan, then you continue. One file
per step, verified by the check the step names before the next; tick a step with its verdict line only when the tree holds the work. A
decision lands as an ADR rule in the same change as its step. A move or delete of tracked files is yours, on disk (plain move, plain
delete); git is the user's: no git add, mv, rm, commit or push, and no git script. Every Bash call runs under the time safeguard (foreground
`timeout: 3000`; longer work in the background behind a GNU `timeout` prefix around one command). Never run Test-Automation or a gate over
the whole tree; run the one test file or gate the step names. The typed DLL under `pwsh/.compiled` is ignored. After any edit to
`.claude/plans`, run `Format-Code -Language markdown -Path .claude/plans` and `Test-Plans`.

Stop and ask the user when a step needs a decision the plan does not record, a mutating git command, or an external binding. End with the
report-fixed shape: files touched, checks run with each verdict line verbatim, left undone with the reason, and the next chunk's name.
