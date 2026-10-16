---
catzc:
  derived:
    path: docs/references/automation/catzc-base-asserts/Assert-PathExist.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: b4d3680b1e6f
---

# automation/Catzc.Base.Asserts/Assert-PathExist.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$message = if ($ErrorText) {`, written with `#`.

```text
Not $ErrorText ?? ... : a [string] param coerces $null to '', and ?? only coalesces $null, so the
default would never apply (the throw would be blank). See ADR: automatic-variable-pitfalls.
```
