# pwsh/Catzc.Base.Languages/tests/New-GoWorkspace.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:root = Join-Path $TestDrive 'repo'`, written with `#`.

```text
Isolate through the seams ([ADR-AUTO-TEST-NOOVERMOCKING](/docs/adr/automation/test-automation.md#rule-adr-auto-test-noovermocking)): a
fixture config, a fixture tools.yml pin, and a fixture
repository root in $TestDrive.
```
