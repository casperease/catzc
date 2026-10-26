# pwsh/Base.ModuleSystem/Set-ImportMix.ps1

The importer's step that decides the session's [ImportMix](types/import-mix.md) once its modules are loaded, keeps it as the session
record, and removes the loaded modules whose code languages fall outside it. `Get-ImportMix` returns the kept record.

## help

### synopsis

Resolves the session's import mix, keeps it as the session record, and removes the loaded modules outside it.

### description

The importer calls it once its modules are loaded
([ADR-AUTO-IMPORTER-RESOLVEDAFTERLOAD](../../../drs/automation/importer.md#rule-adr-auto-importer-resolvedafterload)). Each axis is the
caller's value when given, else the importer configuration's, where auto resolves from the session. A module with a code language outside
the mix is removed
([ADR-AUTO-IMPORTER-CODELANGUAGESSELECTMODULES](../../../drs/automation/importer.md#rule-adr-auto-importer-codelanguagesselectmodules)), and
the removal is announced; nothing is announced when no module goes. Get-ImportMix returns the kept record.

### parameter `LanguageNames`

The languages of the mix. Default: importer.yml's languages, auto unless it names a list.

### parameter `Engines`

The execution engines of the mix. Default: importer.yml's engines, auto unless it names a list.

### parameter `DryRun`

Resolve and return the mix without keeping it or removing a module.

### outputs

`[Catzc.Base.ModuleSystem.ImportMix]` The resolved mix.

### example 1

```powershell
Set-ImportMix -LanguageNames powershell, csharp -DryRun
```
