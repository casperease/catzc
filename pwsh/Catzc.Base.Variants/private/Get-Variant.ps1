<#
---
catzc:
  immutable:
    with_body_sha: "40d19cba548f"
  edges:
    docs: "[Get-Variant.ps1.md](../../../docs/references/pwsh/catzc-base-variants/private/Get-Variant.ps1.md)"
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
