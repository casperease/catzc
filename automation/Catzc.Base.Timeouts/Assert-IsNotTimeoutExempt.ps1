<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Timeouts/Assert-IsNotTimeoutExempt.ps1
    kind: function
    module: Catzc.Base.Timeouts
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Asserts that a budget GUID runs under its normal time limit here, not an exemption.
.DESCRIPTION
    Use it where an exemption would hide a regression, such as a pipeline check; the throw names the exemption's reason.
    [comment:1](/docs/references/automation/catzc-base-timeouts/Assert-IsNotTimeoutExempt.ps1.md#comment1)
.PARAMETER Budget
    The budget's immutable GUID.
.PARAMETER Shell
    The shell the work runs in, one of the execution engines (pwsh, bash or zsh); pwsh is the default.
.EXAMPLE
    if (Test-IsRunningInPipeline) { Assert-IsNotTimeoutExempt $budget }
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
