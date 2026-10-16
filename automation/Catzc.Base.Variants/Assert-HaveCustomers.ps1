<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Variants/Assert-HaveCustomers.ps1
    kind: function
    subkind: assert
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.Variants
    visibility: public
    relatives:
      test: automation/Catzc.Base.Variants/tests/Assert-HaveCustomers.Tests.ps1
  config:
    synopsis: Asserts the repo has customer deployments enabled — for all customers, or for specific names — else throws.
    description: |-
      The throwing companion to Test-HaveCustomers. With no -Name it requires the repo to be customer-enabled
      at all; with -Name it requires every named customer to be enabled. Throws naming the disabled or
      not-enabled customer(s) and pointing at the `have_customers` variant. Guards a customer-only code path.
    parameters:
      Name: Zero or more customer names to require. Omit to require the repo-wide capability.
    examples:
      - Assert-HaveCustomers
      - Assert-HaveCustomers -Name acme
---
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
