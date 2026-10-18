# pwsh/Catzc.Base.QualityGates/tests/Test-Links.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-Links' -Tag 'L0', 'logic' {`, written with `#`.

```text
Test-Links is the link quality gate ([ADR-REPO-LINK-ALIGNEDBYTOOL](/docs/adr/repository/markdown-links.md#rule-adr-repo-link-alignedbytool)):
the same engine as Format-Links, read-only, ending through Write-QualityGateReport
([ADR-AUTO-TEST-QUALITYGATE](/docs/adr/automation/test-automation.md#rule-adr-auto-test-qualitygate)). A fixture repository in
$TestDrive (neutral widget/gadget codes,
[ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/adr/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)) holds the files under test.
```
