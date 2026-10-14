<#
.SYNOPSIS
    Returns where this session runs: Pipeline or Devbox.
.DESCRIPTION
    The environment axis of devbox/pipeline parity
    ([ADR-AUTO-PARITY](/docs/adr/automation/devbox-pipeline-parity.md)), read off the one seam,
    Test-IsRunningInPipeline. It answers where the run happens; who drives it (a person or an agent) is
    Get-SessionActor's question. Environment-dependent settings, such as the time-safeguard limits, key on this.
.PARAMETER EnvironmentAssertIs
    Pins the expected environment: the detected one is still returned, and a different one throws. The guard
    verifies, it never selects.
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
