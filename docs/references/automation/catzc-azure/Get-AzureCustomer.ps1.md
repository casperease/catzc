---
catzc:
  derived:
    path: docs/references/automation/catzc-azure/Get-AzureCustomer.ps1.md
    kind: comment-page
    body_sha: e09c993247ac
---

# automation/Catzc.Azure/Get-AzureCustomer.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A customer is named two ways — its readable key (apex) or its 2-char shortcode (ap). A subscription's
`customer` field in azure.yml may use either; this resolves both to the same record so downstream code
always works with the canonical key. Reads customer.yml (Get-Config -Config customer). The key/shortcode
name-spaces are kept distinct by the CustomerConfig type, so the match is unambiguous: keys first, then
shortcodes. Throws when the token is neither.
```
