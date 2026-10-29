function Get-BicepCustomerClassViolations {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [AllowEmptyString()]
        [string] $Customer,

        [Parameter(Mandatory)] [string] $Location
    )

    $violations = @()

    if ([string]::IsNullOrEmpty($Customer)) {
        return $violations
    }

    if (-not (Test-HaveCustomers)) {
        $violations += "$Location deploys for customer '$Customer', but customer deployments are disabled — set have_customers in variants.yml (all, or a list of customer names)"
        return $violations
    }

    if (-not (Test-HaveCustomer -Name $Customer)) {
        $violations += "$Location deploys for customer '$Customer', which is not enabled by have_customers in variants.yml"
    }

    $violations
}
