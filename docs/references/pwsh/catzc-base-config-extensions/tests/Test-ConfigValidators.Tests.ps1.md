# pwsh/Base.ConfigExtensions/tests/Test-ConfigValidators.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-ConfigValidators'`, written with `#`.

```text
Test-ConfigValidators over a fixture code root in $TestDrive and two in-memory fixture modules whose private
validators the gate lists from their own scope. Neutral fixture names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```

## comment:2

Above `It 'every Assert-*Config validator maps to a configs/*.yml in its module (no...`, written with `#`.

```text
Title deliberately avoids Pester's <var> name-template syntax — under the importer's strict mode an
unmatched <name> token in an It title throws at name-expansion time instead of expanding to empty.
```
