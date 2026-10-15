<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Python/Invoke-Python.ps1
    kind: function
    module: Catzc.Tooling.Python
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Runs python with the given arguments.
.DESCRIPTION
    A dry run skips the version assert, so command strings can be tested without Python installed.
.PARAMETER Arguments
    Arguments to pass to python.
.PARAMETER PassThru
    Return a CliResult object with Output, Errors, Full, and ExitCode.
.PARAMETER NoAssert
    Skip exit code assertion.
.PARAMETER Silent
    Suppress the command log line.
.PARAMETER DryRun
    Return the command string without executing. Used for testing.
.EXAMPLE
    Invoke-Python '--version'
.EXAMPLE
    Invoke-Python '--version' -DryRun
#>
function Invoke-Python {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Arguments,
        [switch] $PassThru,
        [switch] $NoAssert,
        [switch] $Silent,
        [switch] $DryRun
    )

    Assert-NotNullOrWhitespace $Arguments -ErrorText 'Arguments cannot be empty — Python would enter interactive mode'

    if (-not $DryRun) {
        Assert-Tool 'python'
    }

    Invoke-Executable "python $Arguments" -PassThru:$PassThru -NoAssert:$NoAssert -Silent:$Silent -DryRun:$DryRun
}
