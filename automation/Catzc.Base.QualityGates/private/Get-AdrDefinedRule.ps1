<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-AdrDefinedRule.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-REPO-LINK#5
---
#>

<#
.SYNOPSIS
    The rules a Markdown text defines in its own rule headings, spelled as citations.
.DESCRIPTION
    The colon form of a rule heading is spelled as the citation `ADR-<CODE>#<n>`, in document order.
.PARAMETER Text
    The Markdown body to read.
.OUTPUTS
    [string[]] one `ADR-<CODE>#<n>` per defined rule, without duplicates.
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
