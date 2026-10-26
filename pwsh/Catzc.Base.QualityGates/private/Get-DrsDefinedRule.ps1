<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-DrsDefinedRule.ps1.md"
  header: "generated"
---
#>

function Get-DrsDefinedRule {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $Text,

        # The drs code form, which a caller over many texts resolves once and passes in.
        $Form = (Get-Config -Config drs).CodeForm
    )

    [string[]] [Catzc.Base.Drs.DrsCitationScanner]::new($Form, $null).DefinedRules($Text)
}
