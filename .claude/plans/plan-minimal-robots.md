---
plan:
  status: active
  value: high
  reviewed: 2026-10-16
  targets: [.claude/agents, .claude/skills, automation/Catzc.Base.Docs/configs/agents.yml, automation/Catzc.Base.Docs/configs/capabilities.yml, automation/Catzc.Base.Docs/Test-AgentDefinitions.ps1, docs/adr/repository/agent-definitions.md, .claude/CLAUDE.md]
  siblings: [plan-minimal-robots-agents, plan-minimal-robots-capabilities]
---

# Minimal-Robots: every sub-agent is a 20-line robot that loads 10-line capabilities

The seven agents in `.claude/agents/` run 78 to 126 lines each (747 lines total); two name a model, five inherit the session's.
Every spawn re-reads that prose cold. A Minimal-Robot is one agent file of at most 20 body lines on the cheapest model that can
do the job, which loads its know-how from capabilities: 10-line files, mostly fixed front matter, each with a model floor. The
know-how is declared once, in the capability, and shared by every robot that loads it (ADR-PRIN-CONFIG, ADR-PRIN-REDUCEVAR,
ADR-PRIN-NOWASTE#1). This plan is the program; the two siblings are the catalogues.

## The mechanism (fixed by the harness, verified 2026-10-16 against the Claude Code docs)

- A capability is a project skill: `.claude/skills/<name>/SKILL.md`. An agent preloads it with the `skills:` front-matter list,
  which injects the full file into the agent's context at start (up to 32 names). That is the only load path; a robot never
  reads a capability at run time, so the load costs no turn.
- A preloaded skill must not set `disable-model-invocation: true` (the harness refuses to preload it). To keep a capability out of
  the `/` menu it sets `user-invocable: false`; to keep the main session from auto-loading it, its `description` names the robot it
  serves and `paths:` can pin it to the files it is about.
- `model:` on a skill is a selection, not a restriction, and applies only when the skill is invoked or forked, never when preloaded.
  So the model restriction of a capability lives in catzc data: `metadata.catzc.model_floor` (`haiku` | `sonnet` | `opus`). The
  harness ignores `metadata`; the gate enforces it: an agent's `model` must be at or above the highest floor of the capabilities
  it preloads. "Model restrictions giving an agent a capability" is realised exactly there.
- Agent front matter the robots use, fixed order: `name`, `description`, `tools`, `disallowedTools`, `model`, `effort`, `maxTurns`,
  `skills`, then the catzc head (`catzc:` key, kept by Format-FileMeta). Nothing else; an unknown key is a gate failure.
- Capability front matter, fixed order: `name`, `description`, `user-invocable: false`, `allowed-tools`, `paths` (optional),
  `metadata: { catzc: { model_floor, needs } }`, then the catzc head. `needs` names the tools outside catzc the capability runs
  (`uv`, `pillow`, `drawio`), so a missing tool is a stated precondition, not a surprise.

## The shape rules (become ADR-REPO-AGENTS rules 6 to 12; the numbers are proposals)

1. **Robot roof.** An agent file's body, everything after the closing `---`, is at most 20 lines at the repository line width.
   The roof is a setting, `roofs.agent_body_lines` in `agents.yml`, never a literal in the gate.
2. **Cheapest usable model.** Every agent names `model`. The default is `haiku`; `sonnet` only with a `model_reason` in the
   registry; `opus` only where a rule needs design judgement (none proposed today). The model is never below the highest
   `model_floor` of the capabilities the agent preloads.
3. **Capability roof.** A capability file is at most 10 lines outside its catzc head, front matter and body together. The catzc
   head is excluded because Format-FileMeta writes it and it is not the author's text. Setting: `roofs.capability_lines`.
4. **Declared once.** The `skills:` list in the agent file is the one declaration of what an agent loads; the registry never
   repeats it. The model floor lives only in the capability's `metadata.catzc.model_floor`; the registry never repeats it.
5. **No orphan, no ghost.** Every capability is preloaded by at least one agent, and every name in a `skills:` list is a capability
   file. A capability exists because an agent loads it, the way an agent exists because a rule supports it (ADR-REPO-AGENTS#2).
6. **Capability registry.** `capabilities.yml` beside `agents.yml`: one entry per capability with `supported_by` (rule citations)
   and `checks` (the gates and checks it runs or guards, `[]` when none), validated on load by a `CapabilitiesConfig` type the
   same way `AgentsConfig` validates agents (ADR-CONF-LOADING).
7. **One body shape.** A robot body is: one line that says the job, numbered steps (each one action with its tool), one line that
   says what the fixed report contains. The report shape itself is the `report.fixed` capability, so no robot restates it.

## Gate

`Test-AgentDefinitions` keeps its six checks (ADR-REPO-AGENTS#5) and gains, as one gate (no second gate for the same family):

- a body over `roofs.agent_body_lines`; a missing `model`; a front-matter key outside the fixed set; a key out of the fixed order;
- a `skills:` name with no `.claude/skills/<name>/SKILL.md`; an agent `model` below a preloaded capability's `model_floor`;
- a capability file with no registry entry or an entry with no file; a capability over `roofs.capability_lines`; a capability
  missing `user-invocable: false`, `allowed-tools`, or `metadata.catzc.model_floor`; a capability no agent preloads;
- a capability `supported_by` citation that names no rule (through `Get-CatsAdrRuleIds`); a `checks` entry that names no command.

The integrity test keeps running it over the real tree. Fixture agents and capabilities for the L0 tests use neutral names
(widget-robot, gadget.cap), per the fixture rule.

## Docs

- Amend `docs/adr/repository/agent-definitions.md`: the rules above, a "Capabilities" context section (why a skill, why the floor
  is data, why preload and not read), and the enforcement list. Decision proposed here: amend, no new ADR, because a capability is
  part of an agent's definition and one ADR keeps one living account of delegation (ADR-PRIN-ONELIVE). Open: Q3 below.
- `.claude/CLAUDE.md` "Sub-agents": keep one bullet per agent (ADR-REPO-AGENTS#3) but each bullet shrinks to one line; add one
  sentence that names `.claude/skills/` as the capability folder and the two roofs.
- Glossary: `robot` (a Minimal-Robot agent), `capability` (a preloaded skill with a model floor), `model floor`.
- `docs/references/automation/catzc-base-docs/configs/capabilities.yml.md` page, generated like the `agents.yml` page.

## Phases

- **Phase 0, decide.** Answer Q1 to Q6 below and paste in the second agent and second capability. Nothing is written before the
  roofs and the home of the ADR text are settled.
- **Phase 1, doctrine and gate.** ADR amendment; `roofs` and `capabilities.yml` with their config types; the gate extensions with
  L0 tests on fixtures; the CLAUDE.md sentence; glossary terms. Run the gate: it must fail on every existing agent (no model, over
  the roof) so the migration has a red-to-green signal.
- **Phase 2, the proposed pair.** Capabilities `drawio.renderer` and `report.fixed`, robot `drawio-png`; then the user's second
  agent and capability. Prove the renderer on one real `docs/.assets` diagram, output under `out/drawio/`.
- **Phase 3, rewrite the seven.** One agent at a time, least to most knowledge: print-artifacts, write-drawio-files,
  build-inspiration-module, session-cost-audit, test-optimization, catzc-worker, drawio-diagram-waves. For each: extract its
  know-how into capabilities from the catalogue, write the 20-line body, set the model, run the gate, run the agent once on a real
  brief and compare its report with the old agent's. The old file is replaced in the same change; no `*-v2`, no parked copy.
- **Phase 4, the recommended four.** gate-runner, link-fixer, adr-reviewer, glossary-keeper from the agents sibling, each with
  its registry entry, its CLAUDE.md line, and its name in the standard agent's description (ADR-REPO-AGENTS#4).
- **Phase 5, measure.** `session-cost-audit` (now a robot) runs on a session that spawned each robot once; the context bytes per
  spawn and the model mix go into "Done, and why" before this plan is deleted.

## Open questions

- Q1 Roof counting: the 20 lines are the body only, as proposed, or body plus front matter minus the catzc head? Recommendation:
  body only; the front matter is fixed by rule 4 and the gate caps `description` at 3 lines instead.
- Q2 Capability roof: 10 lines including front matter, the catzc head excluded. The examples in the sibling fit in 10. Confirm, or
  set 12 so a `paths:` line and a `needs:` line fit together.
- Q3 ADR home: amend ADR-REPO-AGENTS (recommended) or a new ADR-REPO-CAPS for capabilities.
- Q4 Capability name form: dotted `drawio.renderer` (a domain prefix and a job) is a valid skill directory name. Confirm dots over
  hyphens; the gate then enforces `^[a-z]+(\.[a-z-]+)+$` for capabilities and `^[a-z-]+$` for agents.
- Q5 drawio-diagram-waves orchestrates 12 makers with the Agent tool; its wave logic does not fit 20 lines. Recommendation: the
  wave protocol becomes a capability (`drawio.waves`), the makers become the `drawio-png` robot, and the lead body is the loop.
  Alternative: split into a lead robot and a maker robot.
- Q6 Effort and turns: set `effort: low` and `maxTurns` on every haiku robot as a cost brake, or leave both to the harness default.
  Recommendation: set both; the `maxTurns` per robot is in the catalogue.

## Done, and why

Nothing yet.
