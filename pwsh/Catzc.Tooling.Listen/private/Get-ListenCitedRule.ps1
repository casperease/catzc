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

    $codes = [System.Collections.Generic.SortedSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($match in [regex]::Matches($Text, '\bADR(?:-[A-Z][A-Z0-9]*){2,}\b')) {
        [void] $codes.Add($match.Value)
    }
    [string[]] @($codes)
}
