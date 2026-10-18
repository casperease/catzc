<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Azure.Cli/Test-AzCliConnected.ps1
    name: test-az-cli-connected
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure.Cli
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Azure.Cli/tests/Test-AzCliConnected.Tests.ps1
---
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
