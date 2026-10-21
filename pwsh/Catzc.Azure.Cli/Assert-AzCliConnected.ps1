<#
---
catzc:
  immutable:
    with_body_sha: b88d3f274dec
  edges:
    test: pwsh/Catzc.Azure.Cli/tests/Assert-AzCliConnected.Tests.ps1
    docs: "[Assert-AzCliConnected.ps1.md](docs/references/pwsh/catzc-azure-cli/Assert-AzCliConnected.ps1.md)"
---
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
