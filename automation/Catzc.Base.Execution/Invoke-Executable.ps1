<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Execution/Invoke-Executable.ps1
    kind: function
    module: Catzc.Base.Execution
    visibility: public
    adrs:
      - ADR-AUTO-DRYRUN#2
      - ADR-AUTO-TEST
---
#>

<#
.SYNOPSIS
    Runs a CLI command with exit code handling, stream separation, and
    optional structured output capture.
.DESCRIPTION
    Streamed runs lose ANSI colors, since a piped child disables them; use -Direct when colors matter.
    [comment:1](/docs/references/automation/catzc-base-execution/Invoke-Executable.ps1.md#comment1)
.PARAMETER Command
    The command string to execute.
.PARAMETER Direct
    Direct output also flows into the pipeline, so it leaks into the caller's return value.
    [comment:2](/docs/references/automation/catzc-base-execution/Invoke-Executable.ps1.md#comment2)
.PARAMETER PassThru
    Without it the output only streams to the console and the caller gets nothing to read back.
    [comment:3](/docs/references/automation/catzc-base-execution/Invoke-Executable.ps1.md#comment3)
.PARAMETER AsBytes
    Read .Bytes, not .Output: .Output stays empty, so a text reader of a binary stream gets an empty string.
    [comment:4](/docs/references/automation/catzc-base-execution/Invoke-Executable.ps1.md#comment4)
.PARAMETER TimeoutSeconds
    Overrides the timeouts.yml limit for one call; -Direct has no limit, since a person at the prompt is its safeguard.
    [comment:8](/docs/references/automation/catzc-base-execution/Invoke-Executable.ps1.md#comment8)
.PARAMETER NoAssert
    With -PassThru the ExitCode stays readable on the result, so the caller can judge it instead.
    [comment:5](/docs/references/automation/catzc-base-execution/Invoke-Executable.ps1.md#comment5)
.PARAMETER Silent
    A silent run also closes stdin, so a prompt in the child fails at once instead of waiting unseen.
    [comment:6](/docs/references/automation/catzc-base-execution/Invoke-Executable.ps1.md#comment6)
.PARAMETER WorkingDirectory
    Defaults to the repository root, not $PWD, so pass a directory whenever the command depends on one.
    [comment:7](/docs/references/automation/catzc-base-execution/Invoke-Executable.ps1.md#comment7)
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
# -DryRun, not ShouldProcess or -WhatIf: it hands back the command string, so a caller can inspect it.
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

    # A real launch in a unit test means a Mock missed, usually a wrong -ModuleName, so fail loudly.
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
