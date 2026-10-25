<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-DrsDefinedRule.ps1.md"
  warning: "Generated Header"
---
#>

function Get-DrsDefinedRule {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $Text
    )

    $rules = [System.Collections.Generic.List[string]]::new()
    $ruleHeading = "(?m)^###[ \t]+Rule[ \t]+(?<code>$((Get-Config -Config drs).CodeForm.Rule))[ \t]*\r?$"
    foreach ($match in [regex]::Matches($Text, $ruleHeading)) {
        $citation = $match.Groups['code'].Value
        if (-not $rules.Contains($citation)) {
            $rules.Add($citation)
        }
    }
    [string[]] $rules.ToArray()
}
