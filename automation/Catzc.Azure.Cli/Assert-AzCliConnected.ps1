<#
.SYNOPSIS
    Asserts the active az CLI session matches a given subscription and/or tenant.
.DESCRIPTION
    The throwing companion to Test-AzCliConnected.
    [comment:1](/docs/references/automation/catzc-azure-cli/Assert-AzCliConnected.ps1.md#comment1)
.PARAMETER SubscriptionId
    The subscription GUID the session must be set to.
.PARAMETER TenantId
    The tenant GUID the session must be in. Optional alongside a subscription; required on its own.
.EXAMPLE
    Assert-AzCliConnected -SubscriptionId 50a0ed00-de00-50b0-0000-000000000000
.EXAMPLE
    Assert-AzCliConnected -TenantId fa0e0000-7e0a-0700-1d00-000000000000
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
