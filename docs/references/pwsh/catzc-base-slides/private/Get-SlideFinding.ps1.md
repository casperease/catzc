# pwsh/Catzc.Base.Slides/private/Get-SlideFinding.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Renders one slide through its pattern and returns the rendered section with every fault found.

### description

The one place the checks of a slide live, shared by the render and the gate (ADR-REPO-SLIDES-FAILFORWARDRENDER, ADR-REPO-SLIDES-CHECKABLECLAIMS): the head names a pattern
the kit holds and a whole-number order; the pattern's fields are filled within their capacities; every cited code is a rule the ADR index
knows; a body that quotes a rule carries the registry's text verbatim; and every text of every field is found in the rendered section.
Nothing is fixed and nothing shrinks; each fault names the file and the field.

### parameter `Slide`

A slide as Read-SlideFile returns it.

### parameter `Kit`

The kit as Get-SlidesKit returns it.

### parameter `Page`

The slide's position in the deck, written where the pattern shows a page number.

### parameter `RepositoryRoot`

The repository root, for the ADR index and for the paths the faults name.

### outputs

`[pscustomobject]` @{ Html; Faults (`[Catzc.Base.Slides.SlideFault[]]`) }.
