# pwsh/Catzc.Base.Docs/types/AgentEntry.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One entry of configs/agents.yml's `agents` list: a sub-agent definition (.claude/agents/<name>.md) with the ADR
rules that support it and the gate and check functions it runs or guards
([ADR-REPO-AGENTS-BACKEDBYRULE](/docs/drs/repository/agent-definitions.md#rule-adr-repo-agents-backedbyrule)). Mirrors the YAML mapping
(snake_case keys, [ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](/docs/drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).
AgentsConfig builds one per entry and prefixes every violation with the entry's index.

Constructing an instance validates the entry, collecting every violation into one ArgumentException:
  - only the keys name, supported_by, and checks;
  - name is required and kebab-case (the agent file's name without .md);
  - supported_by is a non-empty list of distinct rule citations ADR-<CODE>#<n>;
  - checks is required and is a list (empty when the agent runs and guards no check) of distinct Verb-Noun
    command names.
Whether a citation names a real rule, a check names an existing command, and the agent file exists are
filesystem and session facts, checked by the quality gate Test-AgentDefinitions, not on load.
```

## comment:2

Above `public string model_reason { get; }`, written with `//`.

```text
Why the agent runs above the default model, when it does; null when it runs on the default
([ADR-REPO-AGENTS-NAMEDMODEL](/docs/drs/repository/agent-definitions.md#rule-adr-repo-agents-namedmodel)).
```

## comment:3

Above `internal static IReadOnlyList<string> ReadList(IDictionary d, string key,...`, written with `//`.

```text
Reads a required list of distinct strings that each match the pattern, collecting every violation.
Shared with CapabilityEntry, whose registry entries have the same two lists.
```
