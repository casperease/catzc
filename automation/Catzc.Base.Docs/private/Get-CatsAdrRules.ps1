<#
.SYNOPSIS
    Extracts the id and one-line summary of each rule in a single ADR file, for Show-Cats.
.DESCRIPTION
    Reads an ADR markdown file and returns one entry per `### Rule <CODE>:<n>` heading: the rule id and the
    first non-empty line of its body. The blank-line-padding authoring convention (docs/adr/index.md) makes
    that first line the rule's normative summary.

    Private helper for Show-Cats; not exported.
.PARAMETER AdrPath
    Absolute path to the ADR markdown file.
.OUTPUTS
    [object[]] One { Id; Summary } per rule heading, in document order.
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

        $summary = ''
        for ($j = $i + 1; $j -lt $lines.Count; $j++) {
            $candidate = $lines[$j].Trim()
            if ($candidate -ne '') {
                $summary = $candidate
                break
            }
        }

        [pscustomobject]@{
            Id      = $ruleId
            Summary = $summary
        }
    }

    @($ret)
}
