---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/Get-BicepTemplateSlots.ps1.md
    kind: comment-page
    body_sha: "61456378d4ff"
---

# automation/Catzc.Azure.Templates/Get-BicepTemplateSlots.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:4

Above `$wantCustomer = [string]$Customer`.

```text
slots are [ordered] dicts -> use the script-block Where-Object/ForEach-Object form (the
`Where-Object prop -EQ` shortcut does not bind ordered-dict keys). Filter by customer — the
configuration axis; empty/unbound = the configuration-root (shared-platform) slots.
```
