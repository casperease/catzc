---
plan:
  status: active
  value: high
  reviewed: 2026-10-16
  parent: plan-minimal-robots
  targets: [.claude/agents, automation/Catzc.Base.Docs/configs/agents.yml, .claude/CLAUDE.md]
---

# Minimal-Robots catalogue: the agents

Two robots the user proposed, four recommended, and the seven existing agents rewritten to the same shape. Every robot: at most
20 body lines, `model` named, `skills:` lists its capabilities (catalogue in plan-minimal-robots-capabilities), registered in
`agents.yml` with `supported_by` and `checks`, one line in `.claude/CLAUDE.md`, named in the standard agent's description.
Model rule: haiku unless a line here gives the reason for sonnet.

## Fixed front matter (the whole set, in this order; the catzc head follows)

```yaml
name: <file name>
description: <when to use, one Do NOT clause; at most 3 lines>
tools: <comma list>
disallowedTools: <comma list, may be empty>
model: haiku | sonnet
effort: low | medium
maxTurns: <n>
skills: [<capability>, ...]
```

## Proposed robot 1: drawio-png

- **Job.** Talks to the user in simple prompts. Takes one or more addresses: a `.drawio.png` (new or existing) and the markdown
  sources whose text the diagram must show. Runs the renderer capability, reports the raster-versus-model differences, links the
  `out/` artifact. Never lands anything under `docs/`; the user does.
- **Model.** haiku. The looking is vision on a PNG, the rendering is a script, the comparison is a list. `effort: low`,
  `maxTurns: 12`.
- **Tools.** Bash, Read, Glob, Grep, Write. `disallowedTools: Edit` (it writes to `out/` only).
- **Skills.** drawio.renderer, drawio.look, catzc.run, report.fixed.
- **Registry.** `supported_by: [ADR-DSGN-VISUAL#4, ADR-REPO-FOLDERS#5]`, `checks: [Test-CheckedInBinaries]`.
- **Body draft (14 lines).** Job line; 1. resolve each given address against `$env:RepositoryRoot`, stop with a one-line ask if one
  is missing; 2. read the markdown sources and list the labels they imply; 3. run drawio.renderer on the PNG; 4. read the source
  PNG and the `out/` PNG and list what differs (missing, extra, mislabelled cells, colour off the dark tokens); 5. compare the labels
  against step 2; 6. report with the `out/` link. Report line.
- **Open.** Does this robot also become the maker inside drawio-diagram-waves (plan-minimal-robots Q5)? Recommended yes.

## Proposed robot 2: plan-clear

- **Built 2026-10-16** as `.claude/agents/plan-clear.md` (8-step body, 11 body lines). The plan cleaner of questionnaire Q06: a
  verdict per plan in `.claude/plans/` (keep, trim, re-point, delete, intake), acted on one file at a time, links re-checked.
  Deletes only when the user asked; otherwise lists "to delete". Never touches a file another session has dirty.
