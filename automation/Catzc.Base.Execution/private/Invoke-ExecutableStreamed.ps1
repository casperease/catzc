<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Execution/private/Invoke-ExecutableStreamed.ps1
    kind: automation-function
    language: powershell
    track: automation
    module: Catzc.Base.Execution
    visibility: private
    relatives:
      page: docs/references/automation/catzc-base-execution/private/Invoke-ExecutableStreamed.ps1.md
  config:
    synopsis: |-
      Runs a CLI command with live-streamed output, exit code handling, and
      optional structured output capture.
    description: |-
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
    parameters:
      Command: The command string to execute.
      WorkingDirectory: The directory to run the command in.
      PassThru: Return a Catzc.Base.Execution.CliResult object with Output, Errors, Full, ExitCode, and Raw.
      NoAssert: Skip the exit code assertion.
      Silent: Suppress all console output. Output is still captured for -PassThru.
      TimeoutSeconds: The run's time limit. Past it CliRunner kills the process tree and throws a TimeoutException.
      AsBytes: |-
        Capture stdout as its exact bytes (CliResult.Bytes) instead of text, with no console echo — for a binary
        stream. Returns the CliResult as -PassThru does.
      InputText: Written to the child's stdin, which is then closed; absent, stdin is left as before.
      DryRun: Return the command string without executing.
---
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
        [string] $InputText,
        [switch] $DryRun
    )

    if ($DryRun) {
        return $Command
    }

    Reset-LastExitCode

    $suppressOutput = [bool]$Silent -or [bool](Get-Variable -Name '__PesterRunning' -Scope Global -ValueOnly -ErrorAction Ignore)

    # CliRunner is autoloaded at import time from types/ (Bootstrap's Import-CSharpTypes).
    try {
        $runResult = if ($AsBytes) {
            [Catzc.Base.Execution.CliRunner]::RunBytes($Command, $WorkingDirectory, $TimeoutSeconds)
        }
        else {
            # Null leaves stdin as before; a bound -InputText, even an empty one, is written and closed.
            $stdin = if ($PSBoundParameters.ContainsKey('InputText')) {
                $InputText
            }
            else {
                $null
            }
            [Catzc.Base.Execution.CliRunner]::Run($Command, $suppressOutput, $WorkingDirectory, $TimeoutSeconds, $stdin)
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
