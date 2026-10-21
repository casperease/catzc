<#
---
catzc:
  immutable:
    with_body_sha: "91455c777776"
  edges:
    docs: "[Get-ContractNormalFormFindings.ps1.md](docs/references/pwsh/catzc-base-contracts/private/Get-ContractNormalFormFindings.ps1.md)"
    cites:
      - ADR-REPO-CMDCONTRACT-CONTRACTLANGUAGE
---
#>

function Get-ContractNormalFormFindings {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [Catzc.Base.Contracts.ContractCommand] $Contract,

        [string] $NormalForm = (Get-Config -Config languages).naming_normal_form
    )

    foreach ($name in $Contract.Names) {
        if (-not [Catzc.Base.Objects.NameCase]::IsNormal($name, $NormalForm)) {
            "'$name' is not in the repository normal form, $NormalForm (ADR-REPO-CMDCONTRACT-CONTRACTLANGUAGE)"
        }
    }
}
