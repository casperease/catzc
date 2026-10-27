---
plan:
  status: active
  value: medium
  reviewed: 2026-10-27
  class: feature
  targets: [pwsh/Azure.Templates]
---

# Evaluator burst: land the lazy if(), for-variables and deep variable evaluation

The plan-debt-azure-gaps evaluator step is built but not landed; its staged files live only in a session scratchpad, so they are lost when
that session clears.

## Open steps

- [ ] Land the staged `ArmExpression.cs` (lazy `if()`, `variables.copy` expansion, a variable's object or array evaluated leaf by leaf),
      its two L0 cases in `ArmExpression.Tests.ps1`, and `HubFirewall.Tests.ps1`'s evaluated route next-hop and policy-tier assertions, by
      `Invoke-StagedBurst` from
      `C:\Users\caspe\AppData\Local\Temp\claude\C--projects-catzc\880a03fc-e256-4e4d-9a2a-8a90eefaeab8\scratchpad\evaluator3\staged`;
      if that folder is gone, rebuild the three edits from this text. Then delete the evaluator step in plan-debt-azure-gaps. Check: the
      ArmExpression, HubFirewall, compliance, ProductionAlerts and Locks tests pass at `-MaxLevel 1`.
- [ ] Role assignments as code (plan-debt-azure-gaps) starts with expedition's data roles; discovery waits until catzc-92 releases
      discovery `main.bicep`, `options.yml` and its slots. Check: as that step states.