- **Model.** sonnet (judging whether a plan's data is in the tree reads several files), `effort: medium`, `maxTurns: 30`.
- **Tools.** Bash, Read, Glob, Grep, Write, Edit. **Skills.** plan.shape, md.links, git.readonly, report.fixed; only plan.shape
  exists yet, the harness skips the other three with a debug warning until Phase 4 builds them.
- **Registry.** `supported_by: [ADR-PRIN-ONELIVE#1, ADR-PRIN-NOWASTE#1]` (add the ADR-REPO-PLANS rule once it exists),
  `checks: [Test-Links]`. Listed in CLAUDE.md and named in catzc-worker's Do NOT clause.

## Recommended robot 3: gate-runner

- **Job.** Runs one named gate or test file in the background with the time safeguard and reports the result verbatim, pass or
  fail, with the failing lines. Nothing else. Every coordinator that today burns a 3-second foreground denial on a gate hands it
  here.
- **Model.** haiku, `effort: low`, `maxTurns: 6`. **Tools.** Bash, Read. **Skills.** catzc.run, catzc.gate, report.fixed.
- **Registry.** `supported_by: [ADR-AUTO-FAILFAST#7, ADR-AUTO-TEST#35]`, `checks: [Invoke-TestFile, Test-Automation]`.

## Recommended robot 4: link-fixer

- **Job.** Takes a list of markdown files; for each, runs `Test-Links`, re-points relative links that resolve one level wrong (the
  carried-text problem value-of-plan.md names), one file at a time, re-runs the check, reports. Never touches link text, only the
  target.
- **Model.** haiku, `effort: low`, `maxTurns: 20`. **Tools.** Bash, Read, Grep, Edit. **Skills.** md.links, catzc.run, report.fixed.
- **Registry.** `supported_by: [ADR-REPO-LINK#1, ADR-REPO-LINK#5]`, `checks: [Test-Links]`.

## Recommended robot 5: adr-reviewer

- **Job.** Read-only review of a named diff or file set against the ADRs that govern those files: reads `docs/adr/index.md`, the
  governing ADRs in full, and reports each finding as `path:line`, the rule code, and one sentence. No edits, no sweep of the
  corpus (the CLAUDE.md rule).
- **Model.** sonnet. Reason: it must weigh a rule's prose against code, which haiku misreads on the ADR corpus. `effort: medium`,
  `maxTurns: 15`. **Tools.** Bash, Read, Glob, Grep; `disallowedTools: Write, Edit`. **Skills.** adr.cite, git.readonly, report.fixed.
- **Registry.** `supported_by: [ADR-PROC-BUILTIN#3, ADR-REPO-LINK#5]`, `checks: []`.

## Recommended robot 6: glossary-keeper

- **Job.** Given a term or a file set: runs `Test-Glossary`, adds or corrects the glossary entries the brief names, runs
  `Build-Glossary`, reports the terms changed and any collision found. One term per step.
- **Model.** haiku, `effort: low`, `maxTurns: 12`. **Tools.** Bash, Read, Grep, Edit. **Skills.** catzc.run, catzc.gate,
  report.fixed. **Registry.** `supported_by: [ADR-REPO-VOCAB#1]` (controlled-vocabulary; pick the rule that says terms live in
  the glossary), `checks: [Test-Glossary, Build-Glossary]`.

## Proposed robots 7 and 8: plan-intake and plan-decide (built 2026-10-16, the planner session written as robots)

- **Two jobs, two robots.** `plan-intake` lands a pasted continuation prompt in `.claude/plans/`: every item in exactly one plan, done
  claims checked against the tree first, prompts kept verbatim as files, open questions kept open, locked or in-use files never planned.
  `plan-decide` runs a decision round: a questionnaire with one item per open question, four per ask with the recommendation first, a
  decisions table with Q, Decision, Rec taken, Outcome, Note, then the fold into the plans. Neither answers a question itself.
- **Model.** sonnet for both. Reason: intake judges which plan owns an item and verifies claims across several files; decide writes a
  recommendation with a reason per item. `effort: medium`; `maxTurns: 30` and `60`.
- **Tools.** intake: Bash, Read, Glob, Grep, Write, Edit. decide: the same plus AskUserQuestion. **Skills.** intake: plan.intake,
  plan.value, git.readonly, report.fixed. decide: plan.decide, plan.value, git.readonly, report.fixed. Bodies 8 lines each.
- **Registry.** intake `supported_by: [ADR-PRIN-ONELIVE#5, ADR-PRIN-NOWASTE#1]`; decide `supported_by: [ADR-PRIN-CONFIG#5,
  ADR-PRIN-NOWASTE#1]` (a design question about one instance is answered by the default: the recommendation is the default). Both
  `checks: [Test-Links]`. Listed in CLAUDE.md and named in catzc-worker's Do NOT clause.
- **Open.** The lessons of 2026-10-16 the robots encode: first option is the recommendation (the user asked for no trick orders); an
  Outcome column; in-use files out of scope; a reframing answer is quoted. Add the ADR-REPO-PLANS rule to both registry entries once it
  exists.

## The seven existing agents, rewritten (Phase 3 of the program plan)

| Agent                    | Lines now | Model now | Model proposed | Capabilities it loads                                        | What leaves the body                            |
| ------------------------ | --------- | --------- | -------------- | ------------------------------------------------------------ | ----------------------------------------------- |
| print-artifacts          | 126       | inherit   | haiku          | catzc.run, report.fixed, artifact.publish (new, see sibling) | the page-building recipe, the answers format    |
| write-drawio-files       | 110       | haiku     | haiku          | drawio.model-edit, drawio.renderer, drawio.look, report.fixed | the chunk recipe, the dark-token migration     |
| build-inspiration-module | 78        | inherit   | sonnet         | catzc.run, catzc.gate, catzc.filehead, report.fixed          | the module conventions (they are ADR rules)     |
| session-cost-audit       | 92        | sonnet    | haiku          | catzc.run, git.readonly, report.fixed                        | the lever list (it lives in its plan)           |
| test-optimization        | 111       | inherit   | sonnet         | catzc.run, catzc.gate, report.fixed                          | the diagnosis checklist (becomes `test.speed`)  |
| catzc-worker             | 109       | inherit   | sonnet         | catzc.run, catzc.gate, catzc.filehead, adr.cite, report.fixed | the per-file verify loop (becomes `catzc.gate`) |
| drawio-diagram-waves     | 121       | inherit   | sonnet         | drawio.waves (new), drawio.look, report.fixed                | the scout, rank, make protocol (program Q5)     |

Sonnet reasons for the registry: build-inspiration-module and catzc-worker write code that must pass the analyzer and the tests
on the first run; test-optimization diagnoses; drawio-diagram-waves leads other agents. Each is a hypothesis to test in Phase 3:
run the rewritten robot on haiku first, and record in "Done, and why" whether it held.

## Open questions

- Q1 Does `drawio-png` replace `write-drawio-files` entirely once it also loads `drawio.model-edit`? Recommendation: no; one robot
  talks to the user and verifies, the other edits in batch on a brief. Two jobs, two robots (ADR-REPO-AGENTS#4).
- Q2 `adr-reviewer` on sonnet is the one recommended robot above haiku. Confirm, or start on haiku and promote on evidence.
- Q3 Agent name form: `drawio-png` as the file name for the user's "Drawio.png agent". Confirm.

## Done, and why

- 2026-10-16: `plan-intake` and `plan-decide` written to the fixed front matter (8 body lines each), registered in agents.yml, listed in
  CLAUDE.md, named in catzc-worker's Do NOT clause. Written by the planner session as its own robot form, so the method it learned today
  survives the session. Test-AgentDefinitions not run by the planner (it runs no gates); the next session that touches agents runs it.
