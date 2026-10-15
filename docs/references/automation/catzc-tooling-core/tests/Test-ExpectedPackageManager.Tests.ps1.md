---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/tests/Test-ExpectedPackageManager.Tests.ps1.md
    kind: comment-page
    body_sha: "7c0038788bd4"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Tooling.Core/tests/Test-ExpectedPackageManager.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeEach {` (occurrence 2), written with `#`.

```text
Neutral fixture ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)): an entry whose
mechanism is an MSYS2 package, installed on Windows into the tree Get-ScriptInstallDir names.
```

## comment:2

Above `BeforeEach {` (occurrence 3), written with `#`.

```text
Neutral fixture ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)): the MSYS2
package on Windows, the apt package on Linux, and nothing declared for macOS, so each platform takes one manager.
```
