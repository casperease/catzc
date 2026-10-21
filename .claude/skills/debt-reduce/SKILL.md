---
name: debt-reduce
description:
  The shape of one planned technical-debt reduction from a hindsight line, and how the .claude weight is measured; for
  its-a-chore-but-i-will-do-better; input is one hindsight sentence.
user-invocable: false
allowed-tools: Bash, Read, Glob, Grep, Write, Edit
metadata:
  catzc:
    config:
      model_floor: sonnet
      needs: []
---

# debt-reduce

1. An item is one open step, opened with the robot's persona from `agents.yml` (`Susan from HR:`): the hindsight line it answers (its first
   words quoted), the cost today (bytes a session or spawn reads, or what an outage or rediscovery cost), the change, and the check that
   proves it; no change without a cost, no step without a check; an item is planned only after a grep or file read shows its gap is still
   in the tree.
2. The `.claude` weight is bytes read per session start (`.claude/CLAUDE.md` and what the master points a session at) and per spawn (a
   robot's file plus the capabilities its `skills` list names); tokens are bytes / 4, said to be an estimate; a cut is proposed only where
   the same fact lives elsewhere in the tree or a gate, hook or command can carry it.
3. The change prefers, in order: delete or merge an instruction a gate, hook or command already enforces; move a fact to the one place that
   serves it (a capability line, a config key with its default declared once, a how-to); add a command or gate; fix a link; a change that
   needs the user's decision is an open question, never a step.
4. An item lands in the plan that already owns its target (Grep `targets:` and the step text); only an unowned `.claude`-weight item opens
   `plan-claude-diet.md`, only an unowned tree item opens `plan-debt-<topic>.md`.
