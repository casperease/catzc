# pwsh/Base.QualityGates/tests/Get-PythonTestCases.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-PythonTestCases'`, written with `#`.

```text
Get-PythonTestCases over fixture test files in $TestDrive: the top-level test functions of every test_*.py file,
with the package pytest reports for them. Neutral fixture names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```
