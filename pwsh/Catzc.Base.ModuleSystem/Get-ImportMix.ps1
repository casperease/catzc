<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.ModuleSystem/Get-ImportMix.ps1
    name: get-import-mix
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.ModuleSystem/tests/Get-ImportMix.Tests.ps1
    docs: "[Get-ImportMix.ps1.md](docs/references/pwsh/catzc-base-modulesystem/Get-ImportMix.ps1.md)"
    cites:
      - ADR-AUTO-IMPORTER
---
#>

function Get-ImportMix {
    [CmdletBinding()]
    [OutputType([Catzc.Base.ModuleSystem.ImportMix])]
    param()

    # The record the importer set for the session; a session the importer did not finish resolves it from the configuration once.
    $recorded = $ExecutionContext.SessionState.PSVariable.GetValue('script:importMix')
    if ($null -ne $recorded) {
        return $recorded
    }
    $script:importMix = Resolve-ImportMix
    $script:importMix
}
