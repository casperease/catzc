---
name: plan-intake
description: >
  Land a pasted continuation prompt or session report in the plans, every item in exactly one plan, each done claim checked against the
  tree, open questions kept open; input is the paste and .claude/plans.
user-invocable: false
allowed-tools: Bash, Read, Grep, Glob, Edit, Write
paths: .claude/plans/**
metadata:
  catzc:
    config:
      model_floor: sonnet
      needs: [pwsh]
---

# plan-intake

1. Read `value-of-plan.md` and the plans the paste names or implies.
2. Every item, idea or signal in the paste lands in exactly one plan: a verified done item deletes the open step it closes and is written
   nowhere, open as a checkbox step naming the check that proves it, a question as an open question left open, never answered.
3. A done claim is written only after a read of the tree confirms it (Glob, Grep, `ls`); a contradiction is recorded with both sides as a
   correction, never silently resolved.
4. An item no plan covers gets a new plan from `New-Plan -Summary` at the value plan-value gives it, which also writes its row in
   `value-of-plan.md` and its chunk line in `plan-master.md`; a changed plan's row is updated.
5. Prompts meant for a fresh session are kept verbatim as `prompt-<topic>-continue.md` beside the plan, with a header mapping dead paths;
   locked, untracked or peer-dirty files get one context line at most, never a step.
6. Finish as plan-clear step 5 says; report the plans touched, items landed per plan, corrections made, and what was left undone and why.
