<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Repository/Get-RunEnvironment.ps1
    kind: function
    module: Catzc.Base.Repository
    visibility: public
    adrs:
      - ADR-AUTO-PARITY
---
#>

<#
.SYNOPSIS
    Returns where this session runs: Pipeline or Devbox.
.DESCRIPTION
    Answers where the run happens, not who drives it: that is Get-SessionActor, so an agent in a pipeline is Pipeline.
.PARAMETER EnvironmentAssertIs
    The guard only verifies the detected environment and never selects one, so a mismatch throws.
.OUTPUTS
    [string] 'Pipeline' or 'Devbox'.
.EXAMPLE
    Get-RunEnvironment
.EXAMPLE
    $null = Get-RunEnvironment -EnvironmentAssertIs Devbox
#>
function Get-RunEnvironment {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [ValidateSet('Pipeline', 'Devbox')]
        [string] $EnvironmentAssertIs
    )

    $environment = if (Test-IsRunningInPipeline) {
        'Pipeline'
    }
    else {
        'Devbox'
    }
    if ($EnvironmentAssertIs -and $environment -ne $EnvironmentAssertIs) {
        throw "Run environment is '$environment', but -EnvironmentAssertIs expects '$EnvironmentAssertIs'"
    }
    $environment
}
