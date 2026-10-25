<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-MarkdownTitleFinding.ps1.md"
  header: "generated"
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
