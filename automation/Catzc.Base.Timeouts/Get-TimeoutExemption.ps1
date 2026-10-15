<#
.SYNOPSIS
    Returns the exemption that covers a budget GUID in this run environment, or nothing.
.DESCRIPTION
    An exemption raises the budget's limit to its scope's ceiling while the work is tuned; it never removes the limit.
    [comment:1](/docs/references/automation/catzc-base-timeouts/Get-TimeoutExemption.ps1.md#comment1)
.PARAMETER Budget
    The budget's immutable GUID — registered in the managed-GUID registry and passed by the call site.
.PARAMETER Shell
    A name that is no execution engine throws and lists the valid shells, so a typo never reads as not exempt.
    [comment:2](/docs/references/automation/catzc-base-timeouts/Get-TimeoutExemption.ps1.md#comment2)
.PARAMETER EnvironmentAssertIs
    The guard only verifies the environment found at run time; it never selects which environment is looked up.
    [comment:3](/docs/references/automation/catzc-base-timeouts/Get-TimeoutExemption.ps1.md#comment3)
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
