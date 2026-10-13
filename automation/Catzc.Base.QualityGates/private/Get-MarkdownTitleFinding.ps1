<#
.SYNOPSIS
    Checks one Markdown file's title against its repository path and returns the fixed text.
.DESCRIPTION
    The title is the first non-blank line after an optional YAML front-matter block; it must be the H1
    `# <repository-relative path>`. Only that line is read as the title, so a `#` line in a later fenced code block
    never counts. Kind is Ok, Wrong (an H1 with other text — the line is replaced), or Missing (the first line is not
    an H1 — the title and a blank line are inserted before it). Fixed is the corrected file text, keeping the file's
    own line endings; it equals the input when Kind is Ok.
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
        $lines[$titleIndex] = $expected
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
