---
plan:
  status: active
  value: low
  reviewed: 2026-10-21
  class: feature
  targets: [.claude/CLAUDE.md, docs/adr/repository/agent-definitions.md, pwsh/Catzc.Base.Docs/Test-AgentDefinitions.ps1]
---

# Session finalize: make the first user skill easy to find and its roof easy to predict

`/session-finalize` (ADR-REPO-AGENTS-USERSKILL) is the checkpoint the user runs on a main session before clearing it. Two things a session
had to find out the hard way when it wrote the skill are still held only in that session: a user skill is listed nowhere a session starts,
and the capability roof counts the top-level front-matter keys as well as the body, which the rule's wording does not say.

## Why its value is low

Both items cut a rediscovery, not a defect: the gate already catches an over-roof file, and the user invokes the skill by name.

## Open questions

- **Q1: Does `.claude/CLAUDE.md` list the user skills?** Recommendation: yes, one line under `## Sub-agents` naming `/session-finalize` as
  the checkpoint before a clear, kept in step by `Test-AgentDefinitions` the way the agents list is (ADR-REPO-AGENTS-LISTEDINCLAUDEFILE
  widened to user skills). The alternative is no line: the harness already lists the skill in every session's skill listing.
- **Q2: Does a drawing of robot-loaded capabilities beside user-invoked skills earn its place?** Recommendation: no; the two-line rule and
  the `invoked_by` key say it, and a drawing is rendered only when asked.

## Open steps

1. [ ] `docs/adr/repository/agent-definitions.md`: rule ADR-REPO-AGENTS-CAPABILITYFILE says the roof counts each top-level front-matter key
       (`name`, `description`, `user-invocable`, `allowed-tools`) as well as each body line, so four of the ten are spent before the body.
       Check: `Test-Links -Path docs/adr/repository/agent-definitions.md` and `Test-Spelling` on the file pass.
2. [ ] `pwsh/Catzc.Base.Docs/Test-AgentDefinitions.ps1`: the over-roof message names both counts ("4 front-matter keys and 7 body lines"),
       from `Get-RobotLineCount`. Check: `Invoke-TestFile pwsh/Catzc.Base.Docs/tests/Test-AgentDefinitions.Tests.ps1` passes with the
       message updated.
3. [ ] `.claude/CLAUDE.md` and `pwsh/Catzc.Base.Docs/Test-AgentDefinitions.ps1`: the user-skill line and its check, once Q1 is answered yes
       and no peer has `.claude/CLAUDE.md` dirty. Check: the same test file passes with a case for an unlisted user skill.
