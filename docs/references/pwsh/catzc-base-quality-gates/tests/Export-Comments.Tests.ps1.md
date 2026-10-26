# pwsh/Base.QualityGates/tests/Export-Comments.Tests.ps1

<!-- cspell:ignore ngadget -->

The tests of `Export-Comments`, which moves a file's long comments into its comment page, one way and losslessly
([PDR-ONELIVE-ONEVERSION](../../../../drs/principles/one-living-version.md#rule-pdr-onelive-oneversion)). Each test builds its own fixture repository in
`$TestDrive` with widget and gadget files and exports only that tree (`-RepositoryRoot`, `-Path`). The page location comes from the shipped
`comments.yml` ([PDR-CONFIG-VARYINGBEHAVIOURISCONFIG](../../../../drs/principles/configure-not-program.md#rule-pdr-config-varyingbehaviourisconfig)).
