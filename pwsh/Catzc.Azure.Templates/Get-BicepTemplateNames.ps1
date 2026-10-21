<#
---
catzc:
  immutable:
    with_body_sha: "1ee4402eed0e"
  edges:
    test: pwsh/Catzc.Azure.Templates/tests/Get-BicepTemplateNames.Tests.ps1
    docs: "[Get-BicepTemplateNames.ps1.md](../../docs/references/pwsh/catzc-azure-templates/Get-BicepTemplateNames.ps1.md)"
---
#>

function Get-BicepTemplateNames {
    [OutputType([string[]])]
    param()

    # Assign first so the comma-wrapped array is collected, then enumerate element-by-element.
    $templates = Get-BicepTemplates
    @($templates | ForEach-Object { $_.name })
}
