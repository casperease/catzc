<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1
    kind: function
    module: Catzc.Base.Globs
    visibility: public
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-FLOW-CD-GLOBS#10
      - ADR-FLOW-CD-GLOBS#7
      - ADR-REPO-PROTGLOB#7
---
#>

<#
.SYNOPSIS
    Quality gate: checks per-layer independence — no two same-layer
    globsets select a common file on their OWN contribution.
.DESCRIPTION
    Layers are checked one by one, never across: a unit contains the base it composes, so that overlap is expected.
.PARAMETER OutputFolder
    The report base folder. Defaults to Write-QualityGateReport's (out/test-globset-independence).
.PARAMETER PassThru
    Return the gate result { Subject; IssueCount; Issues; ReportPath; GlobSets; Files } instead of throwing.
.OUTPUTS
    [pscustomobject] With -PassThru only.
.EXAMPLE
    Test-GlobSetIndependence
.EXAMPLE
    (Test-GlobSetIndependence -PassThru).Issues
#>
function Test-GlobSetIndependence {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    # Loose-filesets cut across other boundaries and overlap by design, so only they are exempt.
    # [comment:2](/docs/references/automation/catzc-base-globs/Test-GlobSetIndependence.ps1.md#comment2)
    $exemptLayer = 'loose-fileset'

    $sets = @(Get-GlobSet) + @(Get-ModuleGlobSet)
    $tracked = [string[]] @(Get-TrackedFile)

    # Compose is ignored here: a set that selects its base's files is a deliberate overlap, not a peer one.
    # [comment:3](/docs/references/automation/catzc-base-globs/Test-GlobSetIndependence.ps1.md#comment3)
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
                $issues.Add("$($layer.Name): $a <-> $b share $($shared.Count) file(s), e.g. $sample (ADR-FLOW-CD-GLOBS#10)")
            }
        }
    }

    Write-QualityGateReport -Subject globset-independence -Title Test-GlobSetIndependence -Issues $issues.ToArray() `
        -Facts ([ordered]@{ GlobSets = $sets.Count; Files = $tracked.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
