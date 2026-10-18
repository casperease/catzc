# pwsh/Catzc.Base.QualityGates/tests/Test-GeneratedFiles.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-GeneratedFiles' -Tag 'L0', 'logic' {`, written with `#`.

```text
Test-GeneratedFiles is a quality gate
([ADR-AUTO-TEST-QUALITYGATE](/docs/adr/automation/test-automation.md#rule-adr-auto-test-qualitygate)): each L0 case mocks every generator
at the module boundary and reads the collected issues; the report goes to $TestDrive. The integrity blocks that run it
over the real tree live beside each generator's own tests.
```
