<#
.SYNOPSIS
    Returns the glossary term a printed world-map label names, or nothing when it names none.
.DESCRIPTION
    A label names the concept it prints in its head: the text before its first ':', trimmed ('World map' in
    'World map: repository tree'), or the whole label when it has no ':'. The head resolves when, compared without
    case, it is a term of -Term or that term's plural (the term followed by 's' or 'es': 'Root files' names the term
    'root file'). Every label the world map prints names a defined term in its head
    ([ADR-DSGN-TRACK#13](/docs/adr/design/tracks.md#rule-adr-dsgn-track13)), so Test-WorldMap reports a label this
    returns nothing for.
.PARAMETER Label
    The printed label.
.PARAMETER Term
    The glossary terms (Get-Glossary), lower-case as the glossary declares them.
.OUTPUTS
    [string] The term the label names; nothing when it names none.
.EXAMPLE
    Resolve-WorldMapLabelTerm -Label 'Root files' -Term (Get-Glossary | ForEach-Object { $_.Concept.term })
#>
function Resolve-WorldMapLabelTerm {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $Label,

        [AllowEmptyCollection()]
        [string[]] $Term = @()
    )

    $colon = $Label.IndexOf(':')
    $head = ($colon -lt 0 ? $Label : $Label.Substring(0, $colon)).Trim().ToLowerInvariant()
    if ($head.Length -eq 0) {
        return
    }
    foreach ($candidate in $Term) {
        $lower = $candidate.ToLowerInvariant()
        if ($head -ceq $lower -or $head -ceq "${lower}s" -or $head -ceq "${lower}es") {
            return $candidate
        }
    }
}
