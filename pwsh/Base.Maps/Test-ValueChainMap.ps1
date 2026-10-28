function Test-ValueChainMap {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    $map = Get-ValueChainMap
    $issues = [System.Collections.Generic.List[string]]::new()

    # The rows and the columns: the closed sets of the registry type, in order.
    $axes = @(
        @{ Name = 'rows'; Printed = @($map.Stacks); Declared = @([Catzc.Base.Drs.DrsConfig]::Stacks); What = 'the rows of the value-chain stack'; Rule = 'ADR-REPO-VALUECHAIN-STACK' }
        @{ Name = 'columns'; Printed = @($map.Concerns); Declared = @([Catzc.Base.Drs.DrsConfig]::Concerns); What = 'the value-chain concerns'; Rule = 'ADR-REPO-VALUECHAIN-CONCERN' }
    )
    foreach ($axis in $axes) {
        if (($axis.Printed -join ', ') -cne ($axis.Declared -join ', ')) {
            $issues.Add("axis: the map prints the $($axis.Name) $($axis.Printed -join ', '), but $($axis.What) are $($axis.Declared -join ', '), in that order ($($axis.Rule))")
        }
    }

    # The records: each sits in a cell, and declares only rows and value-chain concerns the map prints.
    foreach ($stray in $map.Strays) {
        $issues.Add("stray value: $stray (ADR-REPO-VALUECHAIN-CONCERN)")
    }
    foreach ($record in $map.Unplaced) {
        $issues.Add("unplaced record: $record sits in no cell of the value-chain map (ADR-REPO-VALUECHAIN-CONCERN)")
    }

    # Printed labels: each value_chain_ label names a glossary term.
    $terms = [string[]] @(foreach ($entry in @(Get-Glossary)) {
            $entry.Concept.term
        })
    $labels = (Get-Config -Config maps).labels
    $labelNames = [string[]] @(foreach ($property in $labels.PSObject.Properties) {
            if ($property.Name.StartsWith([Catzc.Base.Maps.MapsLabels]::ValueChainPrefix,
                    [System.StringComparison]::Ordinal)) {
                $property.Name
            }
        })
    [System.Array]::Sort($labelNames, [System.StringComparer]::Ordinal)
    foreach ($name in $labelNames) {
        $text = [string] $labels.$name
        if ($null -eq (Resolve-MapLabelTerm -Label $text -Term $terms)) {
            $issues.Add("unregistered label: maps.yml labels.$name '$text' names no glossary term in its head (ADR-REPO-VALUECHAIN-MAP)")
        }
    }

    $nonEmptyCells = 0
    foreach ($cell in $map.Cells) {
        if ($cell.RecordCount -gt 0) {
            $nonEmptyCells++
        }
    }
    $facts = [ordered]@{
        Records       = $map.RecordCount
        Rows          = $map.Stacks.Count
        Columns       = $map.Concerns.Count
        NonEmptyCells = $nonEmptyCells
        Labels        = $labelNames.Count
    }
    Write-QualityGateReport -Subject value-chain-map -Title Test-ValueChainMap -Issues $issues.ToArray() -Facts $facts `
        -OutputFolder $OutputFolder -PassThru:$PassThru
}
