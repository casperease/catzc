---
task:
  status: open
  plans:
    [
      plan-module-model-closeout,
      plan-layers-vocabulary-rename-contracts,
      plan-clear-actions,
      plan-assets-gallery-pdf,
      plan-promotion-ladder,
    ]
  value: medium
  blocked_on: nothing; the test home and Q1 to Q4 were decided 2026-10-18
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

1. [x] Landed 2026-10-18 by session catzc-fb with no edit needed, verdict: "Test-Comments 0 on both sources; Export-Comments dry run moves
       nothing (both comment:4 sections already name live code lines: Get-ModuleGlobSet.ps1:80, variants.yml:5)". Original step: The two
       stale comment-page sections (plan-module-model-closeout): `Get-ModuleGlobSet.ps1.md` comment:4 and `variants.yml.md` comment:4 each
       name a code line the source no longer has; `Export-Comments` on each source re-points or drops the section. Check: `Test-Comments`
       reports 0 on both sources.
2. [x] Landed 2026-10-18 by session catzc-fb, committed by the user in dcc194abd, verdict: "LanguagesConfig.Tests.ps1 Passed 35/35
       failures=0; ADRREG issues=0; LINKS issues=0 on layers.md". `executable` on FileLanguage.cs (default false once on the type),
       validated in LanguagesConfig, set on powershell, csharp, python, go and bash; ADR-AUTO-LAYERS-COMMANDISPUBLICFUNCTION names the flag. Naming note for a
       later look: the `tests:` block already has an `executable` key meaning a parameter name (GoExecutable), so one entry uses the word
       twice. Original step: The `executable` flag (plan-layers-vocabulary-rename-contracts, the last open step): `languages.yml` gains
       `executable: true` on the languages a command is implemented in, read by `LanguagesConfig` with its default declared once on the type
       and a test for the key; ADR-AUTO-LAYERS rule 2 (`docs/adr/automation/layers.md`) names the flag instead of "the file languages its
       track declares". Check: the LanguagesConfig test file passes; `Test-AdrRegistry` and `Test-Links` clean on the ADR; the plan's step
       ticked.
3. The vocabulary findings (plan-clear-actions): each flagged plan file is fixed when a task edits it for its own reason, never swept. The
   files this execution edits (plan-layers-vocabulary-rename-contracts, plan-assert-wait, plan-unboxing, plan-module-model-closeout,
   value-of-plan.md) lose their bare terms in that edit. Check: `Test-Glossary` on each edited file names no line; the file is struck from
   the list in plan-clear-actions.
4. [x] Landed 2026-10-18 by session catzc-93, verdict: ".claude/drawio/tests/test_gallery_pdf.py: two PNGs, one with a same-stem .md
   companion, run `gallery_pdf.py --assets`, which prints pages=3; passes" (runs on a tmp mirror; a REPO argument in the kit would drop
   the mirror, an idea for catzc-fb). Original step: The gallery fixture (plan-assets-gallery-pdf): if the decision round gives the kit a test home, a two-PNG fixture run (one with a
   companion) under it; if not, the step is dropped and the plan deleted in the sweep. Check: page count is 3, or the plan is gone.
5. [x] Landed 2026-10-18 by session catzc-59 as plan-promotion-ladder's steps 1 and 2 (verdicts there). Original step:
   `pipelines/README.md` (plan-promotion-ladder): the ladder's environments and the pipeline that deploys each, as the decision round's Q1
   to Q4 decide; the decisions become ADR-DSGN-LIFE and ADR-FLOW-CD rules in the same change (ADR-REPO-PLANS-DECISIONSBECOMERULES). Check: `Test-Links` and
   `Test-Pipelines` pass; `Test-AdrRegistry` clean. The ladder's build itself is then planned as its own task from the plan's new steps.

## Report

As report-fixed.
