# catzc:
#   path: automation/Catzc.Base.Execution/private/Invoke-ExecutableStreamed.ps1
#   module: Catzc.Base.Execution
#   visibility: private

<#
.SYNOPSIS
    Runs a CLI command with live-streamed output, exit code handling, and
    optional structured output capture.
.DESCRIPTION
    Colors are lost: a piped child sees no terminal and disables them, and only a pseudo-terminal would bring them back.
    [comment:1](/docs/references/automation/catzc-base-execution/private/Invoke-ExecutableStreamed.ps1.md#comment1)
.PARAMETER Command
    The command string to execute.
.PARAMETER PassThru
    Return a Catzc.Base.Execution.CliResult object with Output, Errors, Full, ExitCode, and Raw.
.PARAMETER NoAssert
    Skip the exit code assertion.
.PARAMETER WorkingDirectory
    The directory to run the command in.
.PARAMETER Silent
    Suppress all console output. Output is still captured for -PassThru.
.PARAMETER TimeoutSeconds
    The run's time limit. Past it CliRunner kills the process tree and throws a TimeoutException.
.PARAMETER AsBytes
    Returns the CliResult even without -PassThru, since bytes have no other way back to the caller.
    [comment:2](/docs/references/automation/catzc-base-execution/private/Invoke-ExecutableStreamed.ps1.md#comment2)
.PARAMETER DryRun
    Return the command string without executing.
#>
function Invoke-ExecutableStreamed {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingInvokeExpression', '', Justification = 'By design — executes CLI commands')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseOutputTypeCorrectly', '', Justification = 'Returns string in -DryRun, Catzc.Base.Execution.CliResult in -PassThru')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = '$global:__PesterRunning (set by Test-Automation) is read to suppress streamed child output during test runs; global is required to cross module session-state boundaries')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Command,
        [Parameter(Mandatory)]
        [string] $WorkingDirectory,
        [switch] $PassThru,
        [switch] $NoAssert,
        [switch] $Silent,
        [Parameter(Mandatory)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $TimeoutSeconds,
        [switch] $AsBytes,
        [switch] $DryRun
    )

    if ($DryRun) {
        return $Command
    }

    Reset-LastExitCode

    # The runner's Console.Write bypasses Write-Message suppression, so a test run would leak real tool chatter.
    # [comment:3](/docs/references/automation/catzc-base-execution/private/Invoke-ExecutableStreamed.ps1.md#comment3)
    $suppressOutput = [bool]$Silent -or [bool](Get-Variable -Name '__PesterRunning' -Scope Global -ValueOnly -ErrorAction Ignore)

    # CliRunner is autoloaded at import time from types/ (Bootstrap's Import-CSharpTypes).
    try {
        $runResult = if ($AsBytes) {
            [Catzc.Base.Execution.CliRunner]::RunBytes($Command, $WorkingDirectory, $TimeoutSeconds)
        }
        else {
            [Catzc.Base.Execution.CliRunner]::Run($Command, $suppressOutput, $WorkingDirectory, $TimeoutSeconds)
        }
    }
    catch [System.Management.Automation.MethodInvocationException] {
        # A .NET method call wraps what it throws; surface the runner's own error (e.g. the TimeoutException).
        throw $_.Exception.InnerException
    }

    # Set $LASTEXITCODE so Assert-LastExitCodeWasZero works
    $global:LASTEXITCODE = $runResult.ExitCode

    if (-not $NoAssert) {
        Assert-LastExitCodeWasZero
    }

    Reset-LastExitCode

    if ($AsBytes) {
        [Catzc.Base.Execution.CliResult]::new([byte[]] $runResult.StdoutBytes, $runResult.Stderr, $runResult.ExitCode)
    }
    elseif ($PassThru) {
        # The CliResult constructor owns the derivation (trim, merge, split) — see types/CliResult.cs.
        [Catzc.Base.Execution.CliResult]::new($runResult.Stdout, $runResult.Stderr, $runResult.ExitCode)
    }
}
