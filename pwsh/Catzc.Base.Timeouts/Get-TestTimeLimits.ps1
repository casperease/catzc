<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-timeouts/Get-TestTimeLimits.ps1.md"
  warning: "Generated Header"
---
#>

function Get-TestTimeLimits {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param()

    $config = Get-Config -Config timeouts
    [pscustomobject]@{
        LevelMs    = $config.TestLevelLimitsMs()
        RunSeconds = $config.TestRunSeconds()
    }
}
