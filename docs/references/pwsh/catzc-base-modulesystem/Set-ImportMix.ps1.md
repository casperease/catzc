# pwsh/Catzc.Base.ModuleSystem/Set-ImportMix.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Resolves the session's import mix, keeps it as the session record, and removes the loaded modules outside it.

### description

The importer calls it once its modules are loaded
([ADR-AUTO-IMPORTER-RESOLVEDAFTERLOAD](../../../adr/automation/importer.md#rule-adr-auto-importer-resolvedafterload)). Each axis is the
caller's value when given, else the importer configuration's, where auto resolves from the session. A module with a code language outside
the mix is removed
([ADR-AUTO-IMPORTER-CODELANGUAGESSELECTMODULES](../../../adr/automation/importer.md#rule-adr-auto-importer-codelanguagesselectmodules)), and
the removal is announced; nothing is announced when no module goes. Get-ImportMix returns the kept record.

### parameter `Languages`

The languages of the mix. Default: importer.yml's languages, auto unless it names a list.

### parameter `Engines`

The execution engines of the mix. Default: importer.yml's engines, auto unless it names a list.

### parameter `DryRun`

Resolve and return the mix without keeping it or removing a module.

### outputs

`[Catzc.Base.ModuleSystem.ImportMix]` The resolved mix.

### example 1

```powershell
Set-ImportMix -Languages powershell, csharp -DryRun
```
