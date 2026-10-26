<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-module-system/Get-ImportMix.ps1.md"
  header: "generated"
---
#>

function Get-ImportMix {
    [CmdletBinding()]
    [OutputType([Catzc.Base.ModuleSystem.ImportMix])]
    param()

    $recorded = $ExecutionContext.SessionState.PSVariable.GetValue('script:importMix')
    if ($null -ne $recorded) {
        return $recorded
    }
    $script:importMix = Resolve-ImportMix
    $script:importMix
}
