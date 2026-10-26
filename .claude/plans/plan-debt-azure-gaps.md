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

- [ ] A quality gate that flags outdated or preview API versions in `infrastructure/modules/`. Check: it reports `2021-05-01-preview` on the
      diagnostic setting module.
- [ ] A gate over the compiled templates (`main.json`) that fails a resource without the CAF tags, a resource kind without a diagnostic
      setting, a resource with public network access on or a TLS version below 1.2, or a production config without zone redundancy, and runs
      in CI. Check: the gate fails a template missing any of these and runs in CI.
- [ ] CAF tags on the resource groups `Deploy-Bicep` and `Deploy-AzureResourceGroup` create for `foundation` and `expedition`. Check: the
      resource group tags read back after a deploy, and the compiled-template check finds a resource group without the CAF tags.
- [ ] One tag schema declared once and checked against every config: required keys, allowed values, lowercase casing and lowercase
      provenance-tag keys. Check: `AzureConfig` rejects a dropped key or a misspelled value.
- [ ] A policy requiring the other five CAF tag keys. Check: the policy assignment audit.
- [ ] What the `branch` provenance tag records for a devbox deploy. Check: no personal branch name in a resource tag.
- [ ] Resource names written in template configs equal the namer's render. Check: the check fails on a hand-edited name.
- [ ] A tenant comparison in `Get-BicepDeploymentContext`, failing a session whose tenant differs from the one `azure.yml` declares for its
      subscription. Check: a unit test with a mismatched tenant.
- [ ] A per-environment log retention config value, and a data export to immutable storage for a customer who needs it. Check:
      `retentionInDays` is passed from config. The workspace module also pins resource-context access as its default. Check: the module
      default is set.
- [ ] Traffic Analytics and virtual network flow logs, with a flow-log storage account in `foundation`. Check: a flow log on each virtual
      network. Firewall egress logs ship with the firewall step below.
- [ ] A `CanNotDelete` lock module on the hub's virtual network, the private DNS zones and `foundation`'s Key Vault. Check: the lock is
      listed on those resources and `discovery` deploys the lock module.
- [ ] Service Health and Resource Health alerts in `discovery`; one action group per subscription in `foundation` addressed to `Owner`;
      metric alerts on the production database; capacity alerts with a workbook; saved queries, workbooks and dashboards. Check: the alert
      rules and the action group in the compiled templates, and an alert reaches the `Owner` role.
- [ ] A health model per workload, its tool chosen when the work begins. Check: the health model is deployed with the workload.
- [ ] `foundation`'s Key Vault: diagnostics through the `keyVault` kind with a retention per environment class, purge protection and public
      network access off as the `key-vault.bicep` defaults, a closed vault network with a private endpoint and the
      `privatelink.vaultcore.azure.net` zone in the hub, the same defaults for `vm.bicep` and `data-factory.bicep`, and a secret name per
      configuration slot. Check: the vault shows no public access and purge protection on, sends to the workspace, and the compiled-template
      gate passes.
- [ ] Automated rotation of the break-glass password and monitoring of its use. Check: the secret has a rotation job and an alert on its
      use.
- [ ] Role assignments as code: a standard role set, data roles, a workspace reader role, a condition on assignable roles, and a group per
      customer and environment, with attribute-based conditions weighed for the data roles and a standard set declared once for subscription
      level in `discovery` and resource level in `expedition`. Check: the assignments in the templates and a review of stacked ones.
- [ ] Managed-identity role grants between resources (`storage-account.bicep` and `sql-server.bicep` output the `principalId`), and workload
      identity federation for every service connection. Check: no stored credential on a service connection.
- [ ] The landing-zone identity apart from the workload identity, a service connection per environment, one identity per template and
      environment, and a read-only identity for previews. Check: the connection list per template.
- [ ] Defender for Cloud as a landing-zone resource, a benchmark initiative in audit mode, and a policy denying resource types outside the
      shared modules; Defender for Cloud plans for the services in use and SQL server auditing to the workspace. Check: the benchmark
      assignment exists and the Defender plans and the auditing are deployed.
