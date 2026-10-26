---
name: drawio-look
description:
  Look at one diagram PNG and say what is drawn, never what it means; for edit-diagram-yml, drawio-diagram-waves and diagram-review-chunks;
  input is the PNG's repository path.
user-invocable: false
allowed-tools: Read
paths: docs/**/.assets/*.drawio.png, out/drawio/**, out/diagrams/**
metadata:
  catzc:
    config:
      model_floor: haiku
      needs: []
---

# drawio-look

1. Read the PNG with the Read tool; name every band, glyph, label, marker, edge and sidebar piece in the kit's vocabulary
   (`python/diagrams/assets/STYLE.md`), in reading order left to right; an action or proof diagram (`about.lens`) adds the cause, the
   action, zones, effects, the proof box, transition pills and the one legend band.
2. Name each colour against the dark tokens of STYLE.md; a colour outside the tokens, a dark label on the dark page, or text cut by its box
   is a finding naming the cell's label.
3. Counts come from the model, never from the picture: the renderer's `cells=` line or the decoded XML is the number; the declaration is the
   `yml drawio` block above the image in its article, or `<name>.drawio.yml` beside the png.
