# A diagram's minimaps are one projection, computed from data and never drawn by hand

A minimap is one projection of the repository: a small map a `Get-*` command computes over the generated truths, the kind of output
[ADR-REPO-SLIDES-MINIMAPSFROMDATA](../../drs/repository/slides-as-markdown.md#rule-adr-repo-slides-minimapsfromdata) governs. This page
holds what is particular to the minimaps a diagram shows.

## Slots, ids and pools

A diagram shows exactly three minimaps: the ones its declaration names, or its kind's three defaults from the pools `maps.yml` declares,
each one of the eight minimap ids.

## The data and its inputs

A minimap's data is computed, never drawn by hand and never stored in the declaration: `Catzc.Base.Maps` projects the diagram's subject, the
rule codes in `about.rules` and the files that cite them, onto the minimap's axes with the data command `maps.yml` names for its id, and
every lit cell carries its reason. The declaration holds only the inputs: `about.rules`, and under `content.minimaps` the ids of the
minimaps it shows, each with an optional `exclude:` list of the cells its author rejects. A drawn minimap lights the computed cells less the
excluded ones, so a citing file that is added or moves changes the drawing and leaves the declaration as it is.

## Place rows

A place in a minimap is written in its place normal form
([ADR-AUTO-IDIOM-PLACENORMALFORM](../../drs/automation/idiomatic-names.md#rule-adr-auto-idiom-placenormalform)). When there are more rows
than the budget, the modules of one track fold into one row naming the modules (`pwsh.base_drs|base_maps|base_variants`) or, when the names
do not fit, the count of their places (`pwsh.+9`), and rows still over the budget are left out. The places come first from the drawing's own
glyphs, each code or file glyph's label resolved to the repository place it names (a command by its function file, a type by its types
folder, a file by its name, a module by its manifest), and from the cited records only while rows remain: a label that names no repository
file is dropped and counted, and the docs places of the cited records are dropped when the drawing draws no doc. The counters line says
every place there is: `N places`, and `+k more · N places` when the rows hide places. The budget, the row join, the name join, the root
marker, the fold separator and the count prefix are configuration of the maps config, and a minimap's rows are computed once, beside its
data, by `Catzc.Base.Maps` from the labels the declaration carries (a minimap input, never a computed row stored in it); a drawing prints
the rows as given and cuts nothing itself.

`PlaceRows` of `Catzc.Base.Maps` turns the lit places of the code-locations minimap into their rows and counters line, from the
`minimaps.places` budget of the maps config, and carries them in the minimap data as `place_rows`; `Get-CodeLocationsMinimapData` attaches
them, and the diagram kit prints them as given.

## Where the data lives

The data is contract JSON ([ADR-REPO-CONTRACT](../../drs/repository/api-contracts.md)), written to `out/minimaps/` by `Build-Diagrams` and
`Test-Diagrams` and never written back; the kit validates it and only draws it, and no minimap file lives beside a diagram. A diagram whose
data is missing does not put.
