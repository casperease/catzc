# python/catzc_diagrams/configs/drawio.yml

<!-- cspell:ignore callsite -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `renderer:`, written with `#`.

```text
The draw.io kit's sensible defaults, declared once; a script parameter overrides an entry for one run, never the file.
Two-level mapping only: a section, then key: value. drawio_png.py reads it without a YAML library.
```

## comment:2

Above `edge-semantics:`, written with `#`.

```text
the default meaning of an edge, declared once
([DDR-VISUAL-ARROWSPOINTATWHATTHEYDEPENDON](/docs/drs/design/visual-design.md#rule-ddr-visual-arrowspointatwhattheydependon)): the tail
initiates, the head receives
```
