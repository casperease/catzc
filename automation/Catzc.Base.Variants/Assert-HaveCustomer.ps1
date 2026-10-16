<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Variants/Assert-HaveCustomer.ps1
    name: assert-have-customer
    filetype: ps1
    kind: function
    subkind: assert
    language: powershell
    track: automation
    module: Catzc.Base.Variants
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
    relatives:
      test: automation/Catzc.Base.Variants/tests/Assert-HaveCustomer.Tests.ps1
  config:
    synopsis: Asserts one named customer is enabled for the repo, else throws (singular cover over Assert-HaveCustomers).
    description: |-
      The single-customer form of Assert-HaveCustomers. A thin cover: Assert-HaveCustomers -Name $Name. Throws
      when the named customer is not enabled by the `have_customers` variant.
    parameters:
      Name: The customer name to require.
    examples:
      - Assert-HaveCustomer acme
---
#>

function Assert-HaveCustomer {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Name
    )

    Assert-HaveCustomers -Name $Name
}
