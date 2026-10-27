# pwsh/Base.TypesSystem/Test-LoadedTypesCurrent.ps1

The query form of the loaded-types check: it tells whether the C# types loaded in this PowerShell process are current with their sources.

## help

### synopsis

Tests whether the C# types loaded in this PowerShell process are current with their sources.

### description

A loaded assembly cannot be unloaded or swapped in a running process: once a `types/*.cs` file changes after its types loaded, this process
keeps the old types until a new process loads the new ones
([ADR-PWSH-TYPES-RESTARTTORELOAD](../../../drs/automation/pwsh/hosting-csharp-types.md#rule-adr-pwsh-types-restarttoreload)). This answers
whether that has happened, from the one measurement the loader and the importer use (Get-LoadedTypeDrift in Catzc.Internal.Types):
$true when every type the code root's sources declare is loaded as written (or none is
loaded yet), $false when a source was added, changed,
or removed since the load, or the types were loaded on behalf of another code root and differ. It throws on nothing;
Assert-LoadedTypesCurrent is the throwing form.

### parameter `ModulesRoot`

The code root whose type sources to compare. Default: the loaded code root (Get-CatzcModulesRoot).

### outputs

`[bool]`

### example 1

```powershell
if (-not (Test-LoadedTypesCurrent)) { 'Open a new PowerShell to pick up the type changes.' }
```
