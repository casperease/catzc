<#
---
catzc:
  derived:
    path: automation/Catzc.Base.TypesSystem/Test-LoadedTypesCurrent.ps1
    kind: gate-function
    language: powershell
    track: automation
    module: Catzc.Base.TypesSystem
    visibility: public
    relatives:
      test: automation/Catzc.Base.TypesSystem/tests/Test-LoadedTypesCurrent.Tests.ps1
    adrs:
      - ADR-AUTO-TYPES#7
  config:
    synopsis: Tests whether the C# types loaded in this PowerShell process are current with their sources.
    description: |-
      A loaded assembly cannot be unloaded or swapped in a running process: once a types/*.cs file changes after its
      types loaded, this process keeps the old types until a new process loads the new ones
      ([ADR-AUTO-TYPES#7](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types7)). This answers whether
      that has happened, from the one measurement the loader and the importer use (Get-LoadedTypeDrift in
      Catzc.Internal.Types): $true when every type the code root's sources declare is loaded as written (or none is
      loaded yet), $false when a source was added, changed, or removed since the load, or the types were loaded on
      behalf of another code root and differ. It throws on nothing; Assert-LoadedTypesCurrent is the throwing form.
    parameters:
      ModulesRoot: 'The code root whose type sources to compare. Default: the loaded code root (Get-CatzcModulesRoot).'
    outputs: '[bool]'
    examples:
      - if (-not (Test-LoadedTypesCurrent)) { 'Open a new PowerShell to pick up the type changes.' }
---
#>

function Test-LoadedTypesCurrent {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [string] $ModulesRoot = (Get-CatzcModulesRoot)
    )

    Import-InternalModule Types
    (Get-LoadedTypeDrift -ModulesRoot $ModulesRoot).Current
}
