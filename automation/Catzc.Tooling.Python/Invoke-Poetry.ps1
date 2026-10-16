<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Tooling.Python/Invoke-Poetry.ps1
    name: invoke-poetry
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
    test: automation/Catzc.Tooling.Python/tests/Invoke-Poetry.Tests.ps1
  config:
    synopsis: Runs poetry with the given arguments.
    description: |-
      Asserts that the installed Poetry version matches the locked version
      in Get-ToolConfig before executing the command.
    parameters:
      Arguments: Arguments to pass to poetry.
      PassThru: Return a CliResult object with Output, Errors, Full, and ExitCode.
      NoAssert: Skip exit code assertion.
      Silent: Suppress the command log line.
      DryRun: Return the command string without executing.
    examples:
      - Invoke-Poetry 'install'
      - Invoke-Poetry 'version' -PassThru
---
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
