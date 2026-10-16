<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Group-AdrUsage.ps1
    kind: function
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.QualityGates
    visibility: private
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Group-AdrUsage.Tests.ps1
  config:
    synopsis: Groups ADR usage rows by the rule they cite or by the document that cites them.
    description: |-
      Pure: it takes the rows Get-AdrUsageRow returns and reads nothing else. Grouping by Rule gives one row per code and rule (a null Rule is
      the whole ADR), sorted by code and rule with the whole ADR first, listing the documents that cite it. Grouping by Document gives one row
      per citing file, sorted by path, listing the citations it holds. Count is the number of documents or citations in the list.
    parameters:
      Row: The usage rows, each @{ Path; Code; Rule; Source }.
      By: '`Rule` or `Document`.'
    outputs: |-
      [pscustomobject] one per group, by Rule @{ Code; Rule; Count; Documents }, by Document @{ Path; Count; Citations }, each list sorted without
      duplicates.
---
#>

function Group-AdrUsage {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [pscustomobject[]] $Row,

        [Parameter(Mandatory)]
        [ValidateSet('Rule', 'Document')]
        [string] $By
    )

    if ($By -eq 'Rule') {
        $groups = $Row | Group-Object -Property { "$($_.Code)#$($_.Rule)" }
        $result = foreach ($group in $groups) {
            $first = $group.Group[0]
            $documents = [string[]] @($group.Group.Path | Sort-Object -Unique -CaseSensitive)
            [pscustomobject]@{ Code = $first.Code; Rule = $first.Rule; Count = $documents.Count; Documents = $documents }
        }
        $result | Sort-Object -Property Code, @{ Expression = { if ($null -eq $_.Rule) {
                    -1
                }
                else {
                    $_.Rule
                } }
        }
        return
    }

    $groups = $Row | Group-Object -Property Path
    $result = foreach ($group in $groups) {
        $citations = [string[]] @($group.Group | ForEach-Object { if ($null -eq $_.Rule) {
                    $_.Code
                }
                else {
                    "$($_.Code)#$($_.Rule)"
                } } | Sort-Object -Unique -CaseSensitive)
        [pscustomobject]@{ Path = $group.Name; Count = $citations.Count; Citations = $citations }
    }
    $result | Sort-Object -Property Path
}
