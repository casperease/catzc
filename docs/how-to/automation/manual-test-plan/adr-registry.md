---
catzc:
  derived:
    path: docs/how-to/automation/manual-test-plan/adr-registry.md
    folder: docs/how-to/automation/manual-test-plan
    name: adr-registry
    filetype: md
    kind: how-to
    language: markdown
    track: docs
    body_sha: "9130e4758ce4"
    links:
      - docs/how-to/automation/manual-test-plan.md
---

# Manual test plan — ADR registry

The ADR rule-sets, the domain graph, the generated ADR index, and the rule enforcers. Part of the
[manual test plan](../manual-test-plan.md), which says how to run a check.

## Index

| #   | Tier | Test file                                                           | FullNameFilter                                 | Guards                                                                                                                                                                                                                                                                                                                                                                                                                               |
| --- | ---- | ------------------------------------------------------------------- | ---------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| 1   | L1   | automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1           | Get-AdrRuleSet integrity                       | The flattened ADR rule-sets agree with the ADR files: each heads its Rules section with the declared external code, sits under its own domain folder, and every citation code is unique.                                                                                                                                                                                                                                             |
| 2   | L1   | automation/Catzc.Base.Docs/tests/Build-AdrIndex.Tests.ps1           | Build-AdrIndex — generated ADR index           | docs/adr/index.md is the code-to-ADR registry generated from adrs.yml (Build-AdrIndex), committed and reproduced on import; every ruleset is one parseable row linking to a real ADR file, and `Test-GeneratedFiles -Generator Build-AdrIndex` reports no drift.                                                                                                                                                                     |
| 3   | L1   | automation/Catzc.Base.Docs/tests/Test-AgentDefinitions.Tests.ps1    | Test-AgentDefinitions — real agent definitions | `Test-AgentDefinitions` reports 0 issues: every .claude/agents/*.md has an agents.yml entry and back, front matter parses with name = file name, a description with a Do NOT clause, and tools, every supported_by cites a real ADR rule, every checks entry is an existing command, .claude/CLAUDE.md's Sub-agents section lists exactly the registered agents, and the standard agent's description names every specialised agent. |
| 4   | L2   | automation/Catzc.Base.Docs/tests/Test-AdrEngineNeutrality.Tests.ps1 | Test-AdrEngineNeutrality — real ADRs           | `Test-AdrEngineNeutrality` reports 0 issues: the rule summaries of the configured ADR domains carry no engine-specific syntax.                                                                                                                                                                                                                                                                                                       |
| 5   | L2   | automation/Catzc.Base.Docs/tests/Test-AdrRegistry.Tests.ps1         | Test-AdrRegistry — real ADRs                   | `Test-AdrRegistry` reports 0 issues: the ADR registry (adrs.yml) and the ADR rule files under docs/adr/ agree.                                                                                                                                                                                                                                                                                                                       |
