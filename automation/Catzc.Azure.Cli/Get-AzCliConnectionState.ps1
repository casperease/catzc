<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Cli/Get-AzCliConnectionState.ps1
    kind: function
    module: Catzc.Azure.Cli
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Returns the az CLI session's connection state relative to a given subscription and/or tenant.
.DESCRIPTION
    The one comparison behind both Test and Assert, so the bool and the throw cannot drift apart.
    [comment:1](/docs/references/automation/catzc-azure-cli/Get-AzCliConnectionState.ps1.md#comment1)
.PARAMETER SubscriptionId
    The subscription GUID the session must be set to.
.PARAMETER TenantId
    The tenant GUID the session must be in. Optional alongside a subscription; required on its own.
.EXAMPLE
    (Get-AzCliConnectionState -SubscriptionId 50a0ed00-de00-50b0-0000-000000000000).connected
.EXAMPLE
    (Get-AzCliConnectionState -TenantId fa0e0000-7e0a-0700-1d00-000000000000).connected
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
