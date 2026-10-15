---
catzc:
  derived:
    path: docs/references/automation/catzc-base-variants/Test-HaveCustomers.ps1.md
    kind: comment-page
    body_sha: "19912f855347"
---

# automation/Catzc.Base.Variants/Test-HaveCustomers.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `foreach ($customer in $Name) {`.

```text
Enabled names and the query names are both lowercase-validated, so plain (case-insensitive) membership
is equivalent here and needs no case-sensitive operator.
```
