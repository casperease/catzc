<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-variants/private/Get-Variant.ps1.md"
  header: "generated"
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
