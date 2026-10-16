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

- **Phase 0, decide.** Done 2026-10-16: see Decided.
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

## Decided (2026-10-16, questionnaire items Q127 to Q132 and Q139)

- Q127 Roof counting: the 20 lines are the body only; the gate caps `description` at 3 lines (rule 1).
- Q128 Capability roof: 10 lines outside the catzc head, front matter and body together; the built drawio.renderer is 11 by this count
  and loses one line in Phase 1 (rule 3).
- Q129 ADR home: amend ADR-REPO-AGENTS with rules 6 to 12 and a Capabilities context section; no new ADR.
- Q130 Name form: capabilities are dotted `<domain>.<job>`; the gate enforces `^[a-z]+(\.[a-z-]+)+$` for capabilities and `^[a-z-]+$`
  for agents.
- Q131 drawio-diagram-waves: the wave protocol becomes the `drawio.waves` capability (floor sonnet), the makers are the drawio-png robot,
  the lead body is the loop.
- Q132 Effort and turns: every robot sets `effort` and `maxTurns`; the gate requires both keys; the maxTurns per robot is in the agents
  catalogue.
- Q139 Next: Phase 1 now. The shared capabilities (catzc.run, catzc.gate, git.readonly, md.links, report.fixed) were built by a peer
  session during the round, so Phase 1 starts from whole robots; each decision above becomes an ADR rule in the same change (Q97).

## Done, and why

- 2026-10-16: `drawio.renderer`, `plan.shape`, `drawio-png`, `plan-clear` built and gate-green (Phase 2 ahead of Phase 1, on the
  user's go). The kit got its first source-controlled defaults file, `.claude/drawio/drawio.yml` (`renderer.page: dark`,
  `renderer.out: out/drawio`), read without a YAML library; a parameter overrides an entry for one run. `drawio_forward.py` is
  the fail-forward step and drives the minimap pipeline for one slide from the slide itself. Three slides regenerated with fresh
  minimaps in 9 to 10 s each; the token count is in `out/drawio/token-count.md`: about 3,900 tokens per spawn, about 380 per
  slide for the deterministic step, about 1,790 per optional look at a PNG.
- 2026-10-16, Phase 1 landed on the recommended answers (Q1 body lines only; Q2 10 content lines, delimiters and catzc head excluded;
  Q3 amend ADR-REPO-AGENTS; Q4 dotted names; Q6 effort and maxTurns set, not gated): ADR-REPO-AGENTS rules 6 to 10 with a "Robots and
  capabilities" context; `roofs` in agents.yml with defaults on `AgentsConfig`; `capabilities.yml` with `CapabilitiesConfig` and
  `CapabilityEntry` (dotted names), registered in configs.yml; file kind `capability`; `Test-AgentDefinitions` extended (roof, key
  set and order, model, floor, orphan, ghost, registry) with `Get-RobotLineCount`; L0 tests for every new rule; glossary terms robot,
  capability, model floor; CLAUDE.md sentence; generated pages rebuilt, Test-GeneratedFiles 0.
- 2026-10-16, Phase 3 and 4 landed in one pass: all seven old agents rewritten as robots (print-artifacts, write-drawio-files,
  build-inspiration-module, session-cost-audit, test-optimization, catzc-worker, drawio-diagram-waves), their know-how in
  capabilities artifact.publish, drawio.model-edit, drawio.look, catzc.module, catzc.verify, test.speed, drawio.waves; the inventory
  script of print-artifacts became `.claude/drawio/catalogue.py`. Sonnet with a `model_reason` for catzc-worker,
  build-inspiration-module, test-optimization, drawio-diagram-waves, plan-clear; haiku for the rest. Open: Q5 answered by making
  drawio-png the maker; the only gate issues left are the `contracts` key of plan-intake and plan-decide, a design conflict with
  rule 6 that the user decides (plan-adr-ai), relayed by session catzc-bf.
- 2026-10-16, decided (Q140 in decisions-2026-10-16.md, after one wrong relay that briefly put the key on every file): ADR-AI is
  named once, never per file. Rule 6's key set stays closed; the required set is `contracts` in agents.yml, default once on
  `AgentsConfig`; `.claude/CLAUDE.md` carries the session-start line that names it, linked to the contract and to
  `docs/references/agent-contracts.md`; the gate checks CLAUDE.md names every contract of the registry. The key was removed again from
  every file this session owns; the two staged peer files are catzc-71's to clean. The index registration of ADR-AI stays with
  plan-adr-ai; the gate reads the code as a literal, so neither blocks the other.
- 2026-10-16, Q4 reversed by the harness: a skill name may hold only lowercase letters, digits and hyphens (the user hit the error on
  `adr.cite`), so the capability form is `<domain>-<job>`. All 18 folders renamed, every `skills:` list, body reference, registry name,
  the `CapabilityEntry` name rule (at least one hyphen), rule 8, CLAUDE.md, the glossary short and the test fixtures follow. The three
  planner-session skills (plan-intake, plan-decide, plan-value) were renamed with the rest, the peers told. The hyphen made
  `catzc-gate` a "gate" family phrase for the glossary (ADR-REPO-VOCAB), so that capability is `catzc-check`.
- 2026-10-16: `Test-AgentDefinitions` registered in `languages.yml` as a check of markdown and yaml, so `Test-Change` covers a changed
  robot, capability or registry; its registry issues name the repo-relative registry path so Test-Change can attribute them. The
  session script `out/mr-final.ps1` is thereby replaced by `Test-Change` and goes with the next out/ prune; `regen-explanation.py`
  is the one worth folding into the kit as a bulk mode of `drawio_forward.py` (open step in the capabilities plan).
- 2026-10-16: Test-Change over the robot files surfaced what the rewrite had dropped: every robot and capability carries an H1 title
  (Test-MarkdownTitle, MD041) and is prettier-formatted at the repository width. The wrap made physical lines the wrong measure, so
  the roofs count lines that start something of their own: a wrapped continuation counts with its line, a blank or comment line as
  nothing (`Get-RobotLineCount`, rules 6 and 8, a test). Test-Change over all 33 files: 0 issues; gate 0; tests pass.
