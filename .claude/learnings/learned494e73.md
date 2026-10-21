# Session learnings 494e73

Started 2026-10-21T02:20:59.6603823+02:00.

- 2026-10-21: Truth is the whole repository at one commit, committed files only; only in the listen mode is the editor's edit fact over the
  tree (ADR-REPO-AI-EDITORISFACT).
- 2026-10-21: The rule, docs, code order sequences plan steps and never ranks truth; one repository is one responsibility domain
  (ADR-THES-STORES-RESPONSIBILITYDOMAIN).
- 2026-10-21: eac is a sibling repository read for ideas only, and catzc's ADRs decide.
- 2026-10-21: Most needs are already met: file kinds (Get-FileKind), TimeLimit, DurableHash, Copy-Directory, Build-AgentHook and
  Install-VSCodeExtension.
- 2026-10-21: Every wait is bounded, executables too: a long call inside a command gets that command's TimeLimit, never a workaround.
- 2026-10-21: Under strict mode an if or try assigned to a variable collapses to $null or one item, so .Count throws
  (Measure-NoCollapsingAssignment flags it).
- 2026-10-21: PowerShell passes $null to a .NET string parameter as an empty string.
- 2026-10-21: Sessions edit, stage and commit at the same time, so check git status before touching a shared file and re-read it before
  relying on it.
- 2026-10-21: out/ can be wiped at any time; a run reads back only its own stamped folder there and waits through its absence.
- 2026-10-21: A new tool counts as working only after a live run; green tests alone miss real bugs.
- 2026-10-21: A diagram sample in out/ needs the private Write-DiagramMinimapData before put; Build-Diagrams takes only folders under
  .assets/.
