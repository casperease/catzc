---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/Get-AdrDoraCoverageViolations.Tests.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "4b31753a94e1"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Docs/tests/Get-AdrDoraCoverageViolations.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-AdrDoraCoverageViolations' -Tag 'L0', 'logic',...`, written with `#`.

```text
Get-AdrDoraCoverageViolations — every rule set outside the domains its config exempts has exactly one section linking its ADR in its domain's
DORA file. A fixture tree in $TestDrive and a fixture registry; neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
