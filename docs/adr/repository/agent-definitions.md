---
catzc:
  immutable:
    with_body_sha: "87260716b58a"
    path: docs/adr/repository/agent-definitions.md
    folder: docs/adr/repository
    name: agent-definitions
    filetype: md
    kind: adr
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    defines:
      - ADR-REPO-AGENTS#{1-10}
    cites:
      - ADR-AUTO-TEST#35
      - ADR-REPO-LINK#5
    links:
      - docs/adr/automation/test-automation.md#rule-adr-auto-test35
      - docs/adr/configuration/module-config-loading.md
      - docs/adr/design/visual-design.md
      - docs/adr/principles/configure-not-program.md
      - docs/adr/principles/reduce-variability.md
      - docs/adr/repository/markdown-links.md#rule-adr-repo-link5
---

# ADR: Agent definitions — every sub-agent rests on a rule and maps to its checks

## Rules: ADR-REPO-AGENTS

### Rule ADR-REPO-AGENTS:1

Each sub-agent is defined in one file, `.claude/agents/<name>.md`. Its front matter carries `name`, equal to the file name without `.md`; a
`description` that says when to use the agent and, in a `Do NOT` clause, when not to; and `tools`, the tools the agent may use.

- [One file per agent](#one-file-per-agent)

### Rule ADR-REPO-AGENTS:2

Every sub-agent exists because an ADR rule supports it. It is registered in `automation/Catzc.Base.Docs/configs/agents.yml` with
`supported_by`, the rule citations (`ADR-<CODE>#<n>`) that justify it, and `checks`, the gate and check functions it runs or guards. An
agent that runs and guards no catzc check declares `checks: []`, so the absence is stated, never implied.

- [A rule for every agent](#a-rule-for-every-agent)

### Rule ADR-REPO-AGENTS:3

Every registered agent is listed in the `## Sub-agents` section of `.claude/CLAUDE.md`, as a bullet that opens with its name in bold code
(``**`<name>`**``). The section lists no agent the registry lacks.

- [Listed where sessions start](#listed-where-sessions-start)

### Rule ADR-REPO-AGENTS:4

`catzc-worker` is the standard sub-agent: delegated work goes to it unless a specialised agent fits. The registry names it as `standard`. A
specialised agent exists only when a rule justifies its specialised job, and the standard agent's `description` names every specialised
agent, so a reader of the standard agent knows where each specialised job goes.

- [One standard agent](#one-standard-agent)

### Rule ADR-REPO-AGENTS:5

`Test-AgentDefinitions` is the quality gate for these rules. It keeps the agent files, the registry, and the `.claude/CLAUDE.md` list in
step, and it resolves every `supported_by` citation to a real rule and every `checks` entry to an existing command.

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-REPO-AGENTS:6

A sub-agent is a **robot**: its file's body, everything after the front matter, has at most `roofs.agent_body_lines` lines (20, declared
once on `AgentsConfig` and set in `agents.yml`), a line being one that starts something of its own, so a wrapped continuation counts
with the line it continues and a blank or comment line counts as nothing; its front matter carries only the robot keys in their fixed order
(`name`, `description`, `tools`, `disallowedTools`, `model`, `effort`, `maxTurns`, `skills`, then the catzc head); and its body is one
job line, numbered steps of one action each, and the report line. The contracts every robot reads first (`agents.yml` `contracts`, today
`ADR-AI`) are named once, there and in `.claude/CLAUDE.md`, never in a file's front matter.

- [Robots and capabilities](#robots-and-capabilities)

### Rule ADR-REPO-AGENTS:7

Every robot names its `model`, never `inherit`. The default is `haiku`; a robot above it carries a `model_reason` in the registry; and
no robot runs below the highest **model floor** of the capabilities it preloads, the floor being the lowest model that performs a
capability's steps reliably.

- [Robots and capabilities](#robots-and-capabilities)

### Rule ADR-REPO-AGENTS:8

A **capability** is one file `.claude/skills/<domain>-<job>/SKILL.md` (lowercase letters, digits and hyphens, the only characters the
harness accepts in a skill name) that a robot preloads through its `skills` list: at most
`roofs.capability_lines` lines outside its catzc head (10, the `---` delimiters excluded, lines counted as rule 6 counts them), with
`name` equal to its folder,
`user-invocable: false`, `allowed-tools`, and a `metadata.catzc.model_floor` of `haiku`, `sonnet` or `opus`, declared there once and
nowhere else.

- [Robots and capabilities](#robots-and-capabilities)

### Rule ADR-REPO-AGENTS:9

No orphan and no ghost: every capability is preloaded by at least one robot, and every name in a `skills` list is a capability file. A
capability exists because a robot loads it, as a robot exists because a rule supports it.

- [Robots and capabilities](#robots-and-capabilities)

### Rule ADR-REPO-AGENTS:10

Every capability is registered in `automation/Catzc.Base.Docs/configs/capabilities.yml` with `supported_by` and `checks`, the way an
agent is in `agents.yml`; neither registry repeats the model floor or the `skills` list, which live in their one file each.
`Test-AgentDefinitions` enforces rules 6 to 10 together with rules 1 to 5.

- [How this is enforced](#how-this-is-enforced)

## Context

A sub-agent is a prompt with tools that a session hands work to. Its definition steers what the agent does, which files it touches, and
which checks it runs before it reports. An agent with no reason to exist duplicates another one, drifts from the domain rules, and splits
delegated work across several ways of doing the same job ([ADR-PRIN-REDUCEVAR](../principles/reduce-variability.md)).

### One file per agent

Claude Code discovers an agent from its file under `.claude/agents/` and picks it by its `description`. A `name` that differs from the file
name makes the agent hard to find from either side. A description that says only when to use the agent, and not when to leave it alone,
pulls in work that belongs to a neighbour. The `Do NOT` clause is where each agent hands that work on.

### A rule for every agent

An agent is code that runs with the session's permissions, so it answers to the domain rules like any function does. The registry records
the reason for each agent as rule citations, the same `ADR-<CODE>#<n>` spelling a test tag uses
([ADR-REPO-LINK#5](markdown-links.md#rule-adr-repo-link5)). It also records the gates and checks the agent runs or guards. A renumbered rule
or a renamed quality gate then fails a check instead of leaving an agent that points at nothing.

### Listed where sessions start

Every session reads `.claude/CLAUDE.md` first. Its `## Sub-agents` list is the one place a session learns which agents exist and which one
is the standard, so an agent missing from it is never picked, and a stale entry sends work to an agent that is gone.

### One standard agent

Most delegated work is the same shape: one task from a coordinator's brief, a named set of files, each file verified before the next, and a
fixed report. One standard agent carries that shape, so each delegation does not invent its own. A specialised agent pays for itself only
where the job needs knowledge the standard agent lacks, such as the diagram grammar of [ADR-DSGN-VISUAL](../design/visual-design.md), and
that need is exactly what a supporting rule states.

### Robots and capabilities

Every spawn of a sub-agent reads its whole definition cold, so a long definition is paid for on every delegation, and know-how written
into one agent is written again into the next. A robot keeps its own file to the job and its steps, and loads the know-how it shares
with other robots from capabilities: one skill file each, injected whole by the harness at spawn through the `skills` list, so a load
costs no turn. A capability is written once and read by every robot that lists it ([ADR-PRIN-CONFIG](../principles/configure-not-program.md),
[ADR-PRIN-REDUCEVAR](../principles/reduce-variability.md)). The roofs keep both small enough to be read whole on every spawn, and live in
the registry as settings, never as literals in the gate.

A skill's own `model` key is a selection the harness honours only when the skill is invoked or forked, never when it is preloaded, so it
cannot restrict the robot that loads it. The restriction is catzc data instead: the model floor in the capability's `metadata`, which
the harness ignores and the gate enforces against the robot's `model`. The cheapest model that does the job is the default; a dearer one
needs its reason written down where the registry can show it, so a model choice is a decision and never a habit.

## Decision

Each sub-agent is one `.claude/agents/<name>.md` file, registered in `agents.yml` with the rules that support it and the checks it runs or
guards, and listed in `.claude/CLAUDE.md`. `catzc-worker` is the standard agent; any other agent is specialised and justified by a rule.
Every agent is a robot: a body under the roof, a named model at or above the floors of the capabilities it preloads, and its shared
know-how in capabilities under `.claude/skills/`, each registered in `capabilities.yml` and loaded by at least one robot.

### How this is enforced

- **`agents.yml`** (in `Catzc.Base.Docs`) is the registry, read through `Get-Config -Config agents` and validated on load by its config
  type, `AgentsConfig`, with one `AgentEntry` per agent ([ADR-CONF-LOADING](../configuration/module-config-loading.md)). The type rejects an
  unknown key, a malformed or repeated name, an empty `supported_by`, a citation without a rule number, a missing `checks` list, and a
  `standard` that names no entry, and reports every violation at once.
- **`Test-AgentDefinitions`** is the quality gate ([ADR-AUTO-TEST#35](../automation/test-automation.md#rule-adr-auto-test35)). It reports:
  - an agent file with no registry entry, and an entry with no file;
  - front matter that does not parse, a `name` that differs from the file name, and a missing `description`, `Do NOT` clause, or `tools`;
  - a `supported_by` citation that names no rule (resolved through `Get-CatsAdrRuleIds`);
  - a `checks` entry that names no command;
  - a registered agent that the `## Sub-agents` section of `.claude/CLAUDE.md` does not list, and a listed agent that is not registered;
  - a specialised agent that the standard agent's `description` does not name;
  - a robot body over `roofs.agent_body_lines`, a front-matter key outside the robot set or out of the fixed order, a missing or
    inherited `model`, or a `model` below the floor of a preloaded capability (`Get-RobotLineCount` counts the lines);
  - a capability over `roofs.capability_lines`, with a `name` unlike its folder, user-invocable, without `allowed-tools` or a valid
    `metadata.catzc.model_floor`, preloaded by no robot, or named in a `skills` list without a file;
  - a capability file with no `capabilities.yml` entry, an entry with no file, or an entry whose citation or check resolves to nothing.
- **`capabilities.yml`** (in `Catzc.Base.Docs`) is the capability registry, read through `Get-Config -Config capabilities` and validated
  on load by `CapabilitiesConfig`, one `CapabilityEntry` per capability, with the same shape rules as `AgentsConfig`. The roofs are
  `roofs` in `agents.yml`; their defaults are declared once on `AgentsConfig`.
- An integrity test runs the gate over the real tree, so every default test run includes it.

## Consequences

- A new agent is a three-part change: its file, its registry entry with the rules behind it, and its line in `.claude/CLAUDE.md`. Leaving
  any one part out fails the gate.
- An agent that no rule supports cannot be registered honestly. The missing rule is written first, or the work goes to `catzc-worker`.
- Renumbering a rule or renaming a gate that an agent cites fails the gate, so the registry never points at a rule or command that is gone.
- The registry answers which agents guard a given check, and why each agent exists, without reading every agent's prompt.
