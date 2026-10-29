# pwsh/Base.Slides/private/Get-SlidePictureFinding.ps1

A private helper of Get-SlideFinding. It checks the picture a slide's head names: its source, the rule its diagram cites, and the age of the
image the slide shows.

## help

### synopsis

Returns the faults of one slide's picture, one per broken expectation.

### description

A slide whose head names no `picture.source` is text-only and yields nothing. Otherwise the source must be a catalogue diagram, an
`.assets/<name>.drawio.png` inside the repository, and must exist. The diagram's declaration must exist, the slide's eyebrow must name a
rule code, and the declaration's `about.rules` must cover one of the eyebrow's codes. The slide's `## Image` must hold the picture's link,
and a picture older than its source is stale.

Private helper of Get-SlideFinding; not exported.

### parameter `Slide`

The parsed slide, with its path, its head's picture and its source fields.

### parameter `Relative`

The slide file as its findings name it, repository-relative.

### parameter `RepositoryRoot`

The repository root the picture's source file resolves against.

### outputs

`[Catzc.Base.Slides.SlideFault]` One per fault, naming the slide, the field and the problem.

### example 1

```powershell
Get-SlidePictureFinding $slide -Relative docs/explanation/flow/widget-deck/gadget.slide.md -RepositoryRoot (Get-RepositoryRoot)
```
