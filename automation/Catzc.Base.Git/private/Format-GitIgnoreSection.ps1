<#
.SYNOPSIS
    Renders one gitignore section — its titled, explained comment block followed by its pattern lines.
.DESCRIPTION
    The per-section pretty-printer behind New-GitIgnore: a rule line carrying the section's title, the wrapped
    `why` explanation as comment lines, then each pattern verbatim — with any `note` rendered as its own comment
    line directly above its pattern. git has no trailing comments: a '#' after a pattern becomes part of the
    pattern, so a noted pattern written on one line would match nothing. Pure formatting; the pattern text is never
    rewritten.
.PARAMETER Title
    The section's heading.
.PARAMETER Why
    The section's explanation (wrapped to the comment width).
.PARAMETER Pattern
    The section's resolved pattern entries ({ pattern; note } objects, in order).
.OUTPUTS
    [string[]] The section's rendered lines (no trailing blank — the caller owns section separation).
#>
function Format-GitIgnoreSection {
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

    # Patterns, each note on its own comment line above its pattern.
    foreach ($entry in $Pattern) {
        if ($entry.note) {
            $lines.Add("# $($entry.note)")
        }
        $lines.Add($entry.pattern)
    }

    [string[]] $lines
}
