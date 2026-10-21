<#
---
catzc:
  immutable:
    with_body_sha: "4318475c9b5f"
  edges:
    test: pwsh/Catzc.Base.Timeouts/tests/Assert-IsNotTimeoutExempt.Tests.ps1
    docs: "[Assert-IsNotTimeoutExempt.ps1.md](../../docs/references/pwsh/catzc-base-timeouts/Assert-IsNotTimeoutExempt.ps1.md)"
---
#>

function Assert-IsNotTimeoutExempt {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [guid] $Budget,
        [ArgumentCompleter({ [Catzc.Base.Engines.ExecutionEngines]::Names })]
        [string] $Shell = [Catzc.Base.Engines.ExecutionEngines]::Pwsh.Name
    )

    $exemption = Get-TimeoutExemption $Budget -Shell $Shell
    if ($exemption) {
        throw "Budget '$Budget' is exempt from its time limit here ($($exemption.reason)); remove the exemption from timeout-exemptions.yml"
    }
}
