# automation/Catzc.Base.Docs/tests/Test-AdrRegistry.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-AdrRegistry' -Tag 'L0', 'logic', 'ADR-AUTO-TEST#35' {`, written with `#`.

```text
Test-AdrRegistry over a fixture docs/adr tree in $TestDrive, a fixture AdrsConfig, and a fixture AdrChecksConfig (Get-Config and
Resolve-RepoPath mocked), so each test pins one rule. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
