---
prompt:
  for: a fresh session that owns the isolated diagram track
  written: 2026-10-19
  plan: plan-diagram-engine
---

# Prompt: the diagram track

You work in `C:\projects\catzc`, one of several sessions on this repository, and you own the diagram track alone. Read `.claude/CLAUDE.md`,
then `docs/adr/index.md` (cite rules by code, never sweep the corpus), then `docs/adr/repository/ai-agent-contract.md`, then
`.claude/plans/plan-diagram-engine.md` in full, then `docs/adr/repository/slides-as-markdown.md`. The plan's Decided list is binding; its
open steps are your order; no other plan or session waits on you, and you wait on nothing but the two steps the plan names.

Take the open steps top to bottom, one file per step, each verified by the check the step names before the next; tick a step with its
verdict line only when the tree holds the work. A decision lands as an ADR-REPO-SLIDES rule in the same change as its step. Render nothing
the steps do not ask for, and stop for the user's review where a step says so. A move of tracked files is the user's: write its `git mv`
lines to `out/run-user-git.ps1`, tell the user, and continue with the steps that do not depend on it. No git add, commit, push or mv. Every
Bash call runs under the time safeguard (foreground `timeout: 3000`; longer work in the background behind a GNU `timeout` prefix around one
command). Never run Test-Automation or a gate over the whole tree. The typed DLL under `pwsh/.compiled` is ignored.

Stop and ask the user when a step needs a decision the plan does not record, a mutating git command, or a diagram review. End with the
report-fixed shape: files touched, checks run with each verdict line verbatim, left undone with the reason.
