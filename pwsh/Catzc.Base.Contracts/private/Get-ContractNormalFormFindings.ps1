<#
---
catzc:
  immutable:
    with_body_sha: d64c12efc4a8
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
        if (-not [Catzc.Base.Objects.NameCase]::IsInCase($NormalForm, $name)) {
            "'$name' is not in the repository normal form, $NormalForm (ADR-REPO-CMDCONTRACT-CONTRACTLANGUAGE)"
        }
    }
}
