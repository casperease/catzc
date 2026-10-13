<#
.SYNOPSIS
    Reports per-layer independence violations
    ([ADR-FLOW-CD-GLOBS#10](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs10)): same-layer globsets that
    select a common
    file on their OWN contribution.
.DESCRIPTION
    Within a layer, no two globsets may match a common file on their OWN membership (GlobSet.OwnMatches —
    the set's own include/exclude program, compose IGNORED). Two that do "contain parts of each other" and
    are not independent. The check is per layer, never across layers: a deployable-unit deliberately
    contains the base it composes, so cross-layer overlap is expected and correct. The 'loose-fileset' layer
    is EXEMPT — its sets are cross-cutting check surfaces (a track's root concern, a scan scope, the
    reserved umbrellas) and overlap by design
    ([ADR-FLOW-CD-GLOBS#7](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs7)).

    Evaluates the declared registry (Get-GlobSet) AND the derived module sets (Get-ModuleGlobSet,
    [ADR-REPO-PROTGLOB#7](/docs/adr/automation/protected-globs.md#rule-adr-repo-protglob7)) against the tracked-file
    universe, and returns one object per violating pair — Layer, A,
    B, SharedCount, Shared (the first few shared paths). The output is empty exactly when every non-loose
    layer is pairwise-disjoint on OWN membership; the module's integrity test asserts empty.
.EXAMPLE
    Test-GlobSetIndependence
.EXAMPLE
    @(Test-GlobSetIndependence).Count -eq 0
#>
function Test-GlobSetIndependence {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param()

    # loose-filesets are cross-cutting and overlap-exempt
    # ([ADR-FLOW-CD-GLOBS#7](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs7)/10); every other layer is
    # checked.
    $exemptLayer = 'loose-fileset'

    $sets = @(Get-GlobSet) + @(Get-ModuleGlobSet)
    $tracked = [string[]] @(Get-TrackedFile)

    # OWN members per set (compose ignored,
    # [ADR-FLOW-CD-GLOBS#10](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs10)), computed once as a set for
    # O(1) intersection.
    $own = @{}
    foreach ($set in $sets) {
        $own[$set.Name] = [System.Collections.Generic.HashSet[string]]::new(
            $set.SelectOwnMembers($tracked), [System.StringComparer]::Ordinal)
    }

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
                if ($shared.Count -gt 0) {
                    [pscustomobject]@{
                        Layer       = $layer.Name
                        A           = $a
                        B           = $b
                        SharedCount = $shared.Count
                        Shared      = @($shared | Select-Object -First 5)
                    }
                }
            }
        }
    }
}
