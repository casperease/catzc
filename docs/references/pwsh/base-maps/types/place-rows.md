# pwsh/Base.Maps/types/PlaceRows.cs

The rows of the "Where does it live?" minimap
([ADR-AUTO-IDIOM-PLACENORMALFORM](../../../../drs/automation/idiomatic-names.md#rule-adr-auto-idiom-placenormalform)), built within the
budget of `MapsMinimapPlaces`.

## A row

A place is the triple `[track, module, folder]` of the code-locations minimap. A row is the path of its places from the repository root,
joined with the configured row join: the track, the module as its normal-form name (prefix dropped, lower case, dots joined with the name
join), and the module's lit sub-folders in order, joined by the fold separator, with the module's own root written as the root marker. There
is one row for a module and one for a track without modules. The path is normalised as a repository-relative path before it is read.

A row never cuts a name. It holds every folder joined, or the count of them (`pwsh.azure.+3`). A place outside any module holds its folder's
segments and the count of those left out (`docs.explanation.+2`). The row of a module holds all its names joined; else as many whole names
as fit and then the elision; else the same with the module name elided at a name-join boundary; and only when not even one name fits, the
count of the places.

## Which rows are drawn

`From` builds the rows for the lit places of a code-locations minimap. While the rows are more than the budget, the modules of the track
with the most rows fold into one row naming the modules. Then the first rows that fit are kept, and a count stands for the rest. The
two-list form takes the primary places, the ones the drawing's own glyphs name, first, then the secondary places, the ones its cited
decision records name, one at a time while the rows still hold them. The counters line counts every place, the hidden ones too.

## Is a row normal

`IsNormal` says whether a row is already in the one minimised form: at most three parts, a module name in lower case without the dropped
prefix, the joined names in order, and within the budget unless a single part is itself longer than it. `Test-PlaceRows` uses it.
