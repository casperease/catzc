<#
---
catzc:
  immutable:
    with_body_sha: "65d368d64741"
  edges:
    test: pwsh/Catzc.Base.Timeouts/tests/Test-IsTimeoutExempt.Tests.ps1
    docs: "[Test-IsTimeoutExempt.ps1.md](../../docs/references/pwsh/catzc-base-timeouts/Test-IsTimeoutExempt.ps1.md)"
---
#>

function Test-IsTimeoutExempt {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [guid] $Budget,
        [ArgumentCompleter({ [Catzc.Base.Engines.ExecutionEngines]::Names })]
        [string] $Shell = [Catzc.Base.Engines.ExecutionEngines]::Pwsh.Name
    )

    $null -ne (Get-TimeoutExemption $Budget -Shell $Shell)
}
