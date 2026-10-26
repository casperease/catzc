---
name: drawio-edit
description: >
  Change what one diagram says or shows by editing the content of its <name>.drawio.yml and putting the png from it; never the renderer or
  its vocabularies, and a value outside a vocabulary goes back to the coordinator; input is the diagram and the change.
user-invocable: false
allowed-tools: Bash, Read, Glob, Grep, Edit
paths: docs/**/.assets/*.drawio.yml, docs/**/.assets/*.drawio.png
metadata:
  catzc:
    config:
      model_floor: haiku
      needs: [uv, pillow, pwsh]
---

# drawio-edit

Make the smallest edit to one diagram's yml that satisfies the brief, render it, and prove the png shows it.

1. Glob the diagram the brief names; a yml and png pair already in conflict goes back unedited.
2. Edit only `content:` and, when a cell must move, its `layout:` entry; never the `description:` beyond the brief's words.
3. Run put on the diagram in the background (drawio-declaration step 1) and forward every warning and validation error verbatim.
4. Look at the png (drawio-look) and check each changed label, cell and marker is drawn where the brief says.
5. Run `Test-Diagrams` on the diagram; a stale or conflict line is reported, never cleared by picking a side.
6. Report the yml delta, the put output, what the look showed and the `Test-Diagrams` verdict.
