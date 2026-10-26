# pwsh/Azure.Firewall/Convert-FirewallCsvToYaml.ps1

The command that renders an Azure Firewall rule-export CSV, application or network, as YAML: a provenance header in YAML comments
followed by the rules as a plain list.

## help

### synopsis

Renders an Azure Firewall rule-export CSV (application or network) as YAML.

### description

Reads the CSV and writes each row as a YAML mapping, splitting the multi-value fields into arrays (forced to a list even for a single value,
and to an empty list when blank). All other fields are emitted as-is. Field set is schema-agnostic: a name in -MultiValueFields that the CSV
doesn't have is simply never encountered, so the same defaults serve both the application and network exports.

The file opens with a comment header (source filename, CSV generation time, conversion time, all UTC). Being YAML comments they're ignored
by parsers, so the parsed document is still a plain list of rules.

Two parameter sets:

```text
Path   : -CsvPath + -YamlPath.
Object : -InputObject (a Get-FirewallCsv result, pipeline-bindable) + optional -OutputFolder. CsvPath
         comes from the object and the file is written as <original-name>.yaml.
```

### parameter `CsvPath`

Path to the source CSV (Path set).

### parameter `YamlPath`

Output YAML path (Path set).

### parameter `SourceName`

The filename of the source, recorded in the header comment. Defaults to the CSV's own filename.

### parameter `GeneratedAt`

CSV generation time in UTC, recorded in the header comment. When omitted, that line is dropped.

### parameter `InputObject`

A Get-FirewallCsv result (Type/Path/Generated/Blob/Modified), accepted from the pipeline (Object set).

### parameter `OutputFolder`

Where the .yaml goes in Object mode; the file is named `<original-name>.yaml`. Destination directory in Object mode; the file is named
`<original-name>.yaml`. Defaults to the yaml folder under the output root (Get-OutputRoot: `<repo>/out` locally, the artifact staging
directory in a pipeline).

### parameter `MultiValueFields`

Fields split into YAML arrays on -SplitPattern.

### parameter `SplitPattern`

Regex splitting multi-value fields. Default comma/semicolon with surrounding whitespace.

### example 1

```powershell
Convert-FirewallCsvToYaml -CsvPath .\application.csv -YamlPath .\out\application.yaml
```

### example 2

```powershell
Get-FirewallCsv -SubscriptionId $sub -StorageAccountName stfwexports -ContainerName rule-exports |
    Convert-FirewallCsvToYaml -OutputFolder .\out\yaml
```

## The source name and path

The source name defaults in the body, not as a parameter default: in Object mode `$CsvPath` comes from pipeline input, which binds after
the defaults are evaluated, so a default would never see it
([ADR-PWSH-PARAM-RESOLUTIONORDER](../../../drs/automation/pwsh/parameter-design.md#rule-adr-pwsh-param-resolutionorder)).

The path is asserted in both modes, because in Object mode it comes from the piped object. A wrong path to the source CSV then fails
there by name and never as a raw `Import-Csv` error.

## Provenance header

The provenance is written as YAML comments, so a reader sees it and a parser never does: the parsed shape stays a plain list of rules.
Times are in UTC, and the conversion time is taken now in UTC.
