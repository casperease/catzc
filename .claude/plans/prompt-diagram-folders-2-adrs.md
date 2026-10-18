---
prompt:
  for: a fresh session, run in parallel with the other prompt-* files of 2026-10-18
  written: 2026-10-18
  plan: plan-diagram-folders
---

# Prompt: the diagram-folder rules restated

You work in `C:\projects\catzc`, one of several sessions running in parallel on this repository. Read `.claude/CLAUDE.md`, then
`docs/adr/index.md` (cite rules by code, never sweep the corpus), then `docs/adr/repository/ai-agent-contract.md`, then
`.claude/plans/plan-diagram-folders.md` (its Decisions section is binding) and `.claude/plans/task-diagram-folders.md` step 5, then in full
`docs/adr/repository/conventional-folders.md`, `docs/adr/repository/slides-as-markdown.md` and `docs/adr/repository/file-meta.md`.

Restate, present tense and without history (ADR-PRIN-ONELIVE): ADR-REPO-FOLDERS' `.assets` paragraph (`.assets/` beside an article holds one
folder per diagram, role names `diagram`, `grid`, `tree`, `chain` with their `.md`, the description inside the folder, the folder name the
diagram's only name); ADR-REPO-SLIDES-ONEBUILDCOMMAND (one command on one folder, `Build-Diagrams -Path`; the whole tree is that command repeated); and in
`pwsh/Catzc.Base.Globs/configs/file-kinds.yml` the diagram kinds select `docs/**/.assets/**`, which reaches both today's flat files and the
folders to come, so the reachability test stays green through the migration. In the same conventional-folders.md edit, line 272:
`references/.assets/automation/<module>/` becomes `references/.assets/pwsh/<module>/` (a step of plan-automation-word-residue, given to this
session because it owns the page). No new rule number; if a restatement needs one, stop and put it in the report.

Owns: the two ADR pages, `file-kinds.yml`, and the file-kind reachability test file in `pwsh/Catzc.Base.Globs/tests/`. Touch nothing else;
re-read a file right before editing it; one file at a time, each verified: `Test-AdrRegistry`, `Test-Links -Path`, `Test-Glossary` on each
ADR page, `Invoke-TestFile` on the reachability test. `docs/adr/index.md` is generated: run `Build-AdrIndex`, never edit it by hand, and
keep any change in it that is not yours. Never run Test-Automation or a gate over the whole tree. Never edit `.claude/plans`. No git add,
commit, push or mv. Every Bash call runs under the time safeguard (foreground `timeout: 3000`; longer work in the background behind a GNU
`timeout` prefix). The typed DLL under `pwsh/.compiled` is ignored.

End by writing `out/reports/diagram-folders-2.md`: what landed with each verdict line, what is left and why, every file touched.
