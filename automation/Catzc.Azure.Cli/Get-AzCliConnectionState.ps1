<#
.SYNOPSIS
    Returns the az CLI session's connection state relative to a given subscription and/or tenant.
.DESCRIPTION
    Runs `az account show` and compares the active session against the identity passed by argument —
    a subscription (with optional tenant), or a tenant alone. The generic, azure.yml-free primitive:
    the single source of the comparison shared by Test-AzCliConnected (returns a bool) and
    Assert-AzCliConnected (throws), so the two cannot drift. The config-aware Assert/Test-AzCliIsConnected
    resolve a subscription name from azure.yml and delegate here (subscription set);
    a caller that only cares about the directory (e.g. an ADO token) uses the tenant set.

    Two parameter sets — at least one of subscription / tenant is required:
      Subscription : -SubscriptionId (required) [-TenantId]
      Tenant       : -TenantId (required)

    Returns an ordered dictionary:
      { logged_in, connected, expected_tenant, expected_subscription, actual_tenant, actual_subscription }
    `logged_in` is false when `az account show` exits non-zero; `connected` additionally requires every
    supplied component (subscription and/or tenant) to match.
.PARAMETER SubscriptionId
    The subscription GUID the session must be set to.
.PARAMETER TenantId
    The tenant GUID the session must be in. Optional alongside a subscription; required on its own.
.EXAMPLE
    (Get-AzCliConnectionState -SubscriptionId 00000000-0000-0000-0000-000000000002).connected
.EXAMPLE
    (Get-AzCliConnectionState -TenantId 00000000-0000-0000-0000-000000000001).connected
#>
function Get-AzCliConnectionState {
    [CmdletBinding(DefaultParameterSetName = 'Tenant')]
    param(
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'Subscription')]
        [string] $SubscriptionId,

        [Parameter(ParameterSetName = 'Subscription')]
        [Parameter(Mandatory, ParameterSetName = 'Tenant')]
        [string] $TenantId
    )

    if ($SubscriptionId) {
        Assert-IsGuid $SubscriptionId
    }
    if ($TenantId) {
        Assert-IsGuid $TenantId
    }

    $result = Invoke-AzCli 'account show -o yaml' -PassThru -NoAssert
    if ($result.ExitCode -ne 0) {
        return [Catzc.Azure.Cli.ConnectionState]::new($false, $false, $TenantId, $SubscriptionId, $null, $null)
    }

    $output = $result.Output | ConvertFrom-Yaml
    $subscriptionMatch = ((-not $SubscriptionId) -or ($output.id -eq $SubscriptionId))
    $tenantMatch = ((-not $TenantId) -or ($output.tenantId -eq $TenantId))

    [Catzc.Azure.Cli.ConnectionState]::new($true, ($subscriptionMatch -and $tenantMatch), $TenantId, $SubscriptionId, $output.tenantId, $output.id)
}
