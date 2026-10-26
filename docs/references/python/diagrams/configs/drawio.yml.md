# python/diagrams/configs/drawio.yml

<!-- cspell:ignore callsite -->

The draw.io kit's sensible defaults, declared once: the renderer settings, the meaning of an edge, the closed vocabularies a diagram draws
from and the colour themes.

## Defaults and overrides

A script parameter overrides an entry for one run and never rewrites the file. The file is a two-level mapping only: a section, then
`key: value`. `drawio_png.py` reads it without a YAML library, so nothing richer than that shape belongs here.

## The meaning of an edge

The `edge-semantics` section declares the default meaning of an edge once: the tail initiates and the head receives
([DDR-VISUAL-ARROWSPOINTATWHATTHEYDEPENDON](../../../../drs/design/visual-design.md#rule-ddr-visual-arrowspointatwhattheydependon)). A
diagram that declares its own relation replaces the default and opts out of the checks that follow from it. The `edge-labels`, `edge-rank`,
`edge-defaults` and `edge-rules` sections extend it with the words an edge may carry and which end initiates under each.

## Other sections

The remaining sections close the sets a diagram may name: `roles`, `lenses`, `zooms`, the locked `commits` palette, the paint order
`layers`, the `lane` and `span` placement numbers, the diagram `kinds`, `wheres`, the `action-lens` numbers, the `themes` with their
`theme-dark` and `theme-light` token sets, the `minimaps` ids and the `vocabularies` a span bar's label comes from.
