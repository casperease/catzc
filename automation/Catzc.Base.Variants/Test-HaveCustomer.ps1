<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Variants/Test-HaveCustomer.ps1
    kind: gate-function
    language: powershell
    track: automation
    module: Catzc.Base.Variants
    visibility: public
    relatives:
      test: automation/Catzc.Base.Variants/tests/Test-HaveCustomer.Tests.ps1
  config:
    synopsis: Tests whether one named customer is enabled for the repo (singular cover over Test-HaveCustomers).
    description: |-
      The single-customer form of Test-HaveCustomers, for the common "is this one customer enabled" check.
      A thin cover: Test-HaveCustomers -Name $Name. Returns $true when the `have_customers` variant is 'all'
      or includes the name.
    parameters:
      Name: The customer name to test.
    examples:
      - if (Test-HaveCustomer acme) { ... }
---
#>

function Test-HaveCustomer {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Name
    )

    Test-HaveCustomers -Name $Name
}
