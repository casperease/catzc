<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-module-system/Get-ImportMix.ps1.md"
  warning: "Generated Header"
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
