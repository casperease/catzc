<#
.SYNOPSIS
    Returns the exemption that covers a budget GUID in this run environment, or nothing.
.DESCRIPTION
    Looks the budget up in timeout-exemptions.yml for the run environment (Get-RunEnvironment) and shell. An
    exemption raises the budget's limit to its scope's ceiling while the work is tuned; it never removes the limit.
    The result is the normalized entry: kind (single | range), from, to, environments, shells, reason.
.PARAMETER Budget
    The budget's immutable GUID — registered in the managed-GUID registry and passed by the call site.
.PARAMETER Shell
    The shell the work runs in: Pwsh (the default) or Bash.
.PARAMETER EnvironmentAssertIs
    Pins the expected run environment (Pipeline or Devbox); a different one throws. The guard verifies, it never
    selects.
.OUTPUTS
    [hashtable] The covering exemption; nothing when the budget is not exempt here.
.EXAMPLE
    Get-TimeoutExemption $budget
#>
function Get-TimeoutExemption {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [guid] $Budget,
        [ValidateSet('Pwsh', 'Bash')]
        [string] $Shell = 'Pwsh',
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
