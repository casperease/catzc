<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-azure-templates/Get-BicepTemplateNames.ps1.md"
  warning: "Generated Header"
---
#>

function Get-BicepTemplateNames {
    [OutputType([string[]])]
    param()

    # Assign first so the comma-wrapped array is collected, then enumerate element-by-element.
    $templates = Get-BicepTemplates
    @($templates | ForEach-Object { $_.name })
}
