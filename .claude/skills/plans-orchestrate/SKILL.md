---
name: plans-orchestrate
description:
  The message protocol between an orchestrator and the live sessions it drives over the master plan; for implementation-orchestrator; input
  is plan-master.md and the ListAgents roster.
user-invocable: false
allowed-tools: ListAgents, SendMessage, Read
metadata:
  catzc:
    immutable:
      repo_status: clean
      path: ".claude/skills/plans-orchestrate/SKILL.md"
      folder: skills/plans-orchestrate
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

# plans-orchestrate

1. Three messages, each one line: `what are you working on?`;
   `continue with this: <task-<topic>.md step n, the files it owns, the check it ends with>`; `stop; <reason>`. A reply is read as one of
   four: `working on <chunk>`, `landed <step> with <verdict line>`, `blocked on <what>`, `nothing in hand`; anything else is asked again
   once, then recorded as unclear.
2. One chunk per session, in the master's order, dependencies landed first; a chunk whose files a live session holds waits, never splits.
3. The orchestrator edits plan and task files only, records a claim as reported until its verdict line arrives, and decides nothing for the
   user: an open question goes to the user with the session's recommendation labelled as one.
4. Every message sent and every reply is appended to `out/orchestrator-<date>.log` with the session name; the log is output, never input.
