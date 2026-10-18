---
prompt:
  for: a fresh session, run in parallel with the other prompt-* files of 2026-10-18
  written: 2026-10-18
  plan: plan-layers-vocabulary-rename-contracts
---

# Prompt: the executable flag and the report folders

You work in `C:\projects\catzc`, one of several sessions running in parallel on this repository. Read `.claude/CLAUDE.md`, then
`docs/adr/index.md` (cite rules by code, never sweep the corpus), then `docs/adr/repository/ai-agent-contract.md`, then
`.claude/plans/task-loose-ends.md` steps 1 and 2 and `.claude/plans/decisions-2026-10-19.md` for the out/test-links clearance, then in full
`docs/adr/automation/layers.md` and the ADR the index lists as ADR-AUTO-DEFAULT.

One file at a time: `pwsh/Catzc.Base.Languages/configs/languages.yml` gains `executable: true` on the languages a command is implemented in,
read by `LanguagesConfig` with its default declared once on the type and a test for the key (C# edits need a fresh `pwsh`); ADR-AUTO- LAYERS
rule 2 in `docs/adr/automation/layers.md` names the flag instead of "the file languages its track declares" (a rewording, no new rule).
Then, if the decisions say yes, delete the 36 `out/test-links/20261016-2012*` folders. The `Get-ModuleGlobSet` comment page is not yours:
the automation-word-residue session owns it and fixes its comment:4 section.

Owns: `languages.yml`, the `LanguagesConfig` type and its test file, `docs/adr/automation/layers.md`, and `out/test-links`. Re-read a file
right before editing it; each verified by its test file under `Invoke-TestFile`, `Test-AdrRegistry`, `Test-Links -Path` and `Test-Glossary`
on the ADR page. Never run Test-Automation or a gate over the whole tree; a final session does that once, last. Never edit `.claude/plans`.
No git add, commit, push or mv. Every Bash call runs under the time safeguard (foreground `timeout: 3000`; longer work in the background
behind a GNU `timeout` prefix). The typed DLL under `pwsh/.compiled` changes under you and is ignored.

End by writing `out/reports/loose-ends-1.md`: what landed with each verdict line, what is left and why, every file touched.
