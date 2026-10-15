---
catzc:
  derived:
    path: docs/references/automation/catzc-base-variants/Assert-HaveCustomers.ps1.md
    kind: comment-page
    body_sha: "3930161372de"
    adrs: []
---

# automation/Catzc.Base.Variants/Assert-HaveCustomers.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The throwing companion to Test-HaveCustomers. With no -Name it requires the repo to be customer-enabled
at all; with -Name it requires every named customer to be enabled. Throws naming the disabled or
not-enabled customer(s) and pointing at the `have_customers` variant. Guards a customer-only code path.
```
