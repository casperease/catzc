<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/Invoke-Go.ps1
    kind: public-function
    module: Catzc.Tooling.Toolchain
    visibility: public
  config:
    synopsis: Runs go with the given arguments.
    description: |-
      Asserts that the installed Go matches the locked version in Get-ToolConfig, then runs the executable the check
      located (Test-Tool -PassThru: the managed home first, then PATH), so the asserted Go is the one that runs.
    parameters:
      Arguments: Arguments to pass to go.
      PassThru: Return a CliResult object with Output, Errors, Full, and ExitCode.
      NoAssert: Skip exit code assertion.
      Silent: Suppress the command log line.
      DryRun: Return the command string without executing. Used for testing.
    examples:
      - Invoke-Go 'version'
      - Invoke-Go 'env GOROOT' -PassThru
---
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
