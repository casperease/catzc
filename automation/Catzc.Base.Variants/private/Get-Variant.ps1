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
  config:
    synopsis: Reads a single repo-wide variant from configs/variants.yml, as the typed value VariantsConfig holds.
    description: |-
      The one place variants.yml is read. Variants are fixed for the importer session (Get-Config caches the
      parsed config per session; re-run the importer to pick up an edit — see
      [ADR-AUTO-CACHE](/docs/adr/automation/caching.md)).
      The typed primitives (Get-AdoNaming, Test-HaveCustomers, …) are thin wrappers over this reader so the
      growing variant dictionary has a single access point. Private — callers use the named primitives. A key the
      file omits holds the default VariantsConfig declares once, so this reader names no default of its own
      ([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)).
    parameters:
      Name: The variant key (a top-level key of variants.yml, e.g. 'ado_naming').
    examples:
      - Get-Variant -Name ado_naming
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
