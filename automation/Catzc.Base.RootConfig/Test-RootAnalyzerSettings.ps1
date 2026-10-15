<#
.SYNOPSIS
    Quality gate: the root PSScriptAnalyzerSettings.psd1 parses as a settings hashtable through its link.
.DESCRIPTION
    A quality gate over the consumer contract of the root PSScriptAnalyzerSettings.psd1: PSScriptAnalyzer requires a...
    [ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35),
    [ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md)
    [comment:1](/docs/references/automation/catzc-base-rootconfig/Test-RootAnalyzerSettings.ps1.md#comment1)
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
