---
catzc:
  derived:
    path: docs/references/automation/internal/tests/New-BuiltCatzcRoot.Tests.ps1.md
    kind: test-asset
    body_sha: "675653f9674e"
    adrs:
      - ADR-AUTO-TEST#30
---

# automation/.internal/tests/New-BuiltCatzcRoot.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Invoke-InBuiltCatzc' -Tag 'L1', 'logic', 'ADR-AUTO-TEST#30' {`.

```text
Invoke-InBuiltCatzc against a stand-in build root: its Import-Catzc.ps1 is a fixture that sets the two roots
the way the real entry script does and prints importer-style console lines — the noise the result channel must
survive. A real child pwsh, but no importer, so it stays fast.
```
