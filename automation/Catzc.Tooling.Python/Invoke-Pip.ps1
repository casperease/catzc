<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Python/Invoke-Pip.ps1
    kind: public-function
    module: Catzc.Tooling.Python
    visibility: public
  config:
    synopsis: Runs pip through uv (`uv pip`).
    description: |-
      Delegates to Invoke-Uv, so `Invoke-Pip 'install --system requests'` runs `uv pip install --system requests`
      against the uv-managed Python. uv is the standard Python handler; installs that target the global
      interpreter pass `--system` (see Install-PipTool). uv presence is asserted by Invoke-Uv.
    parameters:
      Arguments: Arguments to pass to `uv pip`.
      PassThru: Return a CliResult object with Output, Errors, Full, and ExitCode.
      NoAssert: Skip exit code assertion.
      Silent: Suppress the command log line and all console output.
      DryRun: Return the command string without executing. Used for testing.
    examples:
      - Invoke-Pip 'install --system requests'
      - Invoke-Pip 'list --format json' -DryRun
---
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
