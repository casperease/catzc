<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.RootConfig/Test-RootAnalyzerSettings.ps1
    name: test-root-analyzer-settings
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.RootConfig
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.RootConfig/tests/Test-RootAnalyzerSettings.Tests.ps1
    cites:
      - ADR-AUTO-TEST#35
      - ADR-REPO-ROOTCFG
---
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
