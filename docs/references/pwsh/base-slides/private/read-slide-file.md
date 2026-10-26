# pwsh/Base.Slides/private/Read-SlideFile.ps1

The reader of one slide file: it returns the file's head values and its parsed body.

## help

### synopsis

Reads one slide file into its head values and its parsed body.

### description

The head's config gives the pattern, the deck, the order and, when the body quotes a rule, the rule it quotes; the head's edges give the
codes the slide cites; the body is parsed by SlideSource into the title and the fields (ADR-REPO-SLIDES-SLIDEFILE). A file that does not
exist fails at once; a head key that is missing is left empty for the checks to report.

### parameter `Path`

The slide file, as an absolute path.

### outputs

`[pscustomobject]` @{ Path; Id; Pattern; Deck; Order; Quotes; Cites; Source (`[Catzc.Base.Slides.SlideSource]`) }.
