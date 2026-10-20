<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Asserts/Assert-PsModule.ps1
    name: assert-ps-module
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
    test: pwsh/Catzc.Base.Asserts/tests/Assert-PsModule.Tests.ps1
    docs: "[Assert-PsModule.ps1.md](docs/references/pwsh/catzc-base-asserts/Assert-PsModule.ps1.md)"
---
#>

function Assert-PsModule {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Module,

        [string] $ErrorText
    )

    if (-not (Get-Module $Module -ListAvailable)) {
        $message = if ($ErrorText) {
            $ErrorText
        }
        else {
            "Module '$Module' is not available"
        }
        throw $message
    }
}
