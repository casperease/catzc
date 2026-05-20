<#
.SYNOPSIS
    Runs npm with the given arguments.
.DESCRIPTION
    Asserts that the installed npm version matches the locked version
    in Get-ToolConfig before executing the command.
.PARAMETER Arguments
    Arguments to pass to npm.
.PARAMETER PassThru
    Return a CliResult object with Output, Errors, Full, and ExitCode.
.PARAMETER NoAssert
    Skip exit code assertion.
.PARAMETER Silent
    Suppress the command log line.
.EXAMPLE
    Invoke-Npm 'install'
.EXAMPLE
    Invoke-Npm 'run build' -PassThru
#>
function Invoke-Npm {
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
        Assert-Tool 'node_js'
    }

    Invoke-Executable "npm $Arguments" -PassThru:$PassThru -NoAssert:$NoAssert -Silent:$Silent -DryRun:$DryRun
}
