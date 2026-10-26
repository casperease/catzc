# pwsh/Azure.Firewall/private/Get-FirewallMarkdownTable.ps1

The private function that renders the Markdown rule table, the header and the rows, for `Convert-FirewallCsvToMarkdown`.

## help

### synopsis

Renders the Markdown rule table (header + rows) for Convert-FirewallCsvToMarkdown.

### description

Builds the '| … |' table from already-sorted rows and the column descriptors from Get-FirewallMarkdownColumns: a header row, the separator
row, then one row per rule. Each cell gathers its column's candidate CSV fields — multi-value fields are split on -SplitPattern and IP-group
resource IDs trimmed to their simple name (unless -DoNotCutIpgNames), sorted within a kind for 'list' columns and paired as protocol:port
for the 'protoport' column. A cell Markdown would mangle (emphasis at a whitespace boundary, or a bare URL/FQDN) is wrapped in a code span.
Returns the table block as a string.

### parameter `Rows`

The rule rows, already sorted into evaluation order; each a CSV record (PSObject).

### parameter `Columns`

The ordered column descriptors from Get-FirewallMarkdownColumns (Name, Candidates, Sort, Render).

### parameter `MultiValueFields`

CSV fields split into multiple values on -SplitPattern.

### parameter `IpGroupColumns`

Fields whose values are IP-group resource IDs, trimmed to the simple name (unless -DoNotCutIpgNames).

### parameter `SplitPattern`

Regex splitting multi-value fields. Default comma/semicolon with surrounding whitespace.

### parameter `CellListSeparator`

Separator joining multiple values within a cell. Default ', '.

### parameter `DoNotCutIpgNames`

Keep full IP-group resource IDs instead of trimming to the simple name.

### outputs

`[string]` The Markdown table block (header, separator, and one line per row).

## Protocols and ports

Protocols are paired with their ports as `protocols:ports`, for example `TCP/UDP:53, 8053`. An application rule carries its port inside the
protocol already and has no port field, so it passes through unpaired.

## Value order

Values are gathered per candidate and kept in candidate (group) order, because a rule may fill several candidates, for example IP groups
and addresses, and the firewall unions them group by group. For a sorted composite column this gives a two-level order: by group, then
sorted within the group.

## Code spans

A cell is wrapped in backticks where Markdown would mangle it, so a rule value renders exactly as the firewall holds it:

- `*` or `_` at a whitespace boundary reads as emphasis. The cell start and end count, since `| value |` pads with spaces. An intra-word
  `_`, as in `Allow_Web`, is safe and stays clean.
- A URL scheme or a `domain.tld` shape trips markdownlint MD034 (bare URL) and auto-linking. That covers FQDNs, wildcards and `www`; IPs,
  CIDRs, ports, tags and categories do not match.

A code span is exactly MD034's recommended fix for a bare URL.
