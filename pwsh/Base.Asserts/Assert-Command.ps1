<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-asserts/Assert-Command.ps1.md"
  header: "generated"
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
