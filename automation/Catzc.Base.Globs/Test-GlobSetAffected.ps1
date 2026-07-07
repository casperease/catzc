<#
.SYNOPSIS
    Whether the current context's change touches a globset — the in-pipeline "is there anything here for us
    to process?" gate.
.DESCRIPTION
    The boolean a deployable unit's pipeline stage checks to stop early ("nothing for us; return") when its
    own area of control is untouched by the change. It reflects the context's diff (Get-GlobSetChangeRange,
    then Get-ChangedGlobSet) and reports whether the named set is among those touched. Because the range is
    resolved from real refs at run time (ADR-GLOBS:1), this gate is immune to the squash-merge and
    concurrent-merge staleness a committed marker hash suffers.

    Fail-open (ADR-PROTGLOB:5): when the reference commit cannot be resolved or the diff cannot be computed —
    a shallow clone that cannot reach the base, an unresolved PR target ref, a first commit with no parent —
    this returns $true, proceed. A redundant run is safe; a wrong skip is an un-deployed change. It returns
    $false ONLY when it has positively confirmed, over a resolvable range, that the set is untouched. An
    undeclared name is a programming error, not a runtime ambiguity, so it throws (fail-fast, ADR-FAILFAST)
    rather than silently reporting "not affected" and skipping.
.PARAMETER Name
    The globset — typically a deployable unit — to test.
.OUTPUTS
    [bool] $true when the set is affected (or the range is indeterminate — fail-open); $false only when the
    set is confirmed untouched.
.EXAMPLE
    if (-not (Test-GlobSetAffected -Name apex)) { return }
#>
function Test-GlobSetAffected {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ (Get-Config -Config globs).Names })]
        [string] $Name
    )

    $config = Get-Config -Config globs
    if (-not $config.Contains($Name)) {
        throw "Test-GlobSetAffected: '$Name' is not a declared globset (globs.yml)."
    }

    $range = Get-GlobSetChangeRange
    if ($null -eq $range) {
        return $true
    }

    try {
        $touched = @(Get-ChangedGlobSet -Range $range)
    }
    catch {
        Write-Message "Test-GlobSetAffected: could not resolve change range '$range' ($($_.Exception.Message)); proceeding (fail-open)."
        return $true
    }

    [bool]($touched.Name -contains $Name)
}
