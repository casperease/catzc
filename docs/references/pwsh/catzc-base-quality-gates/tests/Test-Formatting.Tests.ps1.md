# pwsh/Base.QualityGates/tests/Test-Formatting.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-Formatting'`, written with `#`.

```text
Test-Formatting is a quality gate ([ADR-AUTO-TEST-QUALITYGATE](/docs/drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)):
each L0 case mocks the registry and Format-Code at the module boundary and reads the collected issues;
the report goes to $TestDrive. Neutral fixture names ([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```

## comment:2

Above `Describe 'Repository formatting integrity'`, written with `#`.

```text
Integrity: the real repository is formatted — every language languages.yml gives a formatter, and the C# type
namespaces (each source declares its module's file-scoped namespace, the invariant the type loader also enforces). L2
because it drives the real engines; it self-skips when one of their tools is absent
([ADR-AUTO-TEST-TAGBYOUTERMOSTRING](/docs/drs/automation/test-automation.md#rule-adr-auto-test-tagbyoutermostring)/9). source-only: it reads the
repository's own files, which give the same answer in both run modes.
```
