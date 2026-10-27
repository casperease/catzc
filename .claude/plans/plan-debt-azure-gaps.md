---
plan:
  status: active
  value: medium
  reviewed: 2026-10-26
  class: feature
  targets: [infrastructure, pwsh/Azure.Templates, docs/drs/azure]
---

# Debt Azure gaps: the CAF recommendations the landing zone does not realise yet

The CAF records (`docs/drs/external/azure/caf/`) bind each Microsoft recommendation to the catzc rule that answers it; what is not built yet
is planned here, one step each, so no record carries a planned item.

## Open steps

- [ ] A health model per workload, its tool chosen when the work begins. Check: the workload's compiled template holds the health model.
- [x] Role assignments as code, the discovery slice: `role-assignment.bicep` (resource-group scope: resourceGroup | storageAccount |
      keyVault | sqlServer | workspace) and `subscription-role-assignment.bicep` (bicep refuses a subscription assignment from a
      resource-group file, BCP139), the `azure.yml` `groups:` map on AzureConfig/AzureGroupSet with its `groups` fact, discovery's standard
      set, `action-group.bicep`'s Owner by `roles.yml` address, and ADR-AZ-LZ-CAFIDENTITY rewritten. Check: one staged burst. Verdict
      (2026-10-27 burst): AzureConfig, Resolve-BicepEnvironmentFacts, Read-BicepTemplateOptions, Test-BicepLint, Test-BicepApiVersions,
      Build-Bicep.Integrity and Test-BicepTemplateCompliance passed, 7 of 7.
