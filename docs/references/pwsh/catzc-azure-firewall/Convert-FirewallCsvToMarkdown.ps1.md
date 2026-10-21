# pwsh/Catzc.Azure.Firewall/Convert-FirewallCsvToMarkdown.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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

## comment:1

Above `if (-not $SourceName) {`, written with `#`.

```text
A body fill-in on purpose: in Object mode $CsvPath comes from pipeline input, bound after defaults are
evaluated ([ADR-PWSH-PARAM-RESOLUTIONORDER](/docs/drs/automation/pwsh/parameter-design.md#rule-adr-pwsh-param-resolutionorder)).
```

## comment:2

Above `Assert-PathExist $CsvPath -PathType Leaf`, written with `#`.

```text
In Object mode CsvPath comes from the piped object (the Path set is ValidateScript'd); assert it
exists either way so a source path that is wrong fails here, named, not as a raw Import-Csv error.
```

## comment:3

Above `$sortProps = @()`, written with `#`.

```text
Sort toward firewall evaluation order: rule collection GROUP priority first (from -GroupPriority),
then rule collection priority (e.g. allow=3000 before deny=3010), then rule name.
Unknown group and blank collection priority both sort last rather than first.
```

## comment:4

Above `$columnParams = @{`, written with `#`.

```text
Build the ordered, validated column descriptors (rule name, composites, extras). Trimming to
$present headers and the schema-mismatch throw live in the helper.
```

## comment:5

Above `[void]$ret.AppendLine("# $SourceName")`, written with `#`.

```text
Title + provenance preamble. Times are rendered in UTC; conversion time is taken now in UTC so it
doesn't depend on whether this runs on a CEST workstation or a UTC build agent.
```

## comment:6

Above `$generatedUtc =...`, written with `#`.

```text
PowerShell binds Nullable[datetime] as a plain [datetime], so check for $null and cast —
do NOT use .HasValue/.Value, which don't exist on the unwrapped struct.
```
