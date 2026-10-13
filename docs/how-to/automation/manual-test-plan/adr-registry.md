# docs/how-to/automation/manual-test-plan/adr-registry.md

`Manual test plan — ADR registry`

The ADR rule-sets, the domain graph, the generated ADR index, and the rule enforcers. Part of the
[manual test plan](../manual-test-plan.md), which says how to run a check.

## Index

| #   | Tier | Test file                                                 | FullNameFilter                       | Guards                                                                                                                                                                                                                                                           |
| --- | ---- | --------------------------------------------------------- | ------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | L1   | automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1 | Get-AdrRuleSet integrity             | The flattened ADR rule-sets agree with the ADR files: each heads its Rules section with the declared external code, sits under its own domain folder, and every citation code is unique.                                                                         |
| 2   | L1   | automation/Catzc.Base.Docs/tests/Build-AdrIndex.Tests.ps1 | Build-AdrIndex — generated ADR index | docs/adr/index.md is the code-to-ADR registry generated from adrs.yml (Build-AdrIndex), committed and reproduced on import; every ruleset is one parseable row linking to a real ADR file, and `Test-GeneratedFiles -Generator Build-AdrIndex` reports no drift. |
