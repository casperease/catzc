<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-TestRunLockHolder.ps1
    folder: private
    name: get-test-run-lock-holder
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/private/Get-TestRunLockHolder.ps1.md
  config:
    synopsis: Reads the test-run lock record and describes who holds the working folder.
    description: |-
      A mutex carries no owner data, so the run that holds the test-run lock writes a record beside it
      (Enter-TestRunLocation). This reads that record and says plainly what it can and cannot tell, never guessing:

      - a live holder: '<entry point> (pid <n>, started <time>, run <folder>)';
      - no record: the holder left no lock record;
      - a stale record: the process it names is no longer running (or the pid now belongs to another process,
        detected by its start time), so the record does not describe the current holder.
    parameters:
      Path: The lock record's path (out/.test-run-lock.json).
    outputs: |-
      [pscustomobject] with Known (the record names a live process), Description (the phrase for the
      announcement), and Record (the parsed record, or $null).
---
#>

function Get-TestRunLockHolder {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $Path
    )

    $record = $null
    if ([System.IO.File]::Exists($Path)) {
        try {
            $record = [System.IO.File]::ReadAllText($Path) | ConvertFrom-Json
        }
        catch {
            $record = $null
        }
    }
    if (-not $record -or -not $record.PSObject.Properties['pid']) {
        return [pscustomobject]@{
            Known       = $false
            Description = 'another test run (it left no lock record)'
            Record      = $null
        }
    }

    $toInstant = {
        param($value)
        if ($value -is [datetime]) {
            [DateTimeOffset]::new($value.ToUniversalTime())
        }
        else {
            [DateTimeOffset]::Parse([string] $value, [cultureinfo]::InvariantCulture)
        }
    }

    $process = Get-Process -Id ([int] $record.pid) -ErrorAction SilentlyContinue
    $isSameProcess = $false
    if ($process -and $record.PSObject.Properties['processStartedAt']) {
        try {
            $recordedStart = (& $toInstant $record.processStartedAt).UtcDateTime
            $isSameProcess = [Math]::Abs(($process.StartTime.ToUniversalTime() - $recordedStart).TotalSeconds) -lt 1
        }
        catch {
            $isSameProcess = $false
        }
    }
    if (-not $isSameProcess) {
        return [pscustomobject]@{
            Known       = $false
            Description = "another test run (the lock record names pid $($record.pid), which is no longer running — the record is stale)"
            Record      = $record
        }
    }

    $details = [System.Collections.Generic.List[string]]::new()
    $details.Add("pid $($record.pid)")
    if ($record.PSObject.Properties['startedAt'] -and $record.startedAt) {
        $details.Add('started ' + (& $toInstant $record.startedAt).ToLocalTime().ToString('HH:mm:ss'))
    }
    if ($record.PSObject.Properties['runDirectory'] -and $record.runDirectory) {
        $details.Add('run ' + [System.IO.Path]::GetFileName([string] $record.runDirectory))
    }
    # A user-wide lock (the system-test lock) is held from any checkout: name it.
    if ($record.PSObject.Properties['repositoryRoot'] -and $record.repositoryRoot) {
        $details.Add("in $($record.repositoryRoot)")
    }
    $entryPoint = if ($record.PSObject.Properties['entryPoint'] -and $record.entryPoint) {
        $record.entryPoint
    }
    else {
        'a test run'
    }
    [pscustomobject]@{
        Known       = $true
        Description = "$entryPoint ($($details -join ', '))"
        Record      = $record
    }
}
