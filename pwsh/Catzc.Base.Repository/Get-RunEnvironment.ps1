<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Repository/Get-RunEnvironment.ps1
    name: get-run-environment
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Repository
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Repository/tests/Get-RunEnvironment.Tests.ps1
    docs: "[Get-RunEnvironment.ps1.md](docs/references/pwsh/catzc-base-repository/Get-RunEnvironment.ps1.md)"
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
