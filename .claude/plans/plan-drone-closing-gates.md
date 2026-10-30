---
plan:
  status: active
  value: medium
  reviewed: 2026-10-30
  class: process
  targets: [.claude/skills/catzc-verify]
---

# Drone briefs that close on the gates a full run applies

A drone that ticks a plan's steps on its own test files leaves formatting, function-help pages, analyzer and glossary findings for the
user's full run to find: on 2026-10-30 the test-result-markers chunk passed every named check and the full run still failed four gates.

## Open steps

1. [ ] Once the open question is answered yes, add its line to `.claude/skills/catzc-verify/SKILL.md`'s end-of-task checks. Check:
       `Test-AgentDefinitions` reads 0 issues.

## Open questions

- Simplify proposal, not yet answered: one line in the `catzc-verify` skill's end-of-task checks naming `Format-Code`, `Test-Formatting`,
  `Test-ScriptAnalyzer`, `Test-Glossary` and `Test-Terminology` on every path the drone touched, and that a new private function needs its
  comment page with a `## help` section; and a plan of more than four steps goes to two drones, since one drone hit its 50-turn limit on
  seven.
