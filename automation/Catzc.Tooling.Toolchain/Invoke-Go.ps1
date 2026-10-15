<#
.SYNOPSIS
    Runs go with the given arguments.
.DESCRIPTION
    Asserts that the installed Go matches the locked version in Get-ToolConfig, then runs the executable the check...
    [comment:1](/docs/references/automation/catzc-tooling-toolchain/Invoke-Go.ps1.md#comment1)
.PARAMETER Arguments
    Arguments to pass to go.
.PARAMETER PassThru
    Return a CliResult object with Output, Errors, Full, and ExitCode.
.PARAMETER NoAssert
    Skip exit code assertion.
.PARAMETER Silent
    Suppress the command log line.
.PARAMETER DryRun
    Return the command string without executing. Used for testing.
.EXAMPLE
    Invoke-Go 'version'
.EXAMPLE
    Invoke-Go 'env GOROOT' -PassThru
#>
function Invoke-Go {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Arguments,
        [switch] $PassThru,
        [switch] $NoAssert,
        [switch] $Silent,
        [switch] $DryRun
    )

    if ($DryRun) {
        return Invoke-Executable "go $Arguments" -DryRun
    }

    Assert-Tool 'go'
    $executable = (Test-Tool 'go' -PassThru).Path
    Invoke-Executable "`"$executable`" $Arguments" -PassThru:$PassThru -NoAssert:$NoAssert -Silent:$Silent
}
