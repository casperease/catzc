---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Test-TestInRunScope.ps1.md
    kind: comment-page
    body_sha: "217da252795b"
---

# automation/Catzc.Base.QualityGates/private/Test-TestInRunScope.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$level = Get-TestBlockTag -Test $Test -Valid...`, written with `#`.

```text
Get-TestBlockTag returns its matches as ONE array object (`, $ret`), so its result is used as-is, never
wrapped in @() — that would nest it and every count would read 1.
```
