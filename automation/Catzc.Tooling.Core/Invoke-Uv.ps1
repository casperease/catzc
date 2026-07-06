<#
.SYNOPSIS
    Runs uv with the given arguments.
.DESCRIPTION
    Asserts that uv is installed at the locked version before executing. uv is the standard Python handler —
    it provisions Python (`uv python`) and runs Python-based CLIs in isolated environments (`uv tool`,
    `uv pip`, `uv run`).
.PARAMETER Arguments
    Arguments to pass to uv.
.PARAMETER Prerelease
    Append `--prerelease=allow`, permitting pre-release/dev dependency versions in the resolution. This is a
    deliberate, surfaced choice — it emits a warning — because it pulls dev-marked packages into an otherwise
    version-locked install (e.g. the Azure CLI pins beta azure-* dependencies). Never enable it silently.
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
        # Pre-release resolution is a deliberate, config-driven relaxation of the version lock — surface it so it
        # is never silent. A message, not a warning: the toolchain runs with WarningPreference=Stop, and this is
        # expected (opt-in) behaviour, not an anomaly to halt on.
        Write-Message "uv: allowing pre-release/dev package versions (--prerelease=allow) for: uv $Arguments"
        $Arguments = "$Arguments --prerelease=allow"
    }

    Invoke-Executable "uv $Arguments" -PassThru:$PassThru -NoAssert:$NoAssert -Silent:$Silent -DryRun:$DryRun
}
