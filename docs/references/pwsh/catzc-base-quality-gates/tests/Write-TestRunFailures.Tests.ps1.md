# pwsh/Catzc.Base.QualityGates/tests/Write-TestRunFailures.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Write-TestRunFailures' -Tag 'L0', 'logic' {`, written with `#`.

```text
Write-TestRunFailures over fixture rows and file entries, with the console seam (Write-Message / Write-Header /
Write-Footer) mocked and its lines collected. Neutral fixture names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/adr/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```
