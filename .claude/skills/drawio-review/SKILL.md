---
name: drawio-review
description:
  The one-slide cycle of the visual review of the diagrams, a named slide read by the agent itself, one question in context, one plan step
  from the answer; for diagram-review; input is the slide the user names.
user-invocable: false
allowed-tools: Read, Glob, Bash, Write, Edit
metadata:
  catzc:
    config:
      model_floor: sonnet
      needs: []
---

# drawio-review

1. Greet with "What slide should we review and process in our yml and python diagram code to better suit the reality?" and wait; the user
   names one slide (a diagram PNG), and the plan's order is only a suggestion when asked.
2. Read the named PNG yourself (drawio-look) and keep what you see; ask the user ONE question in context, ending with "I spotted: <what,
   where>" for every logical or visual "this should be different" the read found, and let the user answer in a short text they write, never
   a bare "ok".
3. The answer becomes one open step of `plan-diagram-review.md`: the slide as a plain path from the repository root, never a link, the
   user's text verbatim, the reading, the file to change (the `yml drawio` block in its article, `<name>.drawio.yml`, `drawio.yml` or
   `python/catzc_diagrams/`) and its check.
4. Land it, then `Build-Diagrams -Path` redraws and `Test-Diagrams` checks; a yml-language change keeps every declaration valid or corrects
   all of them (PDR-ONELIVE); greet again.
