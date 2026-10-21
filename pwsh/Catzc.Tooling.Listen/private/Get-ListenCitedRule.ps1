<#
---
catzc:
  immutable:
    with_body_sha: "354a9a20b1d0"
  edges:
    cites:
      - ADR-AUTO
---
#>

function Get-ListenCitedRule {
    <#
    .SYNOPSIS
        Lists the ADR codes a text cites, each once, in ordinal order.
    #>
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyString()]
        [string] $Text
    )

    # Every cited ADR or rule: a domain's own prefix (ADR-AUTO) names no record.
    $adrs = Get-Config -Config drs
    $prefixes = [System.Collections.Generic.HashSet[string]]::new([string[]] @($adrs.Domains.Prefix), [System.StringComparer]::Ordinal)
    $codes = [System.Collections.Generic.SortedSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($match in [regex]::Matches($Text, "\b$($adrs.CodeForm.Cited)\b")) {
        if (-not $prefixes.Contains($match.Value)) {
            [void] $codes.Add($match.Value)
        }
    }
    [string[]] @($codes)
}
