<#
.SYNOPSIS
    Resolves the one subscription of a family that serves an environment — the (family, env) join.
.DESCRIPTION
    A template's configuration folder names a family; the environment in the config filename picks the
    member subscription (configuration/<family>/<env>[-<slot>].yml — see docs/adr/azure/data-model.md).
    This is that join: within a family every environment is served by exactly one subscription
    (validated by Assert-AzureConfig), so the result is unique. Throws when the family is unknown, when
    no member serves the environment, or when more than one does (a config defect the load-time
    validator should already have rejected).
.PARAMETER Family
    Family name (see Get-AzureFamily).
.PARAMETER Environment
    Environment name — a key in azure.yml's `environments`.
.EXAMPLE
    Get-AzureFamilySubscription apex subn     # -> apex_nonprod
.EXAMPLE
    Get-AzureFamilySubscription shared prod   # -> shared_prod
#>
function Get-AzureFamilySubscription {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ (Get-AzureFamilies) | ForEach-Object { $_.name } })]
        [string] $Family,

        [Parameter(Mandatory, Position = 1)]
        [ArgumentCompleter({ (Get-Config -Config azure).environments.Keys })]
        [string] $Environment
    )

    $familyDescriptor = Get-AzureFamily $Family
    $azure = Get-Config -Config azure

    $serving = @($familyDescriptor.subscriptions | Where-Object {
            $Environment -in @($azure.subscriptions[$_].environments)
        })

    if ($serving.Count -eq 0) {
        $servedEnvironments = @($familyDescriptor.subscriptions | ForEach-Object { @($azure.subscriptions[$_].environments) } | Select-Object -Unique | Sort-Object)
        throw "Family '$Family' has no subscription serving environment '$Environment' (family members serve: $($servedEnvironments -join ', '))"
    }
    if ($serving.Count -gt 1) {
        throw "Family '$Family' has more than one subscription serving environment '$Environment' ($(@($serving | Sort-Object) -join ', ')) — within a family every environment is served by exactly one subscription (azure.yml)"
    }
    $serving[0]
}
