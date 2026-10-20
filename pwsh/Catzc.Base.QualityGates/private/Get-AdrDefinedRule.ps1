<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Get-AdrDefinedRule.ps1
    folder: private
    name: get-adr-defined-rule
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-AdrDefinedRule.Tests.ps1
    docs: "[Get-AdrDefinedRule.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-AdrDefinedRule.ps1.md)"
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
