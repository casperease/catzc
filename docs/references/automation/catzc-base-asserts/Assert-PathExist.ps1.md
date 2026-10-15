---
catzc:
  derived:
    path: docs/references/automation/catzc-base-asserts/Assert-PathExist.ps1.md
    kind: comment-page
    body_sha: "6abfcec5fe6e"
    adrs: []
    links: []
---

# automation/Catzc.Base.Asserts/Assert-PathExist.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$message = if ($ErrorText) {`.

```text
Not $ErrorText ?? ... : a [string] param coerces $null to '', and ?? only coalesces $null, so the
default would never apply (the throw would be blank). See ADR: automatic-variable-pitfalls.
```