- [ ] A hub firewall in `AzureFirewallSubnet` with spoke routes, an `AzureFirewallManagementSubnet` in `network.yml`, and the firewall SKU
      choice. Check: egress logs at the firewall.
- [ ] A private-range, reserved-range and public-range check in `NetworkConfig`. Check: a public range in `network.yml` is rejected.
- [ ] `vm.bicep` creates no public IP, and `virtual-network.bicep` turns off default outbound access on every subnet. Check: the compiled
      template shows neither.
- [ ] Finer security-group rules between hub and spoke, narrower per subnet. Check: the rule set is no wider than the needed flows and
      `allow-virtual-network-inbound` is no longer a blanket allow.
- [ ] A required-reviewer policy for `main-via-pr`: minimum reviewers, vote reset, automatic reviewers, comment resolution. Check: the
      policy in `build-validation.yml`.
- [ ] A merge-type branch policy for `main-via-pr` declared as code beside the reviewer policy. Check: the policy in `build-validation.yml`.
- [ ] A scan of every change for secrets in the CI pipeline, a dependency scan, and a threat model. Check: a CI stage fails on a planted
      secret.
- [ ] A written emergency-change procedure. Check: the procedure page exists as a how-to page.
- [ ] Rollback by deploying an earlier commit's artifact, and removal of what a revert takes out of a template. Check: a rollback drill.
- [ ] The Bicep linter as a quality gate configured by `infrastructure/bicepconfig.json`, L3 system tests that deploy each template to an
      on-demand environment, and `-DryRun` (what-if) before every pipeline deploy. Check: a linter warning fails the build, a test deploys a
      template and checks the result, and a what-if stage sits in the CD pipeline.
- [ ] The DORA delivery metrics collected from the pipelines. Check: the four metrics reported per deployable-unit.
- [ ] A cost model per template beside its reference article in `docs/references/infrastructure/`, with the budget amounts derived from it.
      Check: a budget amount has a model behind it.
- [ ] A cost export to storage, a forecast alert and an anomaly alert in `discovery`; `budget.bicep` accepts more than one threshold type.
      Check: `discovery` deploys all three.
- [ ] A policy in `discovery` allowing only listed SKUs, and `databaseSkuName` closed by `@allowed`. Check: `Build-Bicep` rejects an
      unlisted SKU.
- [ ] A pre-deploy cost estimate per template. Check: CI prints one per template.
- [ ] A per-service billing catalogue in the module reference. Check: the catalogue page exists.
- [ ] An orphan check of the configuration tree against Azure, with a reminder to remove special slots. Check: the gate lists a resource
      group with no config.
- [ ] A storage SKU per environment class in `expedition`. Check: a non-production config sets `Standard_LRS`.
- [ ] Blob lifecycle tiering: the access tier and the cool and archive ages as `storage-account.bicep` parameters. Check: the parameters
      exist and a config sets them.
- [ ] A stated RPO and RTO per environment class in `docs/references/infrastructure/expedition.md`. Check: the page names both per class.
- [ ] A written disaster recovery plan, a secret-seeding how-to, a spoke-rollout how-to and an incident response procedure. Check: each is a
      how-to page.
- [ ] A DEPLOY pipeline with staged production promotion, so the CD stage deploys no production. Check: no pipeline deploys production in
      the CD stage.
- [ ] `data-classification` validated in a config type. Check: `Test-ShippedConfigs` or a unit test rejects an unknown value.
- [ ] Performance targets, baselines, alerts and a load test in a preprod slot for any real workload. Check: the workload's reference
      article lists them.
- [ ] `docs/drs/azure/landing-zones.md` (1108 lines) split by section into a folder of linked pages, its rule codes kept, then its
      `file-limits.yml` exception dropped. Check: `Test-FileLimits` passes without the exception.
