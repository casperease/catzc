---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Test-Links.Tests.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: e7a2277888d4
    adrs:
      - ADR-AUTO-TEST#{3,35}
      - ADR-REPO-LINK#8
---

# automation/Catzc.Base.QualityGates/tests/Test-Links.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-Links' -Tag 'L0', 'logic' {`, written with `#`.

```text
Test-Links is the link quality gate ([ADR-REPO-LINK#8](/docs/adr/repository/markdown-links.md#rule-adr-repo-link8)):
the same engine as Format-Links, read-only, ending through Write-QualityGateReport
([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)). A fixture repository in
$TestDrive (neutral widget/gadget codes,
[ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)) holds the files under test.
```
