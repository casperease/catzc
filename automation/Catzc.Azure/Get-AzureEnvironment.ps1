<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Azure/Get-AzureEnvironment.ps1
    name: get-azure-environment
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Azure/tests/Get-AzureEnvironment.Tests.ps1
    cites:
      - ADR-AZ-DATAMOD#4
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
