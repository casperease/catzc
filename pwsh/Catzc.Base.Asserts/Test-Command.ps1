<#
---
catzc:
  immutable:
    with_body_sha: d72ddf112bf9
  edges:
    test: pwsh/Catzc.Base.Asserts/tests/Test-Command.Tests.ps1
    docs: "[Test-Command.ps1.md](docs/references/pwsh/catzc-base-asserts/Test-Command.ps1.md)"
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
