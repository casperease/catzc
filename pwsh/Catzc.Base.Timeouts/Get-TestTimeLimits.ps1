<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Timeouts/Get-TestTimeLimits.ps1
    name: get-test-time-limits
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Timeouts
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
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
