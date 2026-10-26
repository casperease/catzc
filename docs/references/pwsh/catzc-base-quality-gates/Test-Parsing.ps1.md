# pwsh/Base.QualityGates/Test-Parsing.ps1

The quality gate for parsing: it fails on any named PowerShell or YAML file that does not parse, before an import reads it.

## help

### synopsis

The parse quality gate: fails on any named PowerShell or YAML file that does not parse, before an import reads it.

### description

Parses each named file without importing or running it: a .ps1, .psm1 or .psd1 file through the PowerShell parser, a .yml or .yaml file
through ConvertFrom-Yaml. One stray character in a module file or a shipped config on the import path breaks every session's next import, so
an edit to such a file is checked here first. Each PowerShell issue names the file and the line the parser stopped at; a YAML issue names
the file and carries the parser's own position. A quality gate
([ADR-AUTO-TEST-QUALITYGATE](../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)): it ends through
Write-QualityGateReport, which writes out/test-parsing/, prints every issue, and throws once listing them all. A file of any other extension
throws, since it has no parser here.

### parameter `Path`

The files to parse, repository-relative or absolute.

### parameter `OutputFolder`

The report base folder. Defaults to `<out>/test-parsing`.

### parameter `PassThru`

Return a result object ({ Subject; IssueCount; Issues; ReportPath; Facts }, with FileCount among the facts) instead of throwing.

### outputs

Throws on any file that does not parse; with -PassThru, returns the result object.

### example 1

```powershell
Test-Parsing -Path 'pwsh/Base.Docs/private/Get-GlossarySourceViolations.ps1', 'pwsh/Base.Docs/configs/glossary.yml'
```
