<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Variants/private/Get-Variant.ps1
    folder: private
    name: get-variant
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.Variants
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    cites:
      - ADR-AUTO-CACHE
  config:
    synopsis: Reads a single repo-wide variant from configs/variants.yml, or a default when the key is absent.
    description: |-
      The one place variants.yml is read. Variants are fixed for the importer session (Get-Config caches the
      parsed config per session; re-run the importer to pick up an edit — see
      [ADR-AUTO-CACHE](/docs/adr/automation/caching.md)).
      The typed primitives (Get-AdoNaming, Test-HaveCustomers, …) are thin wrappers over this reader so the
      growing variant dictionary has a single access point. Private — callers use the named primitives.
    parameters:
      Name: The variant key (a top-level key of variants.yml, e.g. 'ado_naming').
      Default: The value to return when the key is absent from the file.
    examples:
      - Get-Variant -Name ado_naming -Default 'standard'
---
#>

function Get-Variant {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Name,

        [Parameter(Position = 1)]
        [AllowNull()]
        $Default
    )

    $variants = Get-Config -Config variants
    if ($variants.Contains($Name)) {
        return $variants[$Name]
    }
    $Default
}
