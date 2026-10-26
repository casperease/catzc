---
name: drs-review
description: >
  Review a named file set or revision range against the decision records that govern it, each finding as path:line, rule code and one
  sentence; read-only, never a bug review; input is the files or the revision range.
user-invocable: false
allowed-tools: Bash, Read, Glob, Grep
metadata:
  catzc:
    config:
      model_floor: sonnet
      needs: [git]
---

# drs-review

Review the named files against the rules that govern them; report findings, change nothing.

1. Take the file set from the brief, or `git diff --name-only` for a named revision range (git as catzc-core says).
2. drs-cite steps 1 to 3: the index, the governing decision records in full, each rule by its full code.
3. For each file, each rule it breaks: `path:line`, the rule's full code, one sentence saying what the rule states and what the line does; a
   rule followed is not reported.
4. Report the findings ordered by file, the decision records read, and what could not be judged from the files alone.
