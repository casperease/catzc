<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/Get-BicepTemplateNames.ps1
    name: get-bicep-template-names
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
    relatives:
      test: automation/Catzc.Azure.Templates/tests/Get-BicepTemplateNames.Tests.ps1
  config:
    synopsis: Returns the names of all discovered bicep templates as a flat string array.
    description: |-
      The single source of the template-name list used by the ArgumentCompleter / ValidateScript
      blocks on every -Template parameter. Centralising it removes the repeated
      `Get-BicepTemplates | ForEach-Object { $_.name }` and the member-enumeration trap that the
      comma-wrapped Get-BicepTemplates return invites (see Get-BicepTemplate for the same caution).
    examples:
      - 'Get-BicepTemplateNames   # -> sample, sample-indexed, sample-subscription, sample-with-prepost'
---
#>

function Get-BicepTemplateNames {
    [OutputType([string[]])]
    param()

    # Assign first so the comma-wrapped array is collected, then enumerate element-by-element.
    $templates = Get-BicepTemplates
    @($templates | ForEach-Object { $_.name })
}
