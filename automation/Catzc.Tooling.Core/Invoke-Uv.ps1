<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Core/Invoke-Uv.ps1
    kind: function
    module: Catzc.Tooling.Core
    visibility: public
---
#>

<#
.SYNOPSIS
    Runs uv with the given arguments.
.DESCRIPTION
    The uv version lock is checked on every call, except a dry run, which needs no uv on the machine.
    [comment:1](/docs/references/automation/catzc-tooling-core/Invoke-Uv.ps1.md#comment1)
.PARAMETER Arguments
    Arguments to pass to uv.
.PARAMETER Prerelease
    Opt in only: it pulls dev-marked packages into a version-locked install, so it always emits a message.
    [comment:2](/docs/references/automation/catzc-tooling-core/Invoke-Uv.ps1.md#comment2)
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
    Invoke-Uv 'pip install azure-cli' -Prerelease
#>
function Invoke-Uv {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Arguments,
        [switch] $Prerelease,
        [switch] $PassThru,
        [switch] $NoAssert,
        [switch] $Silent,
        [switch] $DryRun
    )

    Assert-NotNullOrWhitespace $Arguments -ErrorText 'Arguments cannot be empty'

    if (-not $DryRun) {
        Assert-Tool 'uv'
    }

    if ($Prerelease) {
        # A message, not a warning: warnings stop this toolchain, and this opt-in relaxation is expected behaviour.
        # [comment:3](/docs/references/automation/catzc-tooling-core/Invoke-Uv.ps1.md#comment3)
        Write-Message "uv: allowing pre-release/dev package versions (--prerelease=allow) for: uv $Arguments"
        $Arguments = "$Arguments --prerelease=allow"
    }

    Invoke-Executable "uv $Arguments" -PassThru:$PassThru -NoAssert:$NoAssert -Silent:$Silent -DryRun:$DryRun
}
