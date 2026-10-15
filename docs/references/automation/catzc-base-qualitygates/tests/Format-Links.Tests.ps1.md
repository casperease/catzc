---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Format-Links.Tests.ps1.md
    kind: test-asset
    body_sha: "7d28c9351c3a"
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-REPO-LINK#8
---

# automation/Catzc.Base.QualityGates/tests/Format-Links.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Format-Links' -Tag 'L0', 'logic' {`.

```text
Format-Links is the link aligner and the repository-wide migration
([ADR-REPO-LINK#8](/docs/adr/repository/markdown-links.md#rule-adr-repo-link8)), tested in isolation: every test
builds its own fixture repository in $TestDrive — a two-ADR index with neutral widget/gadget codes
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)),
an .editorconfig, and the source files under test — and aligns only that tree (-RepositoryRoot, -Path).
```
