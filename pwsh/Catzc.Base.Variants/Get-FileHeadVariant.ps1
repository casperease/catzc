<#
---
catzc:
  immutable:
    with_body_sha: c5f24bb3c093
  edges:
    test: pwsh/Catzc.Base.Variants/tests/Get-FileHeadVariant.Tests.ps1
    docs: "[Get-FileHeadVariant.ps1.md](../../docs/references/pwsh/catzc-base-variants/Get-FileHeadVariant.ps1.md)"
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
