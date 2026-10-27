# pwsh/Base.Docs/types/AgentEntry.cs

One entry of `configs/agents.yml`'s `agents` list: a sub-agent definition (`.claude/agents/<name>.md`) with the ADR rules that support it
and the gate and check functions it runs or guards
([ADR-REPO-AGENTS-BACKEDBYRULE](../../../../drs/repository/agent-definitions.md#rule-adr-repo-agents-backedbyrule)). It mirrors the YAML
mapping, snake_case keys
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).
`AgentsConfig` builds one per entry and prefixes every violation with the entry's index.

## Validation

Constructing an instance collects every violation into one `ArgumentException`:

- only the keys `name`, `supported_by`, `checks`, `model_reason` and `persona` are allowed;
- `name` is required and kebab-case (the agent file's name without `.md`);
- `supported_by` is a non-empty list of distinct rule citations `ADR-<CODE>#<n>`;
- `checks` is required and is a list (empty when the agent runs and guards no check) of distinct `Verb-Noun` command names;
- `persona`, when given, is a capitalised person name of at most four words.

Whether a citation names a real rule, a check names an existing command, and the agent file exists are filesystem and session facts, checked
by the quality gate `Test-AgentDefinitions`, not on load.

## model_reason

Why the agent runs above the default model, when it does; null when it runs on the default
([ADR-REPO-AGENTS-NAMEDMODEL](../../../../drs/repository/agent-definitions.md#rule-adr-repo-agents-namedmodel)).

## Shared list reader

`ReadList` reads a required list of distinct strings that each match a pattern, collecting every violation. It is shared with
`CapabilityEntry`, whose registry entries have the same two lists.
