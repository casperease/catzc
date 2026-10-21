<#
---
catzc:
  immutable:
    with_body_sha: "41904793d841"
  edges:
    test: pwsh/Catzc.Base.Timeouts/tests/Get-TestTimeLimits.Tests.ps1
    docs: "[Get-TestTimeLimits.ps1.md](docs/references/pwsh/catzc-base-timeouts/Get-TestTimeLimits.ps1.md)"
    cites:
      - ADR-AUTO-FAILFAST-BOUNDEVERYWAIT
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
