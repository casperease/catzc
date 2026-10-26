# pwsh/Base.Drs/types/DrsCitationForm.cs

Respells the citations of a markdown text between the two forms of the one citation spelling, chosen by the line's width
([ADR-REPO-LINK-ONECITATIONSPELLING](../../../../drs/repository/markdown-links.md#rule-adr-repo-link-onecitationspelling)). An inline
citation whose line outgrows the markdown width becomes a reference, its definition at the end of the file.

## ToReference

`ToReference` respells, on each listed line wider than the width, its inline citations as references, the longest destination first, until
the line fits. The label is plumbing: `r1`, `r2` and so on, in order of first use. A destination already defined keeps its label, and a new
one takes the next free number, so an existing label never moves and a definition stays as short as its destination allows.
