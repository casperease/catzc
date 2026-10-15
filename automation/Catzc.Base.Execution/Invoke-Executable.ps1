<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Execution/Invoke-Executable.ps1
    kind: public-function
    module: Catzc.Base.Execution
    visibility: public
    adrs:
      - ADR-AUTO-DRYRUN#2
      - ADR-AUTO-TEST
  config:
    synopsis: |-
      Runs a CLI command with exit code handling, stream separation, and
      optional structured output capture.
    description: |-
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
    parameters:
      Command: The command string to execute.
      Direct: |-
        Raw execution with full color support. Output leaks to the pipeline.
        Use when colors matter or for interactive commands.
      PassThru: |-
        Return a Catzc.Base.Execution.CliResult object with Output, Errors, Full, ExitCode, and Raw.
        Not compatible with -Direct.
      AsBytes: |-
        Capture stdout as its exact bytes, for a binary stream such as `git cat-file --batch`: returns the CliResult
        with stdout in .Bytes (and an empty .Output), never echoed to the console. Not compatible with -Direct.
      TimeoutSeconds: |-
        The time limit for this call, in seconds. Defaults to the executable's limit from timeouts.yml
        (Get-TimeoutSeconds). Not compatible with -Direct.
      InputText: 'Written to the child''s stdin, which is then closed: how one process reads a list that would overflow the command line.'
      NoAssert: |-
        Skip the exit code assertion. The ExitCode is still available on the
        result object when combined with -PassThru.
      Silent: |-
        Suppress the command log line and all console output. A silent run is non-interactive: the child gets an
        empty, closed stdin, so a prompt fails instead of waiting invisibly. A visible run gets the same when this
        session's stdin is not a terminal (a worker, an agent, a pipe), since no one could answer a prompt there.
      WorkingDirectory: |-
        The directory to run the command in. Defaults to the repository root
        ($env:RepositoryRoot). Callers that need a specific directory should
        pass it explicitly rather than relying on $PWD.
      DryRun: Return the command string without executing. Used for testing.
    examples:
      - Invoke-Executable 'python --version'
      - Invoke-Executable 'winget install --id Python.Python.3.11' -Direct
      - |-
        $result = Invoke-Executable 'az account show --output json' -PassThru
        $result.Output | ConvertFrom-Json
      - |-
        $result = Invoke-Executable 'terraform apply' -PassThru
        $result.ExitCode
      - Invoke-Executable 'python --version' -DryRun
---
#>

# Uses -DryRun, not ShouldProcess/-WhatIf — see.
# [comment:11](/docs/references/automation/catzc-base-execution/Invoke-Executable.ps1.md#comment11)
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

        [Parameter(ParameterSetName = 'Stream')]
        [string] $InputText,

        [switch] $NoAssert,
        [switch] $Silent,
        [string] $WorkingDirectory = (Get-RepositoryRoot),
        [switch] $DryRun
    )

    # Unit-test tripwire (sibling to -DryRun: both prevent a launch — DryRun returns the command, this throws).
    # [comment:12](/docs/references/automation/catzc-base-execution/Invoke-Executable.ps1.md#comment12)
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
        $streamed = @{ TimeoutSeconds = $TimeoutSeconds; AsBytes = $AsBytes }
        # An unbound [string] is empty, not null, so only a passed -InputText reaches the child's stdin.
        if ($PSBoundParameters.ContainsKey('InputText')) {
            $streamed.InputText = $InputText
        }
        Invoke-ExecutableStreamed @params @streamed
    }
}
