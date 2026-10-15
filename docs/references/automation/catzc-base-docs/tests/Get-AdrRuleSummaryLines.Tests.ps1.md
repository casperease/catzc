---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/Get-AdrRuleSummaryLines.Tests.ps1.md
    kind: test-asset
    body_sha: "31137c28e896"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Docs/tests/Get-AdrRuleSummaryLines.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-AdrRuleSummaryLines' -Tag 'L0', 'logic' {`.

```text
Get-AdrRuleSummaryLines — the normative lines of every `### Rule` entry in one ADR file, numbered, with the rule in its citation
form. Neutral fixture codes ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
