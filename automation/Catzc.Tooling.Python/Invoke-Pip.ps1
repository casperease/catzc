<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Python/Invoke-Pip.ps1
    kind: function
    module: Catzc.Tooling.Python
    visibility: public
---
#>

<#
.SYNOPSIS
    Runs pip through uv (`uv pip`).
.DESCRIPTION
    Installs aimed at the global interpreter must pass --system, since uv pip otherwise expects a virtual environment.
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
