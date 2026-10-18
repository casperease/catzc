<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Get-AdrDefinedRule.ps1
    folder: private
    name: get-adr-defined-rule
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.QualityGates/tests/Get-AdrDefinedRule.Tests.ps1
    cites:
      - ADR-REPO-LINK#5
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
    foreach ($match in [regex]::Matches($Text, '(?m)^###[ \t]+Rule[ \t]+(?<code>ADR-[A-Z]+(?:-[A-Z]+)*):(?<rule>\d+)[ \t]*\r?$')) {
        $citation = '{0}#{1}' -f $match.Groups['code'].Value, $match.Groups['rule'].Value
        if (-not $rules.Contains($citation)) {
            $rules.Add($citation)
        }
    }
    [string[]] $rules.ToArray()
}
