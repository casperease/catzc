# pwsh/Base.QualityGates/tests/Test-ManualTestPlan.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-ManualTestPlan'`, written with `#`.

```text
Test-ManualTestPlan over a fixture repository in $TestDrive: the repository root is mocked, and each test writes the
test files and the plan checks it needs. Neutral fixture names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```
