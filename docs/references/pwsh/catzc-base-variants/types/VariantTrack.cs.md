# pwsh/Base.Variants/types/VariantTrack.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One track of the `tracks` variant (configs/variants.yml, [DDR-TRACK](/docs/drs/design/tracks.md)): a named
repository root concern, its root folder, its class from the taxonomy, and the file languages its tech-stack is
declared as ([DDR-TRACK-FILELANGUAGE](/docs/drs/design/tracks.md#rule-ddr-track-filelanguage)). The entry's fields mirror the
YAML keys, so the properties are snake_case
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](/docs/drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)); `name` is the entry's
YAML key. VariantsConfig validates the entry and builds one; Get-Track returns them.
```

## comment:2

Above `public IReadOnlyList<string> languages { get; }`, written with `//`.

```text
The file-language names of the track's declared tech-stack, in declared order. Empty when the track declares
none. The names are not resolved here: the file-language registry lives in Catzc.Base.Languages.
```

## comment:3

Above `public IReadOnlyDictionary<string, string> kinds { get; }`, written with `//`.

```text
The named kinds of the track's files: kind -> a place pattern inside one of its places, one '*' segment allowed
(e.g. configs -> infrastructure/templates/*/configuration). Empty when the track names none; membership is decided by places alone.
```

## comment:4

Above `public string join { get; }`, written with `//`.

```text
The join a track's language spells between its namespace and a folder name: catzc + "-" + track-lamps on the js track; empty for one
that joins with nothing, as go does.
```

## comment:5

Above `public IReadOnlyList<string> namespace_exempt { get; }`, written with `//`.

```text
The globs of the files that keep the namespace on disk because they name the product, not a module folder
(DDR-TRACK-MODULENAMESPACE): a loader psm1 PowerShell names its module after, the types assembly's identity.
```

## comment:6

Above `public string NamespaceSegmentOf(string path)`, written with `//`.

```text
The first segment of a '/'-separated repository-relative path below one of the track's places that spells the namespace in the
track's join form, as the path up to that segment; null when none does, the track declares no namespace, or an exempt glob
matches the path. The match is ordinal, as FolderNameOf strips: a segment spelling another track's form (catzc- under Catzc.)
names that track's identity, not this track's namespace.
```

## comment:7

Above `public int PlaceLengthOf(string path)`, written with `//`.

```text
The length of the longest member that contains a '/'-separated repository-relative path, or -1 when none does; a glob member
counts by its pattern's length, so a glob inside another track's place takes the files it names.
```
