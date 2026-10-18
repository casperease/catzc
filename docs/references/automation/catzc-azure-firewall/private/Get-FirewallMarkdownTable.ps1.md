---
catzc:
  immutable:
    with_body_sha: fc9d82aa260d
    repo_status: locked
    path: docs/references/automation/catzc-azure-firewall/private/Get-FirewallMarkdownTable.ps1.md
    folder: docs/references/automation/catzc-azure-firewall/private
    name: get-firewall-markdown-table-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Azure.Firewall/private/Get-FirewallMarkdownTable.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Renders the Markdown rule table (header + rows) for Convert-FirewallCsvToMarkdown.

### description

Builds the '| … |' table from already-sorted rows and the column descriptors from
Get-FirewallMarkdownColumns: a header row, the separator row, then one row per rule. Each cell gathers
its column's candidate CSV fields — multi-value fields are split on -SplitPattern and IP-group resource
IDs trimmed to their simple name (unless -DoNotCutIpgNames), sorted within a kind for 'list' columns and
paired as protocol:port for the 'protoport' column. A cell Markdown would mangle (emphasis at a
whitespace boundary, or a bare URL/FQDN) is wrapped in a code span. Returns the table block as a string.

### parameter Rows

The rule rows, already sorted into evaluation order; each a CSV record (PSObject).

### parameter Columns

The ordered column descriptors from Get-FirewallMarkdownColumns (Name, Candidates, Sort, Render).

### parameter MultiValueFields

CSV fields split into multiple values on -SplitPattern.

### parameter IpGroupColumns

Fields whose values are IP-group resource IDs, trimmed to the simple name (unless -DoNotCutIpgNames).

### parameter SplitPattern

Regex splitting multi-value fields. Default comma/semicolon with surrounding whitespace.

### parameter CellListSeparator

Separator joining multiple values within a cell. Default ', '.

### parameter DoNotCutIpgNames

Keep full IP-group resource IDs instead of trimming to the simple name.

### outputs

`[string]` The Markdown table block (header, separator, and one line per row).

## comment:1

Above `$protocols = @()`, written with `#`.

```text
Pair protocols with ports as "protocols:ports" (e.g. TCP/UDP:53, 8053). App rules
carry the port inside Protocols already and have no port field, so they pass through.
```

## comment:2

Above `$values = foreach ($candidate in $column.Candidates) {`, written with `#`.

```text
Gather values per candidate, preserving candidate (group) order. A rule can populate
more than one candidate (e.g. IP groups and addresses); the firewall unions them.
For sorted composites this gives two-level ordering: by group, then sorted within group.
```

## comment:3

Above `if ($cell -match...`, written with `#`.

```text
Wrap a cell in backticks when Markdown would mangle it:
 - * or _ at a whitespace boundary (cell start/end count, since "| value |" pads with spaces)
   -> emphasis. Intra-word _ (Allow_Web) is safe and stays clean.
 - a URL scheme or a domain.tld shape -> markdownlint MD034 (bare URL) and auto-linking.
   Covers FQDNs/wildcards/www; IPs, CIDRs, ports, tags, and categories don't match.
A code span is exactly MD034's recommended fix for a bare URL.
```
