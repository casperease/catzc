# catzc:
#   path: automation/Catzc.Base.QualityGates/private/Get-TestDurationHistory.ps1
#   module: Catzc.Base.QualityGates
#   visibility: private

<#
.SYNOPSIS
    Reads the per-file test durations the last runs measured on this machine.
.DESCRIPTION
    A missing or unreadable history is empty, so the run falls back to an even split and writes a fresh one.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-TestDurationHistory.ps1.md#comment1)
.PARAMETER Path
    The history file.
.OUTPUTS
    [hashtable] File path -> milliseconds.
#>
function Get-TestDurationHistory {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory)]
        [string] $Path
    )

    $history = @{}
    if (-not [System.IO.File]::Exists($Path)) {
        return $history
    }
    try {
        $parsed = [System.IO.File]::ReadAllText($Path) | ConvertFrom-Json -AsHashtable
    }
    catch {
        Write-Message "Ignoring an unreadable test duration history at '$Path': $($_.Exception.Message)"
        return $history
    }
    foreach ($key in @($parsed.Keys)) {
        $value = $parsed[$key]
        if ($value -is [int] -or $value -is [long] -or $value -is [double]) {
            $history[$key] = [double] $value
        }
    }
    $history
}
