# pwsh/Azure.Firewall/Convert-FirewallCsvToMarkdown.ps1

The command that renders an Azure Firewall rule-export CSV, application or network, as a Markdown document: a title and provenance preamble
followed by one table of the rules in firewall evaluation order.

## help

### synopsis

Renders an Azure Firewall rule-export CSV (application or network) as a Markdown document.

### description

Writes a titled Markdown file: an H1 of the source filename, a line with the CSV generation time and the conversion time (both UTC), then a
'## Rules' section with a one-line ordering note and the table.

Rows are sorted toward firewall evaluation order — rule collection GROUP priority (from -GroupPriority, since the export omits it), then
rule collection priority, then rule name. Columns are composite: Source and Destination each list every populated candidate field (IP
groups, addresses, FQDNs, FQDN tags, web categories), grouped by kind and sorted within a kind; Protocol/Port pairs protocols with ports and
is left unsorted. IP-group resource IDs are trimmed to their simple name unless -DoNotCutIpgNames is set. A requested column with no backing
field in the CSV is a schema mismatch and throws.

Two parameter sets:

```text
Path   : -CsvPath + -MarkdownPath, with optional -SourceName / -GeneratedAt.
Object : -InputObject (a Get-FirewallCsv result, pipeline-bindable) + optional -OutputFolder. CsvPath,
         title, and generation time are taken from the object; the file is written as <name>.md.
```

### parameter `CsvPath`

Path to the source CSV (Path set).

### parameter `MarkdownPath`

Output Markdown path (Path set).

### parameter `RuleNameColumn`

CSV column used as the rule name / first table column. Default 'Name'.

### parameter `CompositeColumns`

Ordered map of output column -> candidate CSV fields. Drives column order and which fields each cell pulls from; a composite cell lists
every populated candidate.

### parameter `ProtocolPortColumnName`

Which composite column pairs protocols with ports (and is rendered unsorted). Default 'Protocol/Port'.

### parameter `IpGroupColumns`

Fields whose values are IP-group resource IDs, trimmed to the simple name. NOT for CIDRs.

### parameter `AdditionalColumns`

Extra single-field columns appended after the composites. Default the rule collection group and priority.

### parameter `MultiValueFields`

Fields split into multiple values on -SplitPattern.

### parameter `SplitPattern`

Regex splitting multi-value fields. Default comma/semicolon with surrounding whitespace.

### parameter `CellListSeparator`

Separator joining multiple values within a cell. Default ', '.

### parameter `GroupPriority`

Rule collection group -> group priority, for evaluation-order sorting (lower = evaluated first). Not present in the export, so it's supplied
here. Unlisted groups sort last.

### parameter `DoNotCutIpgNames`

Keep full IP-group resource IDs instead of trimming to the simple name.

### parameter `SourceName`

H1 title. Defaults to the CSV's own filename.

### parameter `GeneratedAt`

CSV generation time in UTC, from the filename and supplied by Get-FirewallCsv. When omitted, the preamble shows only the conversion time.

### parameter `InputObject`

A Get-FirewallCsv result (Type/Path/Generated/Blob/Modified), accepted from the pipeline (Object set).

### parameter `OutputFolder`

Where the .md goes in Object mode; the file is named `<original-name>.md`. Destination directory in Object mode; the file is named
`<original-name>.md`. Defaults to the markdown folder under the output root (Get-OutputRoot: `<repo>/out` locally, the artifact staging
directory in a pipeline).

### parameter `SortNote`

The sentence under '## Rules' describing the ordering.

### example 1

```powershell
Convert-FirewallCsvToMarkdown -CsvPath .\application.csv -MarkdownPath .\docs\application.md
```

### example 2

```powershell
Get-FirewallCsv -SubscriptionId $sub -StorageAccountName stfwexports -ContainerName rule-exports |
    Convert-FirewallCsvToMarkdown -OutputFolder .\docs
```

## The source name and path

The source name defaults in the body, not as a parameter default: in Object mode `$CsvPath` comes from pipeline input, which binds after the
defaults are evaluated, so a default would never see it
([ADR-PWSH-PARAM-RESOLUTIONORDER](../../../drs/automation/pwsh/parameter-design.md#rule-adr-pwsh-param-resolutionorder)).

The path is asserted in both modes, because in Object mode it comes from the piped object. A wrong path to the source CSV then fails there
by name and never as a raw `Import-Csv` error.

## Row order

Rows sort toward the firewall's own evaluation order: the rule collection group priority first (from `-GroupPriority`), then the rule
collection priority, so an allow collection at 3000 comes before a deny at 3010, then the rule name. An unknown group and a blank collection
priority both sort last, never first.

## Columns

The ordered, validated column descriptors (rule name, the composite columns, then extras) are built in one place, the columns helper. It
trims the candidates to the headers the CSV has, and a requested column the CSV lacks fails there instead of vanishing from the table.

## Preamble and times

The document opens with a title and a provenance preamble. Every time is rendered in UTC, and the conversion time is taken now in UTC, so
the same CSV gives the same page on a workstation in another timezone and on a build agent.

PowerShell binds a nullable date as a plain `[datetime]`, so the generated-time value is null-checked and cast. `HasValue` and `Value` do
not exist on the unwrapped struct.
