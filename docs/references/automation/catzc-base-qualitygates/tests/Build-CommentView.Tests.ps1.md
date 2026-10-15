---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Build-CommentView.Tests.ps1.md
    kind: test-asset
    body_sha: "2ee5e3afa0b7"
    adrs:
      - ADR-PRIN-ONELIVE#1
      - ADR-REPO-OUTDIR#1
---

# automation/Catzc.Base.QualityGates/tests/Build-CommentView.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Build-CommentView' -Tag 'L0', 'logic' {`.

```text
Build-CommentView writes the inverse of Export-Comments: the annotated copy of every file that carries residues,
under the view folder in out/ ([ADR-REPO-OUTDIR#1](/docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir1)),
equal to the file before its comments moved
([ADR-PRIN-ONELIVE#1](/docs/adr/principles/one-living-version.md#rule-adr-prin-onelive1)). Tested in isolation on a
widget/gadget fixture repository in $TestDrive.
```
