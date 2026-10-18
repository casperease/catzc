---
prompt:
  for: a fresh session, after prompt-closeout-1-decisions and after the prompt-automation-word-residue-1-residue session has ended (both edit comment pages)
  written: 2026-10-18
  plan: plan-layers-vocabulary-rename-contracts
---

# Prompt: the command-contracts freeze

You work in `C:\projects\catzc`, one of several sessions running in parallel on this repository. Read `.claude/CLAUDE.md`, then
`docs/adr/index.md` (cite rules by code, never sweep the corpus), then `docs/adr/repository/ai-agent-contract.md`, then
`.claude/plans/task-command-contracts.md`, the P7 open step of `.claude/plans/plan-layers-vocabulary-rename-contracts.md`, the freeze
decision in `.claude/plans/decisions-2026-10-19.md` (without it, the working assumption: an exported function nothing calls becomes
private; a function only docs name is contracted), then in full the ADR the index lists as ADR-REPO-CMDCONTRACT.

Rebuild the two lists from the tree with a grep, do not trust old counts: the exported functions no file calls, and the functions only
docs name. Apply the decision one function at a time: a contract asset under `contracts/catzc/0.0.0/<Module>/<Name>.command.yml`, or the
file moved to the module's `private/` with the `.psd1` export line removed and its comment page re-pointed. Then, if the decisions
allow, the language step the task leaves open: gate results and parameter sets in the contract language, the checker and its tests.

Owns: `contracts/**`, the contract checker and its tests in `pwsh/Catzc.Base.Contracts/`, and the function files, `.psd1` and comment
pages of the modules the freeze touches, except `Catzc.Base.Modules`, `Catzc.Base.Variants`, `Catzc.Base.Slides`, `Catzc.Base.Timeouts`,
`Catzc.Base.Globs` and `Catzc.Base.Languages`, which other sessions own: list their functions in the report instead of editing them.
Re-read a file right before editing it; one file at a time, each verified by `Test-Contracts` on that path, the module's own test file
for the function under `Invoke-TestFile`, `Test-Comments` on the page. Never run Test-Automation or a gate over the whole tree; a final
session does that once, last. Never edit `.claude/plans`. No git add, commit, push or mv (a move to `private/` is a new file and a
deleted one; say so). Every Bash call runs under the time safeguard (foreground `timeout: 3000`; longer work in the background behind a
GNU `timeout` prefix). The typed DLL under `pwsh/.compiled` is ignored.

End by writing `out/reports/command-contracts-1.md`: the two lists, what landed per function with its verdict line, the functions left to
other sessions, every file touched.
