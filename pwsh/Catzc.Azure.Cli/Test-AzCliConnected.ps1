<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Azure.Cli/Test-AzCliConnected.ps1
    name: test-az-cli-connected
    filetype: ps1
    role: function
    subkind: gate
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Azure.Cli
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Azure.Cli/tests/Test-AzCliConnected.Tests.ps1
    docs: "[Test-AzCliConnected.ps1.md](docs/references/pwsh/catzc-azure-cli/Test-AzCliConnected.ps1.md)"
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
