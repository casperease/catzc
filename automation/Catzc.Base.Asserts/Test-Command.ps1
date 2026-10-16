<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Asserts/Test-Command.ps1
    kind: gate-function
    language: powershell
    track: automation
    module: Catzc.Base.Asserts
    visibility: public
    relatives:
      test: automation/Catzc.Base.Asserts/tests/Test-Command.Tests.ps1
  config:
    synopsis: Tests whether a command exists in the current session.
    parameters:
      Command: The command name to check.
    examples:
      - Test-Command 'git'
---
#>

function Test-Command {
    [OutputType([bool])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Command
    )

    $null -ne (Get-Command $Command -ErrorAction Ignore)
}
