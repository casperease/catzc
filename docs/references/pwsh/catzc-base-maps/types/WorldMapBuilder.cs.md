# pwsh/Base.Maps/types/WorldMapBuilder.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
Builds the world map from plain inputs, so a logic test needs no disk: the tracks (variants.yml), the file languages
(languages.yml), the tracked paths (the git index), the aspects per track (the live classification), the adrs index
(ADR code -> domain), each ADR code's own file (the registry's code -> file map, the one the link engine uses), the
text of the files that cite, the repository-root files' owners (files.yml: root file ->
the owning module's folder), and the globsets (globs.yml). Get-WorldMap gathers them from the repository.

Placement is exact: the root folder gives the track and the extension gives the file language
([DDR-TRACK-TRACKISPLACEDCLUSTER](/docs/drs/design/tracks.md#rule-ddr-track-trackisplacedcluster),
[DDR-TRACK-FILELANGUAGE](/docs/drs/design/tracks.md#rule-ddr-track-filelanguage)). A file under no track goes to the NoTrack row
and a file no file language names goes to the NoFileLanguage column, so every file has exactly one cell.

The stack check ([DDR-TRACK-ONETECHSTACK](/docs/drs/design/tracks.md#rule-ddr-track-onetechstack)) reads the live aspect only. A
file is live unless it is in a verification track, under a .vendor/ folder, or outside its track's live aspect. A
track with an aspects entry classifies by it: the unit is the track root's first folder, a file directly under the
root is its own unit, and the first aspect whose pattern matches the unit-relative path wins. A track without an
entry is live throughout. A live file with an extension whose file language the track does not declare is a stack
violation; a file without an extension is never one.

The highlight relation follows a fixed order per artifact kind:
  1. an ADR's own file (the file the registry maps its code to) carries that one ADR code, and lights for it alone;
  2. a file under no track carries the citations of the files in its owner's folder (files.yml), else its own;
  3. a file of the pipelines track carries its own citations, else those of the files of the globset whose
     pipeline key names it;
  4. every other file (module code included) carries its own citations.
A file a citation_exclude glob matches cites nothing at any step (maps.yml highlight.citation_exclude): it sits in its
cell, and its citations light nothing.
The registry types are named in full, so the module dependency gate sees each cross-module edge
([ADR-BCL-TYPES-REFERENCESFOLLOWDEPENDENCIES](/docs/drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-referencesfollowdependencies)).
```

## comment:2

Above `public static WorldMap Build(IEnumerable tracks, IEnumerable fileLanguages,...`, written with `//`.

```text
adrFiles: each ADR code's own file (ADR-<CODE> -> repository-relative path). citationExclude: the globs of the files
whose citations light nothing (maps.yml highlight.citation_exclude); such a file still sits in its cell. None when null.
```

## comment:3

Above `private static Catzc.Base.Variants.VariantTrack TrackOf(string path,...`, written with `//`.

```text
The track with the longest place that contains a '/'-separated path
([DDR-TRACKTYPE-LONGESTPLACEWINS](/docs/drs/design/track-types.md#rule-ddr-tracktype-longestplacewins)), or null when no place does.
```

## comment:4

Above `private static readonly string[] NeverLiveTypes = { "vendored-code" };`, written with `//`.

```text
Track types whose files are never live: code written by a third party; a test file is never live by its track's aspects, whatever the
track's type ([DDR-TRACK-STACKVIOLATION](/docs/drs/design/tracks.md#rule-ddr-track-stackviolation)).
```
