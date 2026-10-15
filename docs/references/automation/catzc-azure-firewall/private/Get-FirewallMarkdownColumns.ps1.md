---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-firewall/private/Get-FirewallMarkdownColumns.ps1.md
    kind: comment-page
    body_sha: "673d869d8209"
---

# automation/Catzc.Azure.Firewall/private/Get-FirewallMarkdownColumns.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `if ($Present.Count -gt 0) {`.

```text
Trim candidates to fields the CSV actually has. A requested column with none left is a schema
mismatch — fail rather than silently drop it from the output.
```
