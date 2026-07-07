<#
.SYNOPSIS
    The globsets a diff touches — the computed area-of-control of a change (ADR-GLOBS:1).
.DESCRIPTION
    Reflects a change into the globset registry: returns every declared globset whose scan program
    (GlobSet.Matches, last-match-wins ADR-GLOBS:4) selects at least one changed path. The "which areas of
    control did this change touch" fact, computed from git at the real refs — reading the merged tree as it
    actually is, so it is immune to the squash-merge and concurrent-merge staleness a per-set hash frozen on a
    branch would suffer, and correct across renames (Get-ChangedFile splits a rename into both of its paths).

    The changed paths come either explicitly (-ChangedFile, a pure and testable call) or from a git range
    (-Range) resolved through Get-ChangedFile. -IncludeModules also matches the derived per-module sets
    (Get-ModuleGlobSet), so a report can name the changed modules, not only the declared units.

    In a pipeline this is the "is there anything here for us to process?" gate: a deployable unit's stage asks
    whether its own set is in the returned list and stops early when it is not. The reference commit that
    range is measured from is the resolver's job, never this function's.
.PARAMETER ChangedFile
    The changed repo-relative, '/'-separated paths to reflect (e.g. a diff's file list). May be empty.
.PARAMETER Range
    A git diff range to resolve the changed paths from, e.g. 'HEAD^1..HEAD'.
.PARAMETER IncludeModules
    Also match the derived module globsets, not only the declared registry.
.OUTPUTS
    [Catzc.Base.Globs.GlobSet] Each touched set — declared sets in registry order, then, with
    -IncludeModules, the touched derived module sets.
.EXAMPLE
    Get-ChangedGlobSet -Range 'HEAD^1..HEAD'
.EXAMPLE
    Get-ChangedGlobSet -ChangedFile @('infrastructure/modules/network/main.bicep')
#>
function Get-ChangedGlobSet {
    [CmdletBinding(DefaultParameterSetName = 'ByRange')]
    [OutputType([Catzc.Base.Globs.GlobSet])]
    param(
        [Parameter(Mandatory, ParameterSetName = 'ByFile')]
        [AllowEmptyCollection()]
        [string[]] $ChangedFile,

        [Parameter(Mandatory, Position = 0, ParameterSetName = 'ByRange')]
        [string] $Range,

        [switch] $IncludeModules
    )

    $changed = if ($PSCmdlet.ParameterSetName -eq 'ByRange') {
        [string[]] (Get-ChangedFile -Range $Range)
    }
    else {
        $ChangedFile
    }

    $sets = [System.Collections.Generic.List[Catzc.Base.Globs.GlobSet]]::new()
    foreach ($set in Get-GlobSet) {
        $sets.Add($set)
    }
    if ($IncludeModules) {
        foreach ($set in Get-ModuleGlobSet) {
            $sets.Add($set)
        }
    }

    foreach ($set in $sets) {
        foreach ($path in $changed) {
            if ($set.Matches($path)) {
                $set
                break
            }
        }
    }
}