- [ ] Role assignments in `expedition` (the templates drone owns its `main.bicep`): `options.yml` gains `facts: groups: groups` and
      `addresses: roles: global.roles.roles`, and `main.bicep` the `roles` and `groups` object params and three `role-assignment.bicep`
      calls, each `if (!empty(<group>))`: `data_readers` to `storage_blob_data_reader` and `data_writers` to `storage_blob_data_contributor`
      on the account (`resourceKind: storageAccount`), and `data_writers` to `key_vault_secrets_user` on foundation's vault
      (`resourceKind: keyVault`, scope foundation's resource group). Check: Test-BicepLint, Test-BicepApiVersions, Build-Bicep.Integrity and
      Test-BicepTemplateCompliance green in one staged burst.
- [ ] A read-only public `Get-BicepRoleAssignmentPlan` in Azure.Templates lists principal, role and scope across templates and slots, read
      from the compiled templates through the compliance evaluator, its output a contract type and its provided contract under
      `contracts/catzc/<v>/pwsh.azure.templates/`, landed by staged burst with its L0. Then an L1 that every slot's assignments are the
      declared set (discovery: readers `reader` and workspace `log_analytics_reader`, operators `contributor` and conditioned
      `rbac_administrator`; expedition: the three data roles), and a user step in the task file to review the stacked assignments. Check:
      the L0 and the L1 green.
- [ ] The identity split (the firewall burst is in the tree; the pipeline order still waits on catzc-ab's `cd-customer.yaml` part B):
      `service-connections.yml` becomes `identities:` — landing-zone (foundation, discovery; subscription scope; `owner`), workload
      (expedition; resource-group scope; `contributor`) and read-only (all templates; subscription scope; `reader`), roles by `roles.yml`
      name — and the connections are derived per subscription, the trust boundary: one landing-zone and one read-only connection per
      subscription, and one workload connection per subscription that hosts expedition slots, named with the subscription's coordinates and
      the role `lz`/`ro`/`wl` through a new namer type `sc` (`pattern long, limit 256`). `Get-BicepServiceConnectionName` and
      `Get-BicepServiceConnections` live in Azure.Templates; `Sync-AdoServiceConnections` and `Test-AdoServiceConnections` take the
      connection objects as input (pipeline or `-Connection`), so Azure.DevOps gains no dependency on Azure.Templates (checked against
      `dependencies.yml`). The pipelines' literal `sc-*` names move to the derived ones in an order agreed with catzc-ab (its part B edits
      `cd-customer.yaml`). Check: the connection listing names each subscription's landing-zone, read-only and workload connections, and an
      L1 that every `serviceConnection` in `.ado/pipelines` resolves to a derived connection whose identity fits what its stage deploys
      (landing-zone for foundation and discovery, workload for expedition, read-only for `-DryRun` previews).
- [ ] Defender for Cloud as a landing-zone resource and the benchmark initiative in audit mode (built with the discovery wiring; SQL server
      auditing now through `sql-server.bicep`'s required `auditWorkspaceId`, `sql-audit.bicep` deleted, verdict 2026-10-27 burst:
      Test-BicepLint on the touched paths, Test-BicepApiVersions, Build-Bicep.Integrity and Test-BicepTemplateCompliance passed). Check:
      Discovery.Security.Tests (Defender pricings, benchmark assignment `DoNotEnforce`) and Alerts.Tests (one auditing setting per
      expedition slot) pass offline on the compiled templates; ADR-AZ-LZ-CAFSECURITY, ADR-AZ-LZ-GOVERNANCELIMITS and the well-architected
      page's "no external benchmark" passage are rewritten to match.
- [ ] The firewall egress narrows `Storage` to the region's tag: `NetworkFirewallEgress`'s default `Storage.{region}`, which
      `firewall-policy.bicep` fills with its location (in HEAD; the working tree's type was restored to `Storage` by a failed burst, staged
      copy kept in drone-opus's scratchpad `s2`). Check: HubFirewall.Tests' "regional Storage.<region> tag" case and NetworkConfig.Tests
      pass in one staged burst with the type swapped in, once the peer's CostMeter/CostModelConfig types compile.
- [x] Rollback by deploying an earlier commit's artifact. Check: a pipeline test that every production DEPLOY offers `rollback` on its prod
      path, certified by a production environment's deployment history. Verdict (2026-10-27): `deploy-apex.yaml` and `deploy-shared.yaml`
      gained `Target: rollback`; Test-Pipelines.Tests passed, 23 of 23.
- [ ] Removal of what a revert takes out of a template. Every template deploys `Incremental` (landing-zones-operations, Operations as code),
      and ARM has no `Complete` mode at subscription scope, so it is a cleanup step, not a mode: a command that lists a resource group's
      resources against the compiled template's evaluated resources (`Get-ArmDeployedResource`) and deletes the rest after a `-DryRun`
      listing, run by the DEPLOY prod and rollback paths after the deploy. Check: the command's L0 against a widget template and a mocked
      resource list, and a pipeline test that each production DEPLOY stage runs the cleanup after its deploy, with `-DryRun` first.
- [x] The compliance evaluator resolves `toObject` and an indexed `map` lambda (`(item, index) => …`), which build the security rules in
      `landing-zone-network.bicep`. Check: `NsgFlows.Tests.ps1` asserts each security group's evaluated rules (only declared flows allowed,
      then the two denies) in place of its binding checks. Verdict (2026-10-27 burst): ArmExpression.Tests, NsgFlows.Tests and
      Build-Bicep.Integrity.Tests passed, 3 of 3.
- [x] Question: should the catzc-run skill gain one line, "a bicep module whose params change lands in the same burst as its callers", and
      the `Get-ArmDeployedResource` page list the evaluator's known gaps, so the next L1 author checks them first? Check: the answer is
      recorded, and a yes lands both lines. Verdict (meister, 2026-10-27): yes; the line is in catzc-run step 3 and the gaps are listed on
      `docs/references/pwsh/azure-templates/private/get-arm-deployed-resource.md`.
- [x] A cost model per template beside its reference article in `docs/references/infrastructure/`, with the budget amounts derived from it.
      Check: a budget amount has a model behind it. Verdict (2026-10-27 burst): `<template>-cost-model.md` for foundation, discovery and
      expedition name the meters and the one derivation (`Get-BicepCostEstimate -Subscription`, `Budget` = total times `headroom`);
      `Discovery.Budget.Tests.ps1` checks every discovery slot's `budgetAmount` against it offline, passed with Get-BicepCostEstimate.Tests
      and Update-AzurePriceTable.Tests, 3 of 3.
- [x] A cost export to storage, a forecast alert and an anomaly alert in `discovery`; `budget.bicep` accepts more than one threshold type.
      Check: `discovery` deploys all three. Verdict (2026-10-27): the export and the forecast thresholds landed with the discovery wiring;
      the anomaly alert stays in its own step below.
- [x] A pre-deploy cost estimate per template. Check: CI prints one per template. Verdict (2026-10-27): `ci-infrastructure.yaml` runs
      `Get-BicepCostEstimate <template>` after each build, from the checked-in price table; Test-Pipelines.Tests passed, 23 of 23, with a
      case for the step order and no price refresh in CI.
- [ ] Cost model: config-driven SKU and billing-zone meters. The estimate counts resources by type, so a type whose SKU varies by config
      cannot be priced yet: - the hub firewall, per hub from `network.yml` `subscriptions.<hub>.firewall_sku`: - `shared_nonprod`: Azure
      Firewall Basic, a Basic policy and 2 Standard static public IPs; - `shared_prod`: Azure Firewall Standard, a Standard policy, 1
      Standard static public IP and zones 1–3; - each with data processed per GB and its resource-specific logs into the workspace; - the
      private DNS zone, priced by DNS billing zone, not ARM region (a per-meter region); - the private endpoint, whose Retail Prices API
      service is not yet known (it is under neither Virtual Network nor Azure Private Link in westeurope). Check: the estimate prices every
      meter cost-model.yml lists, and prices the firewall by each hub's SKU. Verdict (2026-10-27 burst): `skus`, `when_sku`, `count` and a
      per-meter `region` landed on CostModelConfig (CostMeter split to its own file) with the firewall, public-IP and Zone 1 DNS meters; the
      hub firewall is priced by its tier (Discovery.Budget.Tests, 3 of 3). Open: `Update-AzurePriceTable` is not yet run for the new meters
      (the table lacks them, so they read as unpriced), and the private endpoint's service is still unknown.
- [x] Foundation wiring, staged and not yet landed (the run lock stayed busy): `storage-account.bicep` takes a `containers` list of
      `{ name, deleteAfterDays }`, each with a blob container and a `delete-<name>` rule in the account's one lifecycle policy (the policy
      exists only when it has a rule); foundation's flow-log account gets `cost-exports`, kept `costExportRetentionDays` (400), inside its
      `if (withFlowLogStorage)`; `TemplateComplianceConfig.untaggable_types` gains `Storage/storageAccounts/blobServices/containers`,
      `CostManagement/exports`, `CostManagement/scheduledActions` and `Security/pricings` (catzc-ab agreed). Check: Test-BicepLint,
      Build-Bicep.Integrity, Test-BicepTemplateCompliance.Tests and Test-BicepApiVersions green in one staged burst. Verdict (2026-10-27):
      found in the tree, identical to the staged copies; Build-Bicep.Integrity.Tests passed in the evaluator burst, the other three gates
      not run here.
