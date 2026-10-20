<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Variants/Get-AspectDeclaration.ps1
    name: get-aspect-declaration
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
