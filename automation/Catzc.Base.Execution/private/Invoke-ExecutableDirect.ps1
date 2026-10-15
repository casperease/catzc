<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Execution/private/Invoke-ExecutableDirect.ps1
    kind: private-function
    module: Catzc.Base.Execution
    visibility: private
    adrs: []
---
#>

<#
.SYNOPSIS
    Runs a CLI command directly with no output capture or stream separation.
.DESCRIPTION
    Output reaches the pipeline as well as the console, so a caller that wants quiet must suppress it.
.PARAMETER Command
    The command string to execute.
.PARAMETER WorkingDirectory
    The directory to run the command in.
.PARAMETER PassThru
    Ignored: Direct mode captures nothing, so there is no result to hand back.
.PARAMETER NoAssert
    Skip the exit code assertion.
.PARAMETER Silent
    Suppress the command log line.
.PARAMETER DryRun
    Return the command string without executing.
#>
function Invoke-ExecutableDirect {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingInvokeExpression', '', Justification = 'By design — executes CLI commands')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'PassThru', Justification = 'Accepted for signature compatibility with other modes')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'Silent', Justification = 'Accepted for signature compatibility with other modes')]
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

    # The child scope keeps ErrorActionPreference Continue from leaking into the caller.
    # [comment:3](/docs/references/automation/catzc-base-execution/private/Invoke-ExecutableDirect.ps1.md#comment3)
    Push-Location $WorkingDirectory
    try {
        & {
            $ErrorActionPreference = 'Continue'
            Invoke-Expression $Command
        }
    }
    finally {
        Pop-Location
    }

    if (-not $NoAssert) {
        Assert-LastExitCodeWasZero
    }

    Reset-LastExitCode
}
