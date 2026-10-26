function Get-ListenCitedRule {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyString()]
        [string] $Text
    )

    # Every cited ADR or rule: a domain's own prefix (ADR-AUTO) names no record.
    $adrs = Get-Config -Config drs
    $prefixes = [System.Collections.Generic.HashSet[string]]::new([string[]] @($adrs.Domains.Prefix),
        [System.StringComparer]::Ordinal)
    $codes = [System.Collections.Generic.SortedSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($match in [regex]::Matches($Text, "\b$($adrs.CodeForm.Cited)\b")) {
        if (-not $prefixes.Contains($match.Value)) {
            [void] $codes.Add($match.Value)
        }
    }
    [string[]] @($codes)
}
