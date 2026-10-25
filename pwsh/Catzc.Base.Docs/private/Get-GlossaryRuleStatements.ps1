<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-docs/private/Get-GlossaryRuleStatements.ps1.md"
  header: "generated"
---
#>

function Get-GlossaryRuleStatements {
    [CmdletBinding()]
    [OutputType([System.Collections.Generic.Dictionary[string, string]])]
    param(
        [Parameter(Mandatory)]
        [string] $IndexPath
    )

    $adrRoot = Split-Path $IndexPath -Parent
    $statements = [System.Collections.Generic.Dictionary[string, string]]::new([System.StringComparer]::Ordinal)
    foreach ($adr in (Get-CatsDrsIndex -IndexPath $IndexPath)) {
        foreach ($rule in (Get-CatsDrsRules -DrsPath (Join-Path $adrRoot $adr.Path))) {
            $statements[$rule.Id] = $rule.Statement -replace '`[^`]*`', ''
        }
    }

    , $statements
}
