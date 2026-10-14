<#
.SYNOPSIS
    Tests whether a budget GUID is exempt from its normal time limit in this run environment.
.DESCRIPTION
    The boolean form of Get-TimeoutExemption, which defines the lookup.
.PARAMETER Budget
    The budget's immutable GUID.
.PARAMETER Shell
    The shell the work runs in: Pwsh (the default) or Bash.
.EXAMPLE
    if (Test-IsTimeoutExempt $budget) { Write-Message 'running exempt while tuned' }
#>
function Test-IsTimeoutExempt {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [guid] $Budget,
        [ValidateSet('Pwsh', 'Bash')]
        [string] $Shell = 'Pwsh'
    )

    $null -ne (Get-TimeoutExemption $Budget -Shell $Shell)
}
