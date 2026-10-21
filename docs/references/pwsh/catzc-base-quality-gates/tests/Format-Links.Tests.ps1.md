# pwsh/Catzc.Base.QualityGates/tests/Format-Links.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Format-Links' -Tag 'L0', 'logic' {`, written with `#`.

```text
Format-Links is the link aligner and the repository-wide migration
([ADR-REPO-LINK-ALIGNEDBYTOOL](/docs/drs/repository/markdown-links.md#rule-adr-repo-link-alignedbytool)), tested in isolation: every test
builds its own fixture repository in $TestDrive — a two-ADR index with neutral widget/gadget codes
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)),
an .editorconfig, and the source files under test — and aligns only that tree (-RepositoryRoot, -Path).
```
