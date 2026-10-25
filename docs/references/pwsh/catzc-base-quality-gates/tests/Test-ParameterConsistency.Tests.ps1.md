# pwsh/Catzc.Base.QualityGates/tests/Test-ParameterConsistency.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-ParameterConsistency'`, written with `#`.

```text
Test-ParameterConsistency is a quality gate ([ADR-AUTO-TEST-QUALITYGATE](/docs/drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)):
the logic block mocks the file set, the conflict finder (its own unit), and the exemption config; the integrity block
runs the gate over the real public functions. Neutral fixture names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```

## comment:2

Above `Describe 'Parameter consistency of the public functions'`, written with `#`.

```text
The real public functions, through the gate.
source-only: it reads the per-function source files, which give the same answer in both run modes.
```