- [x] Discovery wiring, after the foundation burst: `budgetForecastThresholds` (default `[100]`) to `budget.bicep`'s `forecastThresholds`;
      `cost-export.bicep` to foundation's flow-log account (`costExportName`, namer type `cexp` added to Get-AzureResourceTypeSet, limit
      64), from `budgetStartDate` for five years; `defender-plans.bicep` with `defenderPlans`; the MCSB initiative
      (`1f3afdf9-d0c9-4c3d-847f-89da613e70a8`) in `landing-zone-policies.bicep` as `benchmark` (role `bm`), its own `DoNotEnforce`. Check:
      the same four gates and Get-AzureResourceName tests green in one staged burst. Verdict (2026-10-27 burst): Test-BicepLint,
      Test-BicepApiVersions, Build-Bicep.Integrity, Test-BicepTemplateCompliance, Get-AzureResourceName and Discovery.FlowLog passed, 6
      of 6.
- [x] The anomaly alert's pipeline seed: discovery deploys the alert (`anomalyAlertName`, namer `alert`/`ano`) with
      `anomalyAlertRecipients`, a required `@secure()` comma-separated string that every slot reads as a Key Vault reference to its
      subscription's foundation vault, secret `disco-anomaly-recipients` (the one deploy-time mechanism, recorded in
      ADR-AZ-DATAMOD-PARAMETERCONTRACT); what is left is the pipeline-setup step that seeds that secret from the pipeline variable, joined
      to the task file's pipeline-setup step. Check: a pipeline-YAML test finds the seed reading the variable. Verdict (2026-10-27 burst):
      Test-BicepLint, Test-BicepApiVersions, Build-Bicep.Integrity, Test-BicepTemplateCompliance, Test-BicepResourceNames and
      Discovery.FlowLog passed, 6 of 6. Verdict (2026-10-27 seed burst): every discovery job of `stages/deploy-unit.yaml` runs
      `Set-AnomalyAlertRecipientSecret` with `$(AnomalyAlertRecipients)` before its what-if, writing through the shared private
      `Set-KeyVaultSecretValue` that break-glass now calls; Set-AnomalyAlertRecipientSecret.Tests (with the pipeline-YAML case) passed, 12
      of 12, and Invoke-BreakGlassRotation.Tests passed, 9 of 9.
- [ ] The allowed-resource-types assignment, its list derived from the types the shared modules deploy at build time (a new build-time fact;
      design first). Check: a new module's type is allowed without editing a list.
- [x] Expedition: each template article's "Cost model" section from the estimate; an L1 case that every discovery `budgetAmount` is at least
      the estimate times `headroom`. Check: the L1 case reads 0, offline from the checked-in price table. Verdict (2026-10-27 burst): the
      cost model is a `<template>-cost-model.md` page beside each article, and `Discovery.Budget.Tests.ps1` reads 0, passed.
- [x] A DEPLOY pipeline with staged production promotion, so the CD stage deploys no production. Check: no pipeline deploys production in
      the CD stage. Verdict (2026-10-27): `cd-apex.yaml` and `cd-shared.yaml` dropped their prod-subscription targets (psub, prod);
      `deploy-apex.yaml` `prod` deploys psub, then preprod, then prod, and `deploy-shared.yaml` gained `prod` (psub); Test-Pipelines.Tests
      passed, 23 of 23, with a case that only a `deploy-*` pipeline targets a subscription hosting a production environment.

## Decided

- The dependency scan covers the Python lock only (the orchestrator, 2026-10-26): the extensions under `js/` carry no npm dependencies, the
  `tools.yml` binaries have no OSV ecosystem, and the vendored PowerShell modules (PSGallery) have no OSV feed; no mapped subset of
  `tools.yml` is scanned, since a half-covered list reads as coverage it does not have.
- There is no live deploy (the user, 2026-10-27): the platform is built version by version, so every step is built now and proven offline,
  by the compiled template, the compliance evaluator and the pipeline-YAML tests; a "deployed" check is an offline check, and the
  performance and load-test step is dropped until a real workload exists.
