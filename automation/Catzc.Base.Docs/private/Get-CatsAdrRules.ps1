<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/private/Get-CatsAdrRules.ps1
    kind: function
    module: Catzc.Base.Docs
    visibility: private
---
#>

<#
.SYNOPSIS
    Extracts the id, one-line summary, and normative statement of each rule in a single ADR file.
.DESCRIPTION
    Statement ends at the blank line before the linked bullets, so a term bolded on a wrapped line still counts.
    [ADR-REPO-VOCAB#1](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab1)
    [comment:1](/docs/references/automation/catzc-base-docs/private/Get-CatsAdrRules.ps1.md#comment1)
.PARAMETER AdrPath
    Absolute path to the ADR markdown file.
.OUTPUTS
    [object[]] One { Id; Summary; Statement } per rule heading, in document order.
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
