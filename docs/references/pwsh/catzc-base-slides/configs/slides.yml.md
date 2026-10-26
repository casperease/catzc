# pwsh/Base.Slides/configs/slides.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `kit: python/diagrams/assets/slides`, written with `#`.

```text
Where the slides kit lives, as a repository-relative folder (ADR-REPO-SLIDES-SLIDEFILEKIND). The kit's own defaults, its patterns and its style
guide are read from there; the default is declared once on SlidesConfig, so this file states only a deviation from it.
```
