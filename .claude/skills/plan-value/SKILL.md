---
name: plan-value
description:
  Rank a plan by value and by the docs and tests it needs, never by job size; for plan-intake and plan-decide; input is one plan file.
user-invocable: false
allowed-tools: Read, Grep
paths: .claude/plans/**
metadata:
  catzc:
    immutable:
      repo_status: clean
      path: ".claude/skills/plan-value/SKILL.md"
      folder: skills/plan-value
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
      model_floor: sonnet
      needs: []
---

# plan-value

1. Value is what the plan delivers once landed (a broken rule fixed, a vocabulary settled, a blocker removed), stated in one sentence; job
   size never ranks.
2. Needed docs are the ADR rules, glossary terms and CLAUDE.md lines the plan must write; needed tests are the gates and Pester files that
   prove it; both are listed by name.
3. The rank lives only in `value-of-plan.md` and the head's `value` key; a file name never carries it.
