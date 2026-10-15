<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Python/Invoke-Poetry.ps1
    kind: function
    module: Catzc.Tooling.Python
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Runs poetry with the given arguments.
.DESCRIPTION
    A dry run skips the version assert, so command strings can be tested without Poetry installed.
    [comment:1](/docs/references/automation/catzc-tooling-python/Invoke-Poetry.ps1.md#comment1)
.PARAMETER Arguments
    Arguments to pass to poetry.
.PARAMETER PassThru
    Return a CliResult object with Output, Errors, Full, and ExitCode.
.PARAMETER NoAssert
    Skip exit code assertion.
.PARAMETER Silent
    Suppress the command log line.
.PARAMETER DryRun
    Return the command string without executing.
.EXAMPLE
    Invoke-Poetry 'install'
.EXAMPLE
    Invoke-Poetry 'version' -PassThru
#>
function Invoke-Poetry {
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
        Assert-Tool 'poetry'
    }

    Invoke-Executable "poetry $Arguments" -PassThru:$PassThru -NoAssert:$NoAssert -Silent:$Silent -DryRun:$DryRun
}
