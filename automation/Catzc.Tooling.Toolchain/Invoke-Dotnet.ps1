<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/Invoke-Dotnet.ps1
    kind: public-function
    module: Catzc.Tooling.Toolchain
    visibility: public
  config:
    synopsis: Runs dotnet with the given arguments.
    description: |-
      Asserts that the installed .NET SDK version matches the locked version
      in Get-ToolConfig before executing the command.
    parameters:
      Arguments: Arguments to pass to dotnet.
      PassThru: Return a CliResult object with Output, Errors, Full, and ExitCode.
      NoAssert: Skip exit code assertion.
      Silent: Suppress the command log line.
      DryRun: Return the command string without executing. Used for testing.
    examples:
      - Invoke-Dotnet 'build'
      - Invoke-Dotnet '--version' -DryRun
---
#>

function Invoke-Dotnet {
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
        Assert-Tool 'dotnet'
    }

    Invoke-Executable "dotnet $Arguments" -PassThru:$PassThru -NoAssert:$NoAssert -Silent:$Silent -DryRun:$DryRun
}
