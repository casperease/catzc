<#
.SYNOPSIS
    Runs a CLI command directly with no output capture or stream separation.
.DESCRIPTION
    Private implementation for Invoke-Executable -Direct.
    [comment:1](/docs/references/automation/catzc-base-execution/private/Invoke-ExecutableDirect.ps1.md#comment1)
.PARAMETER Command
    The command string to execute.
.PARAMETER WorkingDirectory
    The directory to run the command in.
.PARAMETER PassThru
    Accepted for signature compatibility.
    [comment:2](/docs/references/automation/catzc-base-execution/private/Invoke-ExecutableDirect.ps1.md#comment2)
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

    # Run directly — output flows straight to the console handle.
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
