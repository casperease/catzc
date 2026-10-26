# pwsh/Base.Slides/configs/slides.yml

The settings of the slides module: where the slides kit lives and which pictures may name catzc or cats.

## Keys

- **`kit`** — where the slides kit lives, as a repository-relative folder
  ([ADR-REPO-SLIDES-SLIDEFILEKIND](../../../../drs/repository/slides-as-markdown.md#rule-adr-repo-slides-slidefilekind)). The kit's own
  defaults, its patterns and its style guide are read from there. The default is declared once on `SlidesConfig`, so this file states only a
  deviation from it.
- **`name_mentions`** — the pictures whose naming of catzc or cats is a contrast or the thing itself, each with why
  ([DDR-VISUAL-NONAMEINPICTURE](../../../../drs/design/visual-design.md#rule-ddr-visual-nonameinpicture)).
