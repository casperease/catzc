---
plan:
  status: open
  value: low
  reviewed: 2026-10-17
  blocked_on: Q1 below is unanswered
catzc:
  immutable:
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
  Recommendation: keep it local, because it is a per-person cost and context preference, not a repository rule. The answer is recorded on
  this line when given (D06 of the decision round).

## Steps

- [ ] If the answer to Q1 is "checked in", move the line to `.claude/settings.json` and remove it from `settings.local.json` (check:
      `.claude/settings.json` holds `"idleCompaction": false`, `settings.local.json` does not, and both parse as JSON).
- [ ] Delete this plan once Q1 is answered and the line sits where the answer says (check: the file is gone and `Test-Links` is clean on
      `.claude/plans`).
