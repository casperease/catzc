<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Variants/private/Get-Variant.ps1
    folder: private
    name: get-variant
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Variants
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    docs: "[Get-Variant.ps1.md](docs/references/pwsh/catzc-base-variants/private/Get-Variant.ps1.md)"
    cites:
      - ADR-AUTO-CACHE
      - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
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
