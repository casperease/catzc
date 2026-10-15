---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Format-Comments.Tests.ps1.md
    kind: test-asset
    body_sha: "768093b2f1a8"
    adrs:
      - ADR-PRIN-CONFIG#1
      - ADR-PRIN-ONELIVE#1
      - ADR-REPO-COMMENTS#5
---

# automation/Catzc.Base.QualityGates/tests/Format-Comments.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Format-Comments' -Tag 'L0', 'logic' {`.

```text
Format-Comments puts every comment residue into its one-liner shape in place
([ADR-REPO-COMMENTS#5](/docs/adr/repository/comments-in-docs.md#rule-adr-repo-comments5),
[ADR-PRIN-ONELIVE#1](/docs/adr/principles/one-living-version.md#rule-adr-prin-onelive1)), tested in isolation:
every test builds its own fixture repository in $TestDrive with widget/gadget files and formats only that tree
(-RepositoryRoot, -Path). The residue rules come from the shipped comments.yml
([ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1)).
```
