---
plan:
  status: active
  value: high
  reviewed: 2026-10-16
  targets:
    [
      .claude/agents,
      .claude/skills,
      automation/Catzc.Base.Docs/configs/agents.yml,
      automation/Catzc.Base.Docs/configs/capabilities.yml,
      automation/Catzc.Base.Docs/Test-AgentDefinitions.ps1,
      docs/adr/repository/agent-definitions.md,
      .claude/CLAUDE.md,
    ]
  siblings: [plan-minimal-robots-agents, plan-minimal-robots-capabilities]
catzc:
  immutable:
    with_body_sha: f285afe8201a
    repo_status: clean
    path: ".claude/plans/plan-minimal-robots.md"
    folder: plans
    name: plan-minimal-robots
    filetype: md
    kind: other
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
  edges:
    cites:
      - ADR-PRIN-NOWASTE#1
---

# Minimal-Robots: every sub-agent is a 20-line robot that loads 10-line capabilities

A Minimal-Robot is one agent file of at most 20 body lines on the cheapest model that can do the job, loading its know-how from
capabilities: 10-line skill files, mostly fixed front matter, each with a model floor. The know-how is declared once, in the capability, and
shared by every robot that loads it (ADR-PRIN-CONFIG, ADR-PRIN-REDUCEVAR, ADR-PRIN-NOWASTE#1). This plan is the program; the two siblings
are the catalogues. Phases 0 to 4 are landed; Phase 5 (measure) is the open work.

## The mechanism (fixed by the harness, verified 2026-10-16 against the Claude Code docs)

- A capability is a project skill: `.claude/skills/<name>/SKILL.md`. An agent preloads it with the `skills:` front-matter list, which
  injects the full file into the agent's context at start (up to 32 names). That is the only load path; a robot never reads a capability at
  run time, so the load costs no turn.
- A preloaded skill must not set `disable-model-invocation: true`. To keep a capability out of the `/` menu it sets `user-invocable: false`;
  its `description` names the robot it serves and `paths:` can pin it to the files it is about.
- `model:` on a skill is a selection, not a restriction, and applies only when the skill is invoked or forked, never when preloaded. The
  model restriction of a capability is catzc data, `metadata.catzc.config.model_floor` (`haiku`, `sonnet` or `opus`). The harness ignores
  `metadata`; the gate enforces it: an agent's `model` is at or above the highest floor of the capabilities it preloads.
- Agent front matter, fixed order: `name`, `description`, `tools`, `disallowedTools`, `model`, `effort`, `maxTurns`, `skills`, then the
  catzc head. Capability front matter, fixed order: `name`, `description`, `user-invocable: false`, `allowed-tools`, `paths` (optional),
  `metadata` (the catzc head with `config: { model_floor, needs }`). `needs` names the tools outside catzc the capability runs, so a missing
  tool is a stated precondition.
- Capability names are `<domain>-<job>`, hyphenated: the harness allows only lowercase letters, digits and hyphens in a skill name.

## Decided

- The shape rules (robot roof of 20 body lines, cheapest usable model, capability roof of 10 lines, declared once, no orphan and no ghost,
  capability registry, one body shape) are ADR-REPO-AGENTS rules 6 to 10; the roofs are settings in `agents.yml`, not literals in the gate.
  Q127 to Q132 and Q139 in decisions-2026-10-16.md record the choices (body-only counting, amend the ADR, effort and maxTurns on every
  robot, the drawio-waves capability with drawio-png as maker).
- ADR-AI is named once, in the CLAUDE.md session-start line and as `contracts` in `agents.yml`, never per file (Q140).

## Done, and why

- Phases 0 to 4: the ADR rules, `roofs` and `capabilities.yml` with their config types, the extended `Test-AgentDefinitions` (registered in
  `languages.yml`, so `Test-Change` covers a changed robot, capability or registry), the glossary terms robot, capability and model floor,
  the CLAUDE.md sentence, 15 robots and 18 capabilities. Gate 0 and tests passing at the last run.
- Measured at the first spawns: about 3,900 tokens per drawio-png spawn, about 380 per slide for the deterministic render step, about 1,790
  per optional look at a PNG (`out/drawio/token-count.md`).

## Open steps

- [ ] Phase 5, measure: run `session-cost-audit` on a session that spawned each robot once; record the context bytes per spawn and the model
      mix here (check: its report in `out/` names both for every robot).
- [ ] Reconcile the seven shape rules above with the ADR, which carries rules 6 to 10: add the one that is missing or state that two rules
      merged (check: Test-AgentDefinitions clean and each rule of the list is cited by an ADR rule number in the Decided section).
- [ ] When Phase 5 is recorded, delete this plan and its two siblings if they have no open step (check: `Test-Links` clean on
      `.claude/plans`).

## Refs

- plan-minimal-robots-agents, plan-minimal-robots-capabilities (the catalogues; they hold the per-robot and per-capability open steps)
- plan-adr-ai (the contract every robot reads first)
- docs/adr/repository/agent-definitions.md
