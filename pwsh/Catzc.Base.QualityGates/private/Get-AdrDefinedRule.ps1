<#
---
catzc:
  immutable:
    with_body_sha: "2cd966acd487"
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
    foreach ($match in [regex]::Matches($Text, '(?m)^###[ \t]+Rule[ \t]+(?<code>ADR(?:-[A-Z][A-Z0-9]*){3,})[ \t]*\r?$')) {
        $citation = $match.Groups['code'].Value
        if (-not $rules.Contains($citation)) {
            $rules.Add($citation)
        }
    }
    [string[]] $rules.ToArray()
}
