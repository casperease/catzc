# pwsh/Catzc.Base.QualityGates/tests/Export-Comments.Tests.ps1

<!-- cspell:ignore ngadget -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Export-Comments' -Tag 'L0', 'logic' {`, written with `#`.

```text
Export-Comments moves a file's long comments into its comment page, one-way and losslessly
([PDR-ONELIVE-ONEVERSION](/docs/adr/principles/one-living-version.md#rule-pdr-onelive-oneversion)), tested in isolation:
every test builds its own fixture repository in $TestDrive with widget/gadget files and exports only that tree
(-RepositoryRoot, -Path). The page location comes from the shipped comments.yml
([PDR-CONFIG-VARYINGBEHAVIOURISCONFIG](/docs/adr/principles/configure-not-program.md#rule-pdr-config-varyingbehaviourisconfig)).
```
