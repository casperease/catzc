<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1
    kind: gate-function
    module: Catzc.Base.Globs
    visibility: public
    adrs:
      - ADR-AUTO-FAILFAST
      - ADR-FLOW-CD-GLOBS#1
      - ADR-REPO-PROTGLOB#5
---
#>

<#
.SYNOPSIS
    Whether the current context's change touches a globset — the in-pipeline "is there anything here for us
    to process?" check.
.DESCRIPTION
    Fails open: an unresolvable range returns true, since a redundant run is safe and a wrong skip is not.
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
