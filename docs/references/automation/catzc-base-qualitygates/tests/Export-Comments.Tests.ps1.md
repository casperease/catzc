---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Export-Comments.Tests.ps1.md
    kind: test-asset
    body_sha: "0757aacdc5f7"
    adrs:
      - ADR-PRIN-CONFIG#1
      - ADR-PRIN-ONELIVE#1
---

# automation/Catzc.Base.QualityGates/tests/Export-Comments.Tests.ps1

<!-- cspell:ignore ngadget -->

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Export-Comments' -Tag 'L0', 'logic' {`.

```text
Export-Comments moves a file's long comments into its comment page, one-way and losslessly
([ADR-PRIN-ONELIVE#1](/docs/adr/principles/one-living-version.md#rule-adr-prin-onelive1)), tested in isolation:
every test builds its own fixture repository in $TestDrive with widget/gadget files and exports only that tree
(-RepositoryRoot, -Path). The page location comes from the shipped comments.yml
([ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1)).
```
