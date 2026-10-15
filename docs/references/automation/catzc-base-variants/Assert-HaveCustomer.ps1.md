---
catzc:
  derived:
    path: docs/references/automation/catzc-base-variants/Assert-HaveCustomer.ps1.md
    kind: comment-page
    body_sha: "30dd354a22f0"
---

# automation/Catzc.Base.Variants/Assert-HaveCustomer.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The single-customer form of Assert-HaveCustomers. A thin cover: Assert-HaveCustomers -Name $Name. Throws
when the named customer is not enabled by the `have_customers` variant.
```
