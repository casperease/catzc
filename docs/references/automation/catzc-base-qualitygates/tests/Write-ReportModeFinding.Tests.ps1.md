---
catzc:
  immutable:
    with_body_sha: "28ab2e5a3605"
    path: docs/references/automation/catzc-base-qualitygates/tests/Write-ReportModeFinding.Tests.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/tests
    name: write-report-mode-finding-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-PRIN-CONFIG#4
---

# automation/Catzc.Base.QualityGates/tests/Write-ReportModeFinding.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Write-ReportModeFinding' -Tag 'L0', 'logic' {`, written with `#`.

```text
Write-ReportModeFinding prints a report-mode check's work list and never fails the run
([ADR-PRIN-CONFIG#4](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config4)).
```
