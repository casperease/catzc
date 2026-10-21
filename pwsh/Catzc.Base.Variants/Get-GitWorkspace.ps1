<#
---
catzc:
  immutable:
    with_body_sha: "2bac1d0a9af9"
  edges:
    test: pwsh/Catzc.Base.Variants/tests/Get-GitWorkspace.Tests.ps1
    docs: "[Get-GitWorkspace.ps1.md](../../docs/references/pwsh/catzc-base-variants/Get-GitWorkspace.ps1.md)"
---
#>

function Get-GitWorkspace {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    "$(Get-Variant -Name git_workspace)"
}
