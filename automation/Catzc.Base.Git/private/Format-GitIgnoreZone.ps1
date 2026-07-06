<#
.SYNOPSIS
    Renders one gitignore zone — its titled, explained comment block followed by its pattern lines.
.DESCRIPTION
    The per-zone pretty-printer behind New-GitIgnore: a rule line carrying the zone's title, the wrapped
    `why` explanation as comment lines, then each pattern verbatim — with any `note` rendered as a trailing
    comment aligned across the zone's noted lines. Pure formatting; the pattern text is never rewritten.
.PARAMETER Title
    The zone's heading.
.PARAMETER Why
    The zone's explanation (wrapped to the comment width).
.PARAMETER Pattern
    The zone's resolved pattern entries ({ pattern; note } objects, in order).
.OUTPUTS
    [string[]] The zone's rendered lines (no trailing blank — the caller owns zone separation).
#>
function Format-GitIgnoreZone {
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $Title,

        [Parameter(Mandatory)]
        [string] $Why,

        [AllowEmptyCollection()]
        [object[]] $Pattern = @()
    )

    $width = 118

    # Rule line: '# ── Title ─────…' padded to the comment width.
    $lead = "# $([char]0x2500)$([char]0x2500) $Title "
    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add($lead + ([string][char]0x2500) * [Math]::Max(3, $width - $lead.Length))

    # The why, wrapped word-by-word into '# ' comment lines.
    $current = '#'
    foreach ($word in ($Why -split '\s+' | Where-Object { $_ })) {
        if (($current.Length + 1 + $word.Length) -gt $width -and $current -ne '#') {
            $lines.Add($current)
            $current = '#'
        }
        $current += " $word"
    }
    if ($current -ne '#') {
        $lines.Add($current)
    }

    # Patterns, with notes aligned two spaces past the zone's longest noted pattern.
    $notedLengths = @(foreach ($entry in $Pattern) {
            if ($entry.note) {
                $entry.pattern.Length
            }
        })
    $noteColumn = if ($notedLengths.Count -gt 0) {
        ($notedLengths | Measure-Object -Maximum).Maximum + 2
    }
    else {
        0
    }
    foreach ($entry in $Pattern) {
        if ($entry.note) {
            $lines.Add($entry.pattern.PadRight($noteColumn) + "# $($entry.note)")
        }
        else {
            $lines.Add($entry.pattern)
        }
    }

    [string[]] $lines
}
