# pwsh/Base.Slides/Test-Diagrams.ps1

The quality gate of the declared diagrams: it runs the kit's check over each one and fails a diagram whose png differs from put of its yml.

## help

### synopsis

The diagrams quality gate; fails every declared diagram whose png differs from put of its yml, and reports the minimaps a registry change
left stale.

### description

A declared diagram is a `<name>.drawio.yml` in a `.assets/` folder, beside the `<name>.drawio.png` put from it, named by its stem
`.assets/<name>`. The gate runs the draw.io kit's `declaration.py check` over each declared diagram through uv and reads one JSON line per
diagram: the cells whose png differs from put of the yml are issues, a kit or diagram error is an issue, and a minimap a registry change
left stale is announced and counted in the report facts without failing the gate. An action diagram (`about.lens: action`) also names, in
`about.proves`, the accosted file that runs what it draws: the file must exist, be readable by Get-AccostedFile, and hold every
`effects[].proves` as a command equal in name and arguments. The action (`action.call` or `action.calls`) may be any contracted command,
mutating included: it must be a contracted command whose arguments fit its command contract (Test-AccostedCommand) and need not be in the
proof file. An effect is a state change (`proves`, as above) or an execution (`call`, checked like the action); an effect with both or
neither is an issue. A band diagram is not checked. It writes no diagram; the render is Build-Diagrams'. The result goes through the
quality-gate report.

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
Test-Diagrams -Path docs/explanation/thesis/.assets/where-truth-comes-from
```

## The kit's rows

The kit's check prints one JSON line per diagram: the cells of a pair edited on both sides since HEAD, the cells whose png differs from put
of the yml, the minimaps a registry change left stale, or an error.

## Which diagrams are checked

A declared diagram is a `<name>.drawio.yml` under `docs/**/.assets/`, tracked or not, named by its stem `.assets/<name>`; a new one is
checked once its first put has run.

A diagram in the article carrier has no yml beside its png: its stem is a tracked png with no yml, or an image a `yml drawio` block sits
above, and the kit's check reads that block, failing a diagram with no block or two. Over the whole tree, a `yml drawio` block declares only
the png embedded directly below it; a block with no such image is a finding.

A legend diagram has no yml: the kit's `drawio.yml` names its stem under roles, and its png is checked against the painted glyph library.

## Query rows

A C3 or C4 slide is checked against its query's rows, as `Build-Diagrams` rendered it
([DDR-VISUAL-ZOOMISANAXIS](../../../drs/design/visual-design.md#rule-ddr-visual-zoomisanaxis)).
