---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-firewall/Convert-FirewallCsvToYaml.ps1.md
    kind: comment-page
    body_sha: defe4af758cd
    adrs:
      - ADR-PWSH-PARAM#4
---

# automation/Catzc.Azure.Firewall/Convert-FirewallCsvToYaml.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:6

Above `if (-not $SourceName) {`.

```text
A body fill-in on purpose: in Object mode $CsvPath comes from pipeline input, bound after defaults are
evaluated ([ADR-PWSH-PARAM#4](/docs/adr/pwsh/parameter-design.md#rule-adr-pwsh-param4)).
```

## comment:7

Above `Assert-PathExist $CsvPath -PathType Leaf`.

```text
In Object mode CsvPath comes from the piped object (the Path set is ValidateScript'd); assert it
exists either way so a source path that is wrong fails here, named, not as a raw Import-Csv error.
```

## comment:8

Above `$header = [System.Collections.Generic.List[string]]::new()`.

```text
Provenance as a YAML comment header — visible to readers, ignored by parsers, so the parsed
shape stays a plain list of rules. Times are UTC; conversion time is taken now in UTC.
```
