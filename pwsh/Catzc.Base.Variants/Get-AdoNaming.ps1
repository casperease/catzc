<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Variants/Get-AdoNaming.ps1
    name: get-ado-naming
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Variants
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Variants/tests/Get-AdoNaming.Tests.ps1
    docs: "[Get-AdoNaming.ps1.md](docs/references/pwsh/catzc-base-variants/Get-AdoNaming.ps1.md)"
---
#>

function Get-AdoNaming {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    "$(Get-Variant -Name ado_naming)"
}
