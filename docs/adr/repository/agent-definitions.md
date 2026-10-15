# docs/adr/repository/agent-definitions.md

`ADR: Agent definitions — every sub-agent rests on a rule and maps to its checks`

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

## Decision

Each sub-agent is one `.claude/agents/<name>.md` file, registered in `agents.yml` with the rules that support it and the checks it runs or
guards, and listed in `.claude/CLAUDE.md`. `catzc-worker` is the standard agent; any other agent is specialised and justified by a rule.

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
  - a specialised agent that the standard agent's `description` does not name.
- An integrity test runs the gate over the real tree, so every default test run includes it.

## Consequences

- A new agent is a three-part change: its file, its registry entry with the rules behind it, and its line in `.claude/CLAUDE.md`. Leaving
  any one part out fails the gate.
- An agent that no rule supports cannot be registered honestly. The missing rule is written first, or the work goes to `catzc-worker`.
- Renumbering a rule or renaming a gate that an agent cites fails the gate, so the registry never points at a rule or command that is gone.
- The registry answers which agents guard a given check, and why each agent exists, without reading every agent's prompt.
