---
catzc:
  immutable:
    with_body_sha: "2049fc81e20a"
    repo_status: locked
    path: docs/references/automation/catzc-azure-firewall/private/Get-FirewallMarkdownColumns.ps1.md
    folder: docs/references/automation/catzc-azure-firewall/private
    name: get-firewall-markdown-columns-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Azure.Firewall/private/Get-FirewallMarkdownColumns.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Builds the ordered, validated Markdown column descriptors for Convert-FirewallCsvToMarkdown.

### description

Produces the column list in render order — the rule-name column, then the composite columns, then the additional single-field columns —
de-duplicated case-insensitively. Each descriptor carries its candidate CSV fields, whether its values are sorted, and its render mode
('list' or 'protoport').

When the CSV's present headers are known (non-empty), each column's candidates are trimmed to fields the CSV actually has; a requested
column left with no backing field is a schema mismatch and throws — rather than silently dropping the column from the output.

### parameter RuleNameColumn

CSV column used as the rule name / first table column.

### parameter CompositeColumns

Ordered map of output column -> candidate CSV fields.

### parameter ProtocolPortColumnName

The composite column rendered as protocol:port pairs (and left unsorted).

### parameter AdditionalColumns

Extra single-field columns appended after the composites.

### parameter Present

The CSV's present header names. Empty means headers are unknown (no rows) — trimming/validation is skipped.

### outputs

`[System.Collections.Generic.List[object]]` of descriptors (Name, Candidates, Sort, Render).

## comment:1

Above `if ($Present.Count -gt 0) {`, written with `#`.

```text
Trim candidates to fields the CSV actually has. A requested column with none left is a schema
mismatch — fail rather than silently drop it from the output.
```
