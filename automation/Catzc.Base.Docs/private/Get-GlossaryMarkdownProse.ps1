<#
.SYNOPSIS
    Returns the prose of one markdown file as the `markdown` surface of the avoided-phrasing gate (G4).
.DESCRIPTION
    Reads the file whole and returns it as one segment starting at line 1, with fenced code blocks (``` or ~~~)
    blanked and mentions blanked (Remove-GlossaryMentions), so code and quoted phrases never match and a match's
    offset still maps to its line
    ([ADR-REPO-VOCAB#5](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab5)).

    Private helper for the glossary gates; not exported.
.PARAMETER Path
    Absolute path to the markdown file.
.OUTPUTS
    [pscustomobject] One { Surface = 'markdown'; Line = 1; Text }.
.EXAMPLE
    Get-GlossaryMarkdownProse (Resolve-RepoPath 'docs/adr/index.md')
#>
function Get-GlossaryMarkdownProse {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path
    )

    $lines = [System.IO.File]::ReadAllLines($Path)
    $fence = $null
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $marker = [regex]::Match($lines[$i].TrimStart(), '^(`{3,}|~{3,})')
        if ($null -eq $fence) {
            if ($marker.Success) {
                $fence = $marker.Value
                $lines[$i] = ''
            }
            continue
        }
        # Inside a fence: blank the line; a marker of the same kind and at least the opening length closes it.
        if ($marker.Success -and $marker.Value.StartsWith($fence)) {
            $fence = $null
        }
        $lines[$i] = ''
    }

    [pscustomobject]@{
        Surface = 'markdown'
        Line    = 1
        Text    = Remove-GlossaryMentions ($lines -join "`n")
    }
}
