# pwsh/Base.Docs/types/AgentsConfig.cs

The sub-agent registry (`configs/agents.yml`): one entry per sub-agent definition under `.claude/agents/`, with the rules that support it
and the checks it runs or guards
([ADR-REPO-AGENTS-BACKEDBYRULE](../../../../drs/repository/agent-definitions.md#rule-adr-repo-agents-backedbyrule)). It is registered in
`Catzc.Base.Config/configs/configs.yml`, so `Get-Config -Config agents` returns this typed record
([ADR-CONF-LOADING-CSHARPCONFIGTYPE](../../../../drs/configuration/module-config-loading.md#rule-adr-conf-loading-csharpconfigtype)). It
mirrors the YAML mapping, snake_case keys
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Validation

Constructing an instance collects every violation into one `ArgumentException`:

- only the top-level keys `agents` (required), `roofs` and `contracts` are allowed;
- `agents` is a non-empty list of well-formed `AgentEntry` mappings with distinct names.

The cross-checks against the agent files, the rule ids, the commands and `.claude/CLAUDE.md` are the quality gate `Test-AgentDefinitions`.

## Properties

- **`contracts`** — the contracts every robot and capability names in its front matter under `contracts`, the default declared once here
  ([ADR-REPO-AGENTS-ROBOTBODYLIMIT](../../../../drs/repository/agent-definitions.md#rule-adr-repo-agents-robotbodylimit)).
- **`agent_body_lines`** — the most body lines an agent file may have, 20 by default and overridable in `roofs`.
- **`capability_lines`** — the most lines a capability file may have outside its catzc head, delimiters excluded, 30 by default
  ([ADR-REPO-AGENTS-CAPABILITYFILE](../../../../drs/repository/agent-definitions.md#rule-adr-repo-agents-capabilityfile)).
