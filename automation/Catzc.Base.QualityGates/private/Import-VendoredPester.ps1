# catzc:
#   path: automation/Catzc.Base.QualityGates/private/Import-VendoredPester.ps1
#   module: Catzc.Base.QualityGates
#   visibility: private

<#
.SYNOPSIS
    Loads the vendored Pester into the session on first use, and makes sure it is the one in use.
.DESCRIPTION
    Any other Pester in the session, a system install or another version, is removed and replaced, and named.
    [ADR-AUTO-ASSETDEP#1](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep1),
    [ADR-AUTO-CONSOLE#11](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console11),
    [ADR-PWSH-VENDOR#5](/docs/adr/pwsh/vendor-toolset-dependencies.md#rule-adr-pwsh-vendor5)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Import-VendoredPester.ps1.md#comment1)
.OUTPUTS
    None.
#>
function Import-VendoredPester {
    [CmdletBinding()]
    param()

    $pesterPath = Join-Path (Get-CatzcModulesRoot) '.vendor/Pester'
    $versionPath = @(Get-ChildItem -LiteralPath $pesterPath -Directory)
    Assert-True ($versionPath.Count -eq 1) -ErrorText "Import-VendoredPester: expected one vendored Pester version under '$pesterPath', found $($versionPath.Count)."
    $vendoredBase = [System.IO.Path]::GetFullPath($versionPath[0].FullName)

    $loaded = @(Get-Module Pester)
    if (@($loaded | Where-Object { [System.IO.Path]::GetFullPath($_.ModuleBase) -eq $vendoredBase }).Count -gt 0) {
        return
    }

    $replaced = ''
    if ($loaded.Count -gt 0) {
        $replaced = "; replaced $(($loaded | ForEach-Object { "Pester $($_.Version) from '$($_.ModuleBase)'" }) -join ', ')"
        Remove-Module -Name Pester -Force
    }
    $pester = Import-Module $pesterPath -Scope Global -Force -PassThru | Select-Object -First 1
    Write-Message "Loaded vendor module Pester $($pester.Version) from '$pesterPath'$replaced"
}
