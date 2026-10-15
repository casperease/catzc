---
catzc:
  derived:
    path: docs/references/automation/catzc-base-variants/Get-EnabledCustomers.ps1.md
    kind: comment-page
    body_sha: "1632e4a0971d"
---

# automation/Catzc.Base.Variants/Get-EnabledCustomers.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `$names = @($value | Where-Object { -not [string]::IsNullOrEmpty("$_") } |...`.

```text
Anything non-bool is 'all' or a name list. A single-element list unrolls to a scalar on return from
Get-Variant, so normalize to an array of non-empty strings before deciding — a lone 'all' is the
every-customer sentinel; everything else is the enabled-name list.
```
