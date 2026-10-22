<#
---
catzc:
  immutable:
    with_body_sha: d99286c00bab
  edges:
    cites:
      - ADR-AUTO-FAILFAST-BOUNDEVERYWAIT
---
#>

<#
.SYNOPSIS
    Runs each named cats command in one imported session, prints each verdict, and goes on past a failure.

.DESCRIPTION
    The one way a gate or test runs in a background call
    ([ADR-AUTO-FAILFAST-BOUNDEVERYWAIT](/docs/drs/automation/fail-fast-with-asserts.md#rule-adr-auto-failfast-boundeverywait)): one command, no script of its own in out/.
    It dot-sources the importer once, then runs every command line it is given in order, from the repository root (the importer's folder),
    and gives the caller its location back at the end. A command that throws, or writes an error, is a
    failure: its verdict line names it with the message, and the next command still runs. So is a command whose result object reports
    Result Failed; every Invoke-TestFile of the run returns that object, -PassThru named or not, so a red test file is a failure. The exit
    code is 1 when any command failed.

    The import and the commands run under the machine's run lock, a named mutex, so heavy runs on one machine go one at a time. The lock
    is taken before the import, so a waiting run holds no import, and waiters take it in the order they came (Wait-CatzcRunLock.ps1). A
    run that finds the lock held says so in one line and waits up to -LockSeconds; one that still cannot take it stops with a "run lock
    busy" line and exit code 1, importing and running nothing. While a session's Enter-CatzcBurst holds the lock, a waiting run says so
    and waits as long as the burst lasts, then up to -LockSeconds more; the burst's own checks pass -InBurst.

    timeout 300 pwsh -NoProfile -File pwsh/.internal/assets/Invoke-CatzcCommand.ps1 "Test-Plans" "Test-Links -Path docs/how-to/index.md"

.PARAMETER Command
    The command lines, each one a cats command with its arguments.

.PARAMETER Importer
    The importer to dot-source. Default: the repository's importer.ps1.

.PARAMETER LockName
    The named mutex the import and the commands run under. Default: Local\catzc-run, one per user on the machine.

.PARAMETER LockSeconds
    The most seconds a run waits for the run lock before it stops, counted again from the end of a burst that held it. Default: 120, so a
    run that cannot take it stops inside the 360 s background roof of the time safeguard.

.PARAMETER InBurst
    Run under the lock the session's Enter-CatzcBurst holds, taking none: the burst's own checks. Throws when no burst holds the lock.
#>
param(
    [Parameter(Position = 0, ValueFromRemainingArguments)]
    [string[]] $Command,

    [string] $Importer = (Join-Path $PSScriptRoot '../../../importer.ps1'),

    [string] $LockName = 'Local\catzc-run',

    [ValidateRange(1, 360)]
    [int] $LockSeconds = 120,

    [switch] $InBurst
)

Set-StrictMode -Version Latest

# An empty remaining-arguments list still binds one empty item, so blank lines are dropped before the count.
$Command = @($Command | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
if ($Command.Count -eq 0) {
    throw 'Invoke-CatzcCommand: name at least one command to run.'
}

# A burst's own checks run under the lock its Enter-CatzcBurst holds, so they take none of their own.
$lock = $null
$owned = $false
if ($InBurst) {
    $burst = $null
    if (-not [System.Threading.EventWaitHandle]::TryOpenExisting("$LockName-burst", [ref] $burst)) {
        throw "Invoke-CatzcCommand: -InBurst, but no burst holds $LockName (start Enter-CatzcBurst.ps1 first)."
    }
    $burst.Dispose()
    $owned = $true
}
else {
    # The lock is taken before the import, so a waiting run holds no import; the waiting lines pass through as they happen.
    . (Join-Path $PSScriptRoot 'Wait-CatzcRunLock.ps1')
    $taken = [ref] $null
    Wait-CatzcRunLock -LockName $LockName -LockSeconds $LockSeconds -Caller 'Invoke-CatzcCommand' -Busy 'nothing ran' -Lock $taken
    $lock = $taken.Value
    $owned = $null -ne $lock
}
if (-not $owned) {
    exit 1
}

$failed = 0
try {
    . $Importer

    # Every command runs from the repository root, where the importer sits, so a relative path never resolves against the caller's folder.
    Push-Location -LiteralPath (Split-Path -Parent ([System.IO.Path]::GetFullPath($Importer)))
    # A test file reports a red run in its result object alone, so every Invoke-TestFile of the run returns one, -PassThru named or not.
    $PSDefaultParameterValues['Invoke-TestFile:PassThru'] = $true
    try {
        foreach ($line in $Command) {
            try {
                $ErrorActionPreference = 'Stop'
                $output = @(& ([scriptblock]::Create($line)))
                # A result object (Invoke-TestFile -PassThru) carries the verdict of a command that reports a failure without throwing.
                $results = @($output | Where-Object { $null -ne $_ -and $_.PSObject.Properties['Result'] })
                # The command's own output is shown as the host renders it, through the information stream, never as a verdict line.
                $output | Where-Object { $results -notcontains $_ } | Out-String -Stream | ForEach-Object { Write-Message $_ -NoHeader }
                if (@($results | Where-Object { $_.Result -eq 'Failed' }).Count -gt 0) {
                    throw 'it reported Failed'
                }
                "[Invoke-CatzcCommand] passed: $line"
            }
            catch {
                $failed++
                "[Invoke-CatzcCommand] failed: $line — $($_.Exception.Message)"
            }
        }
    }
    finally {
        Pop-Location
    }
}
finally {
    if ($lock) {
        $lock.ReleaseMutex()
        $lock.Dispose()
    }
}

"[Invoke-CatzcCommand] $(@($Command).Count - $failed) of $(@($Command).Count) passed"
exit ([int] ($failed -gt 0))
