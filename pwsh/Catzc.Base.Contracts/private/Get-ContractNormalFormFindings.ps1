<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-contracts/private/Get-ContractNormalFormFindings.ps1.md"
  header: "generated"
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
