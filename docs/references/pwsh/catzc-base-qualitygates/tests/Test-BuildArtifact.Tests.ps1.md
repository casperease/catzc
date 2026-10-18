# pwsh/Catzc.Base.QualityGates/tests/Test-BuildArtifact.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-BuildArtifact' -Tag 'L0', 'logic' {`, written with `#`.

```text
Test-BuildArtifact is a quality gate
([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)): each L0 case mocks the build, the
child-pwsh probe, the source reads, and the formatter at the module boundary, and reads the collected issues; the
report goes to $TestDrive. The integrity blocks that build and load the real tree call the gate from their own test files.
```
