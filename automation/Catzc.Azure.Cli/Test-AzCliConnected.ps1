<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Cli/Test-AzCliConnected.ps1
    kind: function
    module: Catzc.Azure.Cli
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Tests whether the active az CLI session matches a given subscription and/or tenant.
.DESCRIPTION
    A pure query: a mismatch or a missing login returns false and never throws.
    [comment:1](/docs/references/automation/catzc-azure-cli/Test-AzCliConnected.ps1.md#comment1)
.PARAMETER SubscriptionId
    The subscription GUID the session must be set to.
.PARAMETER TenantId
    The tenant GUID the session must be in. Optional alongside a subscription; required on its own.
.EXAMPLE
    if (Test-AzCliConnected -SubscriptionId 50a0ed00-de00-50b0-0000-000000000000) { ... }
.EXAMPLE
    if (Test-AzCliConnected -TenantId fa0e0000-7e0a-0700-1d00-000000000000) { ... }
#>
function Test-AzCliConnected {
    [CmdletBinding(DefaultParameterSetName = 'Tenant')]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'Subscription')]
        [string] $SubscriptionId,

        [Parameter(ParameterSetName = 'Subscription')]
        [Parameter(Mandatory, ParameterSetName = 'Tenant')]
        [string] $TenantId
    )

    (Get-AzCliConnectionState @PSBoundParameters).connected
}
