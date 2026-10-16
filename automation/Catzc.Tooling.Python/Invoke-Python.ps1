<#
---
catzc:
  immutable:
    path: automation/Catzc.Tooling.Python/Invoke-Python.ps1
    name: invoke-python
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Tooling.Python
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Tooling.Python/tests/Invoke-Python.Tests.ps1
  config:
    synopsis: Runs python with the given arguments.
    description: |-
      Asserts that the installed Python version matches the locked version
      in Get-ToolConfig before executing the command.
    parameters:
      Arguments: Arguments to pass to python.
      PassThru: Return a CliResult object with Output, Errors, Full, and ExitCode.
      NoAssert: Skip exit code assertion.
      Silent: Suppress the command log line.
      DryRun: Return the command string without executing. Used for testing.
    examples:
      - Invoke-Python '--version'
      - Invoke-Python '--version' -DryRun
---
#>

function Invoke-Python {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Arguments,
        [switch] $PassThru,
        [switch] $NoAssert,
        [switch] $Silent,
        [switch] $DryRun
    )

    Assert-NotNullOrWhitespace $Arguments -ErrorText 'Arguments cannot be empty — Python would enter interactive mode'

    if (-not $DryRun) {
        Assert-Tool 'python'
    }

    Invoke-Executable "python $Arguments" -PassThru:$PassThru -NoAssert:$NoAssert -Silent:$Silent -DryRun:$DryRun
}
