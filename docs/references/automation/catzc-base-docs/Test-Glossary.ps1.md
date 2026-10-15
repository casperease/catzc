---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/Test-Glossary.ps1.md
    kind: reference
    body_sha: b28a30c0e498
    adrs:
      - ADR-AUTO-TEST#35
---

# automation/Catzc.Base.Docs/Test-Glossary.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Runs the glossary checks of [ADR-REPO-VOCAB](/docs/adr/repository/controlled-vocabulary.md) over every glossary
source, in order:
  - G1 — the facts that span more than one source (Get-GlossarySourceViolations);
  - G2 — every term anchored on its defining rule (Get-GlossaryAnchorViolations);
  - G3 — no second rule defining a term (Get-GlossaryDefinitionViolations);
  - G4 — no avoided phrasing used within a source's scope (Get-GlossaryPhrasingViolations);
  - G5 — every realized concept enforced (Get-GlossaryEnforcementViolations);
  - G6 — no term qualified outside its declared forms (Get-GlossaryFormViolations).
G4 and G6 read the same text surfaces of the same tracked files, so they share one surface table and each file's
prose is read once per run.
Each source's own shape is validated when it loads (Catzc.Base.Docs.GlossaryConfig), so a source that is
malformed fails before any check runs. A quality gate
([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)): it ends through
Write-QualityGateReport, which writes out/test-glossary/, prints every issue, and throws once listing them all
([ADR-AUTO-FAILFAST](/docs/adr/automation/fail-fast-with-asserts.md)).
The checks read the source tree's ADRs, tests, and tracked files, so it runs in source mode only.
```
