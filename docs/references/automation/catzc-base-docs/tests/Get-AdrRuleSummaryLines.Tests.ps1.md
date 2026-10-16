---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/Get-AdrRuleSummaryLines.Tests.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "8863163c17fd"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Docs/tests/Get-AdrRuleSummaryLines.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-AdrRuleSummaryLines' -Tag 'L0', 'logic' {`, written with `#`.

```text
Get-AdrRuleSummaryLines — the normative lines of every `### Rule` entry in one ADR file, numbered, with the rule in its citation
form. Neutral fixture codes ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
