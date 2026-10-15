<#
.SYNOPSIS
    Returns where this session runs: Pipeline or Devbox.
.DESCRIPTION
    The environment axis of devbox/pipeline parity, read off the one seam, Test-IsRunningInPipeline.
    [ADR-AUTO-PARITY](/docs/adr/automation/devbox-pipeline-parity.md)
    [comment:1](/docs/references/automation/catzc-base-repository/Get-RunEnvironment.ps1.md#comment1)
.PARAMETER EnvironmentAssertIs
    Pins the expected environment: the detected one is still returned, and a different one throws.
    [comment:2](/docs/references/automation/catzc-base-repository/Get-RunEnvironment.ps1.md#comment2)
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
