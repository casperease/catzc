---
task:
  id: "001"
  status: done
  plans: [plan-clear-actions]
  value: medium
  blocked_on: nothing
  targets: [.claude/plans]
catzc:
  immutable:
    repo_status: clean
    path: ".claude/plans/task001.md"
    folder: plans
    name: task001
    filetype: md
    kind: other
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
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

## Correction (2026-10-17)

The tree contradicts the premise: every link the verdict pass listed was already re-pointed when this task ran (the targets read
`../../docs/adr/...` and the sibling plan names), so steps 1 to 5 needed no edit. Each check was still run and its verdict recorded.

## Steps

1. [x] `plan-adr-link-cleanup-prose-to-pages.md`: 15 links already `../../docs/adr/...`. Check: `[Write-QualityGateReport] No links issues
   found.` (`out/test-links/20261017-053922`).
2. [x] `plan-layers-vocabulary-rename-contracts.md`: 9 links already sibling names. Check: `[Write-QualityGateReport] No links issues found.`
   (`out/test-links/20261017-054019`).
3. [x] `plan-module-kinds-tracks.md`: 3 links already sibling names. Check: `[Write-QualityGateReport] No links issues found.`
   (`out/test-links/20261017-054019-2`).
4. [x] `plan-config-defaults.md`: 3 sibling links already point at the plans that hold the text. Check: `[Write-QualityGateReport] No links
   issues found.` (`out/test-links/20261017-054019-3`).
5. [x] `plan-plans-body-sha-landing-zone.md`: 2 links already `../../docs/adr/...`. Check: `[Write-QualityGateReport] No links issues
   found.` (`out/test-links/20261017-054019-4`).
6. [x] `plan-materialization-of-knowledge.md`: grep `out/adr-draft` finds the Refs line ("formerly") and the "Carried" heading, both prose;
   the Refs path `result-caching.md` re-pointed to `docs/adr/automation/caching.md`. Check: `[Write-QualityGateReport] No links issues
   found.` (`out/test-links/20261017-054248`).
7. [x] `value-of-plan.md`: neither `out/prompt-*-continue.md` nor `out/adr-draft-materialization.md` remains; `ls` finds every named path
   (`docs/explanation/automation/reference-unboxing.md`, `out/README.md`, the six out/ scripts). Check: `[Write-QualityGateReport] No links
   issues found.` (`out/test-links/20261017-054019-6`).
8. [x] `plan-clear-actions.md`: the correction recorded, the re-point halves ticked with their report folders, the trim halves split into
   their own open checkboxes. Check: `[Write-QualityGateReport] No links issues found.` (`out/test-links/20261017-054348`).

## Report

Files touched, the Test-Links verdict line per file verbatim, what was left undone and why (report-fixed).
