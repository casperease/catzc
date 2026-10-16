---
catzc:
  derived:
    path: docs/references/automation/catzc-base-languages/tests/ConvertFrom-GoTestJson.Tests.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "7cf61401ce1f"
---

# automation/Catzc.Base.Languages/tests/ConvertFrom-GoTestJson.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:widgetStream = Get-Content -Raw -LiteralPath (Join-Path $PSScriptRoot...`, written with `#`.

```text
Canned `go test -json` streams (tests/assets), recorded from a widget package (pass, fail, skip, and a
table test with subtests) and a gadget package that does not compile.
```
