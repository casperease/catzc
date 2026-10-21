<#
---
catzc:
  immutable:
    with_body_sha: "40679acf86b4"
  edges:
    test: pwsh/Catzc.Azure/tests/Get-AzureEnvironment.Tests.ps1
    docs: "[Get-AzureEnvironment.ps1.md](docs/references/pwsh/catzc-azure/Get-AzureEnvironment.ps1.md)"
    cites:
      - ADR-AZ-DATAMOD-CUSTOMERAXIS
---
#>

function Get-AzureEnvironment {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ (Get-Config -Config azure).environments.Keys })]
        [ValidateScript({ $_ -in (Get-Config -Config azure).environments.Keys })]
        [string] $Environment,

        [Parameter(Mandatory, Position = 1)]
        [ArgumentCompleter({ (Get-Config -Config azure).subscriptions.Keys })]
        [ValidateScript({ $_ -in (Get-Config -Config azure).subscriptions.Keys })]
        [string] $Subscription
    )

    $azure = Get-Config -Config azure
    $environmentEntry = $azure.environments[$Environment]

    $subscriptionEnvironments = @($azure.subscriptions[$Subscription].environments)
    Assert-True ($Environment -in $subscriptionEnvironments) -ErrorText "Subscription '$Subscription' does not serve environment '$Environment' (serves: $($subscriptionEnvironments -join ', '))"

    $subscriptionDescriptor = Get-AzureSubscription $Subscription
    [Catzc.Azure.AzureEnvironment]::new($Environment, $environmentEntry.shortcode, $environmentEntry.region, $environmentEntry.region_code, $subscriptionDescriptor)
}
