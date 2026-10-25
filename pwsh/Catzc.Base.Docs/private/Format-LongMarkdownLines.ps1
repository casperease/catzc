<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-docs/private/Format-LongMarkdownLines.ps1.md"
  header: "generated"
---
#>

function Format-LongMarkdownLines {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Text,

        [int] $Width = 140
    )

    $skip = '^\s*(\||#|---|\*\*\*|<|```|~~~)'
    $marker = '^\s*(?:[-*+]|\d+\.)\s+'

    $lines = @($Text -split "`n")
    $out = [System.Collections.Generic.List[string]]::new()
    $inFence = $false
    $i = 0
    while ($i -lt $lines.Count) {
        $line = $lines[$i]
        if ($line -match '^\s*(```|~~~)') {
            $inFence = -not $inFence
        }
        if ($inFence -or $line -notmatch '\S' -or $line -match $skip) {
            $out.Add($line)
            $i++
            continue
        }

        $first = ''
        $continuation = ''
        if ($line -match "($marker)") {
            $first = $Matches[1]
            $continuation = ' ' * $first.Length
        }
        elseif ($line -match '^(\s*>\s?)') {
            $first = $Matches[1]
            $continuation = $first
        }
        $isQuote = $first.TrimStart().StartsWith('>')

        $end = $i + 1
        while ($end -lt $lines.Count -and $lines[$end] -match '\S' -and $lines[$end] -notmatch $skip -and $lines[$end] -notmatch $marker -and
            ($lines[$end].TrimStart().StartsWith('>') -eq $isQuote)) {
            $end++
        }
        $block = @($lines[$i..($end - 1)])
        $i = $end

        $tooLong = @($block | Where-Object { $_.Length -gt $Width }).Count -gt 0
        $hardBreak = @($block | Where-Object { $_ -match '(  |\\)$' }).Count -gt 0
        if (-not $tooLong -or $hardBreak) {
            foreach ($row in $block) {
                $out.Add($row)
            }
            continue
        }

        $words = @($block[0].Substring($first.Length).Trim())
        foreach ($row in @($block | Select-Object -Skip 1)) {
            $words += $row.Trim() -replace '^>\s?', ''
        }
        foreach ($row in (Format-MarkdownParagraph -Text ($words -join ' ') -FirstPrefix $first -ContinuationPrefix $continuation -Width $Width)) {
            $out.Add($row)
        }
    }

    $out -join "`n"
}
