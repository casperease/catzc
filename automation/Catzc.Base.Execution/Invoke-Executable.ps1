<#
.SYNOPSIS
    Runs a CLI command with exit code handling, stream separation, and
    optional structured output capture.
.DESCRIPTION
    Central wrapper for external tool invocation.

    Default: Live-streams output to the console via a C# process runner
    that reads char-by-char (preserves spinners, progress bars, \r).
    Output bypasses PowerShell's pipeline — zero leaks. With -PassThru,
    returns a Catzc.Base.Execution.CliResult object with separated stdout/stderr.
    Note: ANSI colors are lost — child processes disable them when stdout
    is a pipe (isatty check). Use -Direct when colors matter.

    -Direct: Like typing the command at the prompt. Full color, full
    fidelity. Output flows to the console AND the pipeline — leaks into
    caller's return value. Use for interactive commands or when colors
    are important.

    Both modes share the same LASTEXITCODE lifecycle (reset before, assert
    after, reset after). -PassThru returns a Catzc.Base.Execution.CliResult object:
      .Output   — stdout only (string)
      .Errors   — stderr only (string)
      .Full     — both merged in original order (string)
      .ExitCode — raw exit code (int)
      .Raw      — unprocessed output array

    -PassThru and -Direct are mutually exclusive (separate parameter sets).

    The default (Stream) mode runs inside a time safeguard: a process that outlives its limit is killed with its
    whole tree and the call throws a TimeoutException. The limit is the executable's entry in timeouts.yml, or
    the run environment's pwsh limit (Get-TimeoutSeconds); -TimeoutSeconds sets it for one call. -Direct is the interactive
    mode — a person at the prompt is its safeguard — so it has no limit.
.PARAMETER Command
    The command string to execute.
.PARAMETER Direct
    Raw execution with full color support. Output leaks to the pipeline.
    Use when colors matter or for interactive commands.
.PARAMETER PassThru
    Return a Catzc.Base.Execution.CliResult object with Output, Errors, Full, ExitCode, and Raw.
    Not compatible with -Direct.
.PARAMETER AsBytes
    Capture stdout as its exact bytes, for a binary stream such as `git cat-file --batch`: returns the CliResult
    with stdout in .Bytes (and an empty .Output), never echoed to the console. Not compatible with -Direct.
.PARAMETER NoAssert
    Skip the exit code assertion. The ExitCode is still available on the
    result object when combined with -PassThru.
.PARAMETER Silent
    Suppress the command log line and all console output. A silent run is non-interactive: the child gets an
    empty, closed stdin, so a prompt fails instead of waiting invisibly. A visible run gets the same when this
    session's stdin is not a terminal (a worker, an agent, a pipe), since no one could answer a prompt there.
.PARAMETER WorkingDirectory
    The directory to run the command in. Defaults to the repository root
    ($env:RepositoryRoot). Callers that need a specific directory should
    pass it explicitly rather than relying on $PWD.
.PARAMETER TimeoutSeconds
    The time limit for this call, in seconds. Defaults to the executable's limit from timeouts.yml
    (Get-TimeoutSeconds). Not compatible with -Direct.
.PARAMETER DryRun
    Return the command string without executing. Used for testing.
.EXAMPLE
    Invoke-Executable 'python --version'
.EXAMPLE
    Invoke-Executable 'winget install --id Python.Python.3.11' -Direct
.EXAMPLE
    $result = Invoke-Executable 'az account show --output json' -PassThru
    $result.Output | ConvertFrom-Json
.EXAMPLE
    $result = Invoke-Executable 'terraform apply' -PassThru
    $result.ExitCode
.EXAMPLE
    Invoke-Executable 'python --version' -DryRun
#>
# Uses -DryRun, not ShouldProcess/-WhatIf — see
# [ADR-AUTO-DRYRUN#2](/docs/adr/automation/powershell/prefer-dryrun-over-shouldprocess.md#rule-adr-auto-dryrun2).
function Invoke-Executable {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingInvokeExpression', '', Justification = 'By design — executes CLI commands via private helpers')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseOutputTypeCorrectly', '', Justification = 'Returns string in -DryRun, Catzc.Base.Execution.CliResult in -PassThru')]
    [CmdletBinding(DefaultParameterSetName = 'Stream')]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Command,

        [Parameter(ParameterSetName = 'Direct')]
        [switch] $Direct,

        [Parameter(ParameterSetName = 'Stream')]
        [switch] $PassThru,

        [Parameter(ParameterSetName = 'Stream')]
        [switch] $AsBytes,

        [Parameter(ParameterSetName = 'Stream')]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $TimeoutSeconds,

        [switch] $NoAssert,
        [switch] $Silent,
        [string] $WorkingDirectory = (Get-RepositoryRoot),
        [switch] $DryRun
    )

    # Unit-test tripwire (sibling to -DryRun: both prevent a launch — DryRun returns the command, this
    # throws). When a unit (L1) run sets $env:CATZC_BLOCK_REAL_PROCESS, a real process launch means a Mock
    # failed to intercept — almost always a -ModuleName pointing at the wrong module — so the test was
    # silently hitting the live tool. Fail loudly instead. -DryRun is exempt (it never launches).
    # See [ADR-AUTO-TEST](/docs/adr/automation/test-automation.md).
    if ($env:CATZC_BLOCK_REAL_PROCESS -and -not $DryRun) {
        throw (
            "Blocked a real process launch during a unit test: '$Command'. A Mock did not intercept it — " +
            'check the mock targets the module the calling function runs in: ' +
            'Mock <command> -ModuleName <module-of-the-function-under-test>.'
        )
    }

    Assert-PathExist $WorkingDirectory -PathType Container

    # Log the command from this function so Write-Message shows [Invoke-Executable].
    if (-not $Silent -and -not $DryRun) {
        Write-Message $Command
    }

    $params = @{
        Command          = $Command
        WorkingDirectory = $WorkingDirectory
        PassThru         = $PassThru
        NoAssert         = $NoAssert
        Silent           = $Silent
        DryRun           = $DryRun
    }

    if ($Direct) {
        Invoke-ExecutableDirect @params
    }
    else {
        if (-not $PSBoundParameters.ContainsKey('TimeoutSeconds')) {
            $TimeoutSeconds = Get-TimeoutSeconds -Executable ([Catzc.Base.Execution.CliRunner]::ExecutableName($Command))
        }
        Invoke-ExecutableStreamed @params -TimeoutSeconds $TimeoutSeconds -AsBytes:$AsBytes
    }
}
