<#
.SYNOPSIS
    Reports per-layer independence violations (ADR-GLOBS:10): same-layer globsets that select a common
    file on their OWN contribution.
.DESCRIPTION
    Within a layer, no two globsets may match a common file on their OWN membership (GlobSet.OwnMatches —
    the set's own include/exclude program, compose IGNORED). Two that do "contain parts of each other" and
    are not independent. The check is per layer, never across layers: a deployable-unit deliberately
    contains the base it composes, so cross-layer overlap is expected and correct. The 'loose-fileset' layer
    is EXEMPT — its sets are cross-cutting check surfaces (a track's root concern, a scan scope, the
    reserved umbrellas) and overlap by design (ADR-GLOBS:7).

    Evaluates the declared registry (Get-GlobSet) AND the derived module sets (Get-ModuleGlobSet,
    ADR-PROTGLOB:7) against the tracked-file universe, and returns one object per violating pair — Layer, A,
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

    # loose-filesets are cross-cutting and overlap-exempt (ADR-GLOBS:7/10); every other layer is checked.
    $exemptLayer = 'loose-fileset'

    $sets = @(Get-GlobSet) + @(Get-ModuleGlobSet)
    $tracked = @(Get-TrackedFile)

    # OWN members per set (compose ignored, ADR-GLOBS:10), computed once as a set for O(1) intersection.
    $own = @{}
    foreach ($set in $sets) {
        $members = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
        foreach ($path in $tracked) {
            if ($set.OwnMatches($path)) {
                [void]$members.Add($path)
            }
        }
        $own[$set.Name] = $members
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
