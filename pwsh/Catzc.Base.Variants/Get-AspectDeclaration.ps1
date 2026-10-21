<#
---
catzc:
  immutable:
    with_body_sha: a21504902f78
  edges:
    test: pwsh/Catzc.Base.Variants/tests/Get-AspectDeclaration.Tests.ps1
    docs: "[Get-AspectDeclaration.ps1.md](docs/references/pwsh/catzc-base-variants/Get-AspectDeclaration.ps1.md)"
    cites:
      - ADR-REPO-VARIANT
---
#>

function Get-AspectDeclaration {
    [CmdletBinding()]
    [OutputType([System.Collections.Generic.IReadOnlyDictionary[string, System.Collections.Generic.IReadOnlyList[Catzc.Base.Variants.VariantAspect]]])]
    param()

    # The declared conventions over the built-in ones (VariantsConfig.DefaultAspects), keyed by track.
    , (Get-Variant -Name aspects)
}
