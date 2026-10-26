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

    $rules = [System.Collections.Generic.List[string]]::new()
    $ruleHeading = "(?m)^###[ \t]+Rule[ \t]+(?<code>$($Form.Rule))[ \t]*\r?$"
    foreach ($match in [regex]::Matches($Text, $ruleHeading)) {
        $citation = $match.Groups['code'].Value
        if (-not $rules.Contains($citation)) {
            $rules.Add($citation)
        }
    }
    [string[]] $rules.ToArray()
}
