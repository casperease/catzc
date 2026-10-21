# pwsh/Catzc.Base.RootConfig/Test-RootAnalyzerSettings.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Quality gate: the root PSScriptAnalyzerSettings.psd1 parses as a settings hashtable through its link.

### description

A quality gate ([ADR-AUTO-TEST-QUALITYGATE](../../../adr/automation/test-automation.md#rule-adr-auto-test-qualitygate)) over the consumer
contract of the root PSScriptAnalyzerSettings.psd1 ([ADR-REPO-ROOTCFG](../../../adr/repository/generated-root-configs.md)): PSScriptAnalyzer
requires a literal-hashtable settings file at the path it is given. The target is a headed copy of its template (Test-RootConfigFiles checks
the copy byte for byte); what remains is that a consumer opening the ROOT path parses a non-empty settings hashtable under the head. It
collects an issue when the file is missing (re-run the importer, which materialises it on every load), does not parse as a data file, or
holds no settings.

When the entry is not opted in, the root file is not managed and the gate checks nothing (Checked = $false).

### parameter `OutputFolder`

The report base folder. Defaults to out/test-root-analyzer-settings/ (Write-QualityGateReport).

### parameter `PassThru`

Return the result ({ Subject; IssueCount; Issues; ReportPath; Checked }) instead of throwing on issues.

### outputs

`[Catzc.Base.Reports.QualityGateResult]` With -PassThru only.

### example 1

```powershell
Test-RootAnalyzerSettings
```
