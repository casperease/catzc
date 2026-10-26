# pwsh/Base.QualityGates/tests/Test-Links.Tests.ps1

The test of `Test-Links`, the link quality gate
([ADR-REPO-LINK-ALIGNEDBYTOOL](../../../../drs/repository/markdown-links.md#rule-adr-repo-link-alignedbytool)). It is the same engine as
`Format-Links`, read-only, and it ends through `Write-QualityGateReport`
([ADR-AUTO-TEST-QUALITYGATE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)). A fixture repository in
`$TestDrive` holds the files under test, with neutral widget and gadget codes
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
