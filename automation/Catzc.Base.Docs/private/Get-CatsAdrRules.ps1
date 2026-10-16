<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/private/Get-CatsAdrRules.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.Docs
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: private
    relatives:
      test: automation/Catzc.Base.Docs/tests/Get-CatsAdrRules.Tests.ps1
    adrs:
      - ADR-REPO-VOCAB#1
  config:
    synopsis: Extracts the id, one-line summary, and normative statement of each rule in a single ADR file.
    description: |-
      Reads an ADR markdown file and returns one entry per `### Rule <CODE>:<n>` heading: the rule id, the
      first non-empty line of its body (Summary, the one-liner Show-Cats lists), and the whole first paragraph
      of its body joined into one line (Statement). The blank-line-padding authoring convention
      ([index](/docs/adr/index.md))
      makes that paragraph the rule's normative summary, ending at the blank line before its linked bullets, so
      Statement never includes them. The glossary checks read Statement: a term bolded on a wrapped line still
      belongs to the rule ([ADR-REPO-VOCAB#1](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab1)).

      Private helper for Show-Cats and the glossary checks; not exported.
    parameters:
      AdrPath: Absolute path to the ADR markdown file.
    outputs: '[object[]] One { Id; Summary; Statement } per rule heading, in document order.'
---
#>

function Get-CatsAdrRules {
    [OutputType([object[]])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $AdrPath
    )

    Assert-PathExist $AdrPath

    $lines = [System.IO.File]::ReadAllLines($AdrPath)
    $ret = for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -notmatch '^###\s+Rule\s+(?<id>ADR-[A-Z]+(?:-[A-Z]+)*:\d+)\s*$') {
            continue
        }
        $ruleId = $Matches['id']

        # The first paragraph: skip the padding blank lines, then read until the next blank line or heading.
        $paragraph = [System.Collections.Generic.List[string]]::new()
        for ($j = $i + 1; $j -lt $lines.Count; $j++) {
            $candidate = $lines[$j].Trim()
            if ($candidate -eq '') {
                if ($paragraph.Count -gt 0) {
                    break
                }
                continue
            }
            if ($candidate.StartsWith('#')) {
                break
            }
            $paragraph.Add($candidate)
        }

        $summary = ''
        if ($paragraph.Count -gt 0) {
            $summary = $paragraph[0]
        }

        [pscustomobject]@{
            Id        = $ruleId
            Summary   = $summary
            Statement = $paragraph -join ' '
        }
    }

    @($ret)
}
