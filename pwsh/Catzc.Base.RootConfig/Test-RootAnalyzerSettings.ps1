<#
---
catzc:
  immutable:
    with_body_sha: a18a70f69e2a
  edges:
    test: pwsh/Catzc.Base.RootConfig/tests/Test-RootAnalyzerSettings.Tests.ps1
    docs: "[Test-RootAnalyzerSettings.ps1.md](docs/references/pwsh/catzc-base-root-config/Test-RootAnalyzerSettings.ps1.md)"
    cites:
      - ADR-AUTO-TEST-QUALITYGATE
      - ADR-REPO-ROOTCFG
---
#>

function Test-RootAnalyzerSettings {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
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
                $issues.Add("${target}: does not parse as a settings hashtable —$($_.Exception.Message)")
            }
        }
    }

    Write-QualityGateReport -Subject 'root-analyzer-settings' -Title 'Test-RootAnalyzerSettings' -Issues $issues `
        -Facts ([ordered]@{ Checked = $entry.Count -gt 0 }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
