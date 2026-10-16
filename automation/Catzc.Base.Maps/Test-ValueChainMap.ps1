<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Maps/Test-ValueChainMap.ps1
    name: test-value-chain-map
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Maps
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1
    cites:
      - ADR-AUTO-ONEJOB
      - ADR-AUTO-TEST#35
      - ADR-DSGN-TRACK#{14-16}
  config:
    synopsis: |-
      Quality gate: every ADR sits in a cell of the value-chain map, and every label the value-chain map prints is a
      glossary term.
    description: |-
      A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) over the
      value-chain map that Get-ValueChainMap returns; it reads the map and never places an ADR itself. It is a sibling of
      Test-WorldMap, not a part of it: a quality gate checks one property, and the value-chain map is read from adrs.yml
      alone, while the world map is read from the git index
      ([ADR-AUTO-ONEJOB](/docs/adr/automation/single-responsibility-functions.md)). It checks four things, and every
      finding is one issue:

      - The rows. The map prints the rows of the value-chain stack, the closed set Catzc.Base.Docs.AdrsConfig Stacks
        declares, in order ([ADR-DSGN-TRACK#14](/docs/adr/design/tracks.md#rule-adr-dsgn-track14)).
      - The columns. The map prints the value-chain concerns, the closed set AdrsConfig Concerns declares, in order
        ([ADR-DSGN-TRACK#15](/docs/adr/design/tracks.md#rule-adr-dsgn-track15)). Row and column names are members of
        those closed sets, so they are checked against them, never against the glossary.
      - The ADRs. Every ADR sits in at least one cell, and every row and value-chain concern it declares is one the
        map prints ([ADR-DSGN-TRACK#15](/docs/adr/design/tracks.md#rule-adr-dsgn-track15)). The adrs.yml load rejects
        an unknown value, so this guards the map's reading of the registry.
      - Printed labels. Each value_chain_ label of maps.yml (Get-Config -Config maps) names a glossary term
        (Get-Glossary) in its head, the text before its first ':' (Resolve-MapLabelTerm,
        [ADR-DSGN-TRACK#16](/docs/adr/design/tracks.md#rule-adr-dsgn-track16)).

      It ends through Write-QualityGateReport: the report goes to out/test-value-chain-map/, every issue is printed, and
      the quality gate throws once listing them all; -PassThru returns the result instead.
    parameters:
      OutputFolder: The report base folder. Defaults to out/test-value-chain-map/ (Write-QualityGateReport).
      PassThru: |-
        Return the result ({ Subject; IssueCount; Issues; ReportPath; Adrs; Rows; Columns; NonEmptyCells; Labels })
        instead of throwing on issues. NonEmptyCells counts the cells that hold at least one ADR, and Labels the printed labels
        checked.
    outputs: '[pscustomobject] With -PassThru only.'
    examples:
      - Test-ValueChainMap
      - (Test-ValueChainMap -PassThru).Issues
---
#>

function Test-ValueChainMap {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    $map = Get-ValueChainMap
    $issues = [System.Collections.Generic.List[string]]::new()

    # The rows and the columns: the closed sets of the registry type, in order.
    $axes = @(
        @{ Name = 'rows'; Printed = @($map.Stacks); Declared = @([Catzc.Base.Docs.AdrsConfig]::Stacks); What = 'the rows of the value-chain stack'; Rule = 'ADR-DSGN-TRACK#14' }
        @{ Name = 'columns'; Printed = @($map.Concerns); Declared = @([Catzc.Base.Docs.AdrsConfig]::Concerns); What = 'the value-chain concerns'; Rule = 'ADR-DSGN-TRACK#15' }
    )
    foreach ($axis in $axes) {
        if (($axis.Printed -join ', ') -cne ($axis.Declared -join ', ')) {
            $issues.Add("axis: the map prints the $($axis.Name) $($axis.Printed -join ', '), but $($axis.What) are $($axis.Declared -join ', '), in that order ($($axis.Rule))")
        }
    }

    # The ADRs: each sits in a cell, and declares only rows and value-chain concerns the map prints.
    foreach ($stray in $map.Strays) {
        $issues.Add("stray value: $stray (ADR-DSGN-TRACK#15)")
    }
    foreach ($adr in $map.Unplaced) {
        $issues.Add("unplaced ADR: $adr sits in no cell of the value-chain map (ADR-DSGN-TRACK#15)")
    }

    # Printed labels: each value_chain_ label names a glossary term.
    $terms = [string[]] @(foreach ($entry in @(Get-Glossary)) {
            $entry.Concept.term
        })
    $labels = (Get-Config -Config maps).labels
    $labelNames = [string[]] @(foreach ($property in $labels.PSObject.Properties) {
            if ($property.Name.StartsWith([Catzc.Base.Maps.MapsLabels]::ValueChainPrefix, [System.StringComparison]::Ordinal)) {
                $property.Name
            }
        })
    [System.Array]::Sort($labelNames, [System.StringComparer]::Ordinal)
    foreach ($name in $labelNames) {
        $text = [string] $labels.$name
        if ($null -eq (Resolve-MapLabelTerm -Label $text -Term $terms)) {
            $issues.Add("unregistered label: maps.yml labels.$name '$text' names no glossary term in its head (ADR-DSGN-TRACK#16)")
        }
    }

    $nonEmptyCells = 0
    foreach ($cell in $map.Cells) {
        if ($cell.AdrCount -gt 0) {
            $nonEmptyCells++
        }
    }
    $facts = [ordered]@{
        Adrs          = $map.AdrCount
        Rows          = $map.Stacks.Count
        Columns       = $map.Concerns.Count
        NonEmptyCells = $nonEmptyCells
        Labels        = $labelNames.Count
    }
    Write-QualityGateReport -Subject value-chain-map -Title Test-ValueChainMap -Issues $issues.ToArray() -Facts $facts `
        -OutputFolder $OutputFolder -PassThru:$PassThru
}
