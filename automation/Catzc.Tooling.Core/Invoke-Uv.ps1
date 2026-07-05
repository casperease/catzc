<#
.SYNOPSIS
    Runs uv with the given arguments.
.DESCRIPTION
    Asserts that uv is installed at the locked version before executing. uv is the standard Python handler —
    it provisions Python (`uv python`) and runs Python-based CLIs in isolated environments (`uv tool`,
    `uv pip`, `uv run`).
.PARAMETER Arguments
    Arguments to pass to uv.
.PARAMETER PassThru
    Return a CliResult object with Output, Errors, Full, and ExitCode.
.PARAMETER NoAssert
    Skip exit code assertion.
.PARAMETER Silent
    Suppress the command log line.
.PARAMETER DryRun
    Return the command string without executing. Used for testing.
.EXAMPLE
    Invoke-Uv 'tool install azure-cli'
.EXAMPLE
    Invoke-Uv 'python install 3.14 --default'
#>
function Invoke-Uv {
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
        Assert-Tool 'uv'
    }

    Invoke-Executable "uv $Arguments" -PassThru:$PassThru -NoAssert:$NoAssert -Silent:$Silent -DryRun:$DryRun
}
