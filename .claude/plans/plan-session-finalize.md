---
plan:
  status: active
  value: low
  reviewed: 2026-10-21
  class: feature
  targets: [docs/adr/repository/agent-definitions.md, pwsh/Catzc.Base.Docs/Test-AgentDefinitions.ps1]
---

# Session finalize: make the capability roof easy to predict

`/session-finalize` (ADR-REPO-AGENTS-USERSKILL) is the checkpoint the user runs on a main session before clearing it. One thing a session
had to find out the hard way when it wrote the skill is still held only in that session: the capability roof counts the top-level front-matter keys as well as the body, which the rule's wording does not say.

## Why its value is low

It cuts a rediscovery, not a defect: the gate already catches an over-roof file.

## Decided (the user, 2026-10-21, decision round)

- **No user-skill line in `.claude/CLAUDE.md`**: the harness lists `/session-finalize` in every session, and a second enforced list would
  widen ADR-REPO-AGENTS-LISTEDINCLAUDEFILE for little gain.
- **No drawing** of robot-loaded capabilities beside user-invoked skills: ADR-REPO-AGENTS-USERSKILL and the `invoked_by` key state it.

## Open steps

1. [ ] `docs/adr/repository/agent-definitions.md`: rule ADR-REPO-AGENTS-CAPABILITYFILE says the roof counts each top-level front-matter key
       (`name`, `description`, `user-invocable`, `allowed-tools`) as well as each body line, so four of the ten are spent before the body.
       It also says wrapping never helps, so a new item needs an existing line merged (the same lesson plan-agent-shortcuts carried as its
       Q3). Check: `Test-Links -Path docs/adr/repository/agent-definitions.md` and `Test-Spelling` on the file pass.
2. [ ] `pwsh/Catzc.Base.Docs/Test-AgentDefinitions.ps1`: the over-roof message names both counts ("4 front-matter keys and 7 body lines"),
       from `Get-RobotLineCount`. Check: `Invoke-TestFile pwsh/Catzc.Base.Docs/tests/Test-AgentDefinitions.Tests.ps1` passes with the
       message updated.
