<#
.SYNOPSIS
    Asserts the repo has customer deployments enabled — for all customers, or for specific names — else throws.
.DESCRIPTION
    The throwing companion to Test-HaveCustomers. With no -Name it requires the repo to be customer-enabled
    at all; with -Name it requires every named customer to be enabled. Throws naming the disabled or
    not-enabled customer(s) and pointing at the `have_customers` variant. Guards a customer-only code path.
.PARAMETER Name
    Zero or more customer names to require. Omit to require the repo-wide capability.
.EXAMPLE
    Assert-HaveCustomers
.EXAMPLE
    Assert-HaveCustomers -Name acme
#>
function Assert-HaveCustomers {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string[]] $Name
    )

    if (-not $PSBoundParameters.ContainsKey('Name')) {
        Assert-True (Test-HaveCustomers) -ErrorText 'Customer deployments are disabled — set have_customers in variants.yml (all, or a list of customer names).'
        return
    }

    $notEnabled = @($Name | Where-Object { -not (Test-HaveCustomers -Name $_) })
    Assert-True ($notEnabled.Count -eq 0) -ErrorText "Customer(s) not enabled for this repo: $($notEnabled -join ', ') — set have_customers in variants.yml (all, or include them in the list)."
}
