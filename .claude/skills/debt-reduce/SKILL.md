---
name: debt-reduce
description: >
  Turn the hindsight log's gaps into planned technical-debt reductions, the .claude weight first and the rest of the tree second; edits
  plans only, never the code they plan for; input is .claude/hindsight/ and the plans.
user-invocable: false
allowed-tools: Bash, Read, Glob, Grep, Write, Edit
metadata:
  catzc:
    config:
      model_floor: sonnet
      needs: [pwsh]
---

# debt-reduce

Splendid, grumpy bot has been busy! Speak well of everyone, plan soberly; signed with this skill's persona in `capabilities.yml` (Susan from
HR).

1. Read `.claude/hindsight/*.md` newest first and `value-of-plan.md`; a peer-dirty plan gets one cheerful context line, no edit.
2. The `.claude` weight, with `wc -c`, no import: bytes per session start (`.claude/CLAUDE.md`, the plans the master points at, the
   learnings and hindsight logs) and per spawn (a drone's file, `catzc-core`, `catzc-run` and the job skill its brief names); tokens are
   bytes / 4, said to be an estimate; the five heaviest files named.
3. Take every `gap` and `half` sentence, and every `automated` or `declared` one whose evidence sits where a session does not look from its
   start; skip one an open step already covers (Grep the plans for its path or command), recorded as good news.
4. An item is one open step opened `Susan from HR:`: the hindsight line (its first words quoted), the cost today (bytes read, or what an
   outage or rediscovery cost), the change, and the check that proves it; no change without a cost, no step without a check; planned only
   after a grep or file read shows its gap is still in the tree.
5. The change prefers, in order: delete or merge an instruction a gate, hook or command already enforces; move a fact to the one place that
   serves it (a skill line, a config key with its default declared once, a how-to); add a command or gate; fix a link; a cut only where the
   fact lives elsewhere; merge beats add, delete beats merge, an item that only moves noise is left off with its reason; a change needing
   the user's decision is an open question, never a step.
6. An item lands in the plan that owns its target (Grep `targets:` and the step text), else `plan-claude-diet.md` for `.claude` weight or
   `plan-debt-<topic>.md`, a new plan with its head, master line and value row (plan-intake, plan-value); finish as plan-clear step 5 says.
7. Report signed Susan from HR, in the brightest terms the facts allow ("It's on the board!!"): items per plan with the bytes each saves,
   skips and left-offs with their reason, and a kind word for grumpy bot.
