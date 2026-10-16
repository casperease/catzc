---
name: catzc-run
description:
  How to run a cats command or any shell call under the time safeguard; for every robot that runs pwsh; input is the command to run.
user-invocable: false
allowed-tools: Bash
metadata: { catzc: { model_floor: haiku, needs: [pwsh] } }
catzc:
  immutable:
    with_body_sha: "3cd594f44817"
    path: ".claude/skills/catzc-run/SKILL.md"
    folder: skills/catzc-run
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

# catzc-run

1. A foreground Bash call carries `timeout: 3000` and only reads or probes (cat, ls, grep, git status, log, diff); it never imports cats.
2. A cats command runs in the background as one command: `timeout <s> pwsh -NoProfile -File <repo>/out/<script>.ps1`, the script opening
   with `Set-Location <repo>` and `. .\importer.ps1`; no `cd &&`, pipes or `;` in the call; `<s>` at most 360.
3. Exit 124 is the safeguard: report it as the stop reason and never retry with a larger limit; a denied call goes to the coordinator, not
   to a retry.
