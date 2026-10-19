# pwsh/Catzc.Base.Modules/Get-CatzcModule.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the modules of the deployable tracks, resolved through their track.

### description

The one resolver of a module
([ADR-AUTO-MODULE-DEPLOYABLETRACKMODULE](../../../adr/automation/module-model.md#rule-adr-auto-module-deployabletrackmodule)). For each
deployable track (Get-Track, by its track type) it takes the module types the track type admits, finds the modules those types place under
the track's places, and returns each as a Catzc.Base.Modules.Module: name, track, module type, place, root, shape, files, languages, engines
and the files the layout does not place. A module exists when its files stand in the layout, so nothing registers it
([ADR-AUTO-MODULE-EXISTSBYLAYOUT](../../../adr/automation/module-model.md#rule-adr-auto-module-existsbylayout)). No track root is spelled
here: the places come from the track, and the code track is anchored on the loaded code root (Get-CatzcModulesRoot) unless -RepositoryRoot
names a tree.

A folder under a place is a module unless its name starts with a dot. The modules a nested place holds (the internal modules under the code
track) are left out unless -IncludeInternal asks for them. Modules come in the track's declared order, then in ordinal order of their names.
A module's languages are those of its live files (the layout marks tests and READMEs not live). A module is laid out, and its unplaced files
are reported, only when its track's primary language (the first it declares) owns layout rows in languages.yml.

It rests on [ADR-PWSH-ENUM-ALWAYSBOUNDED](../../../adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum-alwaysbounded).

### parameter `Name`

The module name(s) to return. A name no module has returns nothing for it.

### parameter `Track`

The deployable track name(s) to look in. Defaults to every deployable track. An unknown track throws.

### parameter `TrackType`

Only the tracks of these track types ('modules' is the code track). Defaults to every deployable track type.

### parameter `IncludeInternal`

Also return the modules of nested places, such as the internal modules under the code track.

### parameter `EngineTrack`

Only the track whose modules run under the engine this resolver runs in, named by its `execution_engines`: the modules the importer loads
and the dependency graph declares, the ones the relocatable modules root holds.

### parameter `RepositoryRoot`

The tree to resolve in, holding the tracks' places. Defaults to the loaded code root for the code track and the repository root for any
other; pass a fixture tree to isolate a logic test.

### outputs

`[Catzc.Base.Modules.Module]` One per module.

### example 1

```powershell
(Get-CatzcModule).name                              # -> every module of the deployable tracks
```

### example 2

```powershell
(Get-CatzcModule -TrackType modules).name           # -> the code track's modules, the ones the dependency graph orders
```

### example 3

```powershell
(Get-CatzcModule -Name Catzc.Base.Modules).languages  # -> csharp, markdown, powershell
```

### example 4

```powershell
Get-CatzcModule | Where-Object { $_.unplaced }       # -> the modules with a file in no layout row
```
