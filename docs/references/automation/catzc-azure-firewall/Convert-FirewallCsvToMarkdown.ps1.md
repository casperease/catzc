---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-firewall/Convert-FirewallCsvToMarkdown.ps1.md
    kind: comment-page
    body_sha: "16dd84d646de"
    adrs:
      - ADR-PWSH-PARAM#4
---

# automation/Catzc.Azure.Firewall/Convert-FirewallCsvToMarkdown.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:11

Above `if (-not $SourceName) {`.

```text
A body fill-in on purpose: in Object mode $CsvPath comes from pipeline input, bound after defaults are
evaluated ([ADR-PWSH-PARAM#4](/docs/adr/pwsh/parameter-design.md#rule-adr-pwsh-param4)).
```

## comment:12

Above `Assert-PathExist $CsvPath -PathType Leaf`.

```text
In Object mode CsvPath comes from the piped object (the Path set is ValidateScript'd); assert it
exists either way so a source path that is wrong fails here, named, not as a raw Import-Csv error.
```

## comment:13

Above `$sortProps = @()`.

```text
Sort toward firewall evaluation order: rule collection GROUP priority first (from -GroupPriority),
then rule collection priority (e.g. allow=3000 before deny=3010), then rule name.
Unknown group and blank collection priority both sort last rather than first.
```

## comment:14

Above `$columnParams = @{`.

```text
Build the ordered, validated column descriptors (rule name, composites, extras). Trimming to
$present headers and the schema-mismatch throw live in the helper.
```

## comment:15

Above `[void]$ret.AppendLine("# $SourceName")`.

```text
Title + provenance preamble. Times are rendered in UTC; conversion time is taken now in UTC so it
doesn't depend on whether this runs on a CEST workstation or a UTC build agent.
```

## comment:16

Above `$generatedUtc =...`.

```text
PowerShell binds Nullable[datetime] as a plain [datetime], so check for $null and cast —
do NOT use .HasValue/.Value, which don't exist on the unwrapped struct.
```
