# docs/adr/azure/waf/security.md

`ADR: Well-Architected security — what the repository does about each item of the WAF security checklist`

Pairs with [`landing-zones`](../landing-zones.md) (its Security line, [ADR-AZ-LZ#5](../landing-zones.md#rule-adr-az-lz5), is the summary
these rules expand), [`network-model`](../azure-network-model.md) (the segments the network rules rely on), and
[`data-model`](../azure-data-model.md) (where a secret may and may not appear in a config).

## Rules: ADR-AZ-WAFSE

### Rule ADR-AZ-WAFSE:1

The security baseline is the set of secure module defaults, the three landing-zone policies, and the Security line of ADR-AZ-LZ#5; a
benchmark initiative and a check that reads the compiled templates against it are planned.

- [SE:01 — Establish a security baseline](#se01--establish-a-security-baseline)

### Rule ADR-AZ-WAFSE:2

Security is built into the delivery flow by the build checks that keep secrets and unregistered identifiers out of the tree; secret
scanning, dependency scanning, and a threat model are planned.

- [SE:02 — Align secure development lifecycle (SDL) throughout the software development lifecycle](#se02--align-secure-development-lifecycle-sdl-throughout-the-software-development-lifecycle)

### Rule ADR-AZ-WAFSE:3

Every deployment carries a `data-classification` tag in its config; validating its values and letting it select controls is planned.

- [SE:03 — Classify and consistently apply sensitivity and information type labels](#se03--classify-and-consistently-apply-sensitivity-and-information-type-labels)

### Rule ADR-AZ-WAFSE:4

Segments are the subscription per customer and tier, the resource group per configuration slot, the hub-and-spoke network, and a network
security group per workload subnet, each deployed by its own service connection; management groups are left to the tenant's administrators.

- [SE:04 — Create intentional segmentation and perimeters](#se04--create-intentional-segmentation-and-perimeters)

### Rule ADR-AZ-WAFSE:5

People reach data through Entra ID groups and services through managed identities, shared-key access is off, and the one non-identity
credential is the break-glass SQL login of ADR-AZ-LZ#6; role assignments as code are planned.

- [SE:05 — Implement strict, conditional, and auditable identity and access management (IAM)](#se05--implement-strict-conditional-and-auditable-identity-and-access-management-iam)

### Rule ADR-AZ-WAFSE:6

Data services have public network access off and are reached only through private endpoints resolved by the hub's private DNS zones, inbound
internet traffic is denied at every workload subnet, and no network interface takes a public IP address; egress through a firewall and flow
logs are planned.

- [SE:06 — Isolate, filter, and control network traffic](#se06--isolate-filter-and-control-network-traffic)

### Rule ADR-AZ-WAFSE:7

Data is encrypted in transit with TLS 1.2 at minimum and HTTPS only, and at rest by the platform's own encryption; customer-managed keys are
not adopted.

- [SE:07 — Encrypt data by using modern, industry-standard methods](#se07--encrypt-data-by-using-modern-industry-standard-methods)

### Rule ADR-AZ-WAFSE:8

Hardening is a secure default of each shared Bicep module, so every caller gets it unless it turns it off; the modules that miss it (the Key
Vault, the virtual machine, the Data Factory) are planned to gain it.

- [SE:08 — Harden all workload components](#se08--harden-all-workload-components)

### Rule ADR-AZ-WAFSE:9

The repository holds no secret: a secure parameter is a Key Vault reference to `foundation`'s vault, a config address never carries a
secret, and services authenticate as managed identities; automated rotation is planned.

- [SE:09 — Protect application secrets](#se09--protect-application-secrets)

### Rule ADR-AZ-WAFSE:10

The subscription's activity log and the diagnostics of every data and network resource go to `foundation`'s Log Analytics workspace; Key
Vault and SQL audit logs and threat detection are planned.

- [SE:10 — Implement a holistic monitoring strategy](#se10--implement-a-holistic-monitoring-strategy)

### Rule ADR-AZ-WAFSE:11

The repository's checks run at build time on the templates and configs; security tests of a deployed workload are planned.

- [SE:11 — Establish a comprehensive testing regimen](#se11--establish-a-comprehensive-testing-regimen)

### Rule ADR-AZ-WAFSE:12

Incident response is not adopted, because it is an operating process of the tenant's security operations, not something a template deploys;
the repository supplies what triage reads — the owner tag, the configuration tree as inventory, and the logs in one workspace.

- [SE:12 — Define and test effective incident response procedures](#se12--define-and-test-effective-incident-response-procedures)

## Context

The Azure Well-Architected Framework (WAF) is Microsoft's guidance for reviewing a workload on Azure against five pillars: reliability,
security, cost optimisation, operational excellence, and performance efficiency. Each pillar publishes a checklist of numbered
recommendations, and each recommendation has a guide that explains it.

The security pillar keeps a workload's data and systems confidential, intact, and available, following the Zero Trust model. Its twelve
items run from a baseline and a secure development lifecycle, through the protection of identities, networks, data, and secrets, to
monitoring, testing, and incident response.

These rules are vendor recommendation, not principled theory: they record what one platform vendor advises for its own cloud, and what this
repository does about each item. Each rule cites Microsoft's page — the item's code, title, guide link, and retrieval date — and summarises
it in our words. The current WAF text is published under the Microsoft Learn Terms of Use, which grant no right to copy it into a shared
repository, so nothing here is quoted.

The [WAF reference](../../../references/waf/index.md) lists the five pillar records in this repository and the Microsoft checklist each one
cites.

The examples are the three templates the [landing-zones](../landing-zones.md) record describes: `foundation` (the Log Analytics workspace
and the Key Vault of each subscription), `discovery` (the landing zone: network, policies, budget), and `expedition` (the workload: a
storage account and a SQL database behind private endpoints). Each item says what each of them does, what it should do, or why the item does
not apply to it.

### SE:01 — Establish a security baseline

```text
SE:01 — Establish a security baseline
Source: https://learn.microsoft.com/en-us/azure/well-architected/security/establish-baseline (retrieved 2026-10-15)
Summary (ours): Write down the minimum security requirements the workload must meet, drawn from compliance obligations,
industry benchmarks, and the platform's own benchmark, and agree them with business and technical leaders before design
begins. The baseline covers technical controls and operations alike, turns its criteria into guardrails such as policy as
code, and is measured continuously so drift is caught and gaps are prioritised.
```

#### What SE:01 means here

The baseline is written in three places, each the owner of one part. The Security line of [ADR-AZ-LZ#5](../landing-zones.md#rule-adr-az-lz5)
names what a workload gets: no public network access, private endpoints only, TLS 1.2 at minimum, a managed identity, and Entra ID
authentication. The shared modules in `infrastructure/modules/` carry those settings as secure defaults, so a caller gets them without
asking. The guardrails of [ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3) — allowed locations, a required tag, and no public IP address
on a network interface — turn part of the baseline into policy as code, and `policy_enforcement` in
`automation/Catzc.Azure/configs/azure.yml` decides whether they deny or only audit
([ADR-AZ-DATAMOD#11](../azure-data-model.md#rule-adr-az-datamod11)).

No external benchmark is assigned: the Microsoft cloud security benchmark initiative is not part of any landing zone, and nothing measures a
deployed subscription against a benchmark continuously.

##### SE:01 in `foundation`

Its two resources come from `log-analytics.bicep` and `key-vault.bicep` and carry the CAF tags, so they pass the required-tag policy. The
Key Vault module has fewer secure defaults than the storage and SQL modules (see SE:08).

##### SE:01 in `discovery`

It deploys the three policy assignments through `policy-assignment.bicep`, at subscription scope, with the enforcement mode read by config
address (`global.azure.policy_enforcement.production` in `psub.yml`, `.nonproduction` in `nsub.yml`). It should also assign the Microsoft
cloud security benchmark initiative in audit mode, so the baseline is measured against a published benchmark.

##### SE:01 in `expedition`

It takes every secure default of `storage-account.bicep` and `sql-server.bicep` and overrides only `entraOnlyAuthentication`, to keep the
break-glass login of ADR-AZ-LZ#6.

##### SE:01 status

**Partly realised.** The baseline exists as module defaults and three policies, but no benchmark is assigned and no check reads the compiled
templates against it.

### SE:02 — Align secure development lifecycle (SDL) throughout the software development lifecycle

```text
SE:02 — Align secure development lifecycle (SDL) throughout the software development lifecycle
Source: https://learn.microsoft.com/en-us/azure/well-architected/security/secure-development-lifecycle (retrieved 2026-10-15)
Summary (ours): Build security into every stage of development, from requirements through build, deployment, and
decommissioning, and extend it to the whole software supply chain: workstations, repositories, build agents, and pipelines.
Threat modeling, secure coding, automated security testing, keeping secrets out of version control, and staged releases keep
design choices and code from introducing exploitable weaknesses.
```

#### What SE:02 means here

The repository treats security as a property of every change
([ADR-DORA-SECURITY#3](../../research/pervasive-security.md#rule-adr-dora-security3)), and its build checks hold part of it. Every
parameters file a build renders must satisfy the template's parameter contract, and a `secureString` parameter must be a Key Vault
reference, never a literal ([ADR-AZ-DATAMOD#9](../azure-data-model.md#rule-adr-az-datamod9)). A config address reaches only
version-controlled config, so it never carries a secret
([ADR-CONF-ADDRESSING#3](../../configuration/config-value-addressing.md#rule-adr-conf-addressing3)). Every GUID in tracked text is a
registered entry in the managed-GUID registry ([ADR-AUTO-GUIDS#1](../../automation/managed-guids.md#rule-adr-auto-guids1)), so a tenant or
subscription id cannot enter the tree unreviewed; a GUID is an identifier, not a credential, so this is not secret scanning. Logic tests
never name a live identity ([ADR-AUTO-TEST#3](../../automation/test-automation.md#rule-adr-auto-test3)).

Deployment is staged: each CD pipeline deploys `foundation`, then `discovery`, then `expedition`, non-production before production, each
through the service connection of its subscription and pinned by `-SubscriptionIdAssertIs`
([az-session-verification](../az-session-verification.md)).

There is no secret scanning, no dependency or static analysis scan of the Bicep code, and no threat model of the templates.

##### SE:02 in `foundation`

Covered by the shared build checks; nothing specific to the template.

##### SE:02 in `discovery`

Covered by the shared build checks; nothing specific to the template.

##### SE:02 in `expedition`

Its `administratorLoginPassword` is `@secure()`, and every config supplies it as a `reference` to `foundation`'s vault (secret
`exped-sql-admin-password`), which the parameter contract checks.

##### SE:02 status

**Partly realised.** The build keeps secrets and unregistered identifiers out of the tree, but secret scanning, dependency scanning, and a
threat model are planned (follow-up).

### SE:03 — Classify and consistently apply sensitivity and information type labels

```text
SE:03 — Classify and consistently apply sensitivity and information type labels
Source: https://learn.microsoft.com/en-us/azure/well-architected/security/data-classification (retrieved 2026-10-15)
Summary (ours): Use the organisation's taxonomy to label all workload data, and the components that process it, by
sensitivity, information type, and compliance scope. The labels drive design choices such as segmentation, encryption
strength, masking, and retention, and they travel with the data through every component.
```

#### What SE:03 means here

Every config of the three templates sets the CAF tag `data-classification` beside `workload`, `environment`, `owner`, `cost-center`, and
`criticality`. The values in use are `internal` (the shared platform) and `confidential` (the customer subscriptions). The tag labels the
resource, not the data inside it; nothing validates its values, and no control is chosen by it. Classification inside a database (tables,
columns) is the workload owner's, not the template's.

##### SE:03 in `foundation`

Shared configs carry `internal`; customer configs (for example `apex/psub.yml`) carry `confidential`.

##### SE:03 in `discovery`

The same split: `internal` for the hubs, `confidential` for the customer spokes.

##### SE:03 in `expedition`

The same split. A config type that rejects a missing or unknown `data-classification` value should check it at build time, so the label is
always present and always one of the taxonomy's values.

##### SE:03 status

**Partly realised.** The label is on every resource, but its values are not validated and no control depends on it.

### SE:04 — Create intentional segmentation and perimeters

```text
SE:04 — Create intentional segmentation and perimeters
Source: https://learn.microsoft.com/en-us/azure/well-architected/security/segmentation (retrieved 2026-10-15)
Summary (ours): Divide the workload into segments, each secured as a unit, using identity, network, roles, and resource
organisation together, so a breach in one segment cannot spread to the next. Identity is the main perimeter and the network
adds to it; clear ownership of each segment speeds up incident response.
```

#### What SE:04 means here

The segments come from the data model and the network plan. Each customer has its own subscriptions, one per tier
(`automation/Catzc.Azure/configs/azure.yml`), and each configuration slot is one resource group
([ADR-AZ-DATAMOD#2](../azure-data-model.md#rule-adr-az-datamod2)). The landing zones form a hub-and-spoke network
([ADR-AZ-LZ#2](../landing-zones.md#rule-adr-az-lz2), [ADR-AZ-NETWORK#5](../azure-network-model.md#rule-adr-az-network5)) whose ranges never
overlap ([ADR-AZ-NETWORK#6](../azure-network-model.md#rule-adr-az-network6)). The deploying identity is segmented too: each subscription has
its own service connection (`sc-apex-nonprod`, `sc-apex-prod`, …), and every deploy pins its subscription with `-SubscriptionIdAssertIs`.
The `owner` tag names the team that owns each resource.

Management groups are not adopted: the landing zone stops at the subscription ([ADR-AZ-LZ#1](../landing-zones.md#rule-adr-az-lz1)), so the
hierarchy above it belongs to the tenant's administrators.

##### SE:04 in `foundation`

One workspace and one vault per subscription, so a customer's logs and secrets never share a resource with another customer's.

##### SE:04 in `discovery`

A spoke gets a network security group on `private-endpoints` and on each workload subnet (`dev`, `test`), and the hub one on
`shared-services`, all with the same two rules: allow traffic inside the virtual networks, deny inbound traffic from the internet. Spokes
peer only to their hub, never to each other. The rule `allow-virtual-network-inbound` uses the `VirtualNetwork` service tag, which covers
every peered network, so east-west traffic between a spoke and the hub is open; narrower rules per subnet are a follow-up item.

##### SE:04 in `expedition`

Its own resource group per configuration slot; its private endpoints sit in its customer's `private-endpoints` subnet, or the hub's
`shared-services` subnet for the shared platform ([ADR-AZ-LZ#4](../landing-zones.md#rule-adr-az-lz4)).

##### SE:04 status

**Partly realised.** Subscriptions, resource groups, networks, and service connections segment the estate, but the network security rules
allow all traffic inside the peered networks.

### SE:05 — Implement strict, conditional, and auditable identity and access management (IAM)

```text
SE:05 — Implement strict, conditional, and auditable identity and access management (IAM)
Source: https://learn.microsoft.com/en-us/azure/well-architected/security/identity-access (retrieved 2026-10-15)
Summary (ours): Authenticate and authorise every human, workload, and resource identity through one trusted identity
provider using standard protocols, and grant each only the access its role needs, for only as long as needed. Access that is
not identity-based, such as shared keys, is minimised and audited, and every action is logged so it can be traced.
```

#### What SE:05 means here

Microsoft Entra ID is the one identity provider. The storage account and the SQL server each have a system-assigned managed identity, the
storage account refuses shared-key and SAS authorization (`allowSharedKeyAccess: false`), and the Key Vault authorizes through Azure RBAC
(`enableRbacAuthorization: true`, no access policies). A SQL server's administrator is an Entra ID group, so access follows group membership
([ADR-AZ-LZ#6](../landing-zones.md#rule-adr-az-lz6)).

The templates make no role assignments: no Key Vault, storage, or SQL data role is granted in code, and the managed identities receive no
role. Who may read a vault or a database is decided outside the repository. Conditional access, just-in-time access, and access reviews are
tenant settings, not templates.

##### SE:05 in `foundation`

The Key Vault is RBAC-authorized; the permission that lets a deploy resolve the break-glass reference, and the roles of the vault's readers,
are granted outside the repository.

##### SE:05 in `discovery`

The policy assignments carry no managed identity, because none of the three policies deploys or modifies a resource; the
`policy-assignment.bicep` module grants remediation roles only when `assignIdentity` is set.

##### SE:05 in `expedition`

`entraAdminLogin: zct-exped-sql-admins` with its `entraAdminObjectId`, `entraAdminPrincipalType` left at `Group`. The template sets
`entraOnlyAuthentication: false` to keep the break-glass login `exped-break-glass`, the one non-identity credential, whose password lives in
`foundation`'s vault. It should grant the data roles its consumers need, to groups, at the narrowest resource.

##### SE:05 status

**Partly realised.** Identities are Entra ID groups and managed identities, but role assignments are made outside the repository and are
planned (follow-up) as code.

### SE:06 — Isolate, filter, and control network traffic

```text
SE:06 — Isolate, filter, and control network traffic
Source: https://learn.microsoft.com/en-us/azure/well-architected/security/networking (retrieved 2026-10-15)
Summary (ours): Classify each traffic flow by exposure, direction, and reach, then segment, filter, and where useful
transform traffic at every boundary, assuming any point may be breached. Keep as much of the workload private as possible,
use private endpoints for platform services, force egress through a central firewall, put a web application firewall in
front of ingress, and log flows at the boundaries.
```

#### What SE:06 means here

The workload is private by default. `storage-account.bicep` and `sql-server.bicep` set `publicNetworkAccess: 'Disabled'`, the storage
network rules deny by default, and the SQL "allow Azure services" rule exists only when public access is enabled. Each data service is
reached through `private-endpoint.bicep`, registered in the hub's private DNS zones ([ADR-AZ-LZ#4](../landing-zones.md#rule-adr-az-lz4)).
The network plan lives in `automation/Catzc.Azure/configs/network.yml` and uses private ranges only
([ADR-AZ-NETWORK#1](../azure-network-model.md#rule-adr-az-network1)). The policy against public IP addresses on network interfaces closes
the most common way to expose a virtual machine ([ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3)).

The workload has no internet-facing endpoint, so a web application firewall and DDoS protection have nothing to protect; they become
relevant with the first public ingress. Egress is not filtered: the hub reserves `AzureFirewallSubnet` but deploys no firewall, and the
spoke route tables carry no routes.

##### SE:06 in `foundation`

The Key Vault and the Log Analytics workspace accept public network traffic (the modules set no `publicNetworkAccess`). The vault should
turn public access off and take a private endpoint (group id `vault`) in the subscription's network, and the hub should host the
`privatelink.vaultcore.azure.net` zone for it.

##### SE:06 in `discovery`

A network security group per workload subnet, with inbound internet traffic denied, and the reserved `GatewaySubnet` and
`AzureFirewallSubnet` with none. `privateEndpointNetworkPolicies` defaults to `Enabled` in `virtual-network.bicep`, so the security groups
apply to the private endpoints too. The hub hosts two private DNS zones, SQL Database and Blob Storage, linked to every spoke it lists. The
spoke's route table (`routeTableName`) should send egress to a firewall in `AzureFirewallSubnet` once one is deployed, and the security
groups should log flows (virtual network flow logs) to `foundation`'s workspace.

##### SE:06 in `expedition`

Two private endpoints (`blobPrivateEndpointName`, `sqlPrivateEndpointName`) in the subnet named by `privateEndpointSubnetName`, and public
network access off on both services. Nothing else to add while the workload has no public ingress.

##### SE:06 status

**Partly realised.** Data services are private and inbound internet traffic is denied, but egress is not filtered, flows are not logged, and
`foundation`'s vault and workspace are public.

### SE:07 — Encrypt data by using modern, industry-standard methods

```text
SE:07 — Encrypt data by using modern, industry-standard methods
Source: https://learn.microsoft.com/en-us/azure/well-architected/security/encryption (retrieved 2026-10-15)
Summary (ours): Protect data at rest, in transit, and where requirements demand it in use, at a strength set by the data's
classification. Prefer the platform's built-in encryption and standard algorithms over custom cryptography, use TLS 1.2 or
later everywhere, and manage keys and certificates, including customer-managed keys where needed, as carefully as the data.
```

#### What SE:07 means here

In transit, the storage account sets `minimumTlsVersion: 'TLS1_2'` and `supportsHttpsTrafficOnly: true`, and the SQL server sets
`minimalTlsVersion: '1.2'`; both are fixed in the modules, not parameters. At rest, storage service encryption and SQL transparent data
encryption are on by the platform's default with Microsoft-managed keys; the modules do not set them, and nothing turns them off.

Customer-managed keys are not adopted: the highest classification in use is `confidential`, which platform-managed keys serve, and a
customer-managed key adds a vault dependency to every read of the data. A classification that requires one would make it a config value of
the storage and SQL modules.

##### SE:07 in `foundation`

The Key Vault holds secrets, not encryption keys. Its module and the Log Analytics module set no TLS minimum, so the platform's own minimum
applies.

##### SE:07 in `discovery`

Not applicable: the landing zone stores no data.

##### SE:07 in `expedition`

Encrypted in transit by the module defaults and at rest by the platform. The database's geo-redundant backups in production
(`databaseBackupStorageRedundancy: Geo` in `apex/prod.yml`) are encrypted the same way.

##### SE:07 status

**Realised.** TLS 1.2, HTTPS only, and platform encryption at rest cover every store; customer-managed keys are not adopted, because the
data's classification does not require them.

### SE:08 — Harden all workload components

```text
SE:08 — Harden all workload components
Source: https://learn.microsoft.com/en-us/azure/well-architected/security/harden-resources (retrieved 2026-10-15)
Summary (ours): Shrink the attack surface of every component and tighten what remains, so cheap, well-known attacks stop
working. Remove unused features, ports, legacy protocols, and default accounts; keep public endpoints to a minimum; enforce
hardening at scale with policy; and verify it regularly against a benchmark, as a continuous, documented activity.
```

#### What SE:08 means here

Hardening lives in the shared modules as secure defaults, so every template inherits it ([landing-zones](../landing-zones.md), "The
Well-Architected checklist"). `storage-account.bicep` turns off anonymous blob access and shared-key access and enables soft delete for
blobs and containers (`deleteRetentionDays: 7`); `sql-server.bicep` defaults to Entra-only authentication with no SQL login and no public
access. The no-public-IP policy enforces one hardening rule at scale.

Three modules miss these defaults. `key-vault.bicep` sets neither `publicNetworkAccess` nor purge protection. `vm.bicep` creates a Basic
dynamic public IP address and takes a local administrator password; no template uses it, and the no-public-IP policy denies it in an
enforcing landing zone. `data-factory.bicep` fixes `publicNetworkAccess: 'Enabled'`; no template uses it either.

##### SE:08 in `foundation`

The vault should set `publicNetworkAccess: 'Disabled'` and `enablePurgeProtection: true` as module defaults, so a deleted vault and its
secrets cannot be purged before the retention period ends.

##### SE:08 in `discovery`

The guardrails harden the subscription; the budget limits the cost of an abuse. Nothing else to harden: a network has no features to remove.

##### SE:08 in `expedition`

Takes every module default; its one relaxation is the break-glass SQL login of ADR-AZ-LZ#6.

##### SE:08 status

**Partly realised.** The storage and SQL modules are hardened by default, but the Key Vault, virtual machine, and Data Factory modules are
planned (follow-up) to gain the same defaults.

### SE:09 — Protect application secrets

```text
SE:09 — Protect application secrets
Source: https://learn.microsoft.com/en-us/azure/well-architected/security/application-secrets (retrieved 2026-10-15)
Summary (ours): Keep the number of secrets as low as possible by letting the platform handle credentials, and keep the rest
in a dedicated, access-controlled, and audited secret store, never in code, infrastructure as code, or pipelines. Secrets
are rotated routinely and can be rotated on demand without disrupting the workload, and a secret found in the wrong place is
treated as compromised.
```

#### What SE:09 means here

The repository holds no secret. A `@secure()` parameter takes a Key Vault `reference`, and the parameter contract rejects a literal for it
([ADR-AZ-DATAMOD#9](../azure-data-model.md#rule-adr-az-datamod9)); a config address reaches only committed config, so it cannot name a
secret ([ADR-AZ-DATAMOD#10](../azure-data-model.md#rule-adr-az-datamod10),
[ADR-CONF-ADDRESSING#3](../../configuration/config-value-addressing.md#rule-adr-conf-addressing3)). In automation, a secret travels as a
protected value and reaches a child process only through one seam that masks it
([ADR-AUTO-ENVVAR#7](../../automation/environment-variables.md#rule-adr-auto-envvar7)). Managed identities and Entra ID groups remove most
credentials before they exist (SE:05).

Rotation is manual: the break-glass password is set in the vault by hand and read by Azure Resource Manager at the next deploy.

##### SE:09 in `foundation`

One Key Vault per subscription (`keyVaultName`, for example `ps-weu-zct-fnd-ap-kv` for apex production), so each customer's secrets stay in
its own subscription and each environment tier has its own copy.

##### SE:09 in `discovery`

Not applicable: the landing zone uses no secret.

##### SE:09 in `expedition`

Its one secret is the break-glass password, `exped-sql-admin-password`, referenced from the vault of the subscription it deploys to. A
rotation should be a vault operation followed by a deploy, with no config change.

##### SE:09 status

**Partly realised.** No secret is in the repository and the services use managed identities, but rotation is manual and planned (follow-up)
to be automated.

### SE:10 — Implement a holistic monitoring strategy

```text
SE:10 — Implement a holistic monitoring strategy
Source: https://learn.microsoft.com/en-us/azure/well-architected/security/monitor-threats (retrieved 2026-10-15)
Summary (ours): Capture security-relevant events from every part of the workload — users, identities, network, builds, and
hosts — and keep them as an audit trail of who did what and when, in durable sinks outside the workload. Correlate them with
platform threat detection so alerts reach security operations quickly, and use them after an incident to reconstruct it.
```

#### What SE:10 means here

`foundation`'s Log Analytics workspace is the one sink of each subscription, outside every workload's resource group. The landing zone
streams the subscription's activity log there, including the `Administrative`, `Security`, and `Policy` categories
([ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3)), and `diagnostic-setting.bicep` sends each resource's logs (category group `allLogs`)
and metrics to it. The workspace keeps 30 days (`retentionInDays` default of `log-analytics.bicep`).

Threat detection is not deployed: no Microsoft Defender for Cloud plan, no Microsoft Sentinel, and no SQL auditing.

##### SE:10 in `foundation`

The vault sends no diagnostics, though `diagnostic-setting.bicep` supports the `keyVault` kind; secret reads are therefore not logged. It
should send them to its own workspace. The workspace retention should follow the audit trail's needs per environment class, as a config
value.

##### SE:10 in `discovery`

The activity log, the virtual network, and every network security group send their diagnostics to the workspace. It should also enable the
Defender for Cloud plans of the services the workloads use, at subscription scope.

##### SE:10 in `expedition`

The storage account, its blob service, and the database send their diagnostics to the workspace. The SQL server should send its audit log
there (server auditing to Log Analytics).

##### SE:10 status

**Partly realised.** The activity log and the data and network diagnostics reach one workspace per subscription, but Key Vault and SQL audit
logs and threat detection are planned (follow-up).

### SE:11 — Establish a comprehensive testing regimen

```text
SE:11 — Establish a comprehensive testing regimen
Source: https://learn.microsoft.com/en-us/azure/well-architected/security/test (retrieved 2026-10-15)
Summary (ours): Test security continuously from inside and outside the workload, highest-severity threats on the most
critical flows first. Cover prevention controls, detection and alerting, and compliance evidence, mixing automated and
manual tests, penetration tests, and team exercises, and feed the results back into the threat model and the tests.
```

#### What SE:11 means here

The repository's tests run before deploy, on the code: `Build-Bicep` compiles each template and checks every rendered parameters file
against its contract, and `Test-AzureNetworkPlan` checks the network plan. None of them reads a security property of the compiled templates,
and nothing tests a deployed workload. A quality gate that reads each compiled `main.json` and fails a resource with public network access,
a TLS minimum below 1.2, a missing tag, or a missing diagnostic setting, citing the rule it breaks, is the planned first step; tests against
a deployed landing zone (for example, that a public IP address is denied in production) are the second.

##### SE:11 in `foundation`

The planned compiled-template check covers its vault and workspace.

##### SE:11 in `discovery`

The planned check covers the network security rules and the policy assignments; a deployed-state test would confirm the policies deny in
production.

##### SE:11 in `expedition`

The planned check covers the storage and SQL settings; a deployed-state test would confirm that the services refuse a connection from
outside the private endpoints.

##### SE:11 status

**Planned (follow-up).** Build-time checks exist for compilation and parameters, but no test reads a security property of a template or of a
deployed workload.

### SE:12 — Define and test effective incident response procedures

```text
SE:12 — Define and test effective incident response procedures
Source: https://learn.microsoft.com/en-us/azure/well-architected/security/incident-response (retrieved 2026-10-15)
Summary (ours): Prepare one tested incident response process, shared with the central security operations team, that names
who is notified, who triages, and who decides. It covers containment, recovery through the disaster recovery process where
needed, communication, and post-incident learning, so time to detect and mitigate stays short.
```

#### What SE:12 means here

Incident response is an operating process of the organisation that runs the tenant, not a resource a template deploys. The repository
supplies its inputs: the `owner` and `criticality` tags on every resource, the configuration tree as the deployment inventory
([ADR-AZ-DATAMOD#2](../azure-data-model.md#rule-adr-az-datamod2)), and the logs of each subscription in one workspace (SE:10). Alerts that
route to a named contact are not deployed; the budget alerts, which go to the subscription's `Owner` role, are the only alerts the templates
create.

##### SE:12 in `foundation`

Not applicable: it holds the workspace triage reads, nothing to respond with.

##### SE:12 in `discovery`

Not applicable: an action group for security alerts would belong here once SE:10's threat detection exists.

##### SE:12 in `expedition`

Not applicable: recovery uses the database's point-in-time restore (`databaseBackupRetentionDays`), which is a reliability setting.

##### SE:12 status

**Not adopted**, because incident response is the tenant's security operations process, and the repository's part is the tags, the
inventory, and the logs that process reads.

## Decision

The repository adopts the WAF security checklist as a review list for its templates, item by item, and records for each item what it does,
what it plans, and what it does not adopt and why. Security settings that every caller should share are secure defaults of the shared Bicep
modules; settings that differ per subscription or environment class are config values; and the subscription-wide guardrails belong to the
landing zone ([ADR-AZ-LZ#5](../landing-zones.md#rule-adr-az-lz5)). Every `partly realised` or `planned` status names the module, template,
or config that the change touches.

### How this is enforced

- `ci-infrastructure.yaml` runs `Assert-BicepTemplate` and `Build-Bicep` for `foundation`, `discovery`, and `expedition`, so every rendered
  parameters file satisfies its template's contract, including a Key Vault reference for every secure parameter
  ([ADR-AZ-DATAMOD#9](../azure-data-model.md#rule-adr-az-datamod9)), and every config address resolves to committed, non-secret config
  ([ADR-AZ-DATAMOD#10](../azure-data-model.md#rule-adr-az-datamod10)).
- `Test-ManagedGuids` fails a GUID in tracked text that is not in the managed-GUID registry
  ([ADR-AUTO-GUIDS#4](../../automation/managed-guids.md#rule-adr-auto-guids4)).
- `NetworkConfig` and `Test-AzureNetworkPlan` keep the network plan private and free of overlap
  ([ADR-AZ-NETWORK#6](../azure-network-model.md#rule-adr-az-network6)).
- In Azure, the landing zone's three policy assignments deny or audit non-compliant resources, by `policy_enforcement`
  ([ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3)).
- Every deploy verifies its subscription against `azure.yml` through `-SubscriptionIdAssertIs`
  ([az-session-verification](../az-session-verification.md)).
- **Planned (follow-up):** a quality gate over the compiled templates for the module defaults of SE:06–SE:08 and the diagnostics of SE:10; a
  secret-scanning quality gate (SE:02); a config-type check of `data-classification` (SE:03). These are plans, not checks that run.

## Consequences

- A new template inherits the security baseline by using the shared modules; turning a default off is a visible parameter in its
  `main.bicep`.
- The secure-defaults approach leaves the baseline unenforced for a module that lacks a default, which is why the Key Vault, virtual
  machine, and Data Factory modules carry follow-up items.
- Without a check over the compiled templates, a regression in a module default is caught only by review until the follow-up gate exists.
- The repository needs no rights above a subscription, at the cost of leaving management groups, conditional access, threat detection plans,
  and incident response to the tenant's administrators.
- Each item cites Microsoft's page and a retrieval date; when the vendor checklist changes, the summary and the takeaways are revisited
  together.
