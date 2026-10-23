---
name: drawio-review
description:
  The one-slide cycle of the visual review of the diagrams, a named slide read by the agent itself, every fix decided and landed by the
  agent, the next pasted name the user's acceptance; for diagram-review; input is the slide the user names.
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
   names one slide (a diagram PNG) and nothing else; the plan's order is only a suggestion when asked.
2. Read the named PNG yourself (drawio-look) and keep what you see; decide every fix for each logical or visual "this should be different"
   the read found, by the governing rules; never ask the user a question, and never leave a finding for them to decide.
3. Land each fix in its file: the `yml drawio` block in its article, `<name>.drawio.yml`, `drawio.yml` or `python/catzc_diagrams/`; a
   yml-language change keeps every declaration valid or corrects all of them (PDR-ONELIVE) and lands with its tests and its sentence in the
   slides decision record; the article's text block and walkthrough follow the markers.
4. Redraw (`Build-Diagrams -Path`, or `declaration.py put` by name when the pair conflicts with HEAD), read the PNG again, and report in
   simple words: the slide as a plain path from the repository root, never a link, "I spotted: <what, where>" per finding, and what changed;
   the user's next pasted name accepts it, a sentence from the user overrides the decision it names; greet again.
