---
plan:
  status: open
  value: low
  reviewed: 2026-10-17
  blocked_on: Q1 below is unanswered
catzc:
  immutable:
    with_body_sha: "2f954a7c562a"
    repo_status: clean
    path: ".claude/plans/plan-idle-compaction.md"
    folder: plans
    name: plan-idle-compaction
    filetype: md
    kind: other
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
---

# Idle compaction off

Claude Code compacts a long conversation shortly before the one-hour prompt cache expires while the terminal sits idle. Setting
`idleCompaction` to `false` turns that off. It needs Claude Code 2.1.290 or later; the user settings pin a minimum of 2.1.300.

## Done

- `"idleCompaction": false` is set in `.claude/settings.local.json` (gitignored, so it applies to one machine only). The file parses as
  valid JSON.

## Open

- **Q1: scope.** Keep the setting local, or move it into the checked-in `.claude/settings.json` so every checkout stops idle compaction?
  Recommendation: keep it local, because it is a per-person cost and context preference, not a repository rule.

## Steps

1. Answer Q1.
2. If the answer is "checked in", move the line to `.claude/settings.json` and remove it from `settings.local.json`.
3. Delete this plan (a done plan is deleted, never kept).
