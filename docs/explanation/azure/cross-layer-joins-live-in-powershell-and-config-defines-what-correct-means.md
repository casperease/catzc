---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-DATAMOD-JOINSINPOWERSHELL
      - ADR-AZ-SESSION-CONFIGDEFINESCORRECT
---

# Cross layer joins live in powershell and config defines what correct means

This article is one rule: [ADR-AZ-DATAMOD-JOINSINPOWERSHELL](../../drs/azure/azure-data-model.md#rule-adr-az-datamod-joinsinpowershell) and
[ADR-AZ-SESSION-CONFIGDEFINESCORRECT](../../drs/azure/az-session-verification.md#rule-adr-az-session-configdefinescorrect) merged into one.
It holds nothing beyond what those two rules say.

The cross-layer joins live in PowerShell, resolved on demand: `Get-AzureSubscription`, `Get-AzureEnvironment` and
`Get-BicepDeploymentContext`. The deploy-time subscription is determined by the az session and reverse-resolved against `azure.yml`. Config
defines what correct means: whether the session is connected to the right place is decided solely by config, `azure.yml` subscription and
tenant and `ado.yml` organization and tenant, never by the presence of a credential alone.
