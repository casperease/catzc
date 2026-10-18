<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Variants/Get-AdoNaming.ps1
    name: get-ado-naming
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Variants
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Variants/tests/Get-AdoNaming.Tests.ps1
---
#>

function Get-AdoNaming {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    "$(Get-Variant -Name ado_naming)"
}
