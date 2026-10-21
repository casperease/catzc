<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Variants/Get-FileHeadVariant.ps1
    name: get-file-head-variant
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
    test: pwsh/Catzc.Base.Variants/tests/Get-FileHeadVariant.Tests.ps1
    docs: "[Get-FileHeadVariant.ps1.md](docs/references/pwsh/catzc-base-variants/Get-FileHeadVariant.ps1.md)"
    cites:
      - ADR-REPO-VARIANT-FILEHEADS
---
#>

function Get-FileHeadVariant {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    "$((Get-Variant -Name file_heads).code)"
}
