# pwsh/Catzc.Base.ModuleSystem/tests/Test-ModuleDependency.Tests.ps1

<!-- cspell:ignore tpols -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-ModuleDependency' {`, written with `#`.

```text
Test-ModuleDependency is a quality gate
([ADR-AUTO-TEST-QUALITYGATE](/docs/drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)): each L0 case runs it with
-PassThru over mocked boundaries and reads the collected issues; the report goes to $TestDrive.
```
