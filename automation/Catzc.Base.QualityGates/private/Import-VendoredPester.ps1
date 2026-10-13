<#
.SYNOPSIS
    Loads the vendored Pester into the session on first use.
.DESCRIPTION
    Pester's import is deferred at import time for speed (ADR-AUTO-VENDOR:5); the test entry points that need
    it in the parent session — for a discovery pass, or an in-session run — load it here, once. It is vendored
    inside the code tree, so it resolves from the code root (ADR-AUTO-ASSETDEP:1), and the load is announced
    (ADR-AUTO-ANNOUNCE:2). A session that already has Pester loaded is left as it is.
.OUTPUTS
    None.
#>
function Import-VendoredPester {
    [CmdletBinding()]
    param()

    if (-not (Get-Module Pester)) {
        $pesterPath = Join-Path (Get-CatzcModulesRoot) '.vendor/Pester'
        $pester = Import-Module $pesterPath -Scope Global -Force -PassThru | Select-Object -First 1
        Write-Message "Loaded vendor module Pester $($pester.Version) from '$pesterPath'"
    }
}
