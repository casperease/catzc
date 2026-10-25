# pwsh/Catzc.Base.QualityGates/tests/Test-ConfigIdentityHygiene.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-ConfigIdentityHygiene' -Tag 'L1', 'integrity', 'source-only' {`, written with `#`.

```text
Integrity — it reads the real shipped config (and derives from the real fixture configs). source-only: those are
repository files, which give the same answer in both run modes. The logic block mocks the fixture set with a
neutral token ([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)) and pins the gate's
uniform shape ([ADR-AUTO-TEST-QUALITYGATE](/docs/drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)).
```
