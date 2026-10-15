<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/Invoke-Java.ps1
    kind: function
    module: Catzc.Tooling.Toolchain
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Runs java with the given arguments.
.DESCRIPTION
    A drifted Java fails the assertion before the command starts, so nothing runs on a version other than the lock.
.PARAMETER Arguments
    Arguments to pass to java.
.PARAMETER PassThru
    Return a CliResult object with Output, Errors, Full, and ExitCode.
.PARAMETER NoAssert
    Skip exit code assertion.
.PARAMETER Silent
    Suppress the command log line.
.PARAMETER DryRun
    Return the command string without executing. Used for testing.
.EXAMPLE
    Invoke-Java '--version'
.EXAMPLE
    Invoke-Java '--version' -DryRun
#>
function Invoke-Java {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Arguments,
        [switch] $PassThru,
        [switch] $NoAssert,
        [switch] $Silent,
        [switch] $DryRun
    )

    if (-not $DryRun) {
        Assert-Tool 'java'
    }

    Invoke-Executable "java $Arguments" -PassThru:$PassThru -NoAssert:$NoAssert -Silent:$Silent -DryRun:$DryRun
}
