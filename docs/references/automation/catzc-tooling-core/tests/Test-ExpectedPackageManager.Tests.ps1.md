---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/tests/Test-ExpectedPackageManager.Tests.ps1.md
    kind: test-asset
    body_sha: "962f10af5b8f"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Tooling.Core/tests/Test-ExpectedPackageManager.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `BeforeEach {`.

```text
Neutral fixture ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)): an entry whose
mechanism is an MSYS2 package, installed on Windows into the tree Get-ScriptInstallDir names.
```

## comment:2

Above `BeforeEach {`.

```text
Neutral fixture ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)): the MSYS2
package on Windows, the apt package on Linux, and nothing declared for macOS, so each platform takes one manager.
```
