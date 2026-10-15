---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-firewall/private/Get-FirewallMarkdownColumns.ps1.md
    kind: reference
    body_sha: ad28242bf674
    adrs: []
---

# automation/Catzc.Azure.Firewall/private/Get-FirewallMarkdownColumns.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Produces the column list in render order — the rule-name column, then the composite columns, then the
additional single-field columns — de-duplicated case-insensitively. Each descriptor carries its candidate
CSV fields, whether its values are sorted, and its render mode ('list' or 'protoport').

When the CSV's present headers are known (non-empty), each column's candidates are trimmed to fields the
CSV actually has; a requested column left with no backing field is a schema mismatch and throws — rather
than silently dropping the column from the output.
```

## comment:2

Above `if ($Present.Count -gt 0) {`.

```text
Trim candidates to fields the CSV actually has. A requested column with none left is a schema
mismatch — fail rather than silently drop it from the output.
```
