<#
.SYNOPSIS
    Quality gate: the root PSScriptAnalyzerSettings.psd1 parses as a settings hashtable through its link.
.DESCRIPTION
    A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) over the consumer
    contract of the root PSScriptAnalyzerSettings.psd1 ([ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md)):
    PSScriptAnalyzer requires a literal-hashtable settings file at the path it is given. The target is a copyAsLink
    entry of rootconfig.yml, so content equality with its source holds by construction (Test-RootConfigFiles checks
    the link); what remains is that a consumer opening the ROOT path can follow the link and parse a non-empty
    settings hashtable. It collects an issue when the file is missing (re-run the importer, which materialises it on
    every load), does not parse as a data file, or holds no settings.

    When the entry is not opted in, the root file is not managed and the gate checks nothing (Checked = $false).
.PARAMETER OutputFolder
    The report base folder. Defaults to out/test-root-analyzer-settings/ (Write-QualityGateReport).
.PARAMETER PassThru
    Return the result ({ Subject; IssueCount; Issues; ReportPath; Checked }) instead of throwing on issues.
.OUTPUTS
    [pscustomobject] With -PassThru only.
.EXAMPLE
    Test-RootAnalyzerSettings
#>
function Test-RootAnalyzerSettings {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    $target = 'PSScriptAnalyzerSettings.psd1'
    $entry = @(Get-RootConfigTargets -Config (Get-Config -Config rootconfig) | Where-Object { $_.target -eq $target })
    $issues = [System.Collections.Generic.List[string]]::new()

    if ($entry.Count -gt 0) {
        $rootPath = Join-Path (Get-RepositoryRoot) $target
        if (-not [System.IO.File]::Exists($rootPath)) {
            $issues.Add("${target}: missing at the repository root — re-run the importer (Build-RootConfig materialises it)")
        }
        else {
            try {
                $settings = Import-PowerShellDataFile -LiteralPath $rootPath
                if ($settings -isnot [hashtable] -or $settings.Keys.Count -eq 0) {
                    $issues.Add("${target}: parses, but holds no settings")
                }
            }
            catch {
                $issues.Add("${target}: does not parse as a settings hashtable through the link — $($_.Exception.Message)")
            }
        }
    }

    Write-QualityGateReport -Subject 'root-analyzer-settings' -Title 'Test-RootAnalyzerSettings' -Issues $issues `
        -Facts ([ordered]@{ Checked = $entry.Count -gt 0 }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
