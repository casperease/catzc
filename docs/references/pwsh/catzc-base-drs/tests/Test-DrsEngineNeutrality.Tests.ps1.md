# pwsh/Catzc.Base.Docs/tests/Test-AdrEngineNeutrality.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-AdrEngineNeutrality' -Tag 'L0', 'logic',...`, written with `#`.

```text
Test-AdrEngineNeutrality over a fixture docs/drs tree in $TestDrive, a fixture AdrsConfig, and a fixture AdrChecksConfig
(Get-Config and Resolve-RepoPath mocked). Neutral fixture names and tokens
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```
