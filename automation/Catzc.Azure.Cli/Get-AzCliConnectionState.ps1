<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Azure.Cli/Get-AzCliConnectionState.ps1
    name: get-az-cli-connection-state
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure.Cli
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Azure.Cli/tests/Get-AzCliConnectionState.Tests.ps1
---
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
