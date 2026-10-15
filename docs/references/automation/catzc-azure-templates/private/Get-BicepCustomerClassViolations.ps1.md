---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/private/Get-BicepCustomerClassViolations.ps1.md
    kind: comment-page
    body_sha: "7c7b296b2101"
    adrs: []
    links: []
---

# automation/Catzc.Azure.Templates/private/Get-BicepCustomerClassViolations.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Checks one config against the template's `customer_deployment` bit and returns a (possibly empty) array
of human-readable violation strings. The config's customer is its configuration subfolder ('' for a
configuration-root config). The rule is asymmetric:
  - customer_deployment = false ⇒ the config must NOT live under a customer subfolder (a non-customer
    template ships root configs only);
  - customer_deployment = true  ⇒ a customer subfolder is allowed, but its customer must be ENABLED by
    the have_customers variant (Test-HaveCustomer). A true template may still ship root configs.
Empty result means the config conforms.
```
