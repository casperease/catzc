<#
---
catzc:
  immutable:
    with_body_sha: "54941b3f5ff4"
  edges:
    test: pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1
    docs: "[Test-WorldMap.ps1.md](docs/references/pwsh/catzc-base-maps/Test-WorldMap.ps1.md)"
    cites:
      - ADR-AUTO-TEST-QUALITYGATE
      - ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER
      - ADR-DSGN-TRACK-ONETECHSTACK
      - ADR-DSGN-TRACK-FILELANGUAGE
      - ADR-DSGN-TRACK-LABELSNAMEDEFINEDTERMS
      - ADR-REPO-OUTDIR
---
#>

function Test-WorldMap {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    $map = Get-WorldMap
    $issues = [System.Collections.Generic.List[string]]::new()

    # Stack violations, one issue per cell; StackViolations is in ordinal path order, so the first file is the first.
    $byCell = [ordered]@{}
    foreach ($placement in $map.StackViolations) {
        $key = "$($placement.Track) x $($placement.FileLanguage)"
        if (-not $byCell.Contains($key)) {
            $byCell[$key] = [System.Collections.Generic.List[string]]::new()
        }
        $byCell[$key].Add($placement.Path)
    }
    foreach ($cell in $map.Cells) {
        $key = "$($cell.Track) x $($cell.FileLanguage)"
        if ($byCell.Contains($key)) {
            $paths = $byCell[$key]
            $issues.Add("stack violation: $key holds $($paths.Count) live file(s) outside the track's file languages, e.g. $($paths[0]) (ADR-DSGN-TRACK-ONETECHSTACK)")
        }
    }

    # Undeclared root folders: a file under a root folder that the map places among the root files.
    $outputFolderName = 'out'
    $undeclared = [System.Collections.Generic.SortedDictionary[string, int]]::new([System.StringComparer]::Ordinal)
    foreach ($placement in $map.Placements) {
        $slash = $placement.Path.IndexOf('/')
        if ($placement.Track -cne [Catzc.Base.Maps.WorldMap]::NoTrack -or $slash -lt 1) {
            continue
        }
        $rootFolder = $placement.Path.Substring(0, $slash)
        if ($rootFolder -ceq $outputFolderName) {
            continue
        }
        $undeclared[$rootFolder] = $undeclared.ContainsKey($rootFolder) ? $undeclared[$rootFolder] + 1 : 1
    }
    foreach ($rootFolder in $undeclared.Keys) {
        $issues.Add("undeclared root folder: $rootFolder/ holds $($undeclared[$rootFolder]) tracked file(s) but no track names it (ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER)")
    }

    # Printed labels: each names a glossary term.
    $terms = [string[]] @(foreach ($entry in @(Get-Glossary)) {
            $entry.Concept.term
        })
    $labels = (Get-Config -Config maps).labels
    $labelNames = [string[]] @(foreach ($property in $labels.PSObject.Properties) {
            if (-not $property.Name.StartsWith([Catzc.Base.Maps.MapsLabels]::ValueChainPrefix, [System.StringComparison]::Ordinal)) {
                $property.Name
            }
        })
    [System.Array]::Sort($labelNames, [System.StringComparer]::Ordinal)
    foreach ($name in $labelNames) {
        $text = [string] $labels.$name
        if ($null -eq (Resolve-MapLabelTerm -Label $text -Term $terms)) {
            $issues.Add("unregistered label: maps.yml labels.$name '$text' names no glossary term in its head (ADR-DSGN-TRACK-LABELSNAMEDEFINEDTERMS)")
        }
    }
    $axes = @(
        @{ Term = 'track'; Names = @($map.Tracks | Where-Object { $_ -cne [Catzc.Base.Maps.WorldMap]::NoTrack }); Rule = 'ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER' }
        @{ Term = 'file language'; Names = @($map.FileLanguages | Where-Object { $_ -cne [Catzc.Base.Maps.WorldMap]::NoFileLanguage }); Rule = 'ADR-DSGN-TRACK-FILELANGUAGE' }
    )
    foreach ($axis in $axes) {
        if ($axis.Names.Count -gt 0 -and $terms -cnotcontains $axis.Term) {
            $issues.Add("unregistered label: the names $($axis.Names -join ', ') print as instances of '$($axis.Term)', which the glossary does not hold ($($axis.Rule))")
        }
    }

    $facts = [ordered]@{
        Files           = $map.FileCount
        Tracks          = $map.Tracks.Count - 1
        FileLanguages   = $map.FileLanguages.Count - 1
        StackViolations = $map.StackViolations.Count
        Labels          = $labelNames.Count
    }
    Write-QualityGateReport -Subject world-map -Title Test-WorldMap -Issues $issues.ToArray() -Facts $facts `
        -OutputFolder $OutputFolder -PassThru:$PassThru
}
