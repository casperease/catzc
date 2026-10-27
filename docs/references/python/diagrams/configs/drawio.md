# python/diagrams/configs/drawio.yml

<!-- cspell:ignore callsite -->

The draw.io kit's sensible defaults, declared once: the renderer settings, the meaning of an edge, the closed vocabularies a diagram draws
from and the colour themes.

## Defaults and overrides

A script parameter overrides an entry for one run and never rewrites the file. The file is a two-level mapping only: a section, then
`key: value`. `drawio_png.py` reads it without a YAML library, so nothing richer than that shape belongs here.

## The meaning of an edge

The `edge-semantics` section declares the default meaning of an edge once: the tail initiates and the head receives
([DDR-VISUAL-ARROWSPOINTATDEPENDENCY](../../../../drs/design/visual-design.md#rule-ddr-visual-arrowspointatdependency)). A diagram that
declares its own relation replaces the default and opts out of the checks that follow from it. The `edge-labels`, `edge-rank`,
`edge-defaults` and `edge-rules` sections extend it with the words an edge may carry and which end initiates under each.

## How the kit orients an edge

The `edge-rank` section lists the ranks, lowest first (actor, code, file or config, store or set, result or failure), each with its glyph
kinds, and the lower rank acts on the higher: an edge between cells of different rank runs from the lower to the higher. An edge with no
label of the vocabulary is oriented this way: declared against its rank it is refused naming the edge, and declared with its rank it takes
the label its kind pair names in `edge-defaults` (code to file or set `reads`, to store `writes`, to failure `failed`; an actor to code
none), drawn in the label presentation like any other label. A label outside the vocabulary is free text, not an arrow meaning, and the edge
is oriented by rank like an unlabelled one. The kinds in `edge-rules` `trusted-kinds` (the gate) keep the direction their author declared,
and a diagram with its own `relation` keeps its plain arrows as they are. The edge audit reads the same ranks and defaults.

The source keeps an edge minimal: get and tidy never write a derived label, and a label the author wrote that equals its pair's default is
the same edge, so the one form leaves it out; a label of another meaning is kept, and so are the direction as written (get never rewrites
`from` and `to` into `between`) and every edge of a diagram with its own `relation`. An edge may be declared minimally as `between: [a, b]`
and the kit orients it; ends of one rank are declared with `from` and `to`, between two code blocks with a `calls` label or an actor.

## How the kit routes an edge

An edge that no waypoint routes leaves the side its two ends face (across the axis they overlap on, else the axis of their wider centre
distance) and takes an even share of that side with every other edge that meets it there, in the order of the other ends, one edge alone at
the side's middle, so edges between aligned cells run straight and edges sharing a side fan out without crossing. A cell that is neither end
of an edge is a keep-out zone for it: the cell grown by the 8 px deadzone and its marker, and a path that enters one is an `E_KEEPOUT` error
under the kit's one findings setting; bands, groups and spans are no obstacle.

An edge whose two ends share no x overlap and no y overlap has no straight line and is routed as one orthogonal elbow by default
(`edge-route: elbow` in the renderer, `straight` keeps the diagonal): it leaves the side facing across, runs along that row to the column of
the side it enters, with the deadzone at both ends and its pill on the longer leg; the route is derived, never written to the declaration,
and an edge whose ends overlap on an axis stays straight.

## An edge's count and a uniform word

An edge may carry a `count`, `n/m` with n at most m (`count: 13/28`), shown in its pill after its label as `calls 13/28`; a count is no
label and decides no direction, and a label that is only an `n/m` is read as the edge's count. Where every flow edge of a diagram carries
one and the same word (all `calls`), no pill is drawn on each: the legend entry of the plain arrow says it once (`flow: calls`), derived at
render time under the renderer's `uniform-label: legend` and never written back; an edge with a count keeps its pill for the count, and a
failure edge does not count toward the sameness.

## Other sections

The remaining sections close the sets a diagram may name: `roles`, `lenses`, `zooms`, the locked `commits` palette, the paint order
`layers`, the `lane` and `span` placement numbers, the diagram `kinds`, `wheres`, the `action-lens` numbers, the `themes` with their
`theme-dark` and `theme-light` token sets, the `minimaps` ids and the `vocabularies` a span bar's label comes from.

## comment:1

Above `flow-glyphs:`, written with `#`.

```text
the closed list of flow glyphs, each a word of three symbols from O 0 - _ = .
([DDR-VISUAL-FLOWGLYPHSAREWORDS](/docs/drs/design/visual-design.md#rule-ddr-visual-flowglyphsarewords)); hint is the editor icon it is
styled after, for the reader only
```
