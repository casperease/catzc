---
name: plan-shape
description: Verdict rules for one plan file in .claude/plans; for plan-clear; input is the plan's repository path.
user-invocable: false
allowed-tools: Read, Grep, Edit
paths: .claude/plans/**
metadata:
  catzc:
    immutable:
      repo_status: clean
      path: ".claude/skills/plan-shape/SKILL.md"
      folder: skills/plan-shape
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
      model_floor: sonnet
      needs: []
---

# plan-shape

1. Read the head: `plan:` with status, value, reviewed, targets; the name is `plan-<topic>.md`, no rank or order prefix.
2. One verdict per rule, each with the line it rests on: keep; trim (carried text whose data is in the tree); re-point (`out/plan-x.md` for
   a sibling, relative links written from out/); delete (no open step); intake (a pasted item no plan holds).
3. Act on one verdict at a time with Edit, re-read the file after each; never delete a plan that still has an open step, never drop a
   signal.
