# pwsh/Base.Drs/tests/Test-DrsRegistry.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-DrsRegistry'`, written with `#`.

```text
Test-DrsRegistry over a fixture docs/drs tree in $TestDrive, a fixture DrsConfig, and a fixture DrsChecksConfig (Get-Config and
Resolve-RepoPath mocked), so each test pins one rule. Neutral fixture names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```

## comment:2

Above `Mock Get-DrsDanglingCodeViolations -ModuleName Catzc.Base.Drs...`, written with `#`.

```text
The registry cases cite codes the fixture map does not hold; the dangling-code cases below run the helper
itself.
```
