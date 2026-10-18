---
prompt:
  for: a fresh session; run LAST and ALONE, after every other prompt-* session of 2026-10-18 has ended and the out/ pilot is approved
  written: 2026-10-18
  plan: plan-diagram-folders
---

# Prompt: move all 150 diagrams into their folders

You work in `C:\projects\catzc`, alone; no other session runs. Read `.claude/CLAUDE.md`, then `docs/adr/index.md` (cite rules by code,
never sweep the corpus), then `docs/adr/repository/ai-agent-contract.md`, then `.claude/plans/plan-diagram-folders.md` (Decisions binding),
`.claude/plans/task-diagram-folders.md` steps 6 to 8, `out/reports/diagram-folders-1.md` and `out/reports/diagram-folders-2.md` (what the
kit, `Move-Diagram`, `Build-Diagrams -Path` and the ADRs now are), and `.claude/plans/decisions-2026-10-19.md` for the pilot's approval.
Stop if the approval is missing or either report says its work is not landed.

For this migration only, you are authorised to run `Move-Diagram`, which performs `git mv`; nothing else mutates git. Go one article
folder at a time, `docs/explanation/configuration` first (the pilot's source): assemble each diagram's nine files under
`<article-folder>/.assets/<name>/` with role names and the description inside, through the move command; run `Build-Diagrams -Path` on
each new folder; verify the folder with `Test-Links`, `Test-FileMeta` and `Test-Spelling` on that folder before the next; list the
article folders done in `out/reports/diagram-folders-3.md` as you go, so a stopped session can resume. Then `glyphs.drawio.png` and
`glyphs.drawio.md` into `docs/explanation/.assets/glyphs/`, every page that links it checked with `Test-Links`. Then delete the emptied
`docs/explanation/.assets/{grid,tree,chain}/` (check: `git ls-files docs/explanation/.assets` lists only `glyphs/`) and bring the
`Build-Diagrams.ps1.md` help and `catzc-base-slides.md` responsibility:4 to the new parameter. The 18 diagrams of `docs/.assets` and
`docs/references/.assets` are out of scope.

Never run Test-Automation or a gate over the whole tree; a final session does that once, last. Never edit `.claude/plans`. Every Bash
call runs under the time safeguard (foreground `timeout: 3000`; longer work in the background behind a GNU `timeout` prefix; a render
goes to the background). The typed DLL under `pwsh/.compiled` is ignored.

End by completing `out/reports/diagram-folders-3.md`: folders done with each verdict line, folders left and why, every file touched.
