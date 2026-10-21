# pwsh/Catzc.Base.QualityGates/tests/Test-LogicTestIdentity.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-LogicTestIdentity' -Tag 'L1', 'integrity', 'source-only' {`, written with `#`.

```text
The integrity block binds the REAL shipped config (the live-identity set is derived from it), so it also names
live identities (e.g. 'apex') as fixture data; the integrity tag is both correct
([ADR-AUTO-TEST-ONECATEGORY](/docs/drs/automation/test-automation.md#rule-adr-auto-test-onecategory))
and what exempts that block from the gate's own self-scan. source-only: it scans the repository's test files,
which give the same answer in both run modes. The logic block mocks the live set with neutral tokens
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)) and pins the gate's uniform
shape ([ADR-AUTO-TEST-QUALITYGATE](/docs/drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)).
```
