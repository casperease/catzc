---
name: plan-decide
description: Run a decision round over open plan questions; for plan-decide; input is .claude/plans and the user's answers.
user-invocable: false
allowed-tools: Read, Grep, Edit, Write, AskUserQuestion
paths: .claude/plans/**
metadata:
  catzc:
    immutable:
      repo_status: clean
      path: ".claude/skills/plan-decide/SKILL.md"
      folder: skills/plan-decide
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

# plan-decide

1. One questionnaire item per open question: one to five lines of context, the options, no links; items are numbered once and never
   renumbered.
2. Ask four at a time; the first option is the recommendation and says so; a decision row records Q, Decision, Rec taken, Outcome (two to
   ten words), Note; a reframing answer is quoted where it carries a new rule.
3. The user decides; nothing unanswered is decided by the agent; after the round each decision moves into its owning plan one file at a time
   and the decisions file stays until its decisions are in ADRs.
