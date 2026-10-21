<#
---
catzc:
  immutable:
    with_body_sha: e389c0dc8154
  edges:
    test: pwsh/Catzc.Azure.Templates/tests/Get-BicepSubscriptionConfigViolations.Tests.ps1
    docs: "[Get-BicepSubscriptionConfigViolations.ps1.md](../../../docs/references/pwsh/catzc-azure-templates/private/Get-BicepSubscriptionConfigViolations.ps1.md)"
    cites:
      - ADR-AZ-DATAMOD-SCHEMAANDINTEGRITY
---
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
