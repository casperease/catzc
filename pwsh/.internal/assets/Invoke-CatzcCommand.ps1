<#
---
catzc:
  immutable:
    with_body_sha: "60cc1ef6f2a9"
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
    Result Failed, which is why a test file runs as `Invoke-TestFile <file> -PassThru`. The exit code is 1 when any command failed.

    The commands run under the machine's run lock, a named mutex, so heavy runs on one machine go one at a time. A run that finds the lock
    held says so in one line and waits up to tests.run_lock_seconds of timeouts.yml; one that still cannot take it stops with a
    "run lock busy" line and exit code 1, running nothing.

    timeout 300 pwsh -NoProfile -File pwsh/.internal/assets/Invoke-CatzcCommand.ps1 "Test-Plans" "Test-Links -Path docs/how-to/index.md"

.PARAMETER Command
    The command lines, each one a cats command with its arguments.

.PARAMETER Importer
    The importer to dot-source. Default: the repository's importer.ps1.

.PARAMETER LockName
    The named mutex the commands run under. Default: Local\catzc-run, one per user on the machine.
#>
param(
    [Parameter(Position = 0, ValueFromRemainingArguments)]
    [string[]] $Command,

    [string] $Importer = (Join-Path $PSScriptRoot '../../../importer.ps1'),

    [string] $LockName = 'Local\catzc-run'
)

Set-StrictMode -Version Latest

# An empty remaining-arguments list still binds one empty item, so blank lines are dropped before the count.
$Command = @($Command | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
if ($Command.Count -eq 0) {
    throw 'Invoke-CatzcCommand: name at least one command to run.'
}

. $Importer

# The lock is taken after the import, since its wait is read from timeouts.yml; an abandoned lock (its run was killed) is taken over.
$lockSeconds = (Get-Config -Config timeouts).tests.run_lock_seconds
$lock = [System.Threading.Mutex]::new($false, $LockName)
$owned = $false
try {
    $owned = $lock.WaitOne(0)
}
catch [System.Threading.AbandonedMutexException] {
    $owned = $true
}
if (-not $owned) {
    "[Invoke-CatzcCommand] waiting for the run lock: another run holds it (up to $lockSeconds s)"
    try {
        $owned = $lock.WaitOne([timespan]::FromSeconds($lockSeconds))
    }
    catch [System.Threading.AbandonedMutexException] {
        $owned = $true
    }
}
if (-not $owned) {
    $lock.Dispose()
    "[Invoke-CatzcCommand] run lock busy: another run held it for $lockSeconds s, so nothing ran"
    exit 1
}

# Every command runs from the repository root, where the importer sits, so a relative path never resolves against the caller's folder.
Push-Location -LiteralPath (Split-Path -Parent ([System.IO.Path]::GetFullPath($Importer)))
$failed = 0
try {
    foreach ($line in $Command) {
        try {
            $ErrorActionPreference = 'Stop'
            $output = @(& ([scriptblock]::Create($line)))
            # A result object (Invoke-TestFile -PassThru) carries the verdict of a command that reports a failure without throwing.
            $results = @($output | Where-Object { $null -ne $_ -and $_.PSObject.Properties['Result'] })
            $output | Where-Object { $results -notcontains $_ } | Out-Host
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
    $lock.ReleaseMutex()
    $lock.Dispose()
}

"[Invoke-CatzcCommand] $(@($Command).Count - $failed) of $(@($Command).Count) passed"
exit ([int] ($failed -gt 0))
