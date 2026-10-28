# pwsh/Base.Maps/types/WorldMapBuilder.cs

Builds the world map from plain inputs, so a logic test needs no disk. `Get-WorldMap` gathers the inputs from the repository.

## Inputs

The tracks (`variants.yml`), the file languages (`languages.yml`), the tracked paths (the git index), the aspects per track (the live
classification), the DRS index (record code to domain), each record code's own file (the registry's code-to-file map, the one the link
engine uses), the text of the files that cite, the owners of the repository-root files (`files.yml`: root file to the owning module's
folder) and the globsets (`globs.yml`). `Build` also takes `citationExclude`, the globs of the files whose citations light nothing
(`highlight.citation_exclude`); such a file still sits in its cell. None when null.

## Placement

Placement is exact: the root folder gives the track and the extension gives the file language
([DDR-TRACK-ISPLACEDCLUSTER](../../../../drs/design/tracks.md#rule-ddr-track-isplacedcluster),
[DDR-TRACK-FILELANGUAGE](../../../../drs/design/tracks.md#rule-ddr-track-filelanguage)). A file under no track goes to the `NoTrack` row and
a file no file language names goes to the `NoFileLanguage` column, so every file has exactly one cell. The track of a path is the one with
the longest place that contains it
([DDR-TRACKTYPE-LONGESTPLACEWINS](../../../../drs/design/track-types.md#rule-ddr-tracktype-longestplacewins)).

## The stack check

The stack check ([DDR-TRACK-ONETECHSTACK](../../../../drs/design/tracks.md#rule-ddr-track-onetechstack)) reads the live aspect only. A file
is live unless it is in a verification track, under a `.vendor/` folder, or outside its track's live aspect. Tracks of a never-live type
(third-party code, `vendored-code`) have no live files, and a test file is never live by its track's aspects, whatever the track's type
([DDR-TRACK-STACKVIOLATION](../../../../drs/design/tracks.md#rule-ddr-track-stackviolation)). A track with an aspects entry classifies by
it: the unit is the track root's first folder, a file directly under the root is its own unit, and the first aspect whose pattern matches
the unit-relative path wins. A track without an entry is live throughout. A live file with an extension whose file language the track does
not declare is a stack violation; a file without an extension is never one.

## The highlight relation

The relation follows a fixed order per artifact kind:

1. a record's own file (the file the registry maps its code to) carries that one record code, and lights for it alone;
2. a file under no track carries the citations of the files in its owner's folder (`files.yml`), else its own;
3. a file of the pipelines track carries its own citations, else those of the files of the globset whose pipeline key names it;
4. every other file, module code included, carries its own citations.

A file a `citation_exclude` glob matches cites nothing at any step: it sits in its cell, and its citations light nothing.

## Why the registry types are named in full

The registry types are named in full, so the module dependency check sees each cross-module edge
([ADR-BCL-TYPES-REFERENCESFOLLOWDEPS](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-referencesfollowdeps)).
