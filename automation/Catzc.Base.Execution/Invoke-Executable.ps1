<#
.SYNOPSIS
    Runs a CLI command with exit code handling, stream separation, and
    optional structured output capture.
.DESCRIPTION
    Central wrapper for external tool invocation.
    [comment:1](/docs/references/automation/catzc-base-execution/Invoke-Executable.ps1.md#comment1)
.PARAMETER Command
    The command string to execute.
.PARAMETER Direct
    Raw execution with full color support.
    [comment:2](/docs/references/automation/catzc-base-execution/Invoke-Executable.ps1.md#comment2)
.PARAMETER PassThru
    Return a Catzc.Base.Execution.CliResult object with Output, Errors, Full, ExitCode, and Raw.
    [comment:3](/docs/references/automation/catzc-base-execution/Invoke-Executable.ps1.md#comment3)
.PARAMETER AsBytes
    Capture stdout as its exact bytes, for a binary stream such as `git cat-file --batch`: returns the CliResult with...
    [comment:4](/docs/references/automation/catzc-base-execution/Invoke-Executable.ps1.md#comment4)
.PARAMETER NoAssert
    Skip the exit code assertion.
    [comment:5](/docs/references/automation/catzc-base-execution/Invoke-Executable.ps1.md#comment5)
.PARAMETER Silent
    Suppress the command log line and all console output.
    [comment:6](/docs/references/automation/catzc-base-execution/Invoke-Executable.ps1.md#comment6)
.PARAMETER WorkingDirectory
    The directory to run the command in.
    [comment:7](/docs/references/automation/catzc-base-execution/Invoke-Executable.ps1.md#comment7)
.PARAMETER TimeoutSeconds
    The time limit for this call, in seconds.
    [comment:8](/docs/references/automation/catzc-base-execution/Invoke-Executable.ps1.md#comment8)
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
# Uses -DryRun, not ShouldProcess/-WhatIf — see.
# [ADR-AUTO-DRYRUN#2](/docs/adr/automation/dry-run.md#rule-adr-auto-dryrun2)
# [comment:9](/docs/references/automation/catzc-base-execution/Invoke-Executable.ps1.md#comment9)
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

    # Unit-test tripwire (sibling to -DryRun: both prevent a launch — DryRun returns the command, this throws).
    # [ADR-AUTO-TEST](/docs/adr/automation/test-automation.md)
    # [comment:10](/docs/references/automation/catzc-base-execution/Invoke-Executable.ps1.md#comment10)
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
