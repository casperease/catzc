<#
---
catzc:
  immutable:
    with_body_sha: "02b6f48f3304"
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-AdrDefinedRule.Tests.ps1
    docs: "[Get-AdrDefinedRule.ps1.md](docs/references/pwsh/catzc-base-quality-gates/private/Get-AdrDefinedRule.ps1.md)"
    cites:
      - ADR-REPO-LINK-ONECITATIONSPELLING
---
#>

function Get-AdrDefinedRule {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $Text
    )

    $rules = [System.Collections.Generic.List[string]]::new()
    $ruleHeading = "(?m)^###[ \t]+Rule[ \t]+(?<code>$((Get-Config -Config adrs).CodeForm.Rule))[ \t]*\r?$"
    foreach ($match in [regex]::Matches($Text, $ruleHeading)) {
        $citation = $match.Groups['code'].Value
        if (-not $rules.Contains($citation)) {
            $rules.Add($citation)
        }
    }
    [string[]] $rules.ToArray()
}
