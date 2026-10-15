---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/private/Get-BicepSubscriptionConfigViolations.ps1.md
    kind: reference
    body_sha: "12c1f494b78d"
    adrs: []
---

# automation/Catzc.Azure.Templates/private/Get-BicepSubscriptionConfigViolations.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A config lives at `configuration/<env>[-<slot>].yml` (a shared-platform config) or
`configuration/<customer>/<env>[-<slot>].yml` (a customer config). This checks the two conventional
rules (returns a possibly-empty array of human-readable violations; the caller prepends the template
identifier):
  - a configuration subfolder is always a customer KEY defined in customer.yml;
  - the config's (customer?, environment) coordinate resolves to exactly ONE subscription
    (Get-BicepConfigSubscriptionCandidates) — the root rule: one non-customer subscription serves
    the env; the customer rule: one of the customer's subscriptions serves it.
Empty result means the config conforms.
```
