---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/Get-AdrDoraCoverageViolations.Tests.ps1.md
    kind: test-asset
    body_sha: "94f8bb456357"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Docs/tests/Get-AdrDoraCoverageViolations.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-AdrDoraCoverageViolations' -Tag 'L0', 'logic',...`.

```text
Get-AdrDoraCoverageViolations — every rule set outside the domains its config exempts has exactly one section linking its ADR in its domain's
DORA file. A fixture tree in $TestDrive and a fixture registry; neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
