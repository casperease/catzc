<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Asserts/Assert-Command.ps1
    name: assert-command
    filetype: ps1
    role: function
    subkind: assert
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Asserts
    moduletype: pwsh-folder
    catzc_bundle: minimal
    visibility: public
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
