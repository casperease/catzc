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
twice elsewhere. The time-safeguard trim of the same file is plan-agent-friction's step 3.

## Why its value is medium

It cuts a cost paid by every session and every spawn that loads the project instructions, but breaks nothing.

## Decided (the user, 2026-10-21, decision round)

- **Two learned-by-failure facts become merged clauses, no new line** (Q4, Q5): `catzc-module` says a shipped config value away from its
  type's default carries a `differs` reason in `configs.yml`; `catzc-run` says `Format-Code` inside a robot takes `-Path` on the files
  touched, never `-Language markdown`.
- **The probe cap is a comment on the 2020-hindsight entry only** (Q6): the robot rule in `agents.yml` stays as it is.
- **The learnings log stays signed `Cats`** (Q7): no `persona` key on `CapabilityEntry`.

## Open steps

1. [ ] Susan from HR: `.claude/CLAUDE.md`, section Sub-agents (4797 bytes of a 14407-byte file, 2026-10-21): each bullet cut to the agent
       name and one clause, the full purpose left to the agent's `description` and `agents.yml`; target 2400 bytes, saving about 2400 bytes
       (about 600 tokens) per session. The file is dirty in a peer's tree, so the step waits until no peer has it dirty, and it is the
       user's step in task-user-runs-and-commits.md. Check: `Test-AgentDefinitions` (it still finds every registered name listed, and none
       unregistered), `Test-Links -Path .claude/CLAUDE.md`, and `wc -c .claude/CLAUDE.md` at most 12100.
2. [ ] Susan from HR: Hindsight d7c207 "If only one capability pointed at the index": in the same edit, the `docs/references/` line of
       Project structure names `docs/references/pwsh/index.md` as where a design round starts (about 70 bytes added, paid for by step 1's
       cut; no new line, no new file). Cost today: no robot, capability or CLAUDE.md line names the index. Check:
       `Test-Links -Path .claude/CLAUDE.md`, and `wc -c .claude/CLAUDE.md` still at most 12100.
3. [ ] `.claude/skills/catzc-module/SKILL.md`: merge into an existing line the clause that a shipped config value away from its type's
       default carries a `differs` reason in `configs.yml` (`Test-ShippedConfigs` fails it otherwise); no line added. Check:
       `Test-AgentDefinitions`, and `wc -l` on the file unchanged.
4. [ ] `.claude/skills/catzc-run/SKILL.md`: merge into an existing line the clause that `Format-Code` inside a robot takes `-Path` on the
       files touched, never `-Language markdown`; no line added. Check: `Test-AgentDefinitions`, and `wc -l` on the file unchanged.
5. [ ] `pwsh/Catzc.Base.Docs/configs/agents.yml`: a comment on the `2020-hindsight` entry that a robot reading a long log caps its probes
       per line and writes in batches, since a 40-turn roof ended its first run before its one write. Check: `Test-AgentDefinitions`.

## Open questions

- From catzc-72's finalize (2026-10-21): the `session-finalize` skill's step 2 runs `Format-Code -Language markdown` over the whole tree,
  which this run used and which reformatted two files outside the session (a peer's learnings file and a reference page), against decision
  Q5. Should step 2 say `Format-Code -Path` on the plans touched? Recommendation: yes, the same clause Q5 gives `catzc-run`.
- Same finalize: `plan-decide` names no folder for its questionnaire and decisions files (older rounds used `.claude/plans`, this one
  `out/`). Should its step 2 name `out/`? Recommendation: yes, three words merged into the line, since `out/` keeps them off `Test-Plans`.
- Same finalize: bash `find` and `grep -r` over the tree exceed the 3 s foreground roof. Should `catzc-run`'s fastest-runner line say the
  Grep and Glob tools answer a tree sweep? Recommendation: yes, a merged clause, no new line.
