<#
.SYNOPSIS
    Runs uv with the given arguments.
.DESCRIPTION
    Asserts that uv is installed at the locked version before executing.
    [comment:1](/docs/references/automation/catzc-tooling-core/Invoke-Uv.ps1.md#comment1)
.PARAMETER Arguments
    Arguments to pass to uv.
.PARAMETER Prerelease
    Append `--prerelease=allow`, permitting pre-release/dev dependency versions in the resolution.
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
        # Pre-release resolution is a deliberate, config-driven relaxation of the version lock — surface it so it is...
        # [comment:3](/docs/references/automation/catzc-tooling-core/Invoke-Uv.ps1.md#comment3)
        Write-Message "uv: allowing pre-release/dev package versions (--prerelease=allow) for: uv $Arguments"
        $Arguments = "$Arguments --prerelease=allow"
    }

    Invoke-Executable "uv $Arguments" -PassThru:$PassThru -NoAssert:$NoAssert -Silent:$Silent -DryRun:$DryRun
}
