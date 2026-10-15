<#
.SYNOPSIS
    Merges a run's measured per-file durations into the test duration history.
.DESCRIPTION
    Each file the run measured replaces its entry; files the run did not run keep theirs, so a partial run (one...
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Save-TestDurationHistory.ps1.md#comment1)
.PARAMETER Path
    The history file.
.PARAMETER DurationMs
    This run's measurements, repository-relative '/'-separated file path -> milliseconds.
#>
function Save-TestDurationHistory {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $DurationMs
    )

    $history = Get-TestDurationHistory -Path $Path
    foreach ($key in $DurationMs.Keys) {
        $history[$key] = [Math]::Round([double] $DurationMs[$key])
    }
    $sorted = [ordered]@{}
    foreach ($key in @($history.Keys | Sort-Object)) {
        $sorted[$key] = $history[$key]
    }
    [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($Path)) | Out-Null
    [System.IO.File]::WriteAllText($Path, (ConvertTo-Json -InputObject $sorted) + "`n", [System.Text.UTF8Encoding]::new($false))
}
