---
name: plan-intake
description: Land a pasted continuation prompt in the plans, nothing discarded; for plan-intake; input is the paste and .claude/plans.
user-invocable: false
allowed-tools: Read, Grep, Glob, Edit, Write
paths: .claude/plans/**
metadata:
  catzc:
    config:
      model_floor: sonnet
      needs: []
---

# plan-intake

1. Every item, idea or signal in the paste lands in exactly one plan: a verified done item deletes the open step it closes and is written
   nowhere, open as a checkbox step naming the check that proves it, a question as an open question left open.
2. A done claim is written only after a read of the tree confirms it; a contradiction is recorded with both sides as a correction, never
   silently resolved.
3. Prompts meant for a fresh session are kept verbatim as `prompt-<topic>-continue.md` with a header mapping dead paths; locked, untracked
   or peer-dirty files get one context line at most, never a step.
