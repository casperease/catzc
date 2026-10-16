---
catzc:
  immutable:
    with_body_sha: cbe120df3896
    path: docs/references/automation/catzc-base-variants/Test-HaveCustomers.ps1.md
    folder: docs/references/automation/catzc-base-variants
    name: test-have-customers-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.Variants/Test-HaveCustomers.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `foreach ($customer in $Name) {`, written with `#`.

```text
Enabled names and the query names are both lowercase-validated, so plain (case-insensitive) membership
is equivalent here and needs no case-sensitive operator.
```
