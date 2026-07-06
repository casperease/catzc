<#
.SYNOPSIS
    Tests whether the active az CLI session matches a given subscription and/or tenant.
.DESCRIPTION
    Returns $true when `az account show` reports the subscription and/or tenant passed by argument;
    $false otherwise (including not logged in). A pure query — it never throws on a mismatch. Use
    Assert-AzCliConnected for the throwing companion. Both share Get-AzCliConnectionState.

    Two parameter sets — at least one of subscription / tenant is required:
      Subscription : -SubscriptionId (required) [-TenantId]
      Tenant       : -TenantId (required)
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
