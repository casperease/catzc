---
catzc:
  derived:
    path: docs/references/automation/catzc-base-languages/tests/ConvertFrom-GoTestJson.Tests.ps1.md
    kind: test-asset
    body_sha: "70f366625d99"
---

# automation/Catzc.Base.Languages/tests/ConvertFrom-GoTestJson.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$script:widgetStream = Get-Content -Raw -LiteralPath (Join-Path $PSScriptRoot...`.

```text
Canned `go test -json` streams (tests/assets), recorded from a widget package (pass, fail, skip, and a
table test with subtests) and a gadget package that does not compile.
```
