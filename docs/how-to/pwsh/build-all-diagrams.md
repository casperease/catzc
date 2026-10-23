# Build all diagrams

How do I render every diagram in the repository from its yml, whether the yml is embedded in an article or a file beside the png?

Run `Build-Diagrams` with no path from the repository root. It finds every tracked diagram, reads each declaration from its carrier, writes
the minimap data, and renders the png ([ADR-REPO-SLIDES](../../drs/repository/slides-as-markdown.md)).

```powershell
. ./importer.ps1
Build-Diagrams
```

A pair whose yml and png both moved since the last commit is a conflict: the build skips it and names its cells in the report under
`out/drawio/bulk/`. Put or get that one diagram by name to pick the side that wins, then build again.

## See also

- [How to read the diagrams](../../explanation/index.md#how-to-read-the-diagrams)
