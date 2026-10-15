<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Asserts/Test-Command.ps1
    kind: function
    module: Catzc.Base.Asserts
    visibility: public
---
#>

<#
.SYNOPSIS
    Tests whether a command exists in the current session.
.PARAMETER Command
    The command name to check.
.EXAMPLE
    Test-Command 'git'
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
