# pwsh/Azure.Firewall/private/Get-FirewallMarkdownColumns.ps1

The private function that builds the ordered, validated Markdown column descriptors for `Convert-FirewallCsvToMarkdown`.

## help

### synopsis

Builds the ordered, validated Markdown column descriptors for Convert-FirewallCsvToMarkdown.

### description

Produces the column list in render order — the rule-name column, then the composite columns, then the additional single-field columns —
de-duplicated case-insensitively. Each descriptor carries its candidate CSV fields, whether its values are sorted, and its render mode
('list' or 'protoport').

When the CSV's present headers are known (non-empty), each column's candidates are trimmed to fields the CSV actually has; a requested
column left with no backing field is a schema mismatch and throws — rather than silently dropping the column from the output.

### parameter `RuleNameColumn`

CSV column used as the rule name / first table column.

### parameter `CompositeColumns`

Ordered map of output column -> candidate CSV fields.

### parameter `ProtocolPortColumnName`

The composite column rendered as protocol:port pairs (and left unsorted).

### parameter `AdditionalColumns`

Extra single-field columns appended after the composites.

### parameter `Present`

The CSV's present header names. Empty means headers are unknown (no rows) — trimming/validation is skipped.

### outputs

`[System.Collections.Generic.List[object]]` of descriptors (Name, Candidates, Sort, Render).

## Trimming to the CSV

The candidates of each column are trimmed to the fields the CSV actually has. A requested column with none of its fields present is a schema
mismatch, so it fails and is never silently dropped from the table.
