---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-TestTagViolations.ps1.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: ef3e7676cfb1
---

# automation/Catzc.Base.QualityGates/private/Get-TestTagViolations.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$validRuleIds = $null`, written with `#`.

```text
The authoritative rule-id set, resolved once on the first well-formed citation and reused across tests
(Get-CatsAdrRuleIds is itself session-cached). Left $null until then so a run whose tests carry no
citation never reads the shipped ADR tree — keeping these logic tests hermetic. Registry (':') form.
```

## comment:2

Above `$candidates =...`, written with `#`.

```text
Provenance axis (optional): collect every candidate citation — any tag carrying the reserved 'ADR-'
marker — across the block chain (own It-tags + ancestor blocks, root excluded), then classify each.
A malformed candidate never needs the rule-id set; a well-formed one triggers its lazy resolution.
```
