<#
.SYNOPSIS
    Quality gate: checks per-layer independence
    ([ADR-FLOW-CD-GLOBS#10](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs10)) — no two same-layer
    globsets select a common file on their OWN contribution.
.DESCRIPTION
    Within a layer, no two globsets may match a common file on their OWN membership (GlobSet.OwnMatches — the set's...
    [ADR-FLOW-CD-GLOBS#7](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs7),
    [ADR-REPO-PROTGLOB#7](/docs/adr/repository/protected-globs.md#rule-adr-repo-protglob7),
    [ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)
    [comment:1](/docs/references/automation/catzc-base-globs/Test-GlobSetIndependence.ps1.md#comment1)
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

    # loose-filesets are cross-cutting and overlap-exempt (/10); every other layer is checked.
    # [ADR-FLOW-CD-GLOBS#7](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs7)
    # [comment:2](/docs/references/automation/catzc-base-globs/Test-GlobSetIndependence.ps1.md#comment2)
    $exemptLayer = 'loose-fileset'

    $sets = @(Get-GlobSet) + @(Get-ModuleGlobSet)
    $tracked = [string[]] @(Get-TrackedFile)

    # OWN members per set (compose ignored, ), computed once as a set for O(1) intersection.
    # [ADR-FLOW-CD-GLOBS#10](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs10)
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
