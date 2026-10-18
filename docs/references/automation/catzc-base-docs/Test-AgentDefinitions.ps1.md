# automation/Catzc.Base.Docs/Test-AgentDefinitions.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Quality gate: the sub-agent definitions, their capabilities, both registries, and the .claude/CLAUDE.md list agree.

### description

A quality gate ([ADR-AUTO-TEST#35](../../../adr/automation/test-automation.md#rule-adr-auto-test35)) over the sub-agent definitions
`.claude/agents/*.md`, the capabilities `.claude/skills/*/SKILL.md`, the two registries (Get-Config -Config agents, an AgentsConfig;
Get-Config -Config capabilities, a CapabilitiesConfig), and the `## Sub-agents` section of .claude/CLAUDE.md
([ADR-REPO-AGENTS](../../../adr/repository/agent-definitions.md)). It collects an issue when:

- an agent file has no registry entry, or an entry has no agent file;
- a file's front matter does not parse, its `name` differs from the file name, or it lacks a `description`, a `Do NOT` clause in that
  description, or `tools` ([ADR-REPO-AGENTS#1](../../../adr/repository/agent-definitions.md#rule-adr-repo-agents1));
- a `supported_by` citation names no rule (Get-CatsAdrRuleIds), or a `checks` entry names no command
  ([ADR-REPO-AGENTS#2](../../../adr/repository/agent-definitions.md#rule-adr-repo-agents2));
- a registered agent is not listed in the CLAUDE.md section, or a listed agent is not registered
  ([ADR-REPO-AGENTS#3](../../../adr/repository/agent-definitions.md#rule-adr-repo-agents3));
- a specialised agent is not named in the standard agent's description
  ([ADR-REPO-AGENTS#4](../../../adr/repository/agent-definitions.md#rule-adr-repo-agents4));
- an agent's body has more lines than roofs.agent_body_lines, or its front matter carries a key outside the robot set or out of the fixed
  order ([ADR-REPO-AGENTS#6](../../../adr/repository/agent-definitions.md#rule-adr-repo-agents6));
- .claude/CLAUDE.md does not name a contract of the registry's `contracts`, the contracts every robot reads first, named once there and
  never per file ([ADR-REPO-AGENTS#6](../../../adr/repository/agent-definitions.md#rule-adr-repo-agents6));
- an agent names no `model`, names `inherit`, or names a model below the highest `model_floor` of the capabilities it preloads
  ([ADR-REPO-AGENTS#7](../../../adr/repository/agent-definitions.md#rule-adr-repo-agents7));
- a capability has more lines than roofs.capability_lines outside its catzc head (nested at the key path its carrier names, metadata.catzc),
  its `name` differs from its folder, it is user-invocable, or it lacks `allowed-tools` or a `metadata.catzc.config.model_floor` of haiku,
  sonnet or opus ([ADR-REPO-AGENTS#8](../../../adr/repository/agent-definitions.md#rule-adr-repo-agents8));
- a `skills` name has no capability file, or a capability is preloaded by no agent
  ([ADR-REPO-AGENTS#9](../../../adr/repository/agent-definitions.md#rule-adr-repo-agents9));
- a capability file has no registry entry, an entry has no file, or an entry's citation or check resolves to nothing
  ([ADR-REPO-AGENTS#10](../../../adr/repository/agent-definitions.md#rule-adr-repo-agents10)).

The registries' own shape (citation and command spelling, distinct names, a standard that names an entry, the roofs) is an AgentsConfig or
CapabilitiesConfig construction rule, not this gate's.

### parameter OutputFolder

The report base folder. Defaults to out/test-agent-definitions/ (Write-QualityGateReport).

### parameter PassThru

Return the result ({ Subject; IssueCount; Issues; ReportPath; Agents; Files; Capabilities }) instead of throwing on issues.

### outputs

`[pscustomobject]` With -PassThru only.

### example 1

```powershell
Test-AgentDefinitions
```
