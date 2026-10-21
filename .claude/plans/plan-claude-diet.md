---
plan:
  status: active
  value: medium
  reviewed: 2026-10-21
  class: meta
  targets: [.claude/CLAUDE.md]
---

# Claude diet: bytes every session reads

`.claude/CLAUDE.md` is 14294 bytes (about 3574 tokens, bytes / 4, an estimate) read at the start of every session; the Sub-agents section is
4788 of them. Each agent's purpose already sits in its `description` front matter and in `agents.yml`, so the section restates a fact held
twice elsewhere. The time-safeguard trim of the same file is plan-agent-friction's step 7.

## Why its value is medium

It cuts a cost paid by every session and every spawn that loads the project instructions, but breaks nothing.

## Open steps

1. [ ] Susan from HR: `.claude/CLAUDE.md`, section Sub-agents (4788 bytes today): each bullet cut to the agent name and one clause, the full
       purpose left to the agent's `description` and `agents.yml`; target 2400 bytes, saving about 2400 bytes (about 600 tokens) per
       session. The file is dirty in a peer's tree, so the step waits until no peer has it dirty, and it is the user's step in
       task-user-runs-and-commits.md. Check: `Test-AgentDefinitions` (it still finds every registered name listed, and none unregistered),
       `Test-Links -Path .claude/CLAUDE.md`, and `wc -c .claude/CLAUDE.md` at most 11900.
2. [ ] Susan from HR: Hindsight d7c207 "If only one capability pointed at the index": in the same edit, the `docs/references/` line of
       Project structure names `docs/references/pwsh/index.md` as where a design round starts (about 70 bytes added, paid for by step 1's
       cut; no new line, no new file). Cost today: no robot, capability or CLAUDE.md line names the index. Check:
       `Test-Links -Path .claude/CLAUDE.md`, and `wc -c .claude/CLAUDE.md` still at most 11900.

## Open questions

- From the session that built the hindsight robots (2026-10-21): three facts it learned by failure could each shrink what the next session
  reads, as one clause merged into an existing capability line rather than a new line anywhere. Should `catzc-module` say that a shipped
  config value away from its type's default carries a `differs` reason in configs.yml (`Test-ShippedConfigs` fails it otherwise)? Should
  `catzc-run` say that `Format-Code` inside a robot takes `-Path` on the files touched, never `-Language markdown`, since the whole-tree run
  rewrote 68 files a session then had to diff? Should the robot rule in `agents.yml` say that a robot reading a log of many lines caps its
  probes per line and writes in batches, since a 40-turn roof ended the first hindsight run before its one write? Recommendation: yes to the
  first two as merged clauses, no new line; the third only as a comment on the 2020-hindsight entry.
- From the same session, after the personas landed (2026-10-21): the learnings log is signed `Cats`, the system's own name, since a main
  session running `/session-finalize` is no robot and has no persona in `agents.yml`. Should it stay `Cats`, or should the finalizing
  session sign with a person name of its own, bound once where `session-finalize` is registered in `capabilities.yml` (which would add a
  `persona` key to `CapabilityEntry`)? Recommendation: stay `Cats`; the lines are the system talking to its next session, and a second
  registry key would only move noise.
