# pwsh/Catzc.Base.Maps/types/PlaceRows.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `[Catzc.Base.Objects.ConsoleDisplay(nameof(Rows), nameof(Counters))]`, written with `//`.

```text
The rows of the "Where does it live?" minimap (ADR-AUTO-IDIOM-PLACENORMALFORM). A place is the triple [track, module, folder] of the
code-locations minimap. A row is the path of its places from the repository root joined with the configured row join: the track, the
module as its normal-form name (prefix dropped, lower case, dots joined with the name join), and the module's lit sub-folders in order
joined by the fold separator, the module's own root written as the root marker. One row for a module, one for a track without modules.
The path is normalised by RepoRelativePath (ADR-AUTO-PATH) before it is read.
```

## comment:2

Above `public static PlaceRows From(IReadOnlyList<MinimapCell> lit,...`, written with `//`.

```text
The rows for the lit places of a code-locations minimap: one row for each module (or track without modules); while the rows are more
than the budget, the modules of the track with the most rows fold into one row naming the modules; then the first rows that fit, and
a count of the rest.
```

## comment:3

Above `public static string[][] Recover(string row, MapsMinimapPlaces places)`, written with `//`.

```text
The places a row names, back from its minimised form: one for a track or a module alone, one for each folder a module row joins. The
module comes back as its repository normal form (the prefix restored, the name join undone). A row that folds modules, elides a name
or names a count only names no place and throws.
```

## comment:4

Above `public static bool IsNormal(string row, MapsMinimapPlaces places)`, written with `//`.

```text
Whether a row is already in the one minimised form: at most three parts, a module name in lower case without the dropped prefix, the
joined names in order, and within the budget unless a single part is itself longer than it.
```

## comment:5

Above `private static string RowText(string track, string module, SortedSet<string>...`, written with `//`.

```text
The row of a module: all its names joined; else as many whole names as fit and then the elision; else the same with the module name
elided at a name-join boundary; and only when not even one name fits, the count of the places.
```

## comment:6

Above `public static PlaceRows From(IReadOnlyList<MinimapCell> primary,...`, written with `//`.

```text
The rows of a drawing's places: the primary places (the ones its own glyphs name) first, then the secondary places (the ones its
cited decision records name) one at a time while the rows still hold them. The counters line counts every place, the hidden ones too.
```

## comment:7

Above `private static string RowText(string track, string module, SortedSet<string>...`, written with `//`.

```text
A row never cuts a name: it holds every folder joined, or the count of them (`pwsh.azure.+3`); a place outside any module holds its
folder's segments and the count of those left out (`docs.explanation.+2`).
```
