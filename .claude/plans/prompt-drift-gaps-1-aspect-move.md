---
prompt:
  for: a fresh session, run in parallel with the other prompt-* files of 2026-10-18
  written: 2026-10-18
  plan: plan-explanation-drift-gaps
---

# Prompt: one read path for aspects, and the Variants comment page

You work in `C:\projects\catzc`, one of several sessions running in parallel on this repository. Read `.claude/CLAUDE.md`, then
`docs/adr/index.md` (cite rules by code, never sweep the corpus), then `docs/adr/repository/ai-agent-contract.md`, then
`.claude/plans/plan-explanation-drift-gaps.md` and `.claude/plans/task-explanation-drift-gaps.md` step 1, then in full the ADR the index
lists as ADR-REPO-VARIANT and `docs/adr/automation/module-model.md`.

Move `Get-Aspect.ps1` and `Test-AspectDeclaration.ps1` with their tests from `Catzc.Base.Modules` into `Catzc.Base.Variants`, reading
through the private `Get-Variant` so `aspects` has one read path; both `.psd1` export lists, `Get-WorldMap`'s call and its test, the Modules
reference page (one responsibility left) and the Variants reference page follow; then the articles under `docs/explanation/repository/` that
state the Variants primitive count or name `Get-Aspect` get the new count and name in their text (text only; a slide change is diagram work
and goes in the report). Then `Export-Comments` on `variants.yml` so its comment page
(`docs/references/pwsh/catzc-base-variants/configs/variants.yml.md`, comment:4) names a line the file has, `Test-Comments` 0 on it.

Owns: `pwsh/Catzc.Base.Modules/**`, `pwsh/Catzc.Base.Variants/**` except `types/VariantTrack.cs` and `types/VariantsConfig.cs` (the
automation-word-residue session edits two example strings there), `pwsh/Catzc.Base.Maps/Get-WorldMap.ps1` and its test file,
`docs/references/pwsh/catzc-base-modules.md`, `catzc-base-modules/**`, `catzc-base-variants.md`, `catzc-base-variants/**`, and the article
text under `docs/explanation/repository/`. Touch nothing else; re-read a file right before editing it; one file at a time, each verified by
its own test file under `Invoke-TestFile` or one gate on that path (`Test-Links -Path`, `Test-Comments`, `Test-FileMeta`,
`Test-ScriptAnalyzer`); the Variants, Modules and Maps L0 files pass; a grep for `Get-Config -Config variants` over `pwsh/**/*.ps1` hits
only Catzc.Base.Variants. Never run Test-Automation or a gate over the whole tree; a final session does that once, last. Never edit
`.claude/plans`. No git add, commit, push or mv (a moved function is a new file and a deleted one; say so in the report). Every Bash call
runs under the time safeguard (foreground `timeout: 3000`; longer work in the background behind a GNU `timeout` prefix). The typed DLL under
`pwsh/.compiled` changes under you and is ignored.

End by writing `out/reports/drift-gaps-1.md`: what landed with each verdict line, what is left and why, every file touched.
