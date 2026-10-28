---
name: plan-orchestrate
description: >
  Drive the open chunks of plan-master.md through the live sessions the user started, by message: ask, brief, record verdicts, decide
  questions; implements nothing, spawns nothing; the user invokes it in the main session; input is plan-master.md and the roster.
user-invocable: true
allowed-tools: ListAgents, SendMessage, Bash, Read, Glob, Grep, Edit
metadata:
  catzc:
    config:
      model_floor: sonnet
      needs: [pwsh]
---

# plan-orchestrate

Run as the main session, never a subagent, which cannot see the peers' replies; edit plan and task files only.

1. On (re)start: `Test-Plans` first, then `plan-master.md` (its list is the order), the task files its open lines name, the `prompt-*` files
   beside them and the last lines of `out/orchestrator-<date>.log`, which the `Record-SessionMessage` hook writes: output, not input.
2. `ListAgents` is the roster, the sessions the user started; none is ever spawned. Three one-line messages: `what are you working on?`;
   `continue with this: <plan> step <n>; owns <files>; check <check>`, never the plan's text; `stop; <reason>`. A reply reads as
   `working on <chunk>`, `landed <step> with <verdict line>`, `blocked on <what>` or `nothing in hand`; else ask once more, then record it
   unclear; an idle notice older than the session's last reply is stale.
3. One chunk per session, the next open in the master's order whose dependencies are landed and whose files no live session holds; it waits,
   never splits (WDR-PULLWORK-PULLNOTPUSH, WDR-PULLWORK-LIMITWORKINPROGRESS); at most two heavy runs at a time, lined up on the run lock.
4. A landed step is ticked in its task file with the verdict line given; a claim without one stays "reported, unverified"; plan checks batch
   into one `Test-Plans` run per report.
5. Every question, a worker's or a plan's, is decided after reading the governing decision records and recorded as delegated in the owning
   plan; a recommendation is a decision, never a question; only git, settings.json and CLAUDE.md reach the user.
6. Two sessions on one file: the later gets `stop; <session> holds <file>`, recorded in both task files; an import-path burst runs under
   `Enter-CatzcBurst.ps1`, whose run lock holds every peer; no HOLD or GO is broadcast. A session in prompting mode holds its messages until
   the user approves them, so a repeated idle timestamp reads as a message waiting on that approval, never a reason to re-ping or reassign;
   the harness's idle subscription is made once per session, never renewed.
7. Repeat steps 2 to 6 until every session reports done or the user stops; report sessions with chunks, steps ticked, blockers, chunks open.
