---
task:
  id: "001"
  status: open
  plans: [plan-clear-actions]
  value: medium
  blocked_on: nothing
  targets: [.claude/plans]
---

# task001: re-point the dangling links in six plan files

The verdict pass of 2026-10-16 found 32 broken links in five plans plus stale out/ paths; none was acted on. Each file is done in full and
checked before the next. Only link targets change, never link text or prose (md-links capability). An `[Untracked]` finding is left as is.

## How a step runs

- Check command, background under the time safeguard, one script per file: write `out/plan-links-<name>.ps1` holding
  `. ./importer.ps1; Test-Links -Path .claude/plans/<file>` and run `timeout 120 pwsh -NoProfile -File out/plan-links-<name>.ps1`.
- Read every finding (line, column, kind, target). For each, Edit that one link's target; a `.claude/docs/adr/...` target becomes
  `../../docs/adr/...` (the file sits two folders below the repository root); a sibling `plan-x.md` that was folded into a carried draft
  becomes the plan that now holds the text, with its `#heading` anchor; `out/plan-x.md` provenance becomes the sibling file name.
- Re-run the same script. Done when it reports zero dangling links (untracked targets excepted).

## Steps

1. `plan-adr-link-cleanup-prose-to-pages.md`: 15 links (verdict lines 79-86, 205, 263, 308, 334, 348, 349, 420, 427; all
   `.claude/docs/adr/...` to `../../docs/adr/...`). Check: Test-Links reports 0 dangling.
2. `plan-layers-vocabulary-rename-contracts.md`: 9 links (verdict lines 111-113, 359, 360, 532, 533, 712). Check: Test-Links reports 0 dangling.
3. `plan-module-kinds-tracks.md`: 3 links (verdict lines 98, 104, 370). Check: Test-Links reports 0 dangling.
4. `plan-config-defaults.md`: 3 sibling links (verdict lines 243, 247, 250) to the plans that now hold the text. Check: Test-Links reports 0 dangling.
5. `plan-plans-body-sha-landing-zone.md`: 2 links (`file-meta.md`, `sensible-defaults.md` in the carried draft, written from out/).
   Check: Test-Links reports 0 dangling.
6. `plan-materialization-of-knowledge.md`: the Refs line says the draft is carried below; confirm no `out/adr-draft-materialization.md` path
   remains as a link. Check: grep `out/adr-draft` finds only prose that says "formerly".
7. `value-of-plan.md`: the two `out/` paths that name absent files (`out/prompt-*-continue.md`, `out/adr-draft-materialization.md`) in
   "Where the data lives now" and "Pastes processed" become the sibling names. Check: every named path exists (`ls` each).
8. Record: in `plan-clear-actions.md` tick the re-point steps that are done, one checkbox per file. Check: the ticked lines name a 0-dangling run.

## Report

Files touched, the Test-Links verdict line per file verbatim, what was left undone and why (report-fixed).
