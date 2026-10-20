# pwsh/Catzc.Base.Slides/Test-Diagrams.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The diagrams quality gate; fails every declared diagram whose png differs from put of its yml, and reports the minimaps a registry change
left stale.

### description

A declared diagram is a folder under a `.assets/` folder holding a tracked `diagram.drawio.png` beside its `diagram.drawio.yml`. The gate
runs the draw.io kit's `declaration.py check` over each declared folder through uv and reads one JSON line per folder: the cells whose png
differs from put of the yml are issues, a kit or folder error is an issue, and a minimap a registry change left stale is announced and
counted in the report facts without failing the gate. It writes no diagram; the render is Build-Diagrams'. The result goes through the
quality-gate report.

### parameter `Path`

Declared diagram folders, repository-relative or absolute. A folder that is not a declared diagram throws. The default is every declared
diagram.

### parameter `Kit`

The draw.io kit folder, repository-relative, holding `declaration.py`. The default is the slides config's `drawio_kit`.

### parameter `RepositoryRoot`

The repository root the diagrams and the kit are under.

### parameter `OutputFolder`

Where the gate report lands. The default is the quality-gate report's own.

### parameter `PassThru`

Return the report object as well.

### outputs

`[Catzc.Base.Reports.QualityGateResult]` The quality-gate report, with -PassThru.

### example 1

```powershell
Test-Diagrams
```

### example 2

```powershell
Test-Diagrams -Path docs/explanation/thesis/.assets/product-thesis
```

## comment:1

Above ``foreach ($line in @($result.Output -split "`r?`n" | Where-Object {...``, written with `#`.

```text
One JSON line per folder: the cells of a pair edited on both sides since HEAD, the cells whose png differs from put of the
yml, the minimaps a registry change left stale, or an error.
```
