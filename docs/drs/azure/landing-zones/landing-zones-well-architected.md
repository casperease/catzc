# Landing zones: The Well-Architected pillars

Part of the decision of [ADR-AZ-LZ](../landing-zones.md), which holds the rules these sections justify.

## Cost by configuration

Cost is open to the team. A landing zone's budget is the `budgetAmount` value in its `discovery` config, so anyone who reads the repository
reads every budget and a change to one goes through review like any other. The CAF tags name the paying team (`cost-center`) and the
accountable one (`owner`) on every resource. The workload has no budget of its own and its cost counts against its subscription's. Training,
cost champions, and recognition belong to the organisation that runs the repository. The budget amounts are plain config values with no cost
model behind them. The cost drivers a model would name are `foundation`'s workspace ingestion (`PerGB2018`), its retention and its Key Vault
operations, `discovery`'s virtual network, peering data transfer and private DNS zones, and `expedition`'s database (`GP_S_Gen5` at up to 2
vCores in non-production, `GP_Gen5` at 2 vCores in production), its backup redundancy and its storage account.

Cost is grouped by tag: the six CAF tags are on every resource that takes tags, the required-tag policy makes all six mandatory
([ADR-AZ-LZ-LANDINGZONEPOLICIES](../landing-zones.md#rule-adr-az-lz-landingzonepolicies)), and `budget.bicep` alerts the holders of the
subscription's `Owner` role at each threshold. The `budgetThresholds` default is 50, 80, and 100 percent of actual cost, and the module
takes one `thresholdType` per budget. Every template's resource group and every tagged resource carry the CAF tags.

The platform guardrails are the allowed-locations and required-tag policies (`requiredTagNames` defaults to the six CAF keys) and the
budget, which alerts and never stops a resource. Whether the policies deny or audit is `policy_enforcement` in `azure.yml`. The cost-bearing
settings are typed parameters: `databaseTier` is `@allowed`, `databaseBackupRetentionDays` is bounded 1 to 35, `budgetAmount` has a minimum
of 1, and every rendered parameters file is checked against those bounds
([ADR-AZ-DATAMOD-PARAMETERCONTRACT](../azure-data-model.md#rule-adr-az-datamod-parametercontract)). `databaseSkuName` is a free string, and
the policies restrict the resource types, the storage SKUs and the virtual machine sizes. `Deploy-Bicep -DryRun` runs Azure's `--what-if`
preview, and a CD pipeline deploys through one service connection per subscription and asserts the target with `-SubscriptionIdAssertIs`.
`foundation`'s SKUs are module defaults (`PerGB2018`, `standard`).

Rates are the billing account's. Every resource is pay-as-you-go: the workspace on `PerGB2018`, the vault on `standard`, a provisioned
`GP_Gen5` production database at 2 vCores (the one candidate for a reservation, bought at the billing account), and nothing in `discovery`
carries commitment-based pricing. The SQL database module exposes no licence type, so Azure Hybrid Benefit cannot be selected.

Each resource is configured to its meter. A serverless SQL database bills compute per second while it runs and only storage while paused, so
non-production configs use `GP_S_Gen5` with `databaseAutoPauseDelay: 60` and `databaseMinCapacity: "0.5"`, while production is provisioned
`GP_Gen5` at `databaseSkuCapacity: 2`. A Log Analytics workspace bills per ingested gigabyte, so `diagnostic-setting.bicep` picks the
categories each resource kind needs (a storage account sends only its `Transaction` metrics and no logs). `discovery` sends the activity
log, the virtual network's diagnostics and each network security group's logs to `foundation`'s workspace, each a per-gigabyte cost there.
The repository keeps no catalogue of each service's meter and runs no billing proof of concept.

The configuration tree is the inventory: one config file is one resource group
([ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION](../azure-data-model.md#rule-adr-az-datamod-onefileonesubscription)), names are deterministic
([ADR-AZ-NAMING-DETERMINISTICNAMES](../azure-naming-standard.md#rule-adr-az-naming-deterministicnames)), and every resource carries `owner`,
so a resource found in a subscription traces to its template and team. Disaster recovery is a redeploy from the templates plus the
database's backups, never a warm standby. The deployment mode defaults to `Incremental`, so a resource removed from a template stays in
Azure until someone deletes it, and nothing finds such an orphan or a resource group with no config. `discovery` reserves `GatewaySubnet`
and `AzureFirewallSubnet` as address space only, so no cost accrues for them. `expedition` holds one storage account and one database per
configuration slot, with no secondary region; an ephemeral slot (`dev-blu` on `apex/dev.yml`) is a second full copy of the workload.

Environment class is a config decision ([ADR-AZ-LZ-EVERYPILLAR](../landing-zones.md#rule-adr-az-lz-everypillar)). The non-production
`expedition` configs (`dev.yml`, `test.yml`, `apex/dev.yml` and its ephemeral `dev-blu`, `nova/dev.yml`) set `GP_S_Gen5` with auto-pause,
`databaseZoneRedundant: false`, `databaseBackupStorageRedundancy: Local`, and `databaseBackupRetentionDays: 7`; `apex/prod.yml` sets
`GP_Gen5`, zone redundancy by default, `Geo`, and 35 days. The storage account takes the module's `Standard_ZRS` in every class, because
`expedition` exposes no storage SKU. `foundation` is identical in both classes (the workspace keeps 30 days in each, the minimum). Policy
enforcement audits outside production by default
([ADR-AZ-DATAMOD-POLICYENFORCEMENTMODE](../azure-data-model.md#rule-adr-az-datamod-policyenforcementmode)). Off-hours shutdown is not used,
because auto-pause stops the database's compute when idle, and no environment is ephemeral.

Each example workload carries one flow (one database and one storage account serving one purpose), so there is no flow inventory to separate
or combine; a workload with flows of different value records them, and their tiers, in its own template. The templates deploy infrastructure
with no application code, so a workload that ships code optimises it in its own repository.

Data is kept as long as it earns its cost. The workspace keeps 30 days, the minimum of `log-analytics.bicep` (`foundation`'s
`retentionInDays` takes the default and no config raises it); deleted blobs and containers are kept 7 days; backup redundancy and
point-in-time retention are per-class config values; `discovery` stores no data of its own. The storage account is fixed on the `Hot` access
tier and carries no lifecycle management policy.

The one component that scales does so within a ceiling set in config: in non-production the serverless database moves between
`databaseMinCapacity: "0.5"` and `databaseSkuCapacity: 2` vCores and pauses at zero use, and in production it is provisioned at a fixed 2
vCores. Nothing in `foundation` or `discovery` scales.

People's time goes to decisions: every template composes the shared modules in `infrastructure/modules/`, so a secure or cheap default is
written once; a config reads a shared value (a network range, a subscription id, the policy mode) by config address
([ADR-AZ-DATAMOD-VALUEBYADDRESS](../azure-data-model.md#rule-adr-az-datamod-valuebyaddress)); a change triggers only the CD pipelines whose
deployable units it touches ([durable-sha-globs](../../flow/durable-sha-globs.md)); `ci-infrastructure.yaml` compiles every template and
checks every parameters file before a deploy can fail on it; budget alerts go to the `Owner` role, so no address list is kept. This applies
the repository's stance on waste ([reduce-waste](../../principles/reduce-waste.md)) to infrastructure. A new customer subscription or
configuration slot is a config file, not a design.

Shared services exist once ([ADR-AZ-LZ-LANDINGZONE](../landing-zones.md#rule-adr-az-lz-landingzone)). `foundation` gives one workspace and
one Key Vault per subscription, which `discovery` and `expedition` send diagnostics to and read the break-glass password from. Each tier's
hub holds the SQL and blob private DNS zones once and links them to every spoke
([ADR-AZ-LZ-HUBANDSPOKE](../landing-zones.md#rule-adr-az-lz-hubandspoke)). The shared platform's workload (`dev.yml`, `test.yml`) places its
private endpoints in the hub's `shared-services` subnet instead of a network of its own. Each configuration slot has its own SQL server with
one database; denser hosting (several databases per server, an elastic pool) is not used, because each slot is its own resource group. Each
tier has its own hub and each customer a subscription per class.

## Performance by configuration

Capacity is configuration, not code: every capacity a template uses is a parameter, and its value per environment class is written in the
per-slot config ([ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION](../azure-data-model.md#rule-adr-az-datamod-onefileonesubscription)), so the
capacity of every deployment is readable from the configuration tree. No utilisation history, forecast, or record of service limits backs
the values. `foundation`'s workspace uses the `PerGB2018` pay-as-you-go tier and 30-day retention, the defaults of `log-analytics.bicep`,
and its vault the `standard` SKU, the default of `key-vault.bicep`; both bill by use. `discovery` reads its ranges from `network.yml` by
config address ([ADR-AZ-DATAMOD-VALUEBYADDRESS](../azure-data-model.md#rule-adr-az-datamod-valuebyaddress)): one `/16` per subscription and
a `/24` for the private endpoints and for each environment, which caps the private endpoints a spoke can hold; its budget (1000 for the
production hub, 300 for the apex non-production spoke) is the one capacity-like number in its configs. Every `expedition` config names the
database capacity: `GP_S_Gen5` with a ceiling of 2 vCores and a floor of 0.5 outside production, `GP_Gen5` with 2 vCores in production; the
storage account is `Standard_ZRS` from the module default and has no capacity setting.

The templates use managed services throughout and no virtual machine (`vm.bicep` exists as a module that no template uses). Every
environment in `azure.yml` names one region, `westeurope`, and the allowed-locations policy keeps resources there
([ADR-AZ-LZ-LANDINGZONEPOLICIES](../landing-zones.md#rule-adr-az-lz-landingzonepolicies)), so the workload, its private endpoints, and its
workspace never cross a region. `foundation` deploys a managed workspace and a vault; `discovery` peers each spoke to its hub on the Azure
backbone and holds the private DNS zones in the hub, so a workload reaches its data services over private addresses
([ADR-AZ-LZ-HUBANDSPOKE](../landing-zones.md#rule-adr-az-lz-hubandspoke)); `expedition` deploys Azure SQL Database (General Purpose, Gen5)
and a StorageV2 account on the `Hot` access tier, both reached only through private endpoints. Outside production the database is serverless
(`GP_S_Gen5`) and in production it is provisioned (`GP_Gen5`) and zone-redundant by the template default.

Measurement is a diagnostic setting per resource, from the shared `diagnostic-setting.bicep` module, which picks the log and metric
categories each resource kind exposes, into the workspace `foundation` deploys in the same subscription. Since production and non-production
run in different subscriptions (`azure.yml`), their signals land in different workspaces by construction. The subscription's activity log
arrives through `subscription-diagnostic-setting.bicep`, with `ServiceHealth`, `ResourceHealth`, and `Autoscale` among the eight categories
it sends. `discovery` sends the virtual network (all logs and `AllMetrics`) and every network security group (all logs). `expedition`'s
storage account sends its `Transaction` metrics, its blob service its logs and `Transaction` metrics, and its database its logs, which carry
its query-store and wait statistics, and its `Basic`, `InstanceAndAppAdvanced`, and `WorkloadManagement` metrics; the SQL server and the
private endpoints have no diagnostic setting. `foundation`'s vault has none either, although the module supports the `keyVault` kind, and
the workspace's 30-day retention bounds how far back a comparison reaches. No baseline, alert, dashboard, synthetic transaction, saved
query, or workbook is deployed, and the architecture is documented in the reference articles under `docs/references/infrastructure/`.

Two scaling mechanisms exist, both by configuration. Outside production Azure scales the serverless database between the
`databaseMinCapacity` floor and the `databaseSkuCapacity` ceiling and pauses it after `databaseAutoPauseDelay` minutes idle (0.5 to 2 vCores
and 60 minutes in `dev.yml`, `test.yml`, `apex/dev.yml` (and so its ephemeral `dev-blu`), and `nova/dev.yml`), so the ceiling is the upper
limit; and the configuration slot is the unit of scale-out, an ephemeral slot (`dev-blu` on `apex/dev.yml`) deploying a whole second copy of
the workload into its own resource group, while a new customer gets its own subscription, spoke, and landing zone, much as the Deployment
Stamps pattern does. Production is provisioned at a fixed 2 vCores in `apex/prod.yml`, no autoscale rule exists, and there is no data to
partition. The address plan reserves a `/16` per spoke, so the number of spokes, not their size, is what grows.

The repository's tests verify code, configs, and compiled templates; testing in production, the L4 tier
([ADR-AUTO-TEST-TESTINGINPRODUCTION](../../automation/test-automation.md#rule-adr-auto-test-testinginproduction)), observes a released
system but measures no performance. `azure.yml` gives each production subscription a `preprod` environment and `network.yml` gives the apex
production spoke a `preprod` subnet, but no `expedition` config targets `preprod`. A workload's performance targets belong beside its
template, in its reference article under `docs/references/infrastructure/`.

The templates deploy no application code, so the code half of optimisation is the workload's. The infrastructure half follows from the
choice of platform services: TLS ends at the managed services, identity is a managed identity and Entra ID rather than stored credentials
([ADR-AZ-LZ-SQLENTRAADMINS](../landing-zones.md#rule-adr-az-lz-sqlentraadmins)), and backups are platform features. The network is as simple
as the landing zone allows: one virtual network, a network security group per workload subnet, no appliance in the traffic path, and the
reserved firewall subnet empty. `expedition` holds one empty database and one storage account with a 7-day soft delete and no schema, index,
cache, read replica, or lifecycle rule, so data tuning is the workload's that owns a schema.

Flows are not inventoried, because the workload has none. The `criticality` tag rates each deployment, not each flow (see
[Reliability in one region](#reliability-in-one-region)), and nothing reserves capacity or limits traffic by it. Isolation comes from the
customer model: each customer has its own subscriptions, spokes, workspace, vault, and workload resources, so one customer's load never
shares a database with another's.

The operational tasks the templates carry run on the platform. A deployment is `Deploy-Bicep`, an `az deployment group create` (or
`sub create` for `discovery`) in Azure's default incremental mode, so a redeploy changes only what differs and removes nothing. Backups are
the database's automated backups and the storage account's soft delete: point-in-time restore keeps 7 days of locally redundant backups
outside production and 35 days of geo-redundant ones in production, and blob soft delete keeps 7 days. The break-glass password is a Key
Vault reference resolved at deploy time, so rotating it touches no running resource. Adding a spoke takes three deploys in a fixed order
([ADR-AZ-LZ-LINKSNEEDBOTHNETWORKS](../landing-zones.md#rule-adr-az-lz-linksneedbothnetworks)). No maintenance window, off-peak schedule,
alert, triage plan, or on-call rota is set, and access to the workspace is whatever role the subscription grants.

What the repository does continuously is change the templates through the same build and verification as any code: `ci-infrastructure.yaml`
compiles and verifies every template on every change under `infrastructure/`, and `tools.yml` pins the Bicep CLI, so a newer platform
feature arrives as a reviewed template change. The SKU, capacity, and serverless settings per environment class are the knobs a review would
turn, each a one-line config change.

## Reliability in one region

Simplicity is the shape of the templates. Every resource comes from a shared module in `infrastructure/modules/`, and the settings every
caller shares (zone redundancy, public access off, TLS 1.2, a managed identity) are module defaults, so a template states only what differs
([ADR-AZ-LZ-EVERYPILLAR](../landing-zones.md#rule-adr-az-lz-everypillar)). Cross-cutting concerns live once: secrets in `foundation`'s Key
Vault, logs in its workspace, the network and private DNS zones in the landing zone
([ADR-AZ-LZ-WORKLOADOWNSNONE](../landing-zones.md#rule-adr-az-lz-workloadownsnone)), and SQL access through an Entra ID group
([ADR-AZ-LZ-SQLENTRAADMINS](../landing-zones.md#rule-adr-az-lz-sqlentraadmins)). `foundation` deploys two managed services
(`log-analytics.bicep`, `key-vault.bicep`), passing names and tags and keeping every module default, and neither exposes a redundancy
setting. `discovery` deploys only platform networking and governance resources: a resource group, a virtual network with inline subnets, a
network security group per workload subnet, a route table on a spoke, peerings, the hub's two private DNS zones, the policy assignments of
`landing-zone-policies.bicep` with one custom definition (the CAF tags), the activity-log diagnostic setting, and a budget. `expedition`
deploys a `Standard_ZRS` storage account (`storage-account.bicep`) and an Azure SQL logical server with one database (`sql-server.bicep`,
`sql-database.bicep`) reached through two private endpoints, with no virtual machine and no self-managed database.

The unit the repository rates is the deployment, not a flow: every config carries `criticality` among the CAF tags. The rating follows
dependency, not environment: the shared non-production hub is `high`, because every non-production spoke resolves its private endpoints
through its DNS zones. `foundation` is `high` for the shared platform's `nsub` and `psub` and for each customer's `psub`, and `medium` for a
customer's `nsub`; `discovery` rates both hubs and a production spoke (`apex/psub.yml`) `high` and the non-production spokes (`apex`,
`nova`, `flux`) `medium`; `expedition` is `low` for every non-production config (`dev.yml`, `test.yml`, `apex/dev.yml` and its ephemeral
`dev-blu`, `nova/dev.yml`) and `high` for `apex/prod.yml`. No check or template reads the tag; it labels for people and for cost and
inventory queries.

The dependencies of the templates are these. `foundation` depends on no other template. Its Key Vault is a strong dependency of every
`expedition` deploy, because the break-glass password is a Key Vault reference resolved at deploy time, and no dependency of the running
database; its workspace is a weak dependency of everything that sends diagnostics, since an outage loses telemetry, not function. A spoke
depends strongly on its hub for name resolution, because the private DNS zones live only in the hub
([ADR-AZ-LZ-HUBANDSPOKE](../landing-zones.md#rule-adr-az-lz-hubandspoke)), so a deleted or broken DNS zone breaks every private endpoint of
that tier; the peering is a strong dependency of anything in a spoke that calls the hub's `shared-services` subnet; and the region is a
strong dependency of all of it ([ADR-AZ-NETWORK-ONEADDRESSSPACE](../azure-network-model.md#rule-adr-az-network-oneaddressspace)). At run
time `expedition` depends strongly on its spoke's `private-endpoints` subnet (the hub's `shared-services` subnet for the shared platform)
and on the hub's `privatelink` DNS zones, and weakly on the workspace; at deploy time it depends strongly on `discovery` and on
`foundation`'s vault.

The production settings of `expedition` imply recovery points without stating them as objectives: `apex/prod.yml` sets
`databaseBackupRetentionDays: 35` and `databaseBackupStorageRedundancy: Geo`, and blobs are recoverable for 7 days after deletion;
non-production sets `databaseBackupRetentionDays: 7` and `databaseBackupStorageRedundancy: Local`. `foundation` holds no business data, and
`discovery` holds configuration, not data, and recovers by redeploying. An availability objective needs measured traffic, which the example
deployments do not have.

Zone-redundant deployment is the module default: `storage-account.bicep` defaults `skuName` to `Standard_ZRS`, and `sql-database.bicep`
turns `zoneRedundant` on for every tier that supports it and defaults `backupStorageRedundancy` to `Geo`. A template weakens that only by a
config value, and only outside production, where the cost saving outweighs a zone outage
([ADR-AZ-LZ-EVERYPILLAR](../landing-zones.md#rule-adr-az-lz-everypillar)). Storage is `Standard_ZRS` in every `expedition` config;
`apex/prod.yml` omits `databaseZoneRedundant`, so the template default `true` applies, while every non-production config sets
`databaseZoneRedundant: false` and `databaseBackupStorageRedundancy: Local`. Every environment maps to one region, so geo-redundant backups
are the only copy outside it. The network is the hub-and-spoke shape, with one hub per tier holding the only copy of the private DNS zones,
and each hub reserves `GatewaySubnet` and `AzureFirewallSubnet` so a gateway or firewall is added without renumbering. No module places a
resource lock.

Scaling: none of the templates deploys compute, so application scaling does not arise, and storage, the workspace and the vault scale inside
the platform. Outside production the serverless SKU scales automatically between `databaseMinCapacity` and `databaseSkuCapacity`, the cap
kept in config (`databaseSkuName: GP_S_Gen5`, `databaseMinCapacity: "0.5"`, `databaseSkuCapacity: 2`, `databaseAutoPauseDelay: 60`); in
production the database is `GP_Gen5` at `databaseSkuCapacity: 2`, so more capacity is a config change and a deploy, and no signal says one
is needed. The network's room to grow is the address plan: each spoke has a `/16` with `/24` subnets
([ADR-AZ-NETWORK-PERSUBSCRIPTION](../azure-network-model.md#rule-adr-az-network-persubscription)), so its `private-endpoints` subnet has
room for many more private endpoints.

The isolation unit is the customer subscription: each gets its own `foundation`, its own spoke from `discovery`, and its own `expedition`
deployments, so a fault or a bad deploy in one customer's subscription does not reach another's, and a broken spoke deploy leaves the hub
and the other spokes untouched ([ADR-AZ-LZ-LANDINGZONE](../landing-zones.md#rule-adr-az-lz-landingzone)). The hub is the one shared part of
a tier. Failover inside a region is the platform's: zone-redundant storage and a zone-redundant database fail over without a deploy, in
production and not in non-production. `storage-account.bicep` turns on soft delete for blobs and containers (`deleteRetentionDays`, 7 by
default, which `expedition` keeps), so an accidental delete is recoverable. The vault module sets no purge protection. No template deploys
an alert, an action group, or a runbook, so no failure triggers an automated action; retries, checkpoints and a degraded mode belong to
application code, which the examples do not have.

Resiliency is tested where Azure is not needed: `ci-infrastructure.yaml` compiles every template, renders every config, and checks each
rendered parameters file against the compiled parameter model
([ADR-AZ-DATAMOD-PARAMETERCONTRACT](../azure-data-model.md#rule-adr-az-datamod-parametercontract)), so a reliability setting outside its
`@allowed` values or bounds, such as a `databaseBackupStorageRedundancy` that is not `Geo`, `GeoZone`, `Zone` or `Local`, or a
`databaseBackupRetentionDays` above 35, fails the build. The values a production config chooses are not checked; a pull request that
overrides a module default shows in review. `Deploy-Bicep -DryRun` runs Azure's `--what-if` preview against a real subscription. Fault
injection, failover drills, and restore tests are not run, because the example deployments target the placeholder subscriptions in
`azure.yml`, with nothing running to test; a deployment that adopts the templates for real starts with a timed restore of its production
database.

Recovery is a redeploy and a restore. Every template is infrastructure as code with its full configuration in the repository, and an
incremental deploy is idempotent, so a lost subscription is rebuilt by deploying `foundation`, `discovery`, and `expedition` in that order,
the order the customer CD pipelines encode, with the hub-spoke-hub order for peerings
([ADR-AZ-LZ-LINKSNEEDBOTHNETWORKS](../landing-zones.md#rule-adr-az-lz-linksneedbothnetworks)). The secrets in the vault are not in the
repository by design, so the break-glass password is restored by whoever owns it. Data comes back from backups: a production database
restores from its geo-redundant backups, into another region when its own is down, kept 35 days; non-production backups are `Local`, so a
regional loss loses non-production data, which is the accepted cost trade. There is no prepared secondary region: a regional recovery means
changing the environment's `region` and `region_code` in `azure.yml`, re-spelling the region-coded resource names written in every config
([ADR-AZ-DATAMOD-STATICRESOURCENAMES](../azure-data-model.md#rule-adr-az-datamod-staticresourcenames)), and redeploying. This is the largest
reliability gap and a deliberate limit on what the repository covers.

Telemetry reaches one workspace, as [Performance by configuration](#performance-by-configuration) lists; the activity log carries
`ServiceHealth` and `ResourceHealth`, the templates that own the resources deploy their alerts, and each workload's health model is the
workbook of its own template ([ADR-AZ-LZ-CAFMANAGEMENT](../landing-zones.md#rule-adr-az-lz-cafmanagement)).

## Security by default

The baseline is written in three places, each the owner of one part. The Security line of
[ADR-AZ-LZ-EVERYPILLAR](../landing-zones.md#rule-adr-az-lz-everypillar) names what a workload gets, the shared modules in
`infrastructure/modules/` carry those settings as secure defaults, and the guardrails of
[ADR-AZ-LZ-LANDINGZONEPOLICIES](../landing-zones.md#rule-adr-az-lz-landingzonepolicies) turn part of it into policy as code, with
`policy_enforcement` in `pwsh/Azure/configs/azure.yml` deciding whether they deny or only audit
([ADR-AZ-DATAMOD-POLICYENFORCEMENTMODE](../azure-data-model.md#rule-adr-az-datamod-policyenforcementmode)). `discovery` assigns the policies
through `policy-assignment.bicep` at subscription scope, with the enforcement mode a fact the build derives from the subscription the slot
targets (production enforcement where the subscription holds a production environment). The Microsoft cloud security benchmark initiative is
assigned beside them in `DoNotEnforce` mode, whatever the subscription, so it measures every resource and denies none
([ADR-AZ-LZ-CAFSECURITY](../landing-zones.md#rule-adr-az-lz-cafsecurity)). `foundation`'s two resources come from `log-analytics.bicep` and
`key-vault.bicep` and carry the CAF tags, so they pass the required-tag policy; `expedition` takes every secure default of
`storage-account.bicep` and `sql-server.bicep` and overrides only `entraOnlyAuthentication`, to keep the break-glass login.

Security is a property of every change
([EDR-DORA-SECURITY-SECUREPATHAUTOMATED](../../external/dora/pervasive-security.md#rule-edr-dora-security-securepathautomated)), and the
build checks hold part of it. Every rendered parameters file must satisfy the template's parameter contract, and a `secureString` parameter
must be a Key Vault reference, never a literal
([ADR-AZ-DATAMOD-PARAMETERCONTRACT](../azure-data-model.md#rule-adr-az-datamod-parametercontract)): `expedition`'s
`administratorLoginPassword` is `@secure()` and every config supplies it as a `reference` to `foundation`'s vault (secret
`exped-sql-admin-password`). A config address reaches only version-controlled config, so it never carries a secret. Every GUID in tracked
text is a registered entry in the managed-GUID registry
([ADR-AUTO-GUIDS-EVERYGUIDREGISTERED](../../automation/managed-guids.md#rule-adr-auto-guids-everyguidregistered)), so a tenant or
subscription id cannot enter the tree unreviewed; a GUID is an identifier, not a credential, so this is not secret scanning. Logic tests
never name a live identity ([ADR-AUTO-TEST-DISTINCTFIXTURES](../../automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).
Deployment is staged: each CD pipeline deploys `foundation`, then `discovery`, then `expedition`, non-production before production, each
through the service connection of its subscription and pinned by `-SubscriptionIdAssertIs`
([az-session-verification](../az-session-verification.md)). The secret-scan quality gate (`Test-SecretScan`) fails a change that carries a
key, a private key or a connection string with a password, and the Bicep linter quality gate (`Test-BicepLint`) checks every template and
module. The threat model of the templates is [threat-model](../../../references/infrastructure/threat-model.md). There is no dependency
scan.

Every config of the three templates sets the CAF tag `data-classification` beside `workload`, `environment`, `owner`, `cost-center`, and
`criticality`: `internal` for the shared platform (the hubs, `foundation`'s shared configs) and `confidential` for the customer
subscriptions (for example `apex/psub.yml`). The tag labels the resource, not the data inside it; nothing validates its values and no
control is chosen by it. Classification inside a database is the workload owner's.

The segments come from the data model and the network plan. Each customer has its own subscriptions, one per tier
(`pwsh/Azure/configs/azure.yml`), and each configuration slot is one resource group
([ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION](../azure-data-model.md#rule-adr-az-datamod-onefileonesubscription)). The landing zones form a
hub-and-spoke network ([ADR-AZ-NETWORK-PERSUBSCRIPTION](../azure-network-model.md#rule-adr-az-network-persubscription)) whose ranges never
overlap ([ADR-AZ-NETWORK-NOOVERLAP](../azure-network-model.md#rule-adr-az-network-nooverlap)), and spokes peer only to their hub, never to
each other. Each subscription has its own service connection (`sc-apex-nonprod`, `sc-apex-prod`, and so on), and every deploy pins its
subscription with `-SubscriptionIdAssertIs`. `foundation` gives each subscription one workspace and one vault, so a customer's logs and
secrets never share a resource with another customer's. A spoke gets a network security group on `private-endpoints` and on each workload
subnet (`dev`, `test`), and the hub one on `shared-services`, all with the same two rules: `allow-virtual-network-inbound`, which uses the
`VirtualNetwork` service tag that covers every peered network and so leaves east-west traffic between a spoke and the hub open, and a deny
of inbound traffic from the internet. `expedition` has its own resource group per configuration slot and its private endpoints in its
customer's `private-endpoints` subnet, or the hub's `shared-services` subnet for the shared platform. Management groups are left to the
tenant's administrators.

Microsoft Entra ID is the one identity provider. The storage account and the SQL server each have a system-assigned managed identity, the
storage account refuses shared-key and SAS authorization (`allowSharedKeyAccess: false`), and the Key Vault authorizes through Azure RBAC
(`enableRbacAuthorization: true`, no access policies). A SQL server's administrator is an Entra ID group, so access follows group membership
([ADR-AZ-LZ-SQLENTRAADMINS](../landing-zones.md#rule-adr-az-lz-sqlentraadmins)): `expedition` sets `entraAdminLogin: zct-exped-sql-admins`
with its `entraAdminObjectId`, `entraAdminPrincipalType` left at `Group`, and `entraOnlyAuthentication: false` to keep the break-glass login
`exped-break-glass`, the one non-identity credential, whose password lives in `foundation`'s vault. The templates assign built-in roles to
groups, never to users, through `role-assignment.bicep` and `subscription-role-assignment.bicep`, each assignment named
`guid(scope, principal, role)` and its role id addressed from `roles.yml`: `discovery` gives the subscription's readers `reader` and its
workspace `log_analytics_reader`, and its operators `contributor` and `rbac_administrator` under an attribute-based condition that lets them
grant only the data roles. The data roles carry no condition of their own, since there is no tagged-container model to condition them on.
The modules take a managed identity as principal too, which no template grants yet. The permission that lets a deploy resolve the
break-glass reference is granted outside the repository, and conditional access, just-in-time access, and access reviews are tenant
settings. The policy assignments carry no managed identity, because none of the ten policies deploys or modifies a resource;
`policy-assignment.bicep` grants remediation roles only when `assignIdentity` is set.

The workload is private by default. `storage-account.bicep` and `sql-server.bicep` set `publicNetworkAccess: 'Disabled'`, the storage
network rules deny by default, and the SQL "allow Azure services" rule exists only when public access is enabled. Each data service is
reached through `private-endpoint.bicep`, registered in the hub's private DNS zones
([ADR-AZ-LZ-WORKLOADOWNSNONE](../landing-zones.md#rule-adr-az-lz-workloadownsnone)); `expedition` has two private endpoints
(`blobPrivateEndpointName`, `sqlPrivateEndpointName`) in the subnet named by `privateEndpointSubnetName`. The network plan lives in
`pwsh/Azure/configs/network.yml` and uses private ranges only
([ADR-AZ-NETWORK-ONEIPPLAN](../azure-network-model.md#rule-adr-az-network-oneipplan)). The policy against public IP addresses on network
interfaces closes the most common way to expose a virtual machine. `privateEndpointNetworkPolicies` defaults to `Enabled` in
`virtual-network.bicep`, so the security groups apply to the private endpoints too; `GatewaySubnet` and `AzureFirewallSubnet` carry no
security group. The hub hosts two private DNS zones, SQL Database and Blob Storage, linked to every spoke it lists. The workload has no
internet-facing endpoint, so a web application firewall and DDoS protection have nothing to protect. Egress is not filtered: the hub
reserves `AzureFirewallSubnet` and deploys no firewall, and the spoke route tables (`routeTableName`) carry no routes. `foundation`'s Key
Vault and Log Analytics workspace accept public network traffic, since the modules set no `publicNetworkAccess`.

In transit, the storage account sets `minimumTlsVersion: 'TLS1_2'` and `supportsHttpsTrafficOnly: true`, and the SQL server sets
`minimalTlsVersion: '1.2'`; both are fixed in the modules, not parameters. At rest, storage service encryption and SQL transparent data
encryption are on by the platform's default with Microsoft-managed keys; the modules do not set them and nothing turns them off, and the
geo-redundant backups of `apex/prod.yml` are encrypted the same way. Customer-managed keys are not adopted: the highest classification in
use is `confidential`, which platform-managed keys serve, and a customer-managed key adds a vault dependency to every read of the data; a
classification that requires one would make it a config value of the storage and SQL modules. `foundation`'s Key Vault holds secrets, not
encryption keys, and neither it nor the Log Analytics module sets a TLS minimum, so the platform's own minimum applies. `discovery` stores
no data.

Hardening lives in the shared modules as secure defaults, so every template inherits it
([The Well-Architected checklist](landing-zones-topology.md#the-well-architected-checklist)). `storage-account.bicep` turns off anonymous
blob access and shared-key access and enables soft delete for blobs and containers (`deleteRetentionDays: 7`); `sql-server.bicep` defaults
to Entra-only authentication with no SQL login and no public access; the no-public-IP policy enforces one hardening rule at scale. Three
modules miss these defaults: `key-vault.bicep` sets neither `publicNetworkAccess` nor purge protection, `vm.bicep` creates a Basic dynamic
public IP address and takes a local administrator password (no template uses it, and the no-public-IP policy denies it in an enforcing
landing zone), and `data-factory.bicep` fixes `publicNetworkAccess: 'Enabled'` (no template uses it either). The budget limits the cost of
an abuse of `discovery`'s subscription.

The repository holds no secret. A `@secure()` parameter takes a Key Vault `reference`, and the parameter contract rejects a literal for it;
a config address reaches only committed config, so it cannot name a secret
([ADR-AZ-DATAMOD-VALUEBYADDRESS](../azure-data-model.md#rule-adr-az-datamod-valuebyaddress)). In automation, a secret travels as a protected
value and reaches a child process only through one seam that masks it
([ADR-AUTO-ENVVAR-SECRETTOCHILDPROCESS](../../automation/environment-variables.md#rule-adr-auto-envvar-secrettochildprocess)). Managed
identities and Entra ID groups remove most credentials before they exist. `foundation` deploys one Key Vault per subscription
(`keyVaultName`, for example `ps-weu-zct-fnd-ap-kv` for apex production), so each customer's secrets stay in its own subscription and each
environment tier has its own copy. The one secret in use is the break-glass password, `exped-sql-admin-password`, referenced from the vault
of the subscription `expedition` deploys to; it is set in the vault by hand and read by Azure Resource Manager at the next deploy, so its
rotation is manual. `discovery` uses no secret.

`foundation`'s Log Analytics workspace is the one sink of each subscription, outside every workload's resource group. The landing zone
streams the subscription's activity log there, including the `Administrative`, `Security`, and `Policy` categories, and
`diagnostic-setting.bicep` sends each resource's logs (category group `allLogs`) and metrics to it; `discovery` sends the virtual network
and every network security group, and `expedition` the storage account, its blob service, and the database. The workspace keeps 30 days
(`retentionInDays` default of `log-analytics.bicep`). The vault sends no diagnostics, so secret reads are not logged. `discovery` turns on
the Microsoft Defender for Cloud plans of `defenderPlans` (storage, SQL, Key Vault, and Resource Manager), `sql-server.bicep` sends each
server's auditing to the workspace, and Microsoft Sentinel is not deployed.

The repository's tests run before deploy, on the code: `Build-Bicep` compiles each template and checks every rendered parameters file
against its contract, and `Test-AzureNetworkPlan` checks the network plan. None of them reads a security property of the compiled templates,
and nothing tests a deployed workload; a regression in a module default is caught by review.

Incident response is an operating process of the organisation that runs the tenant, not a resource a template deploys. The repository
supplies its inputs: the `owner` and `criticality` tags on every resource, the configuration tree as the deployment inventory
([ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION](../azure-data-model.md#rule-adr-az-datamod-onefileonesubscription)), and the logs of each
subscription in one workspace. The budget alerts, which go to the subscription's `Owner` role, are the only alerts the templates create;
recovery uses the database's point-in-time restore (`databaseBackupRetentionDays`), which is a reliability setting.
