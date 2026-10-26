# pwsh/Base.Slides/Test-Slides.ps1

The quality gate of the slide files: it renders every slide through its pattern and fails each fault found, then reports through the
quality-gate report.

## help

### synopsis

The slides quality gate; fails every slide file whose pattern, fields, cited codes or quoted rule text break the rules.

### description

Runs the checks of Get-SlideFinding over each slide file, one at a time, and reports through the quality-gate report
(ADR-REPO-SLIDES-CHECKABLECLAIMS): the head names a pattern the kit holds and a whole-number order; every field fits its pattern and its
capacity; every cited code is a rule the index knows; a quoted rule is the registry's text verbatim; and every text is in the rendered
slide. A deck folder it reads whole, named or found under docs/, is also checked for a gap or a duplicate in its orders, by the same
Get-SlideOrderFinding the render runs (ADR-REPO-SLIDES-SLIDEFILE); one slide file named alone is no deck. It writes no deck; the render is
Build-SlideDeck's.

### parameter `Path`

Slide files or deck folders, repository-relative or absolute. The default is every slide file under docs/.

### parameter `Kit`

The slides kit folder, repository-relative. The default is the slides config's kit.

### parameter `RepositoryRoot`

The repository root the slides and the kit are under.

### parameter `OutputFolder`

Where the gate report lands. The default is the quality-gate report's own.

### parameter `PassThru`

Return the report object as well.

### outputs

`[Catzc.Base.Reports.QualityGateResult]` The quality-gate report, with -PassThru.

### example 1

```powershell
Test-Slides
```

### example 2

```powershell
Test-Slides -Path docs/explanation/thesis/product-thesis
```
