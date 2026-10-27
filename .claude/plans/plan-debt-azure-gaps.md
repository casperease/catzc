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

- [ ] Policy enforcement derived from the subscription a slot targets (a prod subscription takes production enforcement), so the `discovery`
      slots stop addressing `global.azure.policy_enforcement.*` by hand. Check: build-params identical for every `discovery` slot.
- [ ] A health model per workload, its tool chosen when the work begins. Check: the health model is deployed with the workload.
- [ ] Role assignments as code, after catzc-ab's `addresses:` map in options.yml lands: a new `modules/role-assignment.bicep` (scope kind
      subscription | resourceGroup | storageAccount | keyVault | sqlServer | workspace, like `lock.bicep`; principalType Group |
      ServicePrincipal; an optional attribute-based condition; name `guid(scope, principal, role)`), every role id addressed from
      `roles.yml` through the template's `addresses:`, never a literal. The Entra group object ids per customer and environment class go
      under the customer in `azure.yml` (AzureConfig/AzureCustomer gain a `groups:` map; `entraAdminObjectId` is the precedent). The
      standard set is declared once: `discovery` (subscription) readers to `reader`, operators to `contributor`, workspace readers to
      `log_analytics_reader`, and operators to `rbac_administrator` with an attribute-based condition limiting the assignable roles to the
      data roles; `expedition` (resource) data readers and writers to `storage_blob_data_reader`/`_contributor` on the account and
      `key_vault_secrets_user` on the vault. `action-group.bicep`'s Owner literal moves to the `roles.yml` address the same way.
      ADR-AZ-LZ-CAFIDENTITY is rewritten in the same change ("the templates assign built-in roles to groups and managed identities, never to
      users; no group, user, custom role or directory object is created"), with landing-zones-well-architected.md's "the templates make no
      role assignments" passage; attribute-based conditions for the data roles is rejected there with its reason (no tagged-container
      model). The managed-identity grant is dropped (YAGNI) and the module's doc says it serves one. A read-only
      `Get-BicepRoleAssignmentPlan` lists principal, role and scope across templates and slots. Check: an L1 that every slot's assignments
      are the declared set, the plan command's L0, and a user step to review the stacked assignments.
- [ ] The identity split, after catzc-f4's firewall burst (it holds `Get-AzureResourceTypeSet.ps1`): `service-connections.yml` becomes
      `identities:` — landing-zone (foundation, discovery; subscription scope; `owner`), workload (expedition; resource-group scope;
      `contributor`) and read-only (all templates; subscription scope; `reader`), roles by `roles.yml` name — and the connections are
      derived per subscription, the trust boundary: one landing-zone and one read-only connection per subscription, and one workload
      connection per subscription that hosts expedition slots, named with the subscription's coordinates and the role `lz`/`ro`/`wl` through
      a new namer type `sc` (`pattern long, limit 256`). `Get-BicepServiceConnectionName` and `Get-BicepServiceConnections` live in
      Azure.Templates; `Sync-AdoServiceConnections` and `Test-AdoServiceConnections` take the connection objects as input (pipeline or
      `-Connection`), so Azure.DevOps gains no dependency on Azure.Templates (checked against `dependencies.yml`). The pipelines' literal
      `sc-*` names move to the derived ones in an order agreed with catzc-ab (its part B edits `cd-customer.yaml`). Check: the connection
      listing names each subscription's landing-zone, read-only and workload connections, and an L1 that every `serviceConnection` in
      `.ado/pipelines` resolves to a derived connection whose identity fits what its stage deploys (landing-zone for foundation and
      discovery, workload for expedition, read-only for `-DryRun` previews).
- [ ] Defender for Cloud as a landing-zone resource, a benchmark initiative in audit mode, and a policy denying resource types outside the
      shared modules; Defender for Cloud plans for the services in use and SQL server auditing to the workspace. Check: the benchmark
      assignment exists and the Defender plans and the auditing are deployed.
- [ ] The firewall egress narrows `Storage` to the region's tag once a deploy confirms the form. Check: the deployed firewall policy shows
      the regional tag and egress to storage still works.
- [ ] Rollback by deploying an earlier commit's artifact, and removal of what a revert takes out of a template. Check: a rollback drill.
- [ ] The compliance evaluator resolves `toObject` and an indexed `map` lambda (`(item, index) => …`), which build the security rules in
      `landing-zone-network.bicep`. Check: `NsgFlows.Tests.ps1` asserts each security group's evaluated rules (only declared flows allowed,
      then the two denies) in place of its binding checks.
