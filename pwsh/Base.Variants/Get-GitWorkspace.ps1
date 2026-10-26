<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-variants/Get-GitWorkspace.ps1.md"
  header: "generated"
---
#>

function Get-GitWorkspace {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    "$(Get-Variant -Name git_workspace)"
}
