---
catzc:
  derived:
    path: docs/references/automation/internal/tests/New-BuiltCatzcRoot.Tests.ps1.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "1f4695deceda"
    adrs:
      - ADR-AUTO-TEST#30
---

# automation/.internal/tests/New-BuiltCatzcRoot.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Invoke-InBuiltCatzc' -Tag 'L1', 'logic', 'ADR-AUTO-TEST#30' {`, written with `#`.

```text
Invoke-InBuiltCatzc against a stand-in build root: its Import-Catzc.ps1 is a fixture that sets the two roots
the way the real entry script does and prints importer-style console lines — the noise the result channel must
survive. A real child pwsh, but no importer, so it stays fast.
```
