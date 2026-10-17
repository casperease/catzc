---
task:
  id: "009"
  status: open
  plans: [plan-plans-body-sha-landing-zone]
  value: highest
  blocked_on: task008 steps 1 and 4
  targets:
    [
      automation/Catzc.Base.Git,
      automation/Catzc.Base.Docs/configs/glossary.yml,
      docs/adr/design/tracks.md,
      docs/adr/design/track-types.md,
      docs/how-to,
    ]
---

# task009: the import tool and the landing-zone terms

Phase 1 of the plans plan. Decided: Q01 the history move method is chosen at the first real import, the tool's contract does not depend on
it; Q02 optional `-Ref`, default the source's default branch; Q03 the sorting how-to lives in docs/how-to; the landing name defaults to the
source's kebab name, a clash fails, no suffix is ever added (ADR-AUTO-DEFAULT#6, one resolution order, explicit wins).

## Steps

1. `docs/adr/design/tracks.md` rule 17 (line 189): rewrite in present tense. The **unordered track** is the import landing zone: an
   **import** brings an outside repository into this one with its full history; a **landing address** is `.unordered/<name>`, a short kebab
   name unique among the addresses; **sorting** moves a file from its landing address to its module or track with `git mv`, so history
   follows; the unordered part of the repository is whatever is still under `.unordered/`. No command, default, glob, gate, generator or
   agent reads or falls back to it unless a person names it. Drop "finished plans" and "an active plan is out/plan-<topic>.md" (plans live in
   .claude/plans, Q07). Check: Test-AdrRegistry, Test-Links, Test-Markdownlint clean on the file; Test-Glossary names the four bolded terms
   as undefined until step 3.
2. `docs/adr/design/track-types.md` and the tracks registry text in `variants.yml`: the unordered entries say landing zone, not frozen
   fragments. Check: Test-Links; VariantsConfig tests.
3. `automation/Catzc.Base.Docs/configs/glossary.yml`: four concepts, import, landing address, sorting, unordered, `defined_by: ADR-DSGN-TRACK#17`,
   domain design, short forms from step 1, `realized_by` naming `Import-RepositoryWithHistory` for import. `Build-Glossary`. Check:
   Test-Glossary clean.
4. `automation/Catzc.Base.Git/Import-RepositoryWithHistory.ps1`, new, public: `-Source <path or url>` (mandatory), `-Name` (optional), `-Ref`
   (optional), `-DryRun`. Resolves the name (explicit, else the source's folder or repository name in kebab case; a name that is not a short
   kebab word fails with Assert-*), fails if `.unordered/<name>` exists, asserts the source is a clean git repository, imports every source
   commit under the address with the method the first real import decides (a `-Method` parameter is not added; the body has one place to
   fill), touches nothing outside the address. Information stream output through Write-Message; one head block; ADR citations in the head
   (ADR-DSGN-TRACK#17, ADR-AUTO-DEFAULT#6, ADR-AUTO-FAILFAST#5). Check: Test-ScriptAnalyzer clean on the file; the .psd1 export list and
   CatzcFiles regenerated.
5. `automation/Catzc.Base.Git/tests/Import-RepositoryWithHistory.Tests.ps1`: two temporary repositories under TestDrive; the log is preserved
   (commit count and messages equal); a taken name is refused; a bad name is refused; `-DryRun` writes nothing; nothing outside the address
   changes (git status of the target lists only the address). Neutral fixture names. Check: the file passes under its L1 limit.
6. `docs/how-to/automation/sort-an-import.md`: how a landing address is sorted into modules with `git mv`, one file or folder at a time,
   gates after each move; what stays in `.unordered` means. Check: Test-Links, Test-Markdownlint, Test-MarkdownTitle clean; listed where
   the how-to index lists its pages.
7. `plan-plans-body-sha-landing-zone.md`: tick the Phase 1 step with the Pester verdict. Check: the line names the test file and its count.

## Report

As report-fixed.
