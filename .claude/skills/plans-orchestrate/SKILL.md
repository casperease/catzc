---
name: plans-orchestrate
description:
  The message protocol between an orchestrator and the live sessions it drives over the master plan; for implementation-orchestrator; input
  is plan-master.md and the ListAgents roster.
user-invocable: false
allowed-tools: ListAgents, SendMessage, Read
metadata:
  catzc:
    config:
      model_floor: sonnet
      needs: []
---

# plans-orchestrate

1. Three messages, each one line: `what are you working on?`; `continue with this: <plan> step <n or text>; owns <files>; check <check>`,
   pointing at the plan, never its text again; `stop; <reason>`. A reply is read as one of four: `working on <chunk>`,
   `landed <step> with <verdict line>`, `blocked on <what>`, `nothing in hand`; anything else is asked again once, then recorded as unclear;
   an idle notice older than the session's last reply is stale; ask nothing.
2. One chunk per session, in the master's order, dependencies landed first; a chunk whose files a live session holds waits, never splits. At
   most two heavy drones run at a time, one unit per `Invoke-CatzcCommand` call. A worker messages only the session that sent its work,
   never a roster namesake, and greps a step's path or command before it starts.
3. The orchestrator edits plan and task files only, records a claim as reported until its verdict line arrives and keeps a step open naming
   its check, a command a module exports; its plan checks batch into one run per worker report. A drone never stops to ask the user: it
   sends `question: <what>, recommend <x>` to the orchestrator and works on. The orchestrator reads the governing ADRs and decides every
   one, recorded as delegated in the owning plan; only git, settings.json and CLAUDE.md go to the user. A burst sends no message: the run
   lock's holder record says who bursts, and bursts chain from one drone to the next.
4. Every message sent and every reply is appended to `out/orchestrator-<date>.log` with the session name; the log is output, never input.
