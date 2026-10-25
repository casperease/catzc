# pwsh/Catzc.Base.QualityGates/tests/Get-BashTestCases.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-BashTestCases'`, written with `#`.

```text
Get-BashTestCases over fixture .bats files in $TestDrive: the @test declarations of every .bats file, with the file
path bats reports as their package. Neutral fixture names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```
