# pwsh/Base.Modules/Get-CatzcModule.ps1

The one resolver of the modules of the deployable tracks: it finds them by their layout on disk and returns each as a
`Catzc.Base.Modules.Module`.

## help

### synopsis

Returns the modules of the deployable tracks, resolved through their track.

### description

The one resolver of a module
([ADR-AUTO-MODULE-DEPLOYABLETRACKMODULE](../../../drs/automation/module-model.md#rule-adr-auto-module-deployabletrackmodule)). For each
deployable track (Get-Track, by its track type) it takes the module types the track type admits, finds the modules those types place under
the track's places, and returns each as a Catzc.Base.Modules.Module: name, track, module type, place, root, shape, files, languages, engines
and the files the layout does not place. A module exists when its files stand in the layout, so nothing registers it
([ADR-AUTO-MODULE-EXISTSBYLAYOUT](../../../drs/automation/module-model.md#rule-adr-auto-module-existsbylayout)). No track root is spelled
here: the places come from the track, and the code track is anchored on the loaded code root (Get-CatzcModulesRoot) unless -RepositoryRoot
names a tree.

A folder under a place is a module unless its name starts with a dot. The modules a nested place holds (the internal modules under the code
track) are left out unless -IncludeInternal asks for them. Modules come in the track's declared order, then in ordinal order of their names.
A module's languages are those of its live files (the layout marks tests and READMEs not live). A module is laid out, and its unplaced files
are reported, only when its track's primary language (the first it declares) owns layout rows in languages.yml.

It rests on [ADR-PWSH-ENUM-ALWAYSBOUNDED](../../../drs/automation/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum-alwaysbounded).

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

## comment:1

Above `$engine = [Catzc.Base.Engines.ExecutionEngines]::Pwsh.Name`, written with `#`.

```text
The engine this resolver runs in: the track whose modules run under it is the one the relocatable modules root
holds.
```

## comment:2

Above `$nestedPlaces = @($allTracks.Where({ $_.name -cne $trackEntry.name }) |...`, written with `#`.

```text
A place of another track nested under this track's places holds its own files
([DDR-TRACKTYPE-LONGESTPLACEWINS](/docs/drs/design/track-types.md#rule-ddr-tracktype-longestplacewins)).
```

## comment:3

Above `$prefixLength = $entry.Folder.TrimEnd('\', '/').Length + 1`, written with `#`.

```text
A whole module tree is listed on purpose, a named exception to the bounded walk: tests nest
fixtures up to six levels below the module.
```

## comment:4

Above `$full = "$($entry.Root)/$relative"`, written with `#`.

```text
The track's own module holds what no other place of the track names, no nested track
holds, and no dot folder caches.
```

## comment:5

Above `$language = $null -eq $row -or $row.live ? $languages.ForPath($file) : $null`, written with `#`.

```text
The languages of a module are those of its live files: a test, or a README, is no second
tech-stack.
```

## comment:6

Above `$fullName = $entry.Shape -ceq 'folder' ? $trackEntry.FullNameOf($entry.Name)...`, written with `#`.

```text
A module is named by its full name, its folder joined to the track's namespace
([DDR-TRACK-MODULENAMESPACE](/docs/drs/design/tracks.md#rule-ddr-track-modulenamespace)).
A file-shaped module (a pwsh/.internal Catzc.Internal.*.psm1) already carries its full name: a declared global exemption.
```
