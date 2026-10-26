<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-slides/private/Get-NameMentionFinding.ps1.md"
  header: "generated"
---
#>

# The lines of a diagram declaration or a slide that name the system by its code name or its conversational name, as a word.
function Get-NameMentionFinding {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $Text,

        # The paths whose mentions are a declared contrast, from slides.yml's name_mentions; each names its reason there.
        [AllowEmptyCollection()]
        [string[]] $Exempt = @()
    )

    if ($Path -in $Exempt) {
        return
    }
    # A name joined into an identifier (Catzc.Base.Git, catzc-track-lamps, catzc_diagrams, Get-CatzcModuleRoot, Catzc/<v>) is no mention.
    $catzc = [regex]::new('(?<![\w./\-])catzc(?![\w./\-])', 'IgnoreCase')
    $cats = [regex]::new('(?<![\w./\-])cats(?![\w./\-])', 'IgnoreCase')
    $lines = $Text -split '\r?\n'
    $start = 0
    # The head is meta, never the picture: a slide's front matter, a declaration's comment block.
    if ($lines.Count -gt 0 -and $lines[0] -ceq '---') {
        for ($i = 1; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -ceq '---') {
                $start = $i + 1
                break
            }
        }
    }
    for ($i = $start; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        if ($line.TrimStart().StartsWith('#') -and -not $Path.EndsWith('.md', [System.StringComparison]::Ordinal)) {
            continue
        }
        $namesCatzc = $catzc.IsMatch($line)
        $namesCats = $cats.IsMatch($line)
        # A line naming both draws the contrast between them.
        if (($namesCatzc -or $namesCats) -and -not ($namesCatzc -and $namesCats)) {
            "${Path}:$($i + 1): names $(if ($namesCatzc) { 'catzc' } else { 'cats' }) in the picture; say what it is, use an identifier, or declare the contrast in slides.yml name_mentions"
        }
    }
}
