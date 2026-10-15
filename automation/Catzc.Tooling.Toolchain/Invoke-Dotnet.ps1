# catzc:
#   path: automation/Catzc.Tooling.Toolchain/Invoke-Dotnet.ps1
#   module: Catzc.Tooling.Toolchain
#   visibility: public

<#
.SYNOPSIS
    Runs dotnet with the given arguments.
.DESCRIPTION
    A drifted SDK fails the assertion before the command starts, so nothing runs on a version other than the lock.
    [comment:1](/docs/references/automation/catzc-tooling-toolchain/Invoke-Dotnet.ps1.md#comment1)
.PARAMETER Arguments
    Arguments to pass to dotnet.
.PARAMETER PassThru
    Return a CliResult object with Output, Errors, Full, and ExitCode.
.PARAMETER NoAssert
    Skip exit code assertion.
.PARAMETER Silent
    Suppress the command log line.
.PARAMETER DryRun
    Return the command string without executing. Used for testing.
.EXAMPLE
    Invoke-Dotnet 'build'
.EXAMPLE
    Invoke-Dotnet '--version' -DryRun
#>
function Invoke-Dotnet {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Arguments,
        [switch] $PassThru,
        [switch] $NoAssert,
        [switch] $Silent,
        [switch] $DryRun
    )

    Assert-NotNullOrWhitespace $Arguments -ErrorText 'Arguments cannot be empty'

    if (-not $DryRun) {
        Assert-Tool 'dotnet'
    }

    Invoke-Executable "dotnet $Arguments" -PassThru:$PassThru -NoAssert:$NoAssert -Silent:$Silent -DryRun:$DryRun
}
