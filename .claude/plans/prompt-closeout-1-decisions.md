---
prompt:
  for: a fresh session; run this one FIRST and alone, the other prompt-* files of 2026-10-18 read its decisions
  written: 2026-10-18
  plan: plan-master
---

# Prompt: the decision round of 2026-10-19

You work in `C:\projects\catzc`. Read `.claude/CLAUDE.md`, then `docs/adr/index.md` (cite rules by code, never sweep the corpus), then
`docs/adr/repository/ai-agent-contract.md`, then `.claude/plans/task-decision-round.md` and the six plans it names.

Run the `plan-decide` round exactly as that task says: `questionnaire-2026-10-19.md` with one item per question, the recommendation
first; ask four items at a time; record every answer with its projected outcome in `decisions-2026-10-19.md` (the table form of
`decisions-2026-10-18.md`); fold each decision into its owning plan one file at a time with `Test-Links -Path <file>` after each. This
session may edit `.claude/plans`; the parallel sessions may not. Where the user does not answer, write "stays open; the recommendation is
the working assumption" so the parallel sessions can proceed on it. Every Bash call runs under the time safeguard (foreground
`timeout: 3000`; longer work in the background behind a GNU `timeout` prefix). No git add, commit or push. Never run Test-Automation.

End with `Test-Plans -Path .claude/plans` clean and a report to `out/reports/decisions.md`: the decisions taken, the ones left open with
their working assumption, and the prompts they unblock.
