# Landing zones: The Cloud Adoption Framework areas

Part of the decision of [ADR-AZ-LZ](../landing-zones.md), which holds the rules these sections justify.

## CAF design principles

Subscription democratization is partly followed. `azure.yml` declares every subscription, and a customer subscription carries a `customer`
key ([ADR-AZ-CUSTOMER-TWOBINDINGS](../azure-customer-model.md#rule-adr-az-customer-twobindings)). The shared platform holds `shared_nonprod`
and `shared_prod`, and each customer its own pair or a non-production subscription alone. A non-production subscription serves `dev`, `test`
and `nsub`, a production one `preprod`, `prod` and `psub`; `dev` and `test` are kept apart by resource group, one per configuration slot
([ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION](../azure-data-model.md#rule-adr-az-datamod-onefileonesubscription)). Self-service is a pull request
([DDR-SELFSERV-CONSUMERSPROVISION](../../design/self-service.md#rule-ddr-selfserv-consumersprovision)): a team adds a subscription entry, a
network and one config per template. Subscription vending and management groups are not adopted, because the repository deploys into
subscriptions it is given. A new customer therefore waits for the tenant's administrator, and the budget and guardrails of a shared
non-production subscription govern `dev` and `test` alike.

Policy-driven governance is partly followed. The landing zone's ten policies are the tool-agnostic guardrails
([ADR-AZ-LZ-LANDINGZONEPOLICIES](../landing-zones.md#rule-adr-az-lz-landingzonepolicies)), and CI adds guards before deploy that policy
cannot: every template compiles and every rendered parameters file is checked against the compiled parameter model
([ADR-AZ-DATAMOD-PARAMETERCONTRACT](../azure-data-model.md#rule-adr-az-datamod-parametercontract)). The set is narrow: a TLS minimum is set
by the shared modules and not guarded against another tool. Each landing zone assigns its own copy, with no management group to inherit
from, so outside the ten policies compliance rests on module defaults and review, and outside production the default mode audits and does
not block.

Control and management plane: the control plane is Azure Resource Manager. `Deploy-Bicep` runs `az deployment group create` or
`az deployment sub create`, and `-DryRun` runs Azure's `--what-if`
([ADR-AZ-CLI-AZBYDEFAULT](../prefer-az-cli.md#rule-adr-az-cli-azbydefault)). catzc is a command line in front of Azure, kept thin: it
delegates to Bicep and the az CLI and never clones the vendor's behaviour
([DDR-THINPLAT-DELEGATENOTREIMPLEMENT](../../design/thin-platforms.md#rule-ddr-thinplat-delegatenotreimplement)). The management plane
deviates: `foundation` gives each subscription its own Log Analytics workspace, and the landing zone and the workload of that subscription
send diagnostics and the activity log there. A view across customers needs a cross-workspace query and a platform-wide alert is one alert
per workspace, and the gain is that one customer's telemetry stays in that customer's subscription.

The application-centric model is followed: workloads are segmented by customer subscription and environment class, not by management group
archetype, so every landing zone carries the same ten assignments from one template and one setting, which cannot drift. The shared modules
include `vm.bicep`, so an IaaS workload would land in the same subnets under the same policies as the PaaS one.

Azure-native design is followed: Bicep from the shared modules, Azure built-in policy, Azure Monitor, Key Vault, Private DNS and Entra ID,
with no third-party firewall, agent or secret store. `tools.yml` pins the Bicep CLI, and `Build-Bicep` fails before it builds on a missing
or older one. Resource API versions are written in each module by hand and several are older or preview (`2021-05-01-preview` on the
diagnostic settings), so a new capability reaches the templates when someone updates a module.

## CAF management

The workspace is per subscription on purpose: each customer's telemetry stays in the subscription that customer's access covers, and
non-production and production stay apart. `foundation` deploys it through `log-analytics.bicep`, and `discovery` and `expedition` find it by
`logAnalyticsResourceGroupName` and `logAnalyticsName` in their configs. A workspace's retention is a config value per environment class:
`foundation` passes `logAnalyticsRetentionInDays` (30 to 730) to the workspace, 30 days by default and 90 in a production slot. No example
customer needs logs kept for years, and so no export to immutable storage exists; a customer with a longer obligation adds a data export
beside the workspace ([EDR-AZ-WAF-OE-OE07](../../external/azure/waf/operational-excellence.md#rule-edr-az-waf-oe-oe07)). Access to a
workspace is the role-based access of its subscription, in resource-context mode by default (`log-analytics.bicep` sets
`enableLogAccessUsingOnlyResourcePermissions`), so a reader of a resource reads that resource's logs without a role on the whole workspace;
the templates assign no role to people.

Diagnostics exist when a deploy succeeds, because `diagnostic-setting.bicep` (kinds fixed by its `@allowed` decorator, categories by the
`allLogs` group plus the kind's metrics) is part of the template, which a deploy-if-not-exists policy cannot promise. The subscription's
activity log, `ServiceHealth` and `ResourceHealth` included, streams from `discovery` through `subscription-diagnostic-setting.bicep`, which
sends every category (`Administrative`, `Security`, and `Policy` among them); `discovery` sends the virtual network and every network
security group, and `expedition` the storage account, its blob service, and the database. `foundation`'s own Key Vault sends nothing, though
the module supports it. Platform metrics sit in Azure Monitor with no configuration and the diagnostic setting copies them beside the logs
(`AllMetrics` for the virtual network, `Transaction` for the storage account and its blob service); the logs are queryable per subscription,
and `foundation` deploys a query pack, a dashboard, and a capacity workbook over them.

Alerting follows one rule: one action group per subscription in `foundation` addressed to `Owner`, and alert rules in the templates that own
the resources, never Microsoft's baseline alerts deployed by policy
([ADR-AZ-LZ-LANDINGZONEPOLICIES](../landing-zones.md#rule-adr-az-lz-landingzonepolicies)). `budget.bicep` sends its thresholds to the
subscription's `Owner` role; `discovery` deploys the Service Health and Resource Health alerts and a cost anomaly alert, and `expedition`
the break-glass sign-in alert and, in production, the database metric and capacity alerts. `lock.bicep` places a `CanNotDelete` lock on the
hub's virtual network and private DNS zones and on `foundation`'s Key Vault with the break-glass password, the resources others depend on.
Where `foundation` configures a flow-log storage account, `discovery` records a virtual network flow log there, with Traffic Analytics into
the workspace; without one, the network sends logs and metrics, not flows.

The workload relies on the platform's own redundancy and backup: zone-redundant storage (`Standard_ZRS`) in production and locally redundant
storage (`Standard_LRS`) outside it, a production database that is zone-redundant (`databaseZoneRedundant` is false in development) with
geo-redundant backups (`databaseBackupStorageRedundancy` `Geo` in production, `Local` in development), short-term retention
(`databaseBackupRetentionDays` 35 in production, 7 in development, set by `sql-database.bicep`) and blob and container soft delete of 7 days
by default, with the `@minValue`, `@maxValue`, and `@allowed` bounds keeping a config within what the service accepts
([ADR-AZ-LZ-EVERYPILLAR](../landing-zones.md#rule-adr-az-lz-everypillar)). No policy audits redundancy or backup, and no backup vault exists
because nothing deployed needs one. No range of the plan overlaps another, which `NetworkConfig` checks, so a recovery network added to the
plan falls under the same check ([ADR-AZ-NETWORK-NOOVERLAP](../azure-network-model.md#rule-adr-az-network-nooverlap)).

Recommendations that assume a virtual machine (Site Recovery, Update Manager, Machine Configuration) or a hybrid link (ExpressRoute, an
on-premises monitoring system) have nothing to act on: `vm.bicep` exists among the shared modules but no template uses it, the hub's
`GatewaySubnet` holds nothing, every environment maps to one region, and every log stays in Azure. A workload sits in one resource group of
one subscription, named by the `workload` tag, which gives the grouping an Azure Service Group would add. So a workload's health model is an
Azure Monitor workbook in the workload's own template, `health-workbook.bicep` through `workbook.bicep`, scoped to that resource group: the
availability of each resource now (Resource Graph `HealthResources`), its Resource Health events over time (the activity log in the
subscription's workspace), and the alerts its rules fired (Resource Graph `AlertsManagementResources`). Azure Monitor health models are in
preview and build on Service Groups at tenant level, which the landing zone never deploys
([ADR-AZ-LZ-LANDINGZONE](../landing-zones.md#rule-adr-az-lz-landingzone)).

## CAF tags

The tag set is written out in full in each config (eighteen copies across the three templates) and cost is split below the subscription by
`cost-center` and `workload`; tag inheritance is not used, because every template passes the tags to each resource itself. All six are
required by the landing zone's policy, which checks that each key is present and not its value. The `workload` tag names the template
(`foundation`, `landing-zone`, `expedition`), and `environment` is the environment class for the per-subscription templates (`nonprod`,
`prod`) and the standard environment for `expedition`. `criticality` (`low`, `medium`, `high`) and `data-classification` (`internal`,
`confidential`) are the classification tags, and no service-level tag is set because no example workload declares one. `cost-center` equals
`owner` (`platform` or the customer key), since the customer is the unit of cost and of accountability; budget alerts go to the
subscription's `Owner` role, not to the tag.

Tags carry codes only: team codes, class values, and template names. Every key and value is lowercase with hyphens between words, matching
[ADR-AZ-NAMING-LOWERCASECOMPONENTS](../azure-naming-standard.md#rule-adr-az-naming-lowercasecomponents); CAF's examples run the words
together (`costcenter`), which the hyphen replaces for readability. `Deploy-Bicep` adds three provenance tags after a deploy through
`Set-BicepTrackingTagSet`: the commit, the build id, and the branch, with the lowercase keys the `tags.provenance` schema of `azure.yml`
names (`deployed-from-commit`), through `Get-BicepTrackTagNameSet`. The same `tags` schema states the CAF keys and the closed values of
`environment`, `criticality` and `data-classification`, and `Test-BicepTemplateCompliance` holds every compiled resource's tags to it. A
devbox deploy records `devbox` as its branch, never the local branch name, which is often named after a person and would be readable by
every reader of the subscription. The provenance tags land on the resource group of `foundation` and `expedition` and on the subscription
for `discovery`, whose keys carry the template name as a prefix (`discovery-deployed-from-commit`). The required-tag assignment is
`requireTag`, named per subscription by `policyAssignmentNames` (`-tag-pa`), of the custom CAF-tags definition with parameter
`requiredTagNames` defaulting to the six keys of the `azure.yml` tag schema; the policy ignores types that cannot carry a tag, so it never
denies a peering or a budget. The peering, subnet, policy assignment, budget, and diagnostic setting modules take no `tags`, and
`foundation` and `expedition` set the CAF tags on every taggable resource and on their resource groups, beside the provenance tags. The
`criticality` and `data-classification` values in use are listed in
[Reliability in one region](landing-zones-well-architected.md#reliability-in-one-region).

No region tag is set, because the region is a component of every name and the allowed-locations policy holds each landing zone to its
region, so a tag would repeat what the name and the resource's location state; resource selectors in the tag policy are unused for the same
reason. No tier tag is set, because each example template is one tier, and the provenance tags name the commit in place of a repository tag.
No purpose tag is set, because the example workloads model no business process; a workload that serves one adds its purpose tags in its own
configs. No Microsoft workload assessment runs against these subscriptions, and the `workload` and `criticality` tags are what one would
read.

## CAF security

The activity log streams to `foundation`'s Log Analytics workspace and every resource that emits logs sends them to its subscription's
workspace, one per subscription rather than one for the tenant; an archive to storage beyond two years is not needed. Access audit reports,
real-time alerts through Event Grid, an incident response plan
([EDR-AZ-WAF-SE-SE12](../../external/azure/waf/security.md#rule-edr-az-waf-se-se12)), and the tracking of Azure roadmaps as a process belong
to the tenant's security operations or are served by the retrieval dates of the records. No virtual machine is deployed, so patch tracking,
policy-deployed extensions, security drift, attestation, and just-in-time access have nothing to act on, and no endpoint or user application
exists for endpoint management, Defender for Cloud Apps, or application onboarding.

The shared Bicep modules are the allowlist of services, each with secure defaults. The landing zone assigns its policy set at subscription
level in place of the management-group policy set of the CAF reference landing zone, turns on the Defender for Cloud plans of the services
it runs, and measures them against the Microsoft cloud security benchmark in audit mode. Access follows Zero Trust through Entra ID
identities, service connections per deployment identity pinned to their subscription on every deploy, and private endpoints for data, though
`foundation`'s vault and workspace accept public traffic. Each workload deploys the diagnostic settings of its own resources, so its
monitoring travels with its template. Data at rest uses Microsoft-managed keys, and the `data-classification` tag labels each resource in
place of Purview. No workload has public ingress, so the Zero Trust application delivery pattern and the accelerators' network variants do
not apply; workload networking is private by plan (`network.yml`, a security group per workload subnet, private endpoints). Sentinel, its
identity feeds, and threat hunting are the tenant's security operations; `foundation`'s workspace is where Sentinel would attach and the
repository supplies the logs.

Key Vault is federated: `foundation` deploys one vault per subscription from one module, so every customer and tier has its own vault with
the same configuration and no policy is needed. No vault is central to the tenant, though a workload's secret sits in the platform's vault.
Every vault authorizes its data plane through Azure RBAC with no access policies and has the platform's soft delete: `key-vault.bicep` fixes
`enableRbacAuthorization: true` and an empty `accessPolicies`, neither a parameter, so no caller falls back to access policies, and it sets
no retention, no network rule, and `enabledForTemplateDeployment` on, because Azure Resource Manager resolves `expedition`'s break-glass
reference at deploy time. The roles on a vault are granted outside the repository, and the vault name stays taken until a deleted vault's
retention ends. `storage-account.bicep` turns shared-key access off, so every data request carries an Entra ID token. The vaults hold no key
and no certificate, so certificate automation has no use; rotation of the one secret, the break-glass password, is manual. The environments
of one tier share their tier's vault and the same secret name, `exped-sql-admin-password` (`dev` and `test` read the shared non-production
vault, so they share one break-glass password). The platform's vault is the platform's, not the workload's, which fits the one secret in
use, a recovery credential no application reads at run time; a workload that needs run-time secrets creates its own vault from
`key-vault.bicep` in its own resource group.

## CAF identity

The identity recommendations that assume a directory the repository runs, or a tenant setting, are not the repository's: every resource the
templates deploy authenticates through Entra ID alone, no workload uses a legacy directory protocol or users from outside the tenant, the
repository synchronises no on-premises directory, federates through no AD FS, publishes no application through application proxy, deploys no
directory server, file share, or virtual machine, and so has no directory subnet, replica set, Arc-managed server, or directory-server rule.
The tenant's authentication methods, multi-factor authentication, Conditional Access, Defender for Identity, separate administrative
accounts, emergency-access accounts, Entra log streaming (a tenant diagnostic setting needs rights above any subscription), access packages,
built-in directory roles, administrative units, Privileged Identity Management, access reviews, protected actions, and eligibility for Owner
and User Access Administrator are tenant settings, and the repository grants no directory role
([ADR-AZ-DATAMOD-ONETENANT](../azure-data-model.md#rule-adr-az-datamod-onetenant)).

Every principal the templates name is a group or a role: the SQL administrator is an Entra ID group and the budget alerts go to the `Owner`
role. `sql-server.bicep` defaults `entraAdminPrincipalType` to `Group` and `entraOnlyAuthentication` to `true`, and every `expedition`
config names the group `zct-exped-sql-admins` (`entraAdminLogin`) with a placeholder object id registered in `guids.yml` as
`entra_sql_admin_group`, so one group administers every customer's SQL server in every environment. `budget.bicep` takes `contactRoles`,
defaulting to `Owner`. The break-glass login is `exped-break-glass`, with `entraOnlyAuthentication: false` and the password
`exped-sql-admin-password` as a Key Vault reference; it is the one path outside the tenant's sign-in policies. At the level the repository
owns, the break-glass SQL login keeps a SQL server reachable. Every subscription gets the same landing zone from `discovery`, but it assigns
no role and creates no group, role assignment, or user-assigned identity, and the repository defines no custom role and owns no management
group. Key Vault and storage authorize their data plane through Entra ID and Azure RBAC, and SQL through its Entra ID administrator group.

Every `expedition` config names the same SQL administrator group, and the environments of one tier share their service connections, their
vault secret, and the SQL administrator group. Managed identities are system-assigned to one resource of one configuration slot, so none is
shared; the storage account and the SQL server carry them, but nothing grants them a role (`storage-account.bicep` and `sql-server.bicep`
output the `principalId`). `policy-assignment.bicep` gives a remediating policy, when `assignIdentity` is set, a system-assigned identity
and grants each id in `roleDefinitionIds` directly to its principal (`principalType: 'ServicePrincipal'`) on the subscription, and no
landing-zone policy needs it. Every deploy runs through the service connection of its subscription and deployment identity
(`nsub-weu-zct-ado-lz-sc` for the landing zone, `…-wl-sc` for workloads, `…-ro-sc` for read-only checks), handed to `AzureCLI@2` or
`AzurePowerShell@5` by `.ado/pipelines/steps/invoke-automation.yaml` in `azcli` mode, pinned by `-SubscriptionIdAssertIs`, and the
infrastructure CI builds offline in mode `none` and needs no Azure identity; the environments of one subscription (`nsub`, `dev`, `test`)
share its service connections. No template deploys an application that users sign in to, so the Microsoft identity platform and its
checklist are not a template concern.

## CAF delivery

Templates, modules, configs, policy assignments, pipelines, automation, and ADRs all live in one Git repository, which is private by the
visibility of its server remote, outside the repository, and built to hold no secret either way. What the repository shares publicly is the
built catzc package, published by a manual release workflow, never the infrastructure templates and their configs. All Azure infrastructure
is declarative Bicep with shared modules and one config per configuration slot, deployed only by pipelines. The landing zone's ten policy
assignments are Bicep in `landing-zone-policies.bicep`, pinned by id and deployed by its pipeline; they deny in production and audit
elsewhere, none uses a modify or append effect, and the landing zone makes no exemption: a team that needs a different policy proposes a
change to the landing zone, reviewed like any other.

Development is trunk-based on `main`, with short-lived branches that carry nothing automation reads from their names and no release or
version branches. The delivery design takes `main` to advance by squash merge only, and its change detection relies on it; the rule that
`main` admits merges only through a pull request, the merge type, and per-branch permissions are server settings outside the repository. In
the `main-via-pr` variant every change enters `main` through a pull request with blocking build validation; the repository runs
`main-direct`. Blocking build validation per globset is configured in `build-validation.yml`. Every fix, urgent or not, is a commit that the
same pipelines deploy, and a rollback is a revert commit that the same pipelines deploy.

A CI pipeline builds and tests every template, as a pull-request check and again on the merged commit: each template is validated, compiled,
and checked against its parameter model ([ADR-AZ-DATAMOD-PARAMETERCONTRACT](../azure-data-model.md#rule-adr-az-datamod-parametercontract)).
Globset-triggered CD pipelines deploy the templates in order, and every commit to `main` that touches a deployable-unit is deployed to its
non-production subscriptions; production deploys in the same stage as non-production instead of by promotion. Each deploy runs through the
service connection of its own subscription and deployment identity and asserts that subscription. The deploy-time values, the break-glass
password and the anomaly alert's recipients, are Key Vault references resolved by Azure Resource Manager. Every deployment job names an
Azure DevOps environment per template target, whose checks and approvals are not declared in the repository. `Deploy-Bicep -DryRun` runs the
Azure what-if preview.

The pipelines are `.ado/pipelines/ci-infrastructure.yaml` (CI for all three templates, which runs `Assert-BicepTemplate` and `Build-Bicep`
for each, then the infrastructure test suite), `cd-shared.yaml` for the shared platform, and thin customer pipelines (`cd-apex.yaml`,
`cd-nova.yaml`, `cd-flux.yaml`) that extend `extends/cd-customer.yaml`. Each CD pipeline runs the same CI engine, publishes one artifact per
template, and deploys it unchanged in stage order: `foundation` (`nsub` and `psub` as two jobs of one stage), then `discovery` (hubs from
`cd-shared.yaml`, spokes from the customer pipelines), then `expedition` (one job per configuration slot); every job runs on
`vmImage: ubuntu-latest`. The deployment jobs name the Azure DevOps environments `shared-nsub`, `shared-psub`, `shared-main-uat`, and
`shared-test`, and `<customer>-main-uat`, `<customer>-<env>`, or `<customer>-<env>-<slot>`. `build-validation.yml` binds each declared
globset (`automation`, `infrastructure`, `shared`, and one per customer) to its pipeline, applied by `Sync-AdoBuildValidations`;
`Register-AdoPipeline` registers a pipeline from its file, `Test-AdoPipelineTriggerGlob` keeps each trigger equal to its globset, and
`Get-GlobSetChangeRange` diffs `HEAD^1..HEAD` to find what a squash merge changed. `Build-Bicep` compiles a template and renders a
parameters file per slot (failing a config left `UNDEFINED`), `Assert-BicepTemplate` validates `options.yml`, the config classification,
identity references, and parameter alignment, and `Deploy-Bicep` deploys the built artifact into an asserted subscription; the deploys are
incremental, so a resource removed from a template stays in Azure, and no scan of the compiled templates exists. The variant is
`git_workspace: main-direct` in `variants.yml`. The service connections are declared in `service-connections.yml`, each federated by
workload identity with no stored secret, and the Azure DevOps environments' checks in `environment-approvals.yml`;
`Sync-AdoServiceConnections` and `Sync-AdoEnvironmentApprovals` apply them, and `Test-AdoServiceConnections` reports a connection that holds
a secret. An exemption, if one were needed, would be a `Microsoft.Authorization/policyExemptions` resource in `discovery`. Adding a customer
is a change of `customer.yml`, `azure.yml`, `network.yml`, a config per template, a globset, and a thin CD pipeline, reviewed like any
other. The built catzc package is made by `Export-Catzc`, and the toolchain versions are pinned in `tools.yml`. The shipped `azure.yml`
carries placeholder subscription ids.

Provisioning and configuring every landing zone and workload is automated; the rollout of a new spoke and the seeding of the break-glass
secret are manual. The repository deploys its own templates to its own rules, not Microsoft's accelerators, which assume management groups
and a platform it does not own, and `foundation`, `discovery`, and `expedition` deployed in order stand in for the base an accelerator would
provide. Its delivery framework is its own flow model grounded in the DORA research, and it improves continuously from evidence rather than
through an assessed roadmap; the delivery metrics are DORA's. The toolchain is chosen once and pinned, Git, Azure DevOps and GitHub
pipelines, Bicep, the az CLI, and Pester, and installed the same way on a devbox and in a pipeline. The infrastructure runs on Azure DevOps
Pipelines, and the catzc automation's CI and release run on GitHub Actions; planning and collaboration tools belong to the operating
organisation.
