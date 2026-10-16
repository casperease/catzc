<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Import-VendoredPester.ps1
    kind: function
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.QualityGates
    visibility: private
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Import-VendoredPester.Tests.ps1
    adrs:
      - ADR-AUTO-ASSETDEP#1
      - ADR-AUTO-CONSOLE#11
      - ADR-PWSH-VENDOR#5
  config:
    synopsis: Loads the vendored Pester into the session on first use, and makes sure it is the one in use.
    description: |-
      Pester's import is deferred at import time for speed
      ([ADR-PWSH-VENDOR#5](/docs/adr/pwsh/vendor-toolset-dependencies.md#rule-adr-pwsh-vendor5)); the
      test entry points that need
      it in the parent session — for a discovery pass, or an in-session run — load it here, once. It is vendored
      inside the code tree, so it resolves from the code root
      ([ADR-AUTO-ASSETDEP#1](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep1)), and the load
      is announced
      ([ADR-AUTO-CONSOLE#11](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console11)). A
      session that already has the vendored version loaded from the vendor folder is left as it is — a check of a few
      milliseconds; any other Pester in the session (a system install, another version) is removed and replaced, and
      the replacement is named in the announcement.
    outputs: None.
---
#>

function Import-VendoredPester {
    [CmdletBinding()]
    param()

    $pesterPath = Join-Path (Get-CatzcModulesRoot) '.vendor/Pester'
    $versionPath = @(Get-ChildPath $pesterPath -Directory -Depth 1 -PruneVendor $false)
    Assert-True ($versionPath.Count -eq 1) -ErrorText "Import-VendoredPester: expected one vendored Pester version under '$pesterPath', found $($versionPath.Count)."
    $vendoredBase = [System.IO.Path]::GetFullPath($versionPath[0])

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
