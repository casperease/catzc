<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-TestDurationHistory.ps1
    kind: function
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.QualityGates
    visibility: private
  config:
    synopsis: Reads the per-file test durations the last runs measured on this machine.
    description: |-
      The history is a per-machine file, durations.json, beside the run folders under out/ (gitignored, never
      committed): repository-relative '/'-separated test file path -> milliseconds, the file's whole Pester duration
      including its set-up. Select-TestShardAssignment schedules from it. A missing or unreadable history is an empty
      one: the run falls back to an even split and writes a fresh history at its end.
    parameters:
      Path: The history file.
    outputs: '[hashtable] File path -> milliseconds.'
---
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
