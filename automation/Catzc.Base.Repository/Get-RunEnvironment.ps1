<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Repository/Get-RunEnvironment.ps1
    name: get-run-environment
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Repository
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Repository/tests/Get-RunEnvironment.Tests.ps1
    cites:
      - ADR-AUTO-PARITY
---
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
