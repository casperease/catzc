---
catzc:
  derived:
    path: docs/references/automation/catzc-base-variants/Test-HaveCustomers.ps1.md
    kind: comment-page
    body_sha: "46db72db4ad5"
    adrs: []
---

# automation/Catzc.Base.Variants/Test-HaveCustomers.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A predicate over the `have_customers` repo-wide variant (see Get-EnabledCustomers). With no -Name it
answers "is the repo customer-enabled at all" (the variant is 'all' or a non-empty list). With -Name it
answers "are all the named customers enabled" (the variant is 'all', or each name is in the list). A
guard callable anywhere above the Config layer; use Assert-HaveCustomers to fail instead of branch.

Enabled here means enabled by repo policy (the variant). Whether a name is a *defined* customer is a
customer.yml (Azure-layer) concern.
```

## comment:2

Above `foreach ($customer in $Name) {`.

```text
Enabled names and the query names are both lowercase-validated, so plain (case-insensitive) membership
is equivalent here and needs no case-sensitive operator.
```
