---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-TestTagViolations.ps1.md
    kind: comment-page
    body_sha: a88fd5053d37
---

# automation/Catzc.Base.QualityGates/private/Get-TestTagViolations.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:4

Above `$validRuleIds = $null`.

```text
The authoritative rule-id set, resolved once on the first well-formed citation and reused across tests
(Get-CatsAdrRuleIds is itself session-cached). Left $null until then so a run whose tests carry no
citation never reads the shipped ADR tree — keeping these logic tests hermetic. Registry (':') form.
```

## comment:5

Above `$candidates =...`.

```text
Provenance axis (optional): collect every candidate citation — any tag carrying the reserved 'ADR-'
marker — across the block chain (own It-tags + ancestor blocks, root excluded), then classify each.
A malformed candidate never needs the rule-id set; a well-formed one triggers its lazy resolution.
```
