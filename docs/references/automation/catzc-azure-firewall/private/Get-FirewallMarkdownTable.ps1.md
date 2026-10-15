---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-firewall/private/Get-FirewallMarkdownTable.ps1.md
    kind: comment-page
    body_sha: "25bcb58e6a7e"
---

# automation/Catzc.Azure.Firewall/private/Get-FirewallMarkdownTable.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Builds the '| … |' table from already-sorted rows and the column descriptors from
Get-FirewallMarkdownColumns: a header row, the separator row, then one row per rule. Each cell gathers
its column's candidate CSV fields — multi-value fields are split on -SplitPattern and IP-group resource
IDs trimmed to their simple name (unless -DoNotCutIpgNames), sorted within a kind for 'list' columns and
paired as protocol:port for the 'protoport' column. A cell Markdown would mangle (emphasis at a
whitespace boundary, or a bare URL/FQDN) is wrapped in a code span. Returns the table block as a string.
```

## comment:2

Above `$protocols = @()`.

```text
Pair protocols with ports as "protocols:ports" (e.g. TCP/UDP:53, 8053). App rules
carry the port inside Protocols already and have no port field, so they pass through.
```

## comment:3

Above `$values = foreach ($candidate in $column.Candidates) {`.

```text
Gather values per candidate, preserving candidate (group) order. A rule can populate
more than one candidate (e.g. IP groups and addresses); the firewall unions them.
For sorted composites this gives two-level ordering: by group, then sorted within group.
```

## comment:4

Above `if ($cell -match '^[*_]|[*_]$|\s[*_]|[*_]\s|https?://|ftp://|[a-z0-9-]+\.[a-z...`.

```text
Wrap a cell in backticks when Markdown would mangle it:
 - * or _ at a whitespace boundary (cell start/end count, since "| value |" pads with spaces)
   -> emphasis. Intra-word _ (Allow_Web) is safe and stays clean.
 - a URL scheme or a domain.tld shape -> markdownlint MD034 (bare URL) and auto-linking.
   Covers FQDNs/wildcards/www; IPs, CIDRs, ports, tags, and categories don't match.
A code span is exactly MD034's recommended fix for a bare URL.
```

## comment:5

Above `$protocols = @()`.

```text
Pair protocols with ports as "protocols:ports" (e.g. TCP/UDP:53, 8053). App rules
carry the port inside Protocols already and have no port field, so they pass through.
```

## comment:6

Above `$values = foreach ($candidate in $column.Candidates) {`.

```text
Gather values per candidate, preserving candidate (group) order. A rule can populate
more than one candidate (e.g. IP groups and addresses); the firewall unions them.
For sorted composites this gives two-level ordering: by group, then sorted within group.
```

## comment:7

Above `if ($cell -match...`.

```text
Wrap a cell in backticks when Markdown would mangle it:
 - * or _ at a whitespace boundary (cell start/end count, since "| value |" pads with spaces)
   -> emphasis. Intra-word _ (Allow_Web) is safe and stays clean.
 - a URL scheme or a domain.tld shape -> markdownlint MD034 (bare URL) and auto-linking.
   Covers FQDNs/wildcards/www; IPs, CIDRs, ports, tags, and categories don't match.
A code span is exactly MD034's recommended fix for a bare URL.
```
