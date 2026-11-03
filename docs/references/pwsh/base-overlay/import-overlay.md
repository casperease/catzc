# pwsh/Base.Overlay/Import-Overlay.ps1

The step that applies a consumer overlay to a loaded bundle: it checks the overlay as a whole, replaces the overridden functions inside
their modules, and loads nothing else.

## help

### synopsis

Applies the consumer overlay's function overrides to the loaded bundle, after checking the whole overlay.

### description

Runs at the end of a bundle load ([ADR-AUTO-OVERLAY](../../../drs/automation/consumer-overlay.md)). It checks the overlay first
(Assert-Overlay), so nothing applies unless all of it is valid. Then each override file replaces its function inside the bundled module, in
two steps:

1. the file is dot-sourced inside the module's own scope (`. $module { . $file }`), so the module's callers, its script state and Mock
   -ModuleName reach the override (a call with & would open a child scope and discard the definition);
2. a public override is published to the session's command table, where the import had put the original; its script block stays bound to the
   module, so it keeps running in the module's scope, and every other module, which resolves through the session, reaches the override too.

A folder under the overlay that names no bundled module loads nothing: it is a finding Assert-Overlay throws on, pointing at the consumer's
tracks, where the consumer's own modules load from
([ADR-AUTO-CONSUMER-SOURCEMODULES](../../../drs/automation/consumer-repository.md#rule-adr-auto-consumer-sourcemodules)).

Config fragments and asset overrides need no step here: Get-Config and Get-CatzcModuleRoot read them on demand.

### outputs

`[pscustomobject]` The function overrides applied (Kind, Module, Target, Visibility, File, RelativePath).

### example 1

```powershell
Import-Overlay
```
