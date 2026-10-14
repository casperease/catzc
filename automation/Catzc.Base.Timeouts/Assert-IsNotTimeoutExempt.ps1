<#
.SYNOPSIS
    Asserts that a budget GUID runs under its normal time limit here, not an exemption.
.DESCRIPTION
    For work that must never run exempt — for example a quality gate in a pipeline, where an exemption would hide
    a regression. Throws naming the exemption's reason when the budget is exempt; Get-TimeoutExemption defines the
    lookup.
.PARAMETER Budget
    The budget's immutable GUID.
.PARAMETER Shell
    The shell the work runs in: Pwsh (the default) or Bash.
.EXAMPLE
    if (Test-IsRunningInPipeline) { Assert-IsNotTimeoutExempt $budget }
#>
function Assert-IsNotTimeoutExempt {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [guid] $Budget,
        [ValidateSet('Pwsh', 'Bash')]
        [string] $Shell = 'Pwsh'
    )

    $exemption = Get-TimeoutExemption $Budget -Shell $Shell
    if ($exemption) {
        throw "Budget '$Budget' is exempt from its time limit here ($($exemption.reason)); remove the exemption from timeout-exemptions.yml"
    }
}
