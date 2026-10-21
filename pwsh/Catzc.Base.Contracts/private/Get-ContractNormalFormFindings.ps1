<#
---
catzc:
  immutable:
    with_body_sha: "0a8796e76679"
  edges:
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
        if (-not [Catzc.Base.Languages.LanguageNaming]::IsInCase($NormalForm, $name)) {
            "'$name' is not in the repository normal form, $NormalForm (ADR-REPO-CMDCONTRACT-CONTRACTLANGUAGE)"
        }
    }
}
