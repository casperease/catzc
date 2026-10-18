# pwsh/Catzc.Tooling.Core/tests/Test-ExpectedPackageManager.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeEach {` (occurrence 2), written with `#`.

```text
Neutral fixture ([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/adr/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)): an entry whose
mechanism is an MSYS2 package, installed on Windows into the tree Get-ScriptInstallDir names.
```

## comment:2

Above `BeforeEach {` (occurrence 3), written with `#`.

```text
Neutral fixture ([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/adr/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)): the MSYS2
package on Windows, the apt package on Linux, and nothing declared for macOS, so each platform takes one manager.
```
