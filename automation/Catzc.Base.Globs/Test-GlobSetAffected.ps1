# catzc:
#   path: automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1
#   module: Catzc.Base.Globs
#   visibility: public

<#
.SYNOPSIS
    Whether the current context's change touches a globset — the in-pipeline "is there anything here for us
    to process?" check.
.DESCRIPTION
    Fails open: an unresolvable range returns true, since a redundant run is safe and a wrong skip is not.
    [ADR-FLOW-CD-GLOBS#1](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs1),
    [ADR-REPO-PROTGLOB#5](/docs/adr/repository/protected-globs.md#rule-adr-repo-protglob5),
    [ADR-AUTO-FAILFAST](/docs/adr/automation/fail-fast-with-asserts.md)
    [comment:1](/docs/references/automation/catzc-base-globs/Test-GlobSetAffected.ps1.md#comment1)
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
