<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Variants/private/Get-Variant.ps1
    folder: private
    name: get-variant
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Variants
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    cites:
      - ADR-AUTO-CACHE
---
#>

function Get-Variant {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Name
    )

    # The default of every variant is declared once on VariantsConfig; this reader only returns the typed value.
    (Get-Config -Config variants)[$Name]
}
