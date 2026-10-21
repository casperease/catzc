<#
---
catzc:
  immutable:
    with_body_sha: "4037c75188b7"
  edges:
    test: pwsh/Catzc.Azure.Cli/tests/Test-AzCliConnected.Tests.ps1
    docs: "[Test-AzCliConnected.ps1.md](../../docs/references/pwsh/catzc-azure-cli/Test-AzCliConnected.ps1.md)"
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
