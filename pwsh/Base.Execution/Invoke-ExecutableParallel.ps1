<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-execution/Invoke-ExecutableParallel.ps1.md"
  header: "generated"
---
#>

function Invoke-ExecutableParallel {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Execution.CliResult])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyCollection()]
        [string[]] $Command,

        [ValidateRange(1, [int]::MaxValue)]
        [int] $ThrottleLimit = (Get-Config -Config timeouts).parallel['processes'],

        [switch] $NoAssert,

        [switch] $Silent,

        [string] $WorkingDirectory = (Get-RepositoryRoot),

        [switch] $DryRun
    )

    if ($Command.Count -eq 0) {
        return
    }
    # The test tripwire: a launch here means a Mock missed, almost always a wrong -ModuleName, so fail loudly.
    if (-not $DryRun -and (Test-RealProcessBlocked)) {
        throw (
            "Blocked $($Command.Count) real process launch(es) during a unit test, the first '$($Command[0])'. A Mock did not " +
            'intercept them — check the mock targets the module the calling function runs in: ' +
            'Mock <command> -ModuleName <module-of-the-function-under-test>.'
        )
    }
    if ($DryRun) {
        return $Command
    }

    Assert-PathExist $WorkingDirectory -PathType Container
    if (-not $Silent) {
        $executable = [Catzc.Base.Execution.CliRunner]::ExecutableName($Command[0])
        Write-Message "running $($Command.Count) command(s) of $executable, $ThrottleLimit at a time"
    }

    $limits = [int[]] @(foreach ($line in $Command) {
            Get-TimeoutSeconds -Executable ([Catzc.Base.Execution.CliRunner]::ExecutableName($line))
        })
    $drainSeconds = (Get-Config -Config timeouts).wait['drain_seconds']
    try {
        $runs = [Catzc.Base.Execution.CliRunner]::RunMany([string[]] $Command, $WorkingDirectory, $limits, $drainSeconds, $ThrottleLimit)
    }
    catch [System.Management.Automation.MethodInvocationException] {
        # A .NET method call wraps what it throws; surface the runner's own error (e.g. the TimeoutException).
        throw $_.Exception.InnerException
    }

    $results = [Catzc.Base.Execution.CliResult[]] @(foreach ($run in $runs) {
            [Catzc.Base.Execution.CliResult]::new($run.Stdout, $run.Stderr, $run.ExitCode)
        })
    if (-not $NoAssert) {
        $failed = @(for ($index = 0; $index -lt $results.Count; $index++) {
                if ($results[$index].ExitCode -ne 0) {
                    "exit $($results[$index].ExitCode): $($Command[$index])"
                }
            })
        if ($failed.Count -gt 0) {
            throw "$($failed.Count) of $($Command.Count) command(s) failed:`n$($failed -join "`n")"
        }
    }
    $results
}
