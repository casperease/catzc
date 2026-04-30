<#
.SYNOPSIS
    Asserts the active az CLI session matches a given subscription and/or tenant.
.DESCRIPTION
    The throwing companion to Test-AzCliConnected. Throws a remediation-bearing error when az is not
    logged in, or is set to a different subscription / tenant than the ones passed by argument. The
    generic, azure.yml-free primitive — the config-aware Assert-AzCliIsConnected takes a subscription
    name, resolves its identity from azure.yml, and delegates here. Both Assert/Test share Get-AzCliConnectionState.

    Two parameter sets — at least one of subscription / tenant is required:
      Subscription : -SubscriptionId (required) [-TenantId]
      Tenant       : -TenantId (required)
.PARAMETER SubscriptionId
    The subscription GUID the session must be set to.
.PARAMETER TenantId
    The tenant GUID the session must be in. Optional alongside a subscription; required on its own.
.EXAMPLE
    Assert-AzCliConnected -SubscriptionId 00000000-0000-0000-0000-000000000002
.EXAMPLE
    Assert-AzCliConnected -TenantId 00000000-0000-0000-0000-000000000001
#>
function Assert-AzCliConnected {
    [CmdletBinding(DefaultParameterSetName = 'Tenant')]
    param(
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'Subscription')]
        [string] $SubscriptionId,

        [Parameter(ParameterSetName = 'Subscription')]
        [Parameter(Mandatory, ParameterSetName = 'Tenant')]
        [string] $TenantId
    )

    $state = Get-AzCliConnectionState @PSBoundParameters

    if (-not $state.logged_in) {
        $tenantHint = if ($TenantId) {
            " --tenant $TenantId"
        }
        else {
            ''
        }
        throw "Not logged in to az CLI. Run: az login$tenantHint"
    }
    if (-not $state.connected) {
        $expected = @()
        if ($state.expected_subscription) {
            $expected += "sub=$($state.expected_subscription)"
        }
        if ($state.expected_tenant) {
            $expected += "tenant=$($state.expected_tenant)"
        }

        $fix = @()
        if ($state.expected_tenant) {
            $fix += "az login --tenant $($state.expected_tenant)"
        }
        if ($state.expected_subscription) {
            $fix += "az account set --subscription $($state.expected_subscription)"
        }

        throw (
            "az CLI is set to the wrong context. Expected $($expected -join ' '); " +
            "got sub=$($state.actual_subscription) tenant=$($state.actual_tenant). " +
            "Run: $($fix -join '; ')"
        )
    }
}
