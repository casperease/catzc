<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-flow/Get-Rung.ps1.md"
  warning: "Generated Header"
---
#>

function Get-Rung {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Flow.Rung])]
    param(
        [ArgumentCompleter({ (Get-Config -Config rungs).rungs.name })]
        [string[]] $Name
    )

    foreach ($rung in (Get-Config -Config rungs).rungs) {
        if (-not $Name -or $Name -ccontains $rung.name) {
            $rung
        }
    }
}
