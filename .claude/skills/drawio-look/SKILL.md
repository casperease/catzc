---
name: drawio-look
description: Look at one diagram PNG and say what is drawn, never what it means; for write-drawio-files, drawio-png and drawio-diagram-waves; input is the PNG's repository path.
user-invocable: false
allowed-tools: Read
paths: docs/.assets/**/*.png, out/drawio/**, out/diagrams/**
metadata: { catzc: { model_floor: haiku, needs: [] } }
catzc:
  immutable:
    with_body_sha: "746fbf236a81"
    path: ".claude/skills/drawio-look/SKILL.md"
    folder: skills/drawio-look
    name: skill
    filetype: md
    kind: capability
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
---
1. Read the PNG with the Read tool; name every band, glyph, label, marker, edge and sidebar piece in the kit's vocabulary (`.claude/drawio/STYLE.md`), in reading order left to right.
2. Name each colour against the dark tokens of STYLE.md; a colour outside the tokens, a dark label on the dark page, or text cut by its box is a finding naming the cell's label.
3. Counts come from the model, never from the picture: when a count matters, the renderer's `cells=` line or the decoded XML is the number.
