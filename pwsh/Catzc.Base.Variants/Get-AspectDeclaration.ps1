<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-variants/Get-AspectDeclaration.ps1.md"
  warning: "Generated Header"
---
#>

function Get-AspectDeclaration {
    [CmdletBinding()]
    [OutputType([System.Collections.Generic.IReadOnlyDictionary[string, System.Collections.Generic.IReadOnlyList[Catzc.Base.Variants.VariantAspect]]])]
    param()

    # The declared conventions over the built-in ones (VariantsConfig.DefaultAspects), keyed by track.
    , (Get-Variant -Name aspects)
}
