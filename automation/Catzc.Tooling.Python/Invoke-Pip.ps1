<#
.SYNOPSIS
    Runs pip through uv (`uv pip`).
.DESCRIPTION
    Delegates to Invoke-Uv, so `Invoke-Pip 'install --system requests'` runs `uv pip install --system requests`...
    [comment:1](/docs/references/automation/catzc-tooling-python/Invoke-Pip.ps1.md#comment1)
.PARAMETER Arguments
    Arguments to pass to `uv pip`.
.PARAMETER PassThru
    Return a CliResult object with Output, Errors, Full, and ExitCode.
.PARAMETER NoAssert
    Skip exit code assertion.
.PARAMETER Silent
    Suppress the command log line and all console output.
.PARAMETER DryRun
    Return the command string without executing. Used for testing.
.EXAMPLE
    Invoke-Pip 'install --system requests'
.EXAMPLE
    Invoke-Pip 'list --format json' -DryRun
#>
function Invoke-Pip {
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

    Invoke-Uv "pip $Arguments" -PassThru:$PassThru -NoAssert:$NoAssert -Silent:$Silent -DryRun:$DryRun
}
