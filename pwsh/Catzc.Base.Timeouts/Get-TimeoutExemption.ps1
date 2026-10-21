<#
---
catzc:
  immutable:
    with_body_sha: "463a01de4d8b"
  edges:
    test: pwsh/Catzc.Base.Timeouts/tests/Get-TimeoutExemption.Tests.ps1
    docs: "[Get-TimeoutExemption.ps1.md](docs/references/pwsh/catzc-base-timeouts/Get-TimeoutExemption.ps1.md)"
---
#>

function Get-TimeoutExemption {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [guid] $Budget,
        [ArgumentCompleter({ [Catzc.Base.Engines.ExecutionEngines]::Names })]
        [string] $Shell = [Catzc.Base.Engines.ExecutionEngines]::Pwsh.Name,
        [ValidateSet('Pipeline', 'Devbox')]
        [string] $EnvironmentAssertIs
    )

    $guard = @{}
    if ($EnvironmentAssertIs) {
        $guard.EnvironmentAssertIs = $EnvironmentAssertIs
    }
    $environment = Get-RunEnvironment @guard
    $exemption = (Get-Config -Config timeout-exemptions).Find($Budget.ToString(), $environment, $Shell)
    if ($exemption) {
        $exemption
    }
}
