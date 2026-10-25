# pwsh/Catzc.Tooling.KeyHandler/tests/Import-PsReadLineKeyHandlerSet.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Import-PsReadLineKeyHandlerSet'`, written with `#`.

```text
Import-PsReadLineKeyHandlerSet over fixture configs (Get-Config mocked to the real config types built from fixture
data): the plan marks each binding supported exactly when its function is in the allow-list, and -DryRun applies
nothing. The shipped configs' load is the quality gate Test-ShippedConfigs; a binding's non-empty key and function
is a KeyHandlerBinding construction rule. Neutral fixture names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```
