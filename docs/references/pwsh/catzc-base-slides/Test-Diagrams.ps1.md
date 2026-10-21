# pwsh/Catzc.Base.Slides/Test-Diagrams.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The diagrams quality gate; fails every declared diagram whose png differs from put of its yml, and reports the minimaps a registry change
left stale.

### description

A declared diagram is a `<name>.drawio.yml` in a `.assets/` folder, beside the `<name>.drawio.png` put from it, named by its stem
`.assets/<name>`. The gate runs the draw.io kit's `declaration.py check` over each declared diagram through uv and reads one JSON line per
diagram: the cells whose png differs from put of the yml are issues, a kit or diagram error is an issue, and a minimap a registry change
left stale is announced and counted in the report facts without failing the gate. It writes no diagram; the render is Build-Diagrams'. The
result goes through the quality-gate report.

### parameter `Path`

Declared diagrams, repository-relative or absolute, each named by its `.drawio.yml`, its `.drawio.png` or its stem. A path that is not a
declared diagram throws. The default is every declared diagram.

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
One JSON line per diagram: the cells of a pair edited on both sides since HEAD, the cells whose png differs from put of the
yml, the minimaps a registry change left stale, or an error.
```

## comment:2

Above `$candidates = @(Get-GitTrackedPath '.') + @(Get-GitChangedPath 'docs')`, written with `#`.

```text
A declared diagram is a <name>.drawio.yml under docs/**/.assets/, tracked or not, named by its stem .assets/<name>; a new one is
checked once its first put has run.
```

## comment:3

Above `$carrierMap = Get-DiagramCarrierMap -RepositoryRoot $root -Kit $Kit`, written with `#`.

```text
A diagram in the article carrier has no yml beside its png: the kit's drawio.yml names it under carriers, and the kit's check reads
its block, failing a diagram with no block or two.
```
