---
prompt:
  for: a fresh session, after the prompt-automation-word-residue-1-residue session has ended; prompt-promotion-ladder-1-build waits for it
  written: 2026-10-18
  plan: plan-layers-vocabulary-rename-contracts
---

# Prompt: layers P5 and P6, the retired forms and the pipeline names

You work in `C:\projects\catzc`, one of several sessions running in parallel on this repository. Read `.claude/CLAUDE.md`, then
`docs/adr/index.md` (cite rules by code, never sweep the corpus), then `docs/adr/repository/ai-agent-contract.md`, then
`.claude/plans/task-layers-classification-flip.md` steps 6 and 7 and the "P6" open step of
`.claude/plans/plan-layers-vocabulary-rename-contracts.md`, then in full `docs/adr/automation/layers.md` and the glossary rules the index
lists as ADR-REPO-VOCAB, then `out/reports/automation-word-residue-1.md` (the folder meaning of "automation" is already retired; you reword
the layer phrases only, and stop if that report is missing).

P5: in `pwsh/Catzc.Base.Docs/configs/glossary.yml`, avoid-phrasings for "automation folder", "automation track", "automation modules",
"automation layer", "implementation layer", "PowerShell layer", "PowerShell automation", "the loader"; then grep the tracked tree for those
phrases and reword each page one file at a time to the layer family's living terms (pipelines/custom-template-discipline.md and
docs/index.md carry the most). Skip `docs/adr/automation/layers.md` (another session owns it) and any page under
`docs/explanation/repository/` or the five drift slides' pages; list skipped pages in the report. P6, one atomic set, started only when P5
is done: `ci-automation` to `ci-pwsh` and `ci-automation-expected-failures` to `ci-pwsh-expected-failures` in the pipeline and workflow
files, their file-name-keyed contract fragments under `contracts/`, the globset and `pipeline:` key, `docs/references/pipelines/*`, the
README badge, and the `Test-GitHubWorkflowTriggerGlob` and `Register-AdoPipeline` examples; `invoke-automation` and `release-automation`
stay. Tell the user at the end that the Azure DevOps definitions, GitHub required checks and bookmarks must be re-pointed the same day.

Owns: `glossary.yml`, every page the P5 grep finds minus the skips, and the P6 file set. Re-read a file right before editing it; one file at
a time, each verified with `Test-Glossary` or `Test-Links -Path` on that file, `Test-Pipelines` and `Test-Contracts` on the P6 files,
`Invoke-TestFile` on the two test files. Never run Test-Automation or a gate over the whole tree; a final session does that once, last.
Never edit `.claude/plans`. No git add, commit, push or mv. Every Bash call runs under the time safeguard (foreground `timeout: 3000`;
longer work in the background behind a GNU `timeout` prefix). The typed DLL under `pwsh/.compiled` is ignored.

End by writing `out/reports/layers-1.md`: what landed with each verdict line, pages skipped and why, every file touched.
