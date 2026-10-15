---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/private/Get-BicepConfigSubscriptionCandidates.ps1.md
    kind: comment-page
    body_sha: cd5348c1830e
---

# automation/Catzc.Azure.Templates/private/Get-BicepConfigSubscriptionCandidates.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `if ($token -ceq $Customer -or (Get-AzureCustomer $token).key -ceq $Customer) {`.

```text
Customer config: match the raw token first (the common, by-key binding), and only resolve a
non-matching token through the catalogue (the by-shortcode binding) — keeps the read lazy.
```
