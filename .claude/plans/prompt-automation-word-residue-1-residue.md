---
prompt:
  for: a fresh session, run in parallel with the other prompt-* files of 2026-10-18; the layers and command-contracts prompts wait for it
  written: 2026-10-18
  plan: plan-automation-word-residue
---

# Prompt: retire the folder meaning of "automation"

You work in `C:\projects\catzc`, one of several sessions running in parallel on this repository. Read `.claude/CLAUDE.md`, then
`docs/adr/index.md` (cite rules by code, never sweep the corpus), then `docs/adr/repository/ai-agent-contract.md`, then
`.claude/plans/plan-automation-word-residue.md` in full (its Decided section is binding: the layer and ADR-domain meaning stays, only the
folder meaning goes; generated files are fixed at their source and regenerated) and `out/automation-usage-overview.md`, then
`docs/adr/automation/layers.md` and `docs/adr/principles/one-living-version.md`.

Do the plan's open steps in its order, one file at a time, each with the check the step names (a grep for the residue on that file, its
own test file under `Invoke-TestFile`, `Test-Comments` and `Test-Links -Path` on a comment page, `Test-Links -Path` on a doc page). C# edits
need a fresh `pwsh`. The asset folder move is yours: you are authorised to run exactly one git command,
`git mv docs/references/.assets/automation docs/references/.assets/pwsh`, then the steps that depend on it (STYLE.md, the verify notes,
the pages that link in, re-pointed with the `link-fixer` robot one file at a time). The `describe.py` fix and the regeneration of the
asset descriptions run in the background behind a GNU `timeout` prefix. Skip and list in the report: `docs/adr/repository/conventional-
folders.md` (the diagram-ADR session owns it and will change line 272), every step that edits a file under `.claude/plans` (the closeout
session does those), the two open questions (the decision round holds them), and the pipeline names and avoid phrasings (P5 and P6 of the
layers plan, another session). Pages that also say "automation layer" or "PowerShell layer" get only the folder-meaning fix here; the
layers session rewords the rest after you.

Owns: every file the plan's steps name, minus the skips; `docs/references/pwsh/catzc-base-globs/Get-ModuleGlobSet.ps1.md` wholly,
including its comment:4 section, which must name a line the source has (`Export-Comments` on the source). In `pwsh/Catzc.Base.Variants`
you own only `types/VariantTrack.cs` and `types/VariantsConfig.cs`; another session moves that module's functions. Re-read a file right
before editing it. Never run Test-Automation or a gate over the whole tree; a final session does that once, last; the plan's last step,
the empty residue scan, is a `git grep`, run it. Never edit `.claude/plans`. No git add, commit, push or mv beyond the one named. Every
Bash call runs under the time safeguard (foreground `timeout: 3000`; longer work in the background behind a GNU `timeout` prefix). The
typed DLL under `pwsh/.compiled` changes under you and is ignored.

End by writing `out/reports/automation-word-residue-1.md`: what landed with each verdict line, the residue scan's output, the skipped
steps, every file touched.
