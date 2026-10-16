<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Asserts/Assert-Command.ps1
    kind: assert-function
    language: powershell
    track: automation
    module: Catzc.Base.Asserts
    visibility: public
    relatives:
      test: automation/Catzc.Base.Asserts/tests/Assert-Command.Tests.ps1
  config:
    synopsis: Asserts that a command exists on the system.
    parameters:
      Command: The command name to look up via Get-Command.
      ErrorText: Custom error message. Defaults to '<Command> is not installed'.
    examples:
      - Assert-Command 'git'
---
#>

function Assert-Command {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Command,

        [string] $ErrorText = "$Command is not installed"
    )

    if (-not (Test-Command $Command)) {
        throw $ErrorText
    }
}
