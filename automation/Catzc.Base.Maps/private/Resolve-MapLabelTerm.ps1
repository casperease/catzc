<#
.SYNOPSIS
    Returns the glossary term a printed map label names, or nothing when it names none.
.DESCRIPTION
    A label names the concept it prints in its head: the text before its first ':', trimmed ('World map' in 'World...
    [ADR-DSGN-TRACK#13](/docs/adr/design/tracks.md#rule-adr-dsgn-track13),
    [ADR-DSGN-TRACK#16](/docs/adr/design/tracks.md#rule-adr-dsgn-track16)
    [comment:1](/docs/references/automation/catzc-base-maps/private/Resolve-MapLabelTerm.ps1.md#comment1)
.PARAMETER Label
    The printed label.
.PARAMETER Term
    The glossary terms (Get-Glossary), lower-case as the glossary declares them.
.OUTPUTS
    [string] The term the label names; nothing when it names none.
.EXAMPLE
    Resolve-MapLabelTerm -Label 'Root files' -Term (Get-Glossary | ForEach-Object { $_.Concept.term })
#>
function Resolve-MapLabelTerm {
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
