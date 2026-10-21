# pwsh/Catzc.Base.QualityGates/tests/Build-CommentView.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Build-CommentView' -Tag 'L0', 'logic' {`, written with `#`.

```text
Build-CommentView writes the inverse of Export-Comments: the annotated copy of every file that has a comment page,
under the view folder in out/ ([ADR-REPO-OUTDIR-OUTPUTROOTFUNCTION](/docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir-outputrootfunction)),
equal to the file before its comments moved
([PDR-ONELIVE-ONEVERSION](/docs/adr/principles/one-living-version.md#rule-pdr-onelive-oneversion)). Tested in isolation on a
widget/gadget fixture repository in $TestDrive.
```
