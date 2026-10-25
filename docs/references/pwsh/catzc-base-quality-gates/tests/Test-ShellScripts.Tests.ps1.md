# pwsh/Catzc.Base.QualityGates/tests/Test-ShellScripts.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-ShellScripts'`, written with `#`.

```text
Test-ShellScripts is a quality gate ([ADR-AUTO-TEST-QUALITYGATE](/docs/drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)):
the L0 cases run over a fixture repository in $TestDrive with the index, the tool probe, and ShellCheck mocked, and
read the collected issues; the report goes to $TestDrive. Neutral fixture names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```

## comment:2

Above `Describe 'Repository shell script integrity'`, written with `#`.

```text
Integrity: every shell script the repository holds is LF and passes the pinned ShellCheck. L2 because it drives the
ShellCheck CLI; self-skips without it ([ADR-AUTO-TEST-TAGBYOUTERMOSTRING](/docs/drs/automation/test-automation.md#rule-adr-auto-test-tagbyoutermostring)).
source-only: it reads the repository's own files.
```
