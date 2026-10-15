<#
.SYNOPSIS
    Checks one Markdown file's title against its repository path and returns the fixed text.
.DESCRIPTION
    Only the first non-blank line after front matter is the title, so a hash line in a later code fence never counts.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-MarkdownTitleFinding.ps1.md#comment1)
.PARAMETER RelativePath
    The file's repository-relative, '/'-separated path — the expected title.
.PARAMETER Text
    The file's content.
.OUTPUTS
    [pscustomobject] @{ Path; Line; Kind; Actual; Expected; Fixed }
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

    $expected = "# $RelativePath"
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
    $kind = if ($actual -ceq $expected) {
        'Ok'
    }
    elseif ($actual -match '^#\s') {
        'Wrong'
    }
    else {
        'Missing'
    }

    if ($kind -eq 'Wrong') {
        # The old title sits in one code span so it reads as a title; its own backticks go, as they would split it.
        # [comment:2](/docs/references/automation/catzc-base-qualitygates/private/Get-MarkdownTitleFinding.ps1.md#comment2)
        $oldTitle = ($actual -replace '^#\s+', '' -replace '`', '').TrimEnd()
        $replacement = [System.Collections.Generic.List[string]]::new([string[]] @($expected, '', "``$oldTitle``"))
        $next = $titleIndex + 1
        if ($next -lt $lines.Count -and $lines[$next].Trim() -ne '') {
            $replacement.Add('')
        }
        $lines.RemoveAt($titleIndex)
        $lines.InsertRange($titleIndex, $replacement)
    }
    elseif ($kind -eq 'Missing') {
        if ($titleIndex -ge $lines.Count) {
            # Nothing after the front matter: the title becomes the body, keeping one trailing newline.
            $lines.RemoveRange($start, $lines.Count - $start)
            $lines.AddRange([string[]] @($expected, ''))
        }
        else {
            $lines.InsertRange($titleIndex, [string[]] @($expected, ''))
        }
    }

    [pscustomobject]@{
        Path     = $RelativePath
        Line     = $titleIndex + 1
        Kind     = $kind
        Actual   = $actual
        Expected = $expected
        Fixed    = if ($kind -eq 'Ok') {
            $Text
        }
        else {
            $lines -join $newline
        }
    }
}
