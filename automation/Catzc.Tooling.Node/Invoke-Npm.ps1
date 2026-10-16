<#
---
catzc:
  immutable:
    path: automation/Catzc.Tooling.Node/Invoke-Npm.ps1
    name: invoke-npm
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Tooling.Node
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  config:
    synopsis: Runs npm with the given arguments.
    description: |-
      Asserts that the installed npm version matches the locked version
      in Get-ToolConfig before executing the command.
    parameters:
      Arguments: Arguments to pass to npm.
      PassThru: Return a CliResult object with Output, Errors, Full, and ExitCode.
      NoAssert: Skip exit code assertion.
      Silent: Suppress the command log line.
      DryRun: Return the command string without executing.
    examples:
      - Invoke-Npm 'install'
      - Invoke-Npm 'run build' -PassThru
---
#>

function Invoke-Npm {
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
        Assert-Tool 'node_js'
    }

    Invoke-Executable "npm $Arguments" -PassThru:$PassThru -NoAssert:$NoAssert -Silent:$Silent -DryRun:$DryRun
}
