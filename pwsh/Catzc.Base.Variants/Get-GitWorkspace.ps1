<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Variants/Get-GitWorkspace.ps1
    name: get-git-workspace
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
    test: pwsh/Catzc.Base.Variants/tests/Get-GitWorkspace.Tests.ps1
    docs: "[Get-GitWorkspace.ps1.md](docs/references/pwsh/catzc-base-variants/Get-GitWorkspace.ps1.md)"
---
#>

function Get-GitWorkspace {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    "$(Get-Variant -Name git_workspace)"
}
