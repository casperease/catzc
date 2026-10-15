<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Git/private/Format-GitIgnoreSection.ps1
    kind: function
    module: Catzc.Base.Git
    visibility: private
---
#>

<#
.SYNOPSIS
    Renders one gitignore section — its titled, explained comment block followed by its pattern lines.
.DESCRIPTION
    A note gets its own line: git has no trailing comments, so a same-line note would become part of the pattern.
    [comment:1](/docs/references/automation/catzc-base-git/private/Format-GitIgnoreSection.ps1.md#comment1)
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
