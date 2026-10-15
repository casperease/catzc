<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Maps/Test-ValueChainMap.ps1
    kind: gate-function
    module: Catzc.Base.Maps
    visibility: public
    adrs:
      - ADR-AUTO-ONEJOB
      - ADR-AUTO-TEST#35
      - ADR-DSGN-TRACK#14
      - ADR-DSGN-TRACK#15
      - ADR-DSGN-TRACK#16
---
#>

<#
.SYNOPSIS
    Quality gate: every ADR sits in a cell of the value-chain map, and every label the value-chain map prints is a
    glossary term.
.DESCRIPTION
    Separate from Test-WorldMap: this map reads adrs.yml alone, the world map reads the git index.
.PARAMETER OutputFolder
    The report base folder. Defaults to out/test-value-chain-map/ (Write-QualityGateReport).
.PARAMETER PassThru
    NonEmptyCells counts cells holding at least one ADR; Labels counts the printed labels checked.
.OUTPUTS
    [pscustomobject] With -PassThru only.
.EXAMPLE
    Test-ValueChainMap
.EXAMPLE
    (Test-ValueChainMap -PassThru).Issues
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
