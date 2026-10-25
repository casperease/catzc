function Get-TypeSourceBody {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $Text,

        [Parameter(Mandatory)]
        [string[]] $Block
    )

    # The bcl carrier's head, read the way CodeMetaHead.Parse reads it: the opener, a fence, catzc:, the closing fence, the closer, blank lines.
    $lines = $Text -split "`n"
    if ($lines.Count -lt 5 -or $lines[0].Trim() -cne $Block[0] -or $lines[1].Trim() -cne '---' -or $lines[2].TrimEnd() -cne 'catzc:') {
        return $Text
    }
    $fence = 3
    while ($fence -lt $lines.Count -and $lines[$fence].Trim() -cne '---') {
        $fence++
    }
    if (($fence + 1) -ge $lines.Count -or $lines[$fence + 1].Trim() -cne $Block[1]) {
        return $Text
    }
    $start = $fence + 2
    while ($start -lt $lines.Count -and $lines[$start].Trim().Length -eq 0) {
        $start++
    }
    if ($start -ge $lines.Count) {
        return ''
    }
    $lines[$start..($lines.Count - 1)] -join "`n"
}
