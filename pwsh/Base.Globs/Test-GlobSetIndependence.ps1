<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-globs/Test-GlobSetIndependence.ps1.md"
  header: "generated"
---
#>

function Test-GlobSetIndependence {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    # Loose filesets cut across layers and may overlap; every other layer is checked.
    $exemptLayer = 'loose-fileset'

    $sets = @(Get-GlobSet) + @(Get-ModuleGlobSet)
    $tracked = [string[]] @(Get-TrackedFile)

    # Each set's own members (compose ignored), as a set once, so every intersection is O(1).
    $own = @{}
    foreach ($set in $sets) {
        $own[$set.Name] = [System.Collections.Generic.HashSet[string]]::new(
            [string[]] @($set.SelectOwnMembers($tracked)), [System.StringComparer]::Ordinal)
    }

    $issues = [System.Collections.Generic.List[string]]::new()
    foreach ($layer in $sets | Group-Object Layer) {
        if ($layer.Name -eq $exemptLayer) {
            continue
        }
        $names = @($layer.Group.Name)
        for ($i = 0; $i -lt $names.Count; $i++) {
            for ($j = $i + 1; $j -lt $names.Count; $j++) {
                $a = $names[$i]
                $b = $names[$j]
                # The common case, a disjoint pair, is decided in one .NET call; only a violation lists its paths.
                if (-not $own[$a].Overlaps($own[$b])) {
                    continue
                }
                $shared = [System.Collections.Generic.List[string]]::new()
                foreach ($path in $own[$a]) {
                    if ($own[$b].Contains($path)) {
                        $shared.Add($path)
                    }
                }
                $sample = @($shared | Select-Object -First 5) -join ', '
                $issues.Add("$($layer.Name): $a <-> $b share $($shared.Count) file(s), e.g. $sample (FDR-CD-GLOBS-NOOVERLAPWITHINLAYER)")
            }
        }
    }

    Write-QualityGateReport -Subject globset-independence -Title Test-GlobSetIndependence -Issues $issues.ToArray() `
        -Facts ([ordered]@{ GlobSets = $sets.Count; Files = $tracked.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
