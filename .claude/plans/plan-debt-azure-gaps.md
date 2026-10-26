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

- [ ] Further built-in policy assignments in `discovery`: public network access off on storage and SQL, a diagnostic setting on every data
      resource. Check: the assignments are listed in `main.bicep` and registered in `guids.yml`.
- [ ] A quality gate that flags outdated or preview API versions in `infrastructure/modules/`. Check: it reports `2021-05-01-preview` on the
      diagnostic setting module.
- [ ] A gate over the compiled templates (`main.json`) that fails a resource without the CAF tags, a resource kind without a diagnostic
      setting, or a production config without zone redundancy. Check: the gate run on `main.json`.
- [ ] CAF tags on the resource groups `Deploy-Bicep` and `Deploy-AzureResourceGroup` create for `foundation` and `expedition`. Check: the
      resource group tags read back after a deploy.
- [ ] One tag schema declared once and checked against every config: required keys, allowed values, lowercase casing and lowercase
      provenance-tag keys. Check: `AzureConfig` rejects a dropped key or a misspelled value.
- [ ] A policy requiring the other five CAF tag keys. Check: the policy assignment audit.
- [ ] What the `branch` provenance tag records for a devbox deploy. Check: no personal branch name in a resource tag.
- [ ] Resource names written in template configs equal the namer's render. Check: the check fails on a hand-edited name.
- [ ] A tenant comparison in `Get-BicepDeploymentContext`, failing a session whose tenant differs from the one `azure.yml` declares for its
      subscription. Check: a unit test with a mismatched tenant.
- [ ] A per-environment log retention config value, and a data export to immutable storage for a customer who needs it. Check:
      `retentionInDays` is passed from config.
- [ ] Traffic Analytics and virtual network flow logs, with a flow-log storage account in `foundation`. Check: a flow log on each virtual
      network.
- [ ] A `CanNotDelete` lock module on the hub's virtual network, the private DNS zones and `foundation`'s Key Vault. Check: the lock is
      listed on those resources.
- [ ] Service Health and Resource Health alerts in `discovery`; one action group per subscription in `foundation` addressed to `Owner`;
      metric alerts on the production database; capacity alerts with a workbook; saved queries, workbooks and dashboards. Check: the alert
      rules and the action group in the compiled templates.
- [ ] A health model per workload, its tool chosen when the work begins. Check: the health model is deployed with the workload.
- [ ] `foundation`'s Key Vault: diagnostics, purge protection as the module default, public network access off, a private endpoint and the
      `privatelink.vaultcore.azure.net` zone, and a secret name per configuration slot. Check: the vault shows no public access and purge
      protection on.
- [ ] Automated rotation of the break-glass password and monitoring of its use. Check: the rotation job and an alert on its use.
- [ ] Role assignments as code: a standard role set, data roles, a workspace reader role, a condition on assignable roles, and a group per
      customer and environment. Check: the assignments in the templates and a review of stacked ones.
- [ ] Managed-identity role grants between resources, and workload identity federation for every service connection. Check: no stored
      credential on a service connection.
- [ ] The landing-zone identity apart from the workload identity, and a service connection per environment. Check: the connection list per
      template.
- [ ] Defender for Cloud as a landing-zone resource, a benchmark initiative in audit mode, and a policy denying resource types outside the
      shared modules. Check: the assignments in `discovery`.
- [ ] A hub firewall in `AzureFirewallSubnet` with spoke routes, an `AzureFirewallManagementSubnet` in `network.yml`, and the firewall SKU
      choice. Check: egress logs at the firewall.
- [ ] A private-range, reserved-range and public-range check in `NetworkConfig`. Check: a public range in `network.yml` is rejected.
- [ ] `vm.bicep` creates no public IP, and `virtual-network.bicep` turns off default outbound access on every subnet. Check: the compiled
      template shows neither.
- [ ] Finer security-group rules between hub and spoke. Check: the rule set is no wider than the needed flows.
- [ ] A required-reviewer policy for `main-via-pr`: minimum reviewers, vote reset, automatic reviewers, comment resolution. Check: the
      policy in `build-validation.yml`.
- [ ] A merge-type branch policy for `main-via-pr` declared as code beside the reviewer policy. Check: the policy in `build-validation.yml`.
- [ ] A scan of every change for secrets in the CI pipeline. Check: a committed fake secret fails the build.
- [ ] A written emergency-change procedure. Check: the procedure page exists.
- [ ] Rollback by deploying an earlier commit's artifact, and removal of what a revert takes out of a template. Check: a rollback drill.
- [ ] The Bicep linter as a quality gate, system tests of a deployed template in an on-demand environment, and `-DryRun` before every
      pipeline deploy. Check: the gate and a what-if stage in the CD pipeline.
- [ ] The DORA delivery metrics collected from the pipelines. Check: the four metrics reported per deployable-unit.
