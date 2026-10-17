---
task:
  id: "035"
  status: open
  plans: [plan-idle-compaction]
  value: low
  blocked_on: D06
  targets: [.claude/settings.json, .claude/settings.local.json]
catzc:
  immutable:
    repo_status: clean
    path: ".claude/plans/task035.md"
    folder: plans
    name: task035
    filetype: md
    kind: other
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
---

# task035: idle compaction

`"idleCompaction": false` is set in `.claude/settings.local.json` (gitignored, one machine). D06 decides whether it stays local (the
recommendation: a per-person cost and context preference, not a repository rule) or is checked in.

## Steps

1. D06 recorded in the plan. Check: the Decided line.
2. If checked in: add the line to `.claude/settings.json` and remove it from `settings.local.json`; both parse as JSON. Check:
   `pwsh -NoProfile -Command` parses both files.
3. The plan is deleted (a done plan is never kept); one line in value-of-plan.md. Check: no file in `.claude/plans` names it.

## Report

As report-fixed.
