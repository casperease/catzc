# automation/Catzc.Base.Slides/Build-Diagrams.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Renders every draw.io slide of the repository from its source: the model embedded in each `.drawio.png` and the repository's maps.

### description

One command, no session in the loop: for every folder `diagram_folders` of `slides.yml` names (the folders whose slides carry the minimap
sidebar), or the folders `-Folder` names, it runs the draw.io kit's renderer (`drawio_forward.py --all`, through uv with Pillow) stage by
stage. `prepare` extracts each slide's model and writes the folder's slide list; `highlight` runs the map processors and renders each
slide's three minimaps and their stamped sister pages; `join` lays out the sidebar and rebuilds each slide in place. The per-slide stages
run in slices of `-Batch` slides, so each renderer call stays inside the uv time limit of `timeouts.yml`. A slide whose model names no ADR
code has no minimaps and is left as it is.

The renderer's exit codes decide the result: 0 is clean, 2 is warnings with every artifact delivered (reported, the run goes on), 3 is
nothing to render, and anything else stops the run with the renderer's last lines. The kit and the slice size are `drawio_kit` and
`diagram_batch` of `slides.yml`, with their defaults on `SlidesConfig`.

### parameter `Folder`

Repository-relative folders to render. Default: `diagram_folders` of `slides.yml`. A folder whose slides have no sidebar is not one to name:
the `join` stage would lay a sidebar out on every slide whose model names an ADR code.

### parameter `Stage`

`all` (the default) runs `prepare`, `highlight` and `join` in order; one stage name runs that stage alone.

### parameter `Batch`

How many slides one renderer call takes in the per-slide stages. Default: `diagram_batch` of `slides.yml`.

### parameter `Kit`

The draw.io kit folder that holds `drawio_forward.py`. Default: `drawio_kit` of `slides.yml`.

### parameter `RepositoryRoot`

The repository root the folders are relative to. Default: the loaded repository root.

### parameter `DryRun`

List the renderer calls without running them.

### parameter `PassThru`

Return one record per renderer call (`Folder`, `Stage`, `Start`, `End`, `ExitCode`, `Status`).

### outputs

`[pscustomobject]` one record per renderer call, with `-PassThru` only.

### example 1

```powershell
Build-Diagrams
```

### example 2

```powershell
Build-Diagrams -Folder docs/explanation/.assets -Stage highlight -DryRun
```
