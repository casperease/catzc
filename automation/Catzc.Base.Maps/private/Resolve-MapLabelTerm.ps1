<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Maps/private/Resolve-MapLabelTerm.ps1
    kind: automation-function
    language: powershell
    track: automation
    module: Catzc.Base.Maps
    visibility: private
    relatives:
      test: automation/Catzc.Base.Maps/tests/Resolve-MapLabelTerm.Tests.ps1
    adrs:
      - ADR-DSGN-TRACK#{13,16}
  config:
    synopsis: Returns the glossary term a printed map label names, or nothing when it names none.
    description: |-
      A label names the concept it prints in its head: the text before its first ':', trimmed ('World map' in
      'World map: repository tree'), or the whole label when it has no ':'. The head resolves when, compared without
      case, it is a term of -Term or that term's plural (the term followed by 's' or 'es': 'Root files' names the term
      'root file'). Every label the world map or the value-chain map prints names a defined term in its head
      ([ADR-DSGN-TRACK#13](/docs/adr/design/tracks.md#rule-adr-dsgn-track13),
      [ADR-DSGN-TRACK#16](/docs/adr/design/tracks.md#rule-adr-dsgn-track16)), so Test-WorldMap and Test-ValueChainMap
      report a label this returns nothing for.
    parameters:
      Label: The printed label.
      Term: The glossary terms (Get-Glossary), lower-case as the glossary declares them.
    outputs: '[string] The term the label names; nothing when it names none.'
    examples:
      - Resolve-MapLabelTerm -Label 'Root files' -Term (Get-Glossary | ForEach-Object { $_.Concept.term })
---
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
