# pwsh/Base.Slides/types/SlidesConfig.cs

The typed record of the slides settings (`configs/slides.yml`), with the defaults declared once on the type.

## name_mentions

`name_mentions` holds the diagrams (by stem) and slides (by path) whose naming of catzc or cats is a declared contrast, each with its reason
([DDR-VISUAL-NONAMEINPICTURE](../../../../drs/design/visual-design.md#rule-ddr-visual-nonameinpicture)); it is empty when none is declared.
