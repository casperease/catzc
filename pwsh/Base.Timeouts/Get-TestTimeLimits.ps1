<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-timeouts/Get-TestTimeLimits.ps1.md"
  header: "generated"
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
