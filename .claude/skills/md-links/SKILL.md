---
name: md-links
description: Check and repair the links of one markdown file; for plan-clear and link-fixer; input is the file's repository path.
user-invocable: false
allowed-tools: Bash, Read, Edit
paths: "**/*.md"
metadata:
  catzc:
    immutable:
      with_body_sha: dbee73aac03f
      path: ".claude/skills/md-links/SKILL.md"
      folder: skills/md-links
      name: skill
      filetype: md
      kind: capability
      language: markdown
      track: ".claude"
      tracktype: vendor-settings
      vendor: claude
      module: ".claude"
      moduletype: settings
    config:
      model_floor: haiku
      needs: [pwsh]
---

# md-links

1. Run `Test-Links -Path <file>` through catzc-check; each finding names line, column, kind and target.
2. A relative link resolves from the file's own folder: re-point only the target, never the link text, with Edit, one link at a time;
   `Format-Links -Path <file>` for the mechanical forms the gate names.
3. Re-run `Test-Links` on the file; an `[Untracked]` finding is a target not yet committed, reported and left as is; one file per step,
   never a sweep.
