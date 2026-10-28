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

## Before you edit the diagram kit

The kit is the Python package `catzc-diagrams` in `python/diagrams/`, and five of its facts are found only in its code:

- **Reinstall after an edit.** The workspace runs an installed copy of the kit, so an edited `python/diagrams/*.py` reaches a render or a
  test only after `Install-PythonWorkspace -ReinstallPackage catzc-diagrams`
  ([install-python-workspace](../../references/pwsh/tooling-python/install-python-workspace.md)).
- **What the PNG raster paints.** `drawio_png_shapes.py` paints the glyph shapes by their style: a diamond only from the bare `rhombus`
  token, so `shape=rhombus` paints a square, and an embedded SVG only in the circle-and-line subset that `paint_svg` in `drawio_png.py`
  reads; it refuses any other SVG element by name. `embed_images.py` embeds PNG images only.
- **Where the glyph styles live.** Every glyph, edge and marker is a draw.io `mxCell` style in `python/diagrams/assets/glyphs.xml`, which
  the kit reads as its closed vocabulary; a new style starts there.
- **An SVG to PNG.** The devbox has no SVG rasterizer; headless Edge renders one, with `--screenshot` of a local HTML sheet that holds the
  SVG.
- **Contract paths.** The kit reads a module's contract under `contracts/`, its group folder derived in `module_paths.py` the way
  `Get-ContractGroup` derives it, and `assets/STYLE.md` names the minimap schema's path literally; a rename of a contract group edits both.

## See also

- [How to read the diagrams](../../explanation/index.md#how-to-read-the-diagrams)
