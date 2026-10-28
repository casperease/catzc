# Manual test plan — DRS registry

The DRS rule-sets, the domain graph, the generated DRS index, and the rule enforcers. Part of the
[manual test plan](../manual-test-plan.md), which says how to run a check.

## Index

| #   | Tier | Check                                                                                 |
| --- | ---- | ------------------------------------------------------------------------------------- |
| 1   | L1   | [Get-DrsRuleSet integrity][c1]                                                        |
| 2   | L2   | [Build-DrsIndex — generated DRS index][c2]                                            |
| 3   | L1   | [Test-AgentDefinitions — real agent definitions][c3]                                  |
| 4   | L2   | [Test-DrsEngineNeutrality — real records][c4]                                         |
| 5   | L2   | [Test-DrsRegistry — real records][c5]                                                 |
| 6   | L1   | [Get-DrsUsage (repository)][c6]                                                       |
| 7   | L1   | [Build-DrsIndex — shipped configs/drs.yml and types][c7]                              |
| 8   | L1   | [Test-AgentDefinitions — shipped configs/agents.yml and configs/capabilities.yml][c8] |
| 9   | L1   | [Build-DrsCodeDictionary — shipped configs/drs.yml][c9]                               |

[c1]: #1-get-drsruleset-integrity
[c2]: #2-build-drsindex--generated-drs-index
[c3]: #3-test-agentdefinitions--real-agent-definitions
[c4]: #4-test-drsengineneutrality--real-records
[c5]: #5-test-drsregistry--real-records
[c6]: #6-get-drsusage-repository
[c7]: #7-build-drsindex--shipped-configsdrsyml-and-types
[c8]: #8-test-agentdefinitions--shipped-configsagentsyml-and-configscapabilitiesyml
[c9]: #9-build-drscodedictionary--shipped-configsdrsyml

## Checks

### 1. Get-DrsRuleSet integrity

**Test file:** `pwsh/Base.Drs/tests/Get-DrsRuleSet.Tests.ps1` (L1), block `Get-DrsRuleSet integrity`.

**Guards:** The flattened DRS rule-sets agree with the decision-record files: each heads its Rules section with the declared external code,
sits under its own domain folder, and every citation code is unique.

### 2. Build-DrsIndex — generated DRS index

**Test file:** `pwsh/Base.Drs/tests/Build-DrsIndex.Tests.ps1` (L2), block `Build-DrsIndex — generated DRS index`.

**Guards:** docs/drs/index.md is the code-to-record registry generated from drs.yml (Build-DrsIndex), committed and reproduced on import;
every ruleset is one parseable row linking to a real decision-record file, and `Test-GeneratedFiles -Generator Build-DrsIndex` reports no
drift.

### 3. Test-AgentDefinitions — real agent definitions

**Test file:** `pwsh/Base.Docs/tests/Test-AgentDefinitions.Tests.ps1` (L1), block `Test-AgentDefinitions — real agent definitions`.

**Guards:** `Test-AgentDefinitions` reports 0 issues: every .claude/agents/\*.md has an agents.yml entry and back, front matter parses with
name = file name, a description with a Do NOT clause, and tools, every supported_by cites a real DRS rule, every checks entry is an existing
command, .claude/CLAUDE.md's Sub-agents section lists exactly the registered agents, and the standard agent's description names every
specialised agent.

### 4. Test-DrsEngineNeutrality — real records

**Test file:** `pwsh/Base.Drs/tests/Test-DrsEngineNeutrality.Tests.ps1` (L2), block `Test-DrsEngineNeutrality — real records`.

**Guards:** `Test-DrsEngineNeutrality` reports 0 issues: the rule summaries of the configured decision-record domains carry no
engine-specific syntax.

### 5. Test-DrsRegistry — real records

**Test file:** `pwsh/Base.Drs/tests/Test-DrsRegistry.Tests.ps1` (L2), block `Test-DrsRegistry — real records`.

**Guards:** `Test-DrsRegistry` reports 0 issues: the DRS registry (drs.yml) and the DRS rule files under docs/drs/ agree.

### 6. Get-DrsUsage (repository)

**Test file:** `pwsh/Base.QualityGates/tests/Get-DrsUsage.Tests.ps1` (L1), block `Get-DrsUsage (repository)`.

**Guards:** `Get-DrsUsage` lists the citations and links of the tracked files: every row has a path, a registered code and a rule that code
declares, a group never lands in a row, and the scan narrows by code, source and path (ADR-REPO-FILEMETA-IMPRINTEDPARTS).

### 7. Build-DrsIndex — shipped configs/drs.yml and types

**Test file:** `pwsh/Base.Drs/tests/Build-DrsIndex.Tests.ps1` (L1), block `Build-DrsIndex — shipped configs/drs.yml and types`.

**Guards:** Build-DrsIndex finds the domain registry and the C# type sources it stamps in the loaded module
(ADR-AUTO-ASSETDEP-COVEREDBYREALTEST).

### 8. Test-AgentDefinitions — shipped configs/agents.yml and configs/capabilities.yml

**Test file:** `pwsh/Base.Docs/tests/Test-AgentDefinitions.Tests.ps1` (L1), block
`Test-AgentDefinitions — shipped configs/agents.yml and configs/capabilities.yml`.

**Guards:** Test-AgentDefinitions finds the agent and capability registries it names in the loaded module
(ADR-AUTO-ASSETDEP-COVEREDBYREALTEST).

### 9. Build-DrsCodeDictionary — shipped configs/drs.yml

**Test file:** `pwsh/Base.Drs/tests/Build-DrsCodeDictionary.Tests.ps1` (L1), block `Build-DrsCodeDictionary — shipped configs/drs.yml`.

**Guards:** Build-DrsCodeDictionary finds the domain registry it stamps in the loaded module (ADR-AUTO-ASSETDEP-COVEREDBYREALTEST).
