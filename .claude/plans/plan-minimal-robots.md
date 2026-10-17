---
plan:
  status: active
  value: high
  reviewed: 2026-10-17
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

- The shape rules are ADR-REPO-AGENTS rules 6 to 10, each with its home (reconciled 2026-10-17, task013, no rule missing): the robot roof
  of 20 body lines and the one body shape (one job line, numbered steps, the report line) are rule 6; the cheapest usable model is rule 7;
  the capability roof of 10 lines is rule 8; no orphan and no ghost is rule 9; the capability registry is rule 10, and declared once is rule
  10 for the model floor and the skills list and rule 6 for the contract. The roofs are settings in `agents.yml`, not literals in the gate.
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

- [x] Phase 5, measure. Done 2026-10-17 (task013) by a read of the files, not a run: a robot's context at spawn is its agent file plus the
      capabilities it preloads plus the contract it reads first (`ai-agent-contract.md`, 3,646 bytes); tokens are about a quarter of the
      bytes. No robot exceeds 4,000 tokens on this measure; the two heaviest, catzc-worker and drawio-diagram-waves, carry six capabilities
      each (check: the table under "Phase 5 measure" names the model and the bytes for all 15 robots).
- [x] Reconcile the seven shape rules above with the ADR. Done 2026-10-17 (task013): every rule of the list carries its rule number in the
      Decided section; none is missing, the body shape is part of rule 6, and declared once is rules 6 and 10 (check: Test-AgentDefinitions
      clean, `out/test-agent-definitions/20261017-174412`).
- [ ] Delete this plan and its two siblings, which have no open step of their own: the user's `git rm` of `plan-minimal-robots.md`,
      `plan-minimal-robots-agents.md` and `plan-minimal-robots-capabilities.md`; their three lines stand under "Deleted" in
      `value-of-plan.md` (check: `Test-Links` clean on `.claude/plans` after the deletion).

## Phase 5 measure (2026-10-17, read from the files)

| Robot                    | Model  | Agent bytes | Capability bytes | With the contract | Tokens, about |
| ------------------------ | ------ | ----------- | ---------------- | ----------------- | ------------- |
| catzc-worker             | sonnet | 2,950       | 8,366            | 14,962            | 3,740         |
| drawio-diagram-waves     | sonnet | 2,386       | 8,919            | 14,951            | 3,740         |
| write-drawio-files       | haiku  | 2,065       | 8,243            | 13,954            | 3,490         |
| test-optimization        | sonnet | 2,458       | 6,955            | 13,059            | 3,260         |
| build-inspiration-module | sonnet | 2,370       | 6,437            | 12,453            | 3,110         |
| plan-clear               | sonnet | 1,828       | 6,831            | 12,305            | 3,080         |
| glossary-keeper          | haiku  | 1,838       | 5,743            | 11,227            | 2,810         |
| link-fixer               | haiku  | 1,560       | 5,674            | 10,880            | 2,720         |
| plan-decide              | sonnet | 2,483       | 4,508            | 10,637            | 2,660         |
| print-artifacts          | haiku  | 2,028       | 4,885            | 10,559            | 2,640         |
| plan-intake              | sonnet | 2,125       | 4,519            | 10,290            | 2,570         |
| session-cost-audit       | haiku  | 2,990       | 3,328            | 9,964             | 2,490         |
| drawio-png               | haiku  | 2,132       | 4,093            | 9,871             | 2,470         |
| gate-runner              | haiku  | 1,582       | 3,530            | 8,758             | 2,190         |
| adr-reviewer             | sonnet | 1,582       | 3,330            | 8,558             | 2,140         |

Seven robots run on sonnet with a `model_reason`, eight on haiku. The one measured spawn, drawio-png at about 3,900 tokens
(`out/drawio/token-count.md`), sits above its 2,470 static tokens by the harness's own preamble, which no file here controls.

## Refs

- plan-minimal-robots-agents, plan-minimal-robots-capabilities (the catalogues; they hold the per-robot and per-capability open steps)
- plan-adr-ai (the contract every robot reads first)
- docs/adr/repository/agent-definitions.md
