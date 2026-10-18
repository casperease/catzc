---
prompt:
  for: a fresh session, run in parallel with the other prompt-* files of 2026-10-18
  written: 2026-10-18
  plan: plan-diagram-folders
---

# Prompt: the diagram kit tests, the two subtitles, Move-Diagram and Build-Diagrams -Path

You work in `C:\projects\catzc`, one of several sessions running in parallel on this repository. Read `.claude/CLAUDE.md`, then
`docs/adr/index.md` (cite rules by code, never sweep the corpus), then `docs/adr/repository/ai-agent-contract.md`, then
`.claude/plans/plan-diagram-folders.md` (its Decisions section is binding) and `.claude/plans/task-diagram-folders.md` steps 1 to 4, and
`.claude/plans/decisions-2026-10-19.md` if it exists (the drawio kit's test home; without it, assume `.claude/drawio/tests/`).

Do steps 1 to 4 of the task in order: the kit tests (subtitle parsing, the closed lens set, the `Supports` drift warning) under the test
home, run with `uv run` in the background; the two `:1,2,3` subtitles normalised through the `write-drawio-files` robot; `Move-Diagram` in
`pwsh/Catzc.Base.Slides` with `-DryRun` and L0 tests on neutral widget/gadget fixtures in a fixture git repository under TestDrive;
`Build-Diagrams -Path <folder>` with folder discovery under `docs/**/.assets/**`, `diagram_folders` removed from the config and its type in
the same change (ADR-PRIN-ONELIVE), L0 tests for one folder, every folder, an orphan, two embedders, the locality gate. Then the two-PNG
gallery fixture of plan-assets-gallery-pdf under the same test home (page count 3). Render no slide in `docs/`.

Owns: `.claude/drawio/**`, `pwsh/Catzc.Base.Slides/**`, `docs/references/pwsh/catzc-base-slides.md` and `catzc-base-slides/**`, and the
files of the two named subtitle slides under `docs/explanation/.assets/`. Touch nothing else; re-read a file right before editing it; one
file at a time, each verified by its own test file under `Invoke-TestFile` or one gate on that path (Test-FileMeta, Test-Links,
Test-Comments, Test-ScriptAnalyzer). Never run Test-Automation or a gate over the whole tree; a final session does that once, last. Never
edit `.claude/plans`. No git add, commit, push or mv (the fixture repository under TestDrive is the one exception). Every Bash call runs
under the time safeguard (foreground `timeout: 3000`; longer work in the background behind a GNU `timeout` prefix). The typed DLL under
`pwsh/.compiled` changes under you and is ignored.

End by writing `out/reports/diagram-folders-1.md`: what landed with each verdict line, what is left and why, every file touched.
