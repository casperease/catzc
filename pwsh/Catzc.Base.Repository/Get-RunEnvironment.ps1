<#
---
catzc:
  immutable:
    with_body_sha: e573a9be18fc
  edges:
    test: pwsh/Catzc.Base.Repository/tests/Get-RunEnvironment.Tests.ps1
    docs: "[Get-RunEnvironment.ps1.md](../../docs/references/pwsh/catzc-base-repository/Get-RunEnvironment.ps1.md)"
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