- [ ] Question: should the catzc-run skill gain one line, "a bicep module whose params change lands in the same burst as its callers", and
      the `Get-ArmDeployedResource` page list the evaluator's known gaps, so the next L1 author checks them first? Check: the answer is
      recorded, and a yes lands both lines.
- [ ] A cost model per template beside its reference article in `docs/references/infrastructure/`, with the budget amounts derived from it.
      Check: a budget amount has a model behind it.
- [ ] A cost export to storage, a forecast alert and an anomaly alert in `discovery`; `budget.bicep` accepts more than one threshold type.
      Check: `discovery` deploys all three.
- [ ] A pre-deploy cost estimate per template. Check: CI prints one per template.
- [ ] Cost model: config-driven SKU and billing-zone meters. The estimate counts resources by type, so a type whose SKU varies by config
      cannot be priced yet: - the hub firewall, per hub from `network.yml` `subscriptions.<hub>.firewall_sku`: - `shared_nonprod`: Azure
      Firewall Basic, a Basic policy and 2 Standard static public IPs; - `shared_prod`: Azure Firewall Standard, a Standard policy, 1
      Standard static public IP and zones 1–3; - each with data processed per GB and its resource-specific logs into the workspace; - the
      private DNS zone, priced by DNS billing zone, not ARM region (a per-meter region); - the private endpoint, whose Retail Prices API
      service is not yet known (it is under neither Virtual Network nor Azure Private Link in westeurope). Check: the estimate prices every
      meter cost-model.yml lists, and prices the firewall by each hub's SKU.
- [ ] Foundation wiring, staged and not yet landed (the run lock stayed busy): `storage-account.bicep` takes a `containers` list of
      `{ name, deleteAfterDays }`, each with a blob container and a `delete-<name>` rule in the account's one lifecycle policy (the policy
      exists only when it has a rule); foundation's flow-log account gets `cost-exports`, kept `costExportRetentionDays` (400), inside its
      `if (withFlowLogStorage)`; `TemplateComplianceConfig.untaggable_types` gains `Storage/storageAccounts/blobServices/containers`,
      `CostManagement/exports`, `CostManagement/scheduledActions` and `Security/pricings` (catzc-ab agreed). Check: Test-BicepLint,
      Build-Bicep.Integrity, Test-BicepTemplateCompliance.Tests and Test-BicepApiVersions green in one staged burst.
- [ ] Discovery wiring, after the foundation burst: `budgetForecastThresholds` (default `[100]`) to `budget.bicep`'s `forecastThresholds`;
      `cost-export.bicep` to foundation's flow-log account (`costExportName`, namer type `cexp` added to Get-AzureResourceTypeSet, limit
      64), from `budgetStartDate` for five years; `defender-plans.bicep` with `defenderPlans`; the MCSB initiative
      (`1f3afdf9-d0c9-4c3d-847f-89da613e70a8`) in `landing-zone-policies.bicep` as `benchmark` (role `bm`), its own `DoNotEnforce`. Check:
      the same four gates and Get-AzureResourceName tests green in one staged burst.
- [ ] The anomaly alert (`scheduled-action.bicep`) in discovery: its recipients are a required template input injected at deploy time from a
      pipeline variable (decided), but no deploy-time parameter injection exists yet, so the mechanism is designed and approved first, then
      the variable joins the task file's pipeline-setup step. Check: discovery deploys the alert with recipients from the variable and no
      address in config.
- [ ] The allowed-resource-types assignment, its list derived from the types the shared modules deploy at build time (a new build-time fact;
      design first). Check: a new module's type is allowed without editing a list.
- [ ] Expedition: `auditWorkspaceId` on its `sql-server.bicep` call (ask catzc-ab first, after the data-role burst); the CI step in
      `ci-infrastructure.yaml` printing Get-BicepCostEstimate per template and environment (released by catzc-f9; it adds no
      serviceConnection); each template article's "Cost model" section from the estimate; an L1 case that every discovery `budgetAmount` is
      at least the estimate times `headroom`. Check: CI prints an estimate per template, and the L1 case reads 0.
- [ ] A DEPLOY pipeline with staged production promotion, so the CD stage deploys no production. Check: no pipeline deploys production in
      the CD stage.
- [ ] Performance targets, baselines, alerts and a load test in a preprod slot for any real workload. Check: the workload's reference
      article lists them.

## Decided

- The dependency scan covers the Python lock only (the orchestrator, 2026-10-26): the extensions under `js/` carry no npm dependencies, the
  `tools.yml` binaries have no OSV ecosystem, and the vendored PowerShell modules (PSGallery) have no OSV feed; no mapped subset of
  `tools.yml` is scanned, since a half-covered list reads as coverage it does not have.
