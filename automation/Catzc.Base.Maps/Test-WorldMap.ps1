<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Maps/Test-WorldMap.ps1
    kind: function
    subkind: gate
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.Maps
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: public
    relatives:
      test: automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-DSGN-TRACK#{1,3,6,13}
      - ADR-REPO-OUTDIR
  config:
    synopsis: |-
      Quality gate: every tracked file sits in a declared track and its tech-stack, and every label the world map prints
      is a glossary term.
    description: |-
      A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) over the world
      map that Get-WorldMap returns; it reads the map's placements and never places a file itself. It checks three
      things, and every finding is one issue:

      - Stack violations. A cell that holds a live file whose file language its track does not declare is a second
        tech-stack inside the track ([ADR-DSGN-TRACK#3](/docs/adr/design/tracks.md#rule-adr-dsgn-track3)): one issue
        per cell, with its file count and its first file in ordinal order.
      - Undeclared root folders. A root folder that holds a tracked file names a track, except out/, which holds
        gitignored output ([ADR-DSGN-TRACK#1](/docs/adr/design/tracks.md#rule-adr-dsgn-track1),
        [ADR-REPO-OUTDIR](/docs/adr/repository/dedicated-output-directory.md)). The map places the files of any other
        root folder no track names among the root files: one issue per such folder, with its file count.
      - Printed labels. Every label the world map prints names a defined term
        ([ADR-DSGN-TRACK#13](/docs/adr/design/tracks.md#rule-adr-dsgn-track13)): each world-map label of
        maps.yml (Get-Config -Config maps; the value_chain_ labels are Test-ValueChainMap's) names a glossary term
        (Get-Glossary) in its head, the text before its first ':' (Resolve-MapLabelTerm). A row prints a track's
        name and a column a file language's name, so the names resolve through their axis's term: the glossary holds
        'track'
        ([ADR-DSGN-TRACK#1](/docs/adr/design/tracks.md#rule-adr-dsgn-track1)) and 'file language'
        ([ADR-DSGN-TRACK#6](/docs/adr/design/tracks.md#rule-adr-dsgn-track6)). The two catch-all lines print their
        labels, root_files and unlisted_files, which the maps.yml check covers.

      It ends through Write-QualityGateReport: the report goes to out/test-world-map/, every issue is printed, and the
      quality gate throws once listing them all; -PassThru returns the result instead.
    parameters:
      OutputFolder: The report base folder. Defaults to out/test-world-map/ (Write-QualityGateReport).
      PassThru: |-
        Return the result ({ Subject; IssueCount; Issues; ReportPath; Files; Tracks; FileLanguages; StackViolations;
        Labels }) instead of throwing on issues. StackViolations counts the files that break their track's tech-stack,
        and Labels the printed labels checked.
    outputs: '[pscustomobject] With -PassThru only.'
    examples:
      - Test-WorldMap
      - (Test-WorldMap -PassThru).Issues
---
#>

function Test-WorldMap {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
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
            $issues.Add("stack violation: $key holds $($paths.Count) live file(s) outside the track's file languages, e.g. $($paths[0]) (ADR-DSGN-TRACK#3)")
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
        $issues.Add("undeclared root folder: $rootFolder/ holds $($undeclared[$rootFolder]) tracked file(s) but no track names it (ADR-DSGN-TRACK#1)")
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
            $issues.Add("unregistered label: maps.yml labels.$name '$text' names no glossary term in its head (ADR-DSGN-TRACK#13)")
        }
    }
    $axes = @(
        @{ Term = 'track'; Names = @($map.Tracks | Where-Object { $_ -cne [Catzc.Base.Maps.WorldMap]::NoTrack }); Rule = 'ADR-DSGN-TRACK#1' }
        @{ Term = 'file language'; Names = @($map.FileLanguages | Where-Object { $_ -cne [Catzc.Base.Maps.WorldMap]::NoFileLanguage }); Rule = 'ADR-DSGN-TRACK#6' }
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
