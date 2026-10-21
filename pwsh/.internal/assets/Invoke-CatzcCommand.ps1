<#
---
catzc:
  immutable:
    with_body_sha: "7cec9329ec88"
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

    timeout 300 pwsh -NoProfile -File pwsh/.internal/assets/Invoke-CatzcCommand.ps1 "Test-Plans" "Test-Links -Path docs/how-to/index.md"

.PARAMETER Command
    The command lines, each one a cats command with its arguments.

.PARAMETER Importer
    The importer to dot-source. Default: the repository's importer.ps1.
#>
param(
    [Parameter(Position = 0, ValueFromRemainingArguments)]
    [string[]] $Command,

    [string] $Importer = (Join-Path $PSScriptRoot '../../../importer.ps1')
)

Set-StrictMode -Version Latest

# An empty remaining-arguments list still binds one empty item, so blank lines are dropped before the count.
$Command = @($Command | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
if ($Command.Count -eq 0) {
    throw 'Invoke-CatzcCommand: name at least one command to run.'
}

. $Importer

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
}

"[Invoke-CatzcCommand] $(@($Command).Count - $failed) of $(@($Command).Count) passed"
exit ([int] ($failed -gt 0))
