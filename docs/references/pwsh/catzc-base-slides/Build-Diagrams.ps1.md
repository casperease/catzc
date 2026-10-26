# pwsh/Base.Slides/Build-Diagrams.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Rebuilds diagrams from their source: each diagram's `<name>.drawio.yml` and the minimap data computed for it.

### description

One command on one diagram, the pair `<article-folder>/.assets/<name>.drawio.yml`, its one source, and the `<name>.drawio.png` put from it,
named by either file or by its stem `.assets/<name>`; with no `-Path` it repeats that for every diagram found under `docs/**/.assets/`, so a
diagram is found, never listed. The run has two stages. First it writes the minimap data of every declared diagram, the data the
declaration's three minimaps draw from (under `-Stale`, the `Test-Diagrams` call that found the set has already written it); then it renders
every diagram in one call of the draw.io kit's renderer (`drawio_forward.py --all <stem> ...`, through uv with Pillow), which ends each
diagram with a JSON row of its exit code and puts the diagram from its yml, the minimaps drawn from that data
(ADR-REPO-SLIDES-MINIMAPSFROMDATA), or under `-FromDrawing` it syncs each. A diagram with no declaration gets no minimap data and is left to
the renderer, which reports it.

Each stage prints one line per diagram with its position, the diagram, its status and its time, and the run ends with the total. A full run
over every diagram takes minutes; the everyday journeys are `-Stale`, which rebuilds only what a tree change left stale, and `-Path`, which
rebuilds the diagrams named. A tree `-Stale` run takes about 210 seconds, so it and a tree `Test-Diagrams` run as two calls, each under the
360-second roof.

Before it renders, each diagram finds its articles: every page anywhere in the tree that embeds its `<name>.drawio.png`. A diagram no page
embeds is an orphan (`E_ORPHAN`), and a page whose Supports line disagrees with the diagram's yml is drift (`E_SUPPORTS`); each is a
finding, and every finding is an error that stops the run before it renders, by the one setting `renderer: findings-fail` of the kit's
`drawio.yml`.

A single sample outside `docs/`, such as a pair under `out/diagrams/dark-sample/`, is put by hand in two calls: `Write-DiagramMinimapData`
run inside its module (`& (Get-Module Catzc.Base.Slides) { Write-DiagramMinimapData -Stem <stem> }`), then the kit's renderer's `put` on the
diagram.

The renderer's exit codes decide the result: 0 is clean, 2 is findings (errors) with every artifact delivered, which stops the run, 3 is
nothing to render, and anything else stops the run with the renderer's last lines. The kit is `drawio_kit` of `slides.yml`, with its default
on `SlidesConfig`.

### parameter `Path`

Repository-relative diagrams to rebuild, each named by its `.drawio.yml`, its `.drawio.png` or its stem. Default: every diagram under
`docs/**/.assets/`. A path that is not a diagram stops the run.

### parameter `Kit`

The draw.io kit folder that holds `drawio_forward.py`. Default: `drawio_kit` of `slides.yml`.

### parameter `Theme`

The theme the renderer puts in. The default theme writes the committed png; another theme puts the declared diagrams to
`out/drawio/themes/<theme>/` and leaves the tree alone. Default: `theme` of `slides.yml`, declared once on SlidesConfig.

### parameter `RepositoryRoot`

The repository root the diagrams are relative to. Default: the loaded repository root.

### parameter `FromDrawing`

Sync the diagrams named by -Path after an edit, instead of running the renderer: get when the drawing moved since HEAD, then put, then
Test-Diagrams on the diagrams. A pair whose yml and png both moved since HEAD and disagree stops before put, naming its cells.

### parameter `Workers`

The worker processes the one renderer call splits the diagrams across, each with a disjoint slice. Default: `render_parallel` of
slides.yml.

### parameter `Stale`

Rebuild only the diagrams whose minimaps a tree change left stale, the set Test-Diagrams reports; takes no -Path.

### parameter `DryRun`

List the renderer calls per diagram without running them.

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
Build-Diagrams -Path docs/explanation/configuration/.assets/an-address-is-a-read-only-walk.drawio.yml -DryRun
```

## comment:1

Above `if ($FromDrawing) {`, written with `#`.

```text
-FromDrawing syncs named diagrams after an edit: the kit's sync runs get when the drawing moved since HEAD, then put, and stops
on a conflict before put; the drift gate then checks the diagrams. The renderer does not run.
```

## comment:2

Above `$tracked = @(Get-GitTrackedPath '.')`, written with `#`.

```text
A diagram is the pair `<article-folder>/.assets/<name>.drawio.png` and `.drawio.yml`, found by a tracked png or a yml tracked or not,
so a new diagram gets its first put; it is found, never listed.
```

## comment:3

Above ``$quoted = ($folders | ForEach-Object { "`"$(Join-Path $root $_)`"" }) -join ' '``, written with `#`.

```text
One renderer call takes every folder and splits it across its workers, each paying uv, python and the kit's imports once;
it ends each folder with a JSON row, in folder order.
```

## comment:4

Above `$rowsPath = Join-Path (Get-OutputRoot -EnsureExists) 'diagrams/query-rows.json'`, written with `#`.

```text
A C3 or C4 slide's cells are its query's rows, written to an address named here and handed to the renderer
(DDR-VISUAL-ZOOMISANAXIS).
```

## comment:5

Above `$rowsPath = Join-Path (Get-OutputRoot -EnsureExists) 'diagrams/query-rows.json'`, written with `#`.

```text
The query rows go to an address named here, never a default
([DDR-VISUAL-ZOOMISANAXIS](/docs/drs/design/visual-design.md#rule-ddr-visual-zoomisanaxis)).
```

## comment:6

Above `$stalePaths = @((Test-Diagrams -Kit $Kit -RepositoryRoot $root...`, written with `#`.

```text
The stale set is checked before it becomes -Path, whose ValidatePathGiven refuses an empty list on assignment
too.
```

## comment:7

Above `$found = @($candidates | Where-Object { $_ -cmatch...`, written with `#`.

```text
A diagram is the pair <article-folder>/.assets/<name>.drawio.png and .yml, named by its stem
<article-folder>/.assets/<name>.
```

## comment:8

Above `$found = @($found) + @(Get-DiagramArticleStem -RepositoryRoot $root...`, written with `#`.

```text
A diagram in the article carrier has no yml beside its png, and before its first put no png either: its block
names it.
```

## comment:9

Above `$embedders = Get-DiagramEmbedder -Tracked $tracked -RepositoryRoot $root`, written with `#`.

```text
Every article and slide that embeds a diagram's png, wherever it sits; each one's Supports line is held against
the yml.
```

## comment:10

Above `$index = 0`, written with `#`.

```text
One call builds the world map once for every diagram; each diagram's target streams back as its data is
written.
```

## comment:11

Above `$run.Status = switch ($run.ExitCode) {`, written with `#`.

```text
The renderer's exit codes: 0 clean, 2 findings (errors) with every artifact delivered, 3 nothing to
render; no row is a failure.
```
