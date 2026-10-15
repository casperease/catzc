---
catzc:
  derived:
    path: docs/references/automation/catzc-base-variants/Get-EnabledCustomers.ps1.md
    kind: comment-page
    body_sha: "8a6b6e61c6de"
---

# automation/Catzc.Base.Variants/Get-EnabledCustomers.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$names = @($value | Where-Object { -not [string]::IsNullOrEmpty("$_") } |...`, written with `#`.

```text
Anything non-bool is 'all' or a name list. A single-element list unrolls to a scalar on return from
Get-Variant, so normalize to an array of non-empty strings before deciding — a lone 'all' is the
every-customer sentinel; everything else is the enabled-name list.
```
