<#
---
catzc:
  immutable:
    with_body_sha: "91ab6f7a80f2"
  edges:
    test: pwsh/Catzc.Base.Asserts/tests/Assert-Command.Tests.ps1
    docs: "[Assert-Command.ps1.md](docs/references/pwsh/catzc-base-asserts/Assert-Command.ps1.md)"
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
