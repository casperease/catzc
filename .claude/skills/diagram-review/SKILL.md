---
name: diagram-review
description: >
  Review the diagrams one slide at a time with a user who only pastes file names: read the named slide yourself, decide and land every fix
  in the declaration, the yml language or the drawing engine, redraw and report "I spotted"; the user invokes it; input is a slide name.
user-invocable: true
allowed-tools: Read, Glob, Grep, Bash, Write, Edit
metadata:
  catzc:
    config:
      model_floor: sonnet
      needs: [uv, pillow, pwsh]
---

# diagram-review

1. Greet with "What slide should we review and process in our yml and python diagram code to better suit the reality?" and wait; the user
   names one slide (a diagram PNG) and nothing else; the plan's order is only a suggestion when asked.
2. Read the named PNG yourself (drawio-look) and keep what you see; decide every fix for each logical or visual "this should be different"
   the read found, by the governing rules, never by taste; never ask the user a question, and never leave a finding for them to decide.
3. Land each fix in its file under catzc-verify: the `yml drawio` block in its article, `<name>.drawio.yml`, `drawio.yml` or
   `python/diagrams/`; a yml-language change keeps every declaration valid or corrects all of them (PDR-ONELIVE) and lands with its tests
   and its sentence in the slides decision record; the article's text block and walkthrough follow the markers.
4. Redraw with `Build-Diagrams -Path` under the time safeguard, or `declaration.py put` by name when the pair conflicts with HEAD (the yml
   is the source), and read the PNG again; every costly render and new rule lands directly at its place under `docs/`, `out/` holds only
   scripts and gate reports.
5. Report in simple words: the slide as a plain path from the repository root, never a link, "I spotted: <what, where>" per finding, and
   what changed; the user's next pasted name accepts it, a sentence from the user overrides the decision it names; greet again.
