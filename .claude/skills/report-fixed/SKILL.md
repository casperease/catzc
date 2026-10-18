---
name: report-fixed
description: The fixed end-of-run report every robot ends with; for every robot; input is what the run touched, ran and left undone.
user-invocable: false
allowed-tools: Read
metadata:
  catzc:
    immutable:
      repo_status: clean
      path: ".claude/skills/report-fixed/SKILL.md"
      folder: skills/report-fixed
      name: skill
      filetype: md
      role: capability
      language: markdown
      track: ".claude"
      tracktype: vendor-settings
      vendor: claude
      module: ".claude"
      moduletype: settings
    config:
      model_floor: haiku
      needs: []
---

# report-fixed

1. Files touched: one repository-relative path per line, marked created, edited or deleted; a shared file the brief did not own is listed
   under "asks" with the exact entry wanted, never edited.
2. Checks run: each gate or test with its verdict line verbatim and its report path; a check not run is listed as not run, with why.
3. Left undone: what the brief asked that did not land, each with its reason (blocked, denied, out of scope); then stop, nothing beyond
   these three lists.
