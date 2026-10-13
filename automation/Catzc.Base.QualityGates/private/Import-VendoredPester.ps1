<#
.SYNOPSIS
    Loads the vendored Pester into the session on first use, and makes sure it is the one in use.
.DESCRIPTION
    Pester's import is deferred at import time for speed
    ([ADR-AUTO-VENDOR#5](/docs/adr/automation/powershell/vendor-toolset-dependencies.md#rule-adr-auto-vendor5)); the
    test entry points that need
    it in the parent session — for a discovery pass, or an in-session run — load it here, once. It is vendored
    inside the code tree, so it resolves from the code root
    ([ADR-AUTO-ASSETDEP#1](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep1)), and the load
    is announced
    ([ADR-AUTO-ANNOUNCE#2](/docs/adr/automation/powershell/announce-state-changes.md#rule-adr-auto-announce2)). A
    session that already has the vendored version loaded from the vendor folder is left as it is — a check of a few
    milliseconds; any other Pester in the session (a system install, another version) is removed and replaced, and
    the replacement is named in the announcement.
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
