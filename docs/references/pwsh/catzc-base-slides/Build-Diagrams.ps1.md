# pwsh/Catzc.Base.Slides/Build-Diagrams.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Rebuilds diagram folders from their source: each folder's `diagram.drawio.yml` and the minimap data computed for it.

### description

One command on one diagram folder, `<article-folder>/.assets/<name>/`, which holds a diagram's `diagram.drawio.yml`, its one source, and the
`diagram.drawio.png` put from it; with no `-Path` it repeats that for every diagram folder found under `docs/**/.assets/**`, so a folder is
found, never listed. The run has two stages. First it writes the minimap data of every declared folder, the data the declaration's three
minimaps draw from; then it renders each folder with one call of the draw.io kit's renderer (`drawio_forward.py --all <folder>`, through uv
with Pillow), which puts the folder from its yml, the minimaps drawn from that data (ADR-REPO-SLIDES-MINIMAPSFROMDATA), or under
`-FromDrawing` it syncs each. A folder with no declaration gets no minimap data and is left to the renderer, which reports it.

Each stage prints one line per folder with its position, the folder, its status and its time, and the run ends with the total. A full run
over every folder takes minutes; the everyday journeys are `-Stale`, which rebuilds only what a tree change left stale, and `-Path`, which
rebuilds the folders named.

Before it renders, each folder finds its articles: every page anywhere in the tree that embeds its `diagram.drawio.png`. A folder no page
embeds is an orphan, reported and still rendered. Each page's Supports line is held against the folder's yml, and a mismatch is reported as
drift.

A single sample outside `docs/`, such as a folder under `out/diagrams/dark-sample/`, is put by hand in two calls: `Write-DiagramMinimapData`
run inside its module (`& (Get-Module Catzc.Base.Slides) { Write-DiagramMinimapData -Folder <folder> }`), then the kit's renderer's `put` on
the folder.

The renderer's exit codes decide the result: 0 is clean, 2 is warnings with every artifact delivered (reported, the run goes on), 3 is
nothing to render, and anything else stops the run with the renderer's last lines. The kit is `drawio_kit` of `slides.yml`, with its default
on `SlidesConfig`.

### parameter `Path`

Repository-relative diagram folders to rebuild. Default: every diagram folder under `docs/**/.assets/**`. A path that is not a diagram
folder stops the run.

### parameter `Kit`

The draw.io kit folder that holds `drawio_forward.py`. Default: `drawio_kit` of `slides.yml`.

### parameter `Theme`

The theme the renderer puts in. The default theme writes the committed png; another theme puts the declared folders to
`out/drawio/themes/<theme>/` and leaves the tree alone. Default: `theme` of `slides.yml`, declared once on SlidesConfig.

### parameter `RepositoryRoot`

The repository root the folders are relative to. Default: the loaded repository root.

### parameter `FromDrawing`

Sync the folders named by -Path after an edit, instead of running the renderer: get when the drawing moved since HEAD, then put, then
Test-Diagrams on the folders. A pair whose yml and png both moved since HEAD and disagree stops before put, naming its cells.

### parameter `Stale`

Rebuild only the diagrams whose minimaps a tree change left stale, the set Test-Diagrams reports; takes no -Path.

### parameter `DryRun`

List the renderer calls per folder without running them.

### parameter `PassThru`

Return one record per renderer call or sync (`Folder`, `Article`, `Stage`, `ExitCode`, `Status`); `Stage` is `render`, or
`sync (<the directions that ran>)` under -FromDrawing.

### outputs

`[pscustomobject]` one record per renderer call, with `-PassThru` only.

### example 1

```powershell
Build-Diagrams
```

### example 2

```powershell
Build-Diagrams -Path docs/explanation/configuration/.assets/an-address-is-a-read-only-walk -DryRun
```

## comment:1

Above `if ($FromDrawing) {`, written with `#`.

```text
-FromDrawing syncs named folders after an edit: the kit's sync runs get when the drawing moved since HEAD, then put, and stops
on a conflict before put; the drift gate then checks the folders. The renderer does not run.
```

## comment:2

Above `$tracked = @(Get-GitTrackedPath '.')`, written with `#`.

```text
A diagram folder is `<article-folder>/.assets/<name>/` holding a tracked diagram.drawio.png, or a diagram.drawio.yml tracked or not,
so a new folder gets its first put; it is found, never listed.
```
