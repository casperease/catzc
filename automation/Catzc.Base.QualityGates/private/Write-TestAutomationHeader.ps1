<#
.SYNOPSIS
    Writes the opening banner for a Test-Automation run — the framed header that brackets the run's output.
.DESCRIPTION
    Renders a single Write-Header (a self-contained curved box) naming the run's scope: its tier range, plus
    the category and the module list when either is narrowed from the defaults. Test-Automation calls this
    before it sets the writers' suppression flag, so the banner renders and everything the run then emits —
    Pester's own lines, and the timing / report / skip sections below — sits under it.
.PARAMETER MinLevel
    The run's minimum tier (0-3), as Test-Automation resolved it.
.PARAMETER MaxLevel
    The run's maximum tier (0-3).
.PARAMETER Category
    The run's category filter (Logic / Integrity / Both); named in the scope only when it is not Both.
.PARAMETER Modules
    The modules the run was scoped to; named in the scope only when non-empty.
#>
function Write-TestAutomationHeader {
    [CmdletBinding()]
    param(
        [int] $MinLevel = 0,

        [int] $MaxLevel = 2,

        [string] $Category = 'Both',

        [string[]] $Modules = @()
    )

    $scope = if ($MinLevel -eq $MaxLevel) {
        "L$MaxLevel"
    }
    else {
        "L$MinLevel-L$MaxLevel"
    }
    if ($Category -ne 'Both') {
        $scope += ", $Category"
    }
    if ($Modules) {
        $scope += ", modules: $($Modules -join ', ')"
    }
    Write-Header "Test Automation — $scope" -ForegroundColor Cyan
}
