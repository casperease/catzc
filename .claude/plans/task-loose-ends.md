---
task:
  status: open
  plans:
    [plan-module-model-closeout, plan-layers-vocabulary-rename-contracts, plan-clear-actions, plan-assets-gallery-pdf, plan-promotion-ladder]
  value: medium
  blocked_on: step 4 on the decision round (test home); step 5 on the decision round (Q1 to Q4)
  targets:
    [
      docs/references/pwsh/catzc-base-globs/Get-ModuleGlobSet.ps1.md,
      docs/references/pwsh/catzc-base-variants/configs/variants.yml.md,
      pwsh/Catzc.Base.Languages/configs/languages.yml,
      docs/adr/automation/layers.md,
      .claude/drawio/gallery_pdf.py,
      pipelines/README.md,
    ]
---

# Task: the single steps no other task carries

Five plans each hold one step that fits no larger chunk. Each is one file and one check; none depends on another.

## Steps

1. The two stale comment-page sections (plan-module-model-closeout): `Get-ModuleGlobSet.ps1.md` comment:4 and `variants.yml.md` comment:4
   each name a code line the source no longer has; `Export-Comments` on each source re-points or drops the section. Check: `Test-Comments`
   reports 0 on both sources.
2. The `executable` flag (plan-layers-vocabulary-rename-contracts, the last open step): `languages.yml` gains `executable: true` on the
   languages a command is implemented in, read by `LanguagesConfig` with its default declared once on the type and a test for the key;
   ADR-AUTO-LAYERS rule 2 (`docs/adr/automation/layers.md`) names the flag instead of "the file languages its track declares". Check: the
   LanguagesConfig test file passes; `Test-AdrRegistry` and `Test-Links` clean on the ADR; the plan's step ticked.
3. The vocabulary findings (plan-clear-actions): each flagged plan file is fixed when a task edits it for its own reason, never swept. The
   files this execution edits (plan-layers-vocabulary-rename-contracts, plan-assert-wait, plan-unboxing, plan-module-model-closeout,
   value-of-plan.md) lose their bare terms in that edit. Check: `Test-Glossary` on each edited file names no line; the file is struck from
   the list in plan-clear-actions.
4. The gallery fixture (plan-assets-gallery-pdf): if the decision round gives the kit a test home, a two-PNG fixture run (one with a
   companion) under it; if not, the step is dropped and the plan deleted in the sweep. Check: page count is 3, or the plan is gone.
5. `pipelines/README.md` (plan-promotion-ladder): the ladder's environments and the pipeline that deploys each, as the decision round's Q1
   to Q4 decide; the decisions become ADR-DSGN-LIFE and ADR-FLOW-CD rules in the same change (ADR-REPO-PLANS#9). Check: `Test-Links` and
   `Test-Pipelines` pass; `Test-AdrRegistry` clean. The ladder's build itself is then planned as its own task from the plan's new steps.

## Report

As report-fixed.
