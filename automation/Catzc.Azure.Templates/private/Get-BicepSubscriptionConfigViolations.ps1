<#
.SYNOPSIS
    Returns the subscription-resolution violations for a single config — the shared rule used by both
    Get-BicepTemplates (fail-fast at discovery) and Assert-BicepTemplate (collect-all), so the two never
    drift. Parallels Get-BicepConfigClassViolations. See
    [ADR-AZ-DATAMOD#8](/docs/adr/azure/azure-data-model.md#rule-adr-az-datamod8).
.DESCRIPTION
    The caller prepends the template identifier, and an empty result means the config conforms.
    [comment:1](/docs/references/automation/catzc-azure-templates/private/Get-BicepSubscriptionConfigViolations.ps1.md#comment1)
.PARAMETER Customer
    The configuration subfolder name, or '' for a configuration-root config.
.PARAMETER Environment
    The config's resolved environment name.
.PARAMETER AzureConfig
    The loaded azure config (Get-Config -Config azure) — used to read subscriptions.
.PARAMETER Location
    A human-readable label for the config (e.g. 'configuration/acme/alpha.yml') used in messages.
#>
function Get-BicepSubscriptionConfigViolations {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [AllowEmptyString()]
        [string] $Customer,

        [Parameter(Mandatory)] [string] $Environment,
        [Parameter(Mandatory)] $AzureConfig,
        [Parameter(Mandatory)] [string] $Location
    )

    $violations = @()

    if (-not [string]::IsNullOrEmpty($Customer)) {
        $customerKeys = Get-AzureCustomers
        if ($Customer -cnotin $customerKeys) {
            $violations += "$Location is under configuration/$Customer/ but '$Customer' is not a customer key in customer.yml — a configuration subfolder is always a customer key (valid: $(@($customerKeys | Sort-Object) -join ', '))"
            # Without a valid customer there is nothing more to resolve against.
            return $violations
        }
    }

    $candidates = Get-BicepConfigSubscriptionCandidates -Customer $Customer -Environment $Environment -AzureConfig $AzureConfig
    if ($candidates.Count -eq 0) {
        $scope = if ([string]::IsNullOrEmpty($Customer)) {
            "no non-customer subscription serves environment '$Environment'"
        }
        else {
            "customer '$Customer' has no subscription serving environment '$Environment'"
        }
        $violations += "$Location cannot be resolved: $scope (azure.yml)"
    }
    elseif ($candidates.Count -gt 1) {
        $violations += "$Location resolves to more than one subscription ($(@($candidates | Sort-Object) -join ', ')) — every config must resolve to exactly one subscription id (azure.yml)"
    }

    $violations
}
