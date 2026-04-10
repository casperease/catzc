<#
.SYNOPSIS
    Runs a CLI command with live-streamed output, exit code handling, and
    optional structured output capture.
.DESCRIPTION
    Private implementation for Invoke-Executable (default mode).

    Uses a C# CliRunner class (types/CliRunner.cs) that reads stdout/stderr
    char-by-char on background threads via Console.Write. Preserves \r
    carriage returns (spinners, progress bars) and Unicode. Output bypasses
    PowerShell's output stream entirely — zero pipeline leaks.

    Limitation: ANSI color codes are NOT preserved. When stdout is redirected
    to a pipe (which Process does internally), most CLI tools detect this via
    isatty() and disable colored output. This is a fundamental OS-level
    constraint — the child process never emits the escape sequences. Solving
    this would require ConPTY (pseudo-terminal). Use -Direct when colors
    are important and pipeline leaks are acceptable.
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
        [switch] $DryRun
    )

    if ($DryRun) {
        return $Command
    }

    Reset-LastExitCode

    # During a Pester run, also suppress the child's streamed output. CliRunner echoes stdout/stderr via
    # Console.Write, which bypasses the Write-Message/Write-Object suppression (so a real tool's chatter —
    # e.g. an `az bicep` upgrade nag — would otherwise leak into test logs). Output is still captured into
    # the result, so -PassThru and the exit-code assertion are unaffected. Same global the writers read,
    # set by Test-Automation. The variable is scope-qualified, so it reads as $null when unset (no strict-mode error).
    $suppressOutput = [bool]$Silent -or [bool]$global:__PesterRunning

    # CliRunner is autoloaded at import time from types/ (Bootstrap's Import-CSharpTypes).
    $runResult = [Catzc.Base.Execution.CliRunner]::Run($Command, $suppressOutput, $WorkingDirectory)

    # Set $LASTEXITCODE so Assert-LastExitCodeWasZero works
    $global:LASTEXITCODE = $runResult.ExitCode

    if (-not $NoAssert) {
        Assert-LastExitCodeWasZero
    }

    Reset-LastExitCode

    if ($PassThru) {
        # The CliResult constructor owns the derivation (trim, merge, split) — see types/CliResult.cs.
        [Catzc.Base.Execution.CliResult]::new($runResult.Stdout, $runResult.Stderr, $runResult.ExitCode)
    }
}
