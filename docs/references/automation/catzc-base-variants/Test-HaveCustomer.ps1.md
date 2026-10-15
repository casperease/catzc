---
catzc:
  derived:
    path: docs/references/automation/catzc-base-variants/Test-HaveCustomer.ps1.md
    kind: comment-page
    body_sha: f50e4a58121a
    adrs: []
---

# automation/Catzc.Base.Variants/Test-HaveCustomer.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The single-customer form of Test-HaveCustomers, for the common "is this one customer enabled" check.
A thin cover: Test-HaveCustomers -Name $Name. Returns $true when the `have_customers` variant is 'all'
or includes the name.
```
