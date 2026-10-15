<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-MarkdownTitleFinding.ps1
    kind: automation-function
    module: Catzc.Base.QualityGates
    visibility: private
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/private/Get-MarkdownTitleFinding.ps1.md
      test: automation/Catzc.Base.QualityGates/tests/Get-MarkdownTitleFinding.Tests.ps1
  config:
    synopsis: Checks one Markdown file's title and returns the fixed text.
    description: |-
      The title is the first non-blank line after an optional YAML front-matter block; it must be an H1 that is not the
      file's own repository path (the path is a derived meta fact, never the title). Only that line is read as the title,
      so a `#` line in a later fenced code block never counts. Kind is Ok (an H1 that is a title), PathTitle (the H1 is
      the path and one code-span line follows), Untitled (the H1 is the path and nothing titles it), or Missing (the first
      line is not an H1). A PathTitle is repaired: the H1 takes the code-span line's text without its backticks and the
      line goes, so no authored wording is lost. Untitled and Missing have no repair, since nothing can invent a title: a
      person writes it. Fixed is the corrected file text, keeping the file's own line endings; it equals the input for every
      Kind but PathTitle.
    parameters:
      RelativePath: The file's repository-relative, '/'-separated path — the H1 that is no title.
      Text: The file's content.
    outputs: '[pscustomobject] @{ Path; Line; Kind; Actual; Expected; Fixed }'
---
#>

function Get-MarkdownTitleFinding {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $RelativePath,

        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $Text
    )

    $pathTitle = "# $RelativePath"
    $newline = if ($Text.Contains("`r`n")) {
        "`r`n"
    }
    else {
        "`n"
    }
    $lines = [System.Collections.Generic.List[string]]::new([string[]] ($Text -split '\r?\n'))

    # Skip a YAML front-matter block: a first line of '---' up to the next '---'.
    $start = 0
    if ($lines.Count -gt 1 -and $lines[0] -eq '---') {
        for ($index = 1; $index -lt $lines.Count; $index++) {
            if ($lines[$index] -eq '---') {
                $start = $index + 1
                break
            }
        }
    }

    $titleIndex = $start
    while ($titleIndex -lt $lines.Count -and $lines[$titleIndex].Trim() -eq '') {
        $titleIndex++
    }

    $actual = if ($titleIndex -lt $lines.Count) {
        $lines[$titleIndex]
    }
    else {
        ''
    }

    $kind = 'Ok'
    $expected = $actual
    $subtitleIndex = -1
    if ($actual -cnotmatch '^#\s') {
        $kind = 'Missing'
        $expected = 'an H1 that is the file''s title'
    }
    elseif ($actual -ceq $pathTitle) {
        # The old form: the path as the H1 and the real title in one code-span line below it.
        $subtitleIndex = $titleIndex + 1
        while ($subtitleIndex -lt $lines.Count -and $lines[$subtitleIndex].Trim() -eq '') {
            $subtitleIndex++
        }
        if ($subtitleIndex -lt $lines.Count -and $lines[$subtitleIndex] -cmatch '^`([^`]+)`\s*$') {
            $kind = 'PathTitle'
            $expected = "# $($Matches[1].Trim())"
        }
        else {
            $kind = 'Untitled'
            $expected = 'an H1 that is the file''s title, not its path'
        }
    }

    if ($kind -eq 'PathTitle') {
        $lines.RemoveRange($titleIndex, $subtitleIndex - $titleIndex + 1)
        $lines.Insert($titleIndex, $expected)
        $next = $titleIndex + 1
        if ($next -lt $lines.Count -and $lines[$next].Trim() -ne '') {
            $lines.Insert($next, '')
        }
    }

    [pscustomobject]@{
        Path     = $RelativePath
        Line     = $titleIndex + 1
        Kind     = $kind
        Actual   = $actual
        Expected = $expected
        Fixed    = if ($kind -eq 'PathTitle') {
            $lines -join $newline
        }
        else {
            $Text
        }
    }
}
