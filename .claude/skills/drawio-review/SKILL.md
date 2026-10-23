---
name: drawio-review
description:
  The chunk protocol of the visual review of every diagram, five reads, five questions and one plan step per answer; for
  diagram-review-chunks; input is the plan's next five diagram PNG paths.
user-invocable: false
allowed-tools: Read, Glob, Bash, Write, Edit
metadata:
  catzc:
    config:
      model_floor: sonnet
      needs: []
---

# drawio-review

1. A chunk is five diagrams in the plan's order: Read each PNG (drawio-look), note what a reader sees, what is hard to read, what an LLM
   could misread.
2. Ask five questions in one message, one per diagram, each with its PNG as a plain path from the repository root, never a link, and a recommendation; the user answers each with a short
   snippet in their own words, never a bare "ok".
3. Each snippet is one open step of the plan: the diagram, the snippet verbatim, the reading, the file to change and its check; a diagram's
   declaration is the `yml drawio` block above its image in an article (most), or `<name>.drawio.yml` for the file carriers (`carriers:` in
   `drawio.yml`), beside `drawio.yml` and `python/catzc_diagrams/`.
4. A language change keeps every declaration valid or corrects all of them in the same change (PDR-ONELIVE); then `Build-Diagrams -Path`
   redraws all, folder by folder, and the next chunk reads the new renders.
