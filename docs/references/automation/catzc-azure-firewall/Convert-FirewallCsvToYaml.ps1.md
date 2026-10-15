---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-firewall/Convert-FirewallCsvToYaml.ps1.md
    kind: reference
    body_sha: "675111b0bc30"
    adrs:
      - ADR-PWSH-PARAM#4
---

# automation/Catzc.Azure.Firewall/Convert-FirewallCsvToYaml.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Reads the CSV and writes each row as a YAML mapping, splitting the multi-value fields into arrays
(forced to a list even for a single value, and to an empty list when blank). All other fields are
emitted as-is. Field set is schema-agnostic: a name in -MultiValueFields that the CSV doesn't have is
simply never encountered, so the same defaults serve both the application and network exports.

The file opens with a comment header (source filename, CSV generation time, conversion time, all UTC).
Being YAML comments they're ignored by parsers, so the parsed document is still a plain list of rules.

Two parameter sets:
  Path   : -CsvPath + -YamlPath.
  Object : -InputObject (a Get-FirewallCsv result, pipeline-bindable) + optional -OutputFolder. CsvPath
           comes from the object and the file is written as <original-name>.yaml.
```

## comment:2

Section `.PARAMETER OutputFolder` of the comment-based help.

```text
Destination directory in Object mode; the file is named <original-name>.yaml. Defaults to the yaml folder
under the output root (Get-OutputRoot: <repo>/out locally, the artifact staging directory in a pipeline).
```

## comment:3

Above `if (-not $SourceName) {`.

```text
A body fill-in on purpose: in Object mode $CsvPath comes from pipeline input, bound after defaults are
evaluated ([ADR-PWSH-PARAM#4](/docs/adr/pwsh/parameter-design.md#rule-adr-pwsh-param4)).
```

## comment:4

Above `Assert-PathExist $CsvPath -PathType Leaf`.

```text
In Object mode CsvPath comes from the piped object (the Path set is ValidateScript'd); assert it
exists either way so a source path that is wrong fails here, named, not as a raw Import-Csv error.
```

## comment:5

Above `$header = [System.Collections.Generic.List[string]]::new()`.

```text
Provenance as a YAML comment header — visible to readers, ignored by parsers, so the parsed
shape stays a plain list of rules. Times are UTC; conversion time is taken now in UTC.
```
