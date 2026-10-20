<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.ModuleSystem/Test-ModuleDependency.ps1
    name: test-module-dependency
    filetype: ps1
    role: function
    subkind: gate
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.ModuleSystem/tests/Test-ModuleDependency.Tests.ps1
    docs: "[Test-ModuleDependency.ps1.md](docs/references/pwsh/catzc-base-modulesystem/Test-ModuleDependency.ps1.md)"
    cites:
      - ADR-AUTO-TEST-QUALITYGATE
---
#>

function Test-ModuleDependency {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    [OutputType([pscustomobject])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    Write-QualityGateReport -Subject module-dependency -Title Test-ModuleDependency `
        -Issues @(Get-ModuleDependencyViolations) -OutputFolder $OutputFolder -PassThru:$PassThru
}
