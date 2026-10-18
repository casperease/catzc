# pwsh/Catzc.Base.Slides/Test-Slides.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The slides quality gate; fails every slide file whose pattern, fields, cited codes or quoted rule text break the rules.

### description

Runs the checks of Get-SlideFinding over each slide file, one at a time, and reports through the quality-gate report (ADR-REPO-SLIDES#4):
the head names a pattern the kit holds and a whole-number order; every field fits its pattern and its capacity; every cited code is a rule
the index knows; a quoted rule is the registry's text verbatim; and every text is in the rendered slide. It writes no deck; the render is
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

`[pscustomobject]` The quality-gate report, with -PassThru.

### example 1

```powershell
Test-Slides
```

### example 2

```powershell
Test-Slides -Path docs/explanation/thesis/product-thesis
```
