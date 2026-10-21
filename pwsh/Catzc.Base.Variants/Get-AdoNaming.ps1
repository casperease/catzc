<#
---
catzc:
  immutable:
    with_body_sha: e2cb53de4a48
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
