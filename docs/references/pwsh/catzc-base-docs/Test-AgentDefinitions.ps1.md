# pwsh/Catzc.Base.Docs/Test-AgentDefinitions.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Quality gate: the sub-agent definitions, their capabilities, both registries, and the .claude/CLAUDE.md list agree.

### description

A quality gate ([ADR-AUTO-TEST-QUALITYGATE](../../../adr/automation/test-automation.md#rule-adr-auto-test-qualitygate)) over the sub-agent
definitions `.claude/agents/*.md`, the capabilities `.claude/skills/*/SKILL.md`, the two registries (Get-Config -Config agents, an
AgentsConfig; Get-Config -Config capabilities, a CapabilitiesConfig), and the `## Sub-agents` section of .claude/CLAUDE.md
([ADR-REPO-AGENTS](../../../adr/repository/agent-definitions.md)). It collects an issue when:

- an agent file has no registry entry, or an entry has no agent file;
- a file's front matter does not parse, its `name` differs from the file name, or it lacks a `description`, a `Do NOT` clause in that
  description, or `tools`
  ([ADR-REPO-AGENTS-ONEFILEPERAGENT](../../../adr/repository/agent-definitions.md#rule-adr-repo-agents-onefileperagent));
- a `supported_by` citation names no rule (Get-CatsAdrRuleIds), or a `checks` entry names no command
  ([ADR-REPO-AGENTS-BACKEDBYRULE](../../../adr/repository/agent-definitions.md#rule-adr-repo-agents-backedbyrule));
- a registered agent is not listed in the CLAUDE.md section, or a listed agent is not registered
  ([ADR-REPO-AGENTS-LISTEDINCLAUDEFILE](../../../adr/repository/agent-definitions.md#rule-adr-repo-agents-listedinclaudefile));
- a specialised agent is not named in the standard agent's description
  ([ADR-REPO-AGENTS-STANDARDWORKER](../../../adr/repository/agent-definitions.md#rule-adr-repo-agents-standardworker));
- an agent's body has more lines than roofs.agent_body_lines, or its front matter carries a key outside the robot set or out of the fixed
  order ([ADR-REPO-AGENTS-ROBOTBODYLIMIT](../../../adr/repository/agent-definitions.md#rule-adr-repo-agents-robotbodylimit));
- .claude/CLAUDE.md does not name a contract of the registry's `contracts`, the contracts every robot reads first, named once there and
  never per file ([ADR-REPO-AGENTS-ROBOTBODYLIMIT](../../../adr/repository/agent-definitions.md#rule-adr-repo-agents-robotbodylimit));
- an agent names no `model`, names `inherit`, or names a model below the highest `model_floor` of the capabilities it preloads
  ([ADR-REPO-AGENTS-NAMEDMODEL](../../../adr/repository/agent-definitions.md#rule-adr-repo-agents-namedmodel));
- a capability has more lines than roofs.capability_lines outside its catzc head (nested at the key path its carrier names, metadata.catzc),
  its `name` differs from its folder, its `user-invocable` differs from its registry's `invoked_by` (true only for a user skill), or it
  lacks `allowed-tools` or a `metadata.catzc.config.model_floor` of haiku, sonnet or opus
  ([ADR-REPO-AGENTS-CAPABILITYFILE](../../../adr/repository/agent-definitions.md#rule-adr-repo-agents-capabilityfile));
- a `skills` name has no capability file, or a capability is preloaded by no agent
  ([ADR-REPO-AGENTS-NOORPHANNOGHOST](../../../adr/repository/agent-definitions.md#rule-adr-repo-agents-noorphannoghost));
- a `skills` list names a user skill, which no robot preloads
  ([ADR-REPO-AGENTS-USERSKILL](../../../adr/repository/agent-definitions.md#rule-adr-repo-agents-userskill));
- a capability file has no registry entry, an entry has no file, or an entry's citation or check resolves to nothing
  ([ADR-REPO-AGENTS-CAPABILITYREGISTERED](../../../adr/repository/agent-definitions.md#rule-adr-repo-agents-capabilityregistered)).

The registries' own shape (citation and command spelling, distinct names, a standard that names an entry, the roofs) is an AgentsConfig or
CapabilitiesConfig construction rule, not this gate's.

### parameter `OutputFolder`

The report base folder. Defaults to out/test-agent-definitions/ (Write-QualityGateReport).

### parameter `PassThru`

Return the result ({ Subject; IssueCount; Issues; ReportPath; Agents; Files; Capabilities }) instead of throwing on issues.

### outputs

`[Catzc.Base.Reports.QualityGateResult]` With -PassThru only.

### example 1

```powershell
Test-AgentDefinitions
```
