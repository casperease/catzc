<#
---
catzc:
  immutable:
    path: automation/Catzc.Tooling.Core/Invoke-Uv.ps1
    name: invoke-uv
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Tooling.Core
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-tooling-core/Invoke-Uv.ps1.md
  config:
    synopsis: Runs uv with the given arguments.
    description: |-
      Asserts that uv is installed at the locked version before executing. uv is the standard Python handler —
      it provisions Python (`uv python`) and runs Python-based CLIs in isolated environments (`uv tool`,
      `uv pip`, `uv run`).
    parameters:
      Arguments: Arguments to pass to uv.
      Prerelease: |-
        Append `--prerelease=allow`, permitting pre-release/dev dependency versions in the resolution. This is a
        deliberate, surfaced choice — it emits a warning — because it pulls dev-marked packages into an otherwise
        version-locked install (e.g. the Azure CLI pins beta azure-* dependencies). Never enable it silently.
      PassThru: Return a CliResult object with Output, Errors, Full, and ExitCode.
      NoAssert: Skip exit code assertion.
      Silent: Suppress the command log line.
      DryRun: Return the command string without executing. Used for testing.
    examples:
      - Invoke-Uv 'tool install azure-cli'
      - Invoke-Uv 'pip install azure-cli' -Prerelease
---
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
        Write-Message "uv: allowing pre-release/dev package versions (--prerelease=allow) for: uv $Arguments"
        $Arguments = "$Arguments --prerelease=allow"
    }

    Invoke-Executable "uv $Arguments" -PassThru:$PassThru -NoAssert:$NoAssert -Silent:$Silent -DryRun:$DryRun
}
