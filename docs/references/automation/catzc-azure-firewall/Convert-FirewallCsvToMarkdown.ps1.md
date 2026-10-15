---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-firewall/Convert-FirewallCsvToMarkdown.ps1.md
    kind: comment-page
    body_sha: ef819015defe
    adrs:
      - ADR-PWSH-PARAM#4
---

# automation/Catzc.Azure.Firewall/Convert-FirewallCsvToMarkdown.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Writes a titled Markdown file: an H1 of the source filename, a line with the CSV generation time and
the conversion time (both UTC), then a '## Rules' section with a one-line ordering note and the table.

Rows are sorted toward firewall evaluation order — rule collection GROUP priority (from -GroupPriority,
since the export omits it), then rule collection priority, then rule name. Columns are composite: Source
and Destination each list every populated candidate field (IP groups, addresses, FQDNs, FQDN tags, web
categories), grouped by kind and sorted within a kind; Protocol/Port pairs protocols with ports and is
left unsorted. IP-group resource IDs are trimmed to their simple name unless -DoNotCutIpgNames is set.
A requested column with no backing field in the CSV is a schema mismatch and throws.

Two parameter sets:
  Path   : -CsvPath + -MarkdownPath, with optional -SourceName / -GeneratedAt.
  Object : -InputObject (a Get-FirewallCsv result, pipeline-bindable) + optional -OutputFolder. CsvPath,
           title, and generation time are taken from the object; the file is written as <name>.md.
```

## comment:2

Section `.PARAMETER OutputFolder` of the comment-based help.

```text
Destination directory in Object mode; the file is named <original-name>.md. Defaults to the markdown folder
under the output root (Get-OutputRoot: <repo>/out locally, the artifact staging directory in a pipeline).
```

## comment:3

Above `[Parameter()]`.

```text
Rule collection group -> group priority, for evaluation-order sorting (lower = evaluated first).
Not present in the export, so it's supplied here. Unlisted groups sort last.
```

## comment:4

Above `if (-not $SourceName) {`.

```text
A body fill-in on purpose: in Object mode $CsvPath comes from pipeline input, bound after defaults are
evaluated ([ADR-PWSH-PARAM#4](/docs/adr/pwsh/parameter-design.md#rule-adr-pwsh-param4)).
```

## comment:5

Above `Assert-PathExist $CsvPath -PathType Leaf`.

```text
In Object mode CsvPath comes from the piped object (the Path set is ValidateScript'd); assert it
exists either way so a source path that is wrong fails here, named, not as a raw Import-Csv error.
```

## comment:6

Above `$sortProps = @()`.

```text
Sort toward firewall evaluation order: rule collection GROUP priority first (from -GroupPriority),
then rule collection priority (e.g. allow=3000 before deny=3010), then rule name.
Unknown group and blank collection priority both sort last rather than first.
```

## comment:7

Above `$columnParams = @{`.

```text
Build the ordered, validated column descriptors (rule name, composites, extras). Trimming to
$present headers and the schema-mismatch throw live in the helper.
```

## comment:8

Above `[void]$ret.AppendLine("# $SourceName")`.

```text
Title + provenance preamble. Times are rendered in UTC; conversion time is taken now in UTC so it
doesn't depend on whether this runs on a CEST workstation or a UTC build agent.
```

## comment:9

Above `$generatedUtc = ([datetime]$GeneratedAt).ToUniversalTime().ToString('yyyy-MM-...`.

```text
PowerShell binds Nullable[datetime] as a plain [datetime], so check for $null and cast —
do NOT use .HasValue/.Value, which don't exist on the unwrapped struct.
```
