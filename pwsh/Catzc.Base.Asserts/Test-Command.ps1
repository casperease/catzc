<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-asserts/Test-Command.ps1.md"
  warning: "Generated Header"
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
