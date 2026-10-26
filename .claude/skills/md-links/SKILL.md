---
name: md-links
description: >
  Check and repair the links of named markdown files, one file at a time, targets only, never link text or prose; for plan-clear and a
  drone's brief; input is the files' repository paths.
user-invocable: false
allowed-tools: Bash, Read, Edit
paths: "**/*.md"
metadata:
  catzc:
    config:
      model_floor: haiku
      needs: [pwsh]
---

# md-links

1. Run `Test-Links -Path <file>` through catzc-gate; each finding names line, column, kind and target.
2. A relative link resolves from the file's own folder: re-point only the target, never the link text, with Edit, one link at a time;
   `Format-Links -Path <file>` for the mechanical forms the gate names.
3. Re-run `Test-Links` on the file; one file per step, never a sweep.
4. An `[Untracked]` finding is a target not yet committed, listed and left as is (the commit is the user's); a target that exists nowhere is
   listed with the nearest candidate, never guessed.
5. Report per file the links re-pointed (old target, new target) and the final `Test-Links` line.
