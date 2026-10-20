# pwsh/Catzc.Base.Slides/Build-Diagrams.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Rebuilds diagram folders from their source: the model embedded in each `diagram.drawio.png` and the repository's maps.

### description

One command on one diagram folder, `<article-folder>/.assets/<name>/`, which holds a diagram's slide, its description and its three minimaps
under role names; with no `-Path` it repeats that for every diagram folder found under `docs/**/.assets/**`, so a folder is found, never
listed. For each folder it runs the draw.io kit's renderer (`drawio_forward.py --all <folder>`, through uv with Pillow) stage by stage:
`prepare` extracts the slide's model and writes its slide list; `highlight` runs the map processors and renders the three minimaps and their
stamped sister pages; `join` lays out the sidebar and rebuilds the slide in place. A slide whose model names no ADR code has no minimaps and
is left as it is.

Before it renders, each folder finds its article by locality: the one page beside the folder's `.assets` that embeds its
`diagram.drawio.png`. A folder no page there embeds is an orphan, reported and still rendered; a folder two pages embed stops the run.

The renderer's exit codes decide the result: 0 is clean, 2 is warnings with every artifact delivered (reported, the run goes on), 3 is
nothing to render, and anything else stops the run with the renderer's last lines. The kit is `drawio_kit` of `slides.yml`, with its default
on `SlidesConfig`.

### parameter `Path`

Repository-relative diagram folders to rebuild. Default: every diagram folder under `docs/**/.assets/**`. A path that is not a diagram
folder stops the run.

### parameter `Stage`

`all` (the default) runs `prepare`, `highlight` and `join` in order; one stage name runs that stage alone.

### parameter `Kit`

The draw.io kit folder that holds `drawio_forward.py`. Default: `drawio_kit` of `slides.yml`.

### parameter `RepositoryRoot`

The repository root the folders are relative to. Default: the loaded repository root.

### parameter `FromDrawing`

Sync the folders named by -Path after an edit, instead of running the renderer stages: get when the drawing moved since HEAD, then put, then
Test-Diagrams on the folders. A pair whose yml and png both moved since HEAD and disagree stops before put, naming its cells.

### parameter `Stale`

Rebuild only the diagrams whose minimaps a tree change left stale, the set Test-Diagrams reports; takes no -Path.

### parameter `DryRun`

List the renderer calls per folder without running them.

### parameter `PassThru`

Return one record per renderer call (`Folder`, `Article`, `Stage`, `ExitCode`, `Status`).

### outputs

`[pscustomobject]` one record per renderer call, with `-PassThru` only.

### example 1

```powershell
Build-Diagrams
```

### example 2

```powershell
Build-Diagrams -Path docs/explanation/configuration/.assets/an-address-is-a-read-only-walk -Stage highlight -DryRun
```

## comment:1

Above `if ($FromDrawing) {`, written with `#`.

```text
-FromDrawing syncs named folders after an edit: the kit's sync runs get when the drawing moved since HEAD, then put, and stops
on a conflict before put; the drift gate then checks the folders. No renderer stage runs.
```
