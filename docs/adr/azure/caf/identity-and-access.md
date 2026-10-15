---
catzc:
  derived:
    path: docs/adr/azure/caf/identity-and-access.md
    kind: adr
    body_sha: e192bb608891
    defines:
      - ADR-AZ-CAFIAM#{1-68}
    adrs:
      - ADR-AUTO-GUIDS#{1,4}
      - ADR-AZ-CAFGOV#6
      - ADR-AZ-CAFSEC#{3,7,13,15,16,22,25,26,28,29,34,37,38,43}
      - ADR-AZ-DATAMOD#{2,7,9,11}
      - ADR-AZ-LZ#{1-6}
      - ADR-AZ-NETWORK#3
      - ADR-AZ-SESSION#{2,4,5}
      - ADR-AZ-WAFSE#{4,5,8-10}
      - ADR-FLOW-CD-RUNNER#3
    links:
      - docs/adr/automation/managed-guids.md#rule-adr-auto-guids1
      - docs/adr/automation/managed-guids.md#rule-adr-auto-guids4
      - docs/adr/azure/az-session-verification.md
      - docs/adr/azure/az-session-verification.md#rule-adr-az-session2
      - docs/adr/azure/az-session-verification.md#rule-adr-az-session4
      - docs/adr/azure/az-session-verification.md#rule-adr-az-session5
      - docs/adr/azure/azure-data-model.md#rule-adr-az-datamod11
      - docs/adr/azure/azure-data-model.md#rule-adr-az-datamod2
      - docs/adr/azure/azure-data-model.md#rule-adr-az-datamod7
      - docs/adr/azure/azure-data-model.md#rule-adr-az-datamod9
      - docs/adr/azure/azure-network-model.md#rule-adr-az-network3
      - docs/adr/azure/caf/governance.md#rule-adr-az-cafgov6
      - docs/adr/azure/caf/landing-zone-security.md
      - docs/adr/azure/caf/landing-zone-security.md#rule-adr-az-cafsec13
      - docs/adr/azure/caf/landing-zone-security.md#rule-adr-az-cafsec15
      - docs/adr/azure/caf/landing-zone-security.md#rule-adr-az-cafsec16
      - docs/adr/azure/caf/landing-zone-security.md#rule-adr-az-cafsec22
      - docs/adr/azure/caf/landing-zone-security.md#rule-adr-az-cafsec25
      - docs/adr/azure/caf/landing-zone-security.md#rule-adr-az-cafsec26
      - docs/adr/azure/caf/landing-zone-security.md#rule-adr-az-cafsec28
      - docs/adr/azure/caf/landing-zone-security.md#rule-adr-az-cafsec29
      - docs/adr/azure/caf/landing-zone-security.md#rule-adr-az-cafsec3
      - docs/adr/azure/caf/landing-zone-security.md#rule-adr-az-cafsec34
      - docs/adr/azure/caf/landing-zone-security.md#rule-adr-az-cafsec37
      - docs/adr/azure/caf/landing-zone-security.md#rule-adr-az-cafsec38
      - docs/adr/azure/caf/landing-zone-security.md#rule-adr-az-cafsec43
      - docs/adr/azure/caf/landing-zone-security.md#rule-adr-az-cafsec7
      - docs/adr/azure/landing-zones.md
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz1
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz2
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz3
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz4
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz5
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz6
      - docs/adr/azure/waf/security.md
      - docs/adr/azure/waf/security.md#rule-adr-az-wafse10
      - docs/adr/azure/waf/security.md#rule-adr-az-wafse4
      - docs/adr/azure/waf/security.md#rule-adr-az-wafse5
      - docs/adr/azure/waf/security.md#rule-adr-az-wafse8
      - docs/adr/azure/waf/security.md#rule-adr-az-wafse9
      - docs/adr/flow/pipeline-runner-pattern.md#rule-adr-flow-cd-runner3
      - docs/references/caf/index.md
      - "https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/security-considerations-overview"
---

# ADR: CAF identity and access — what the repository does about each recommendation of the landing-zone identity and access design area

Pairs with [`waf-security`](../waf/security.md) (the workload view of identity, [ADR-AZ-WAFSE#5](../waf/security.md#rule-adr-az-wafse5),
whose analysis is cited here, not repeated), [`caf-security`](landing-zone-security.md) (the platform's Key Vault and privileged-access
rules), and [`landing-zones`](../landing-zones.md) (the SQL authentication of [ADR-AZ-LZ#6](../landing-zones.md#rule-adr-az-lz6)).

## Rules: ADR-AZ-CAFIAM

### Rule ADR-AZ-CAFIAM:1

An inventory of authentication providers is not adopted, because every resource the templates deploy authenticates through Entra ID alone.

- [1 — Inventory the authentication of each application](#1--inventory-the-authentication-of-each-application)

### Rule ADR-AZ-CAFIAM:2

A managed directory for legacy protocols is not adopted, because no workload uses a legacy directory protocol.

- [2 — Prefer a managed directory for legacy protocols](#2--prefer-a-managed-directory-for-legacy-protocols)

### Rule ADR-AZ-CAFIAM:3

Resilience of directory services is not adopted, because the repository runs no directory service of its own.

- [3 — Design directory services for resilience](#3--design-directory-services-for-resilience)

### Rule ADR-AZ-CAFIAM:4

Active Directory sites per region are not adopted, because no template extends an on-premises directory into Azure.

- [4 — An Active Directory site per Azure region](#4--an-active-directory-site-per-azure-region)

### Rule ADR-AZ-CAFIAM:5

A choice of guest and partner identity is not adopted, because no workload has users from outside the tenant.

- [5 — Guest and partner access](#5--guest-and-partner-access)

### Rule ADR-AZ-CAFIAM:6

The advice against application proxy for intranet access is not adopted, because no template publishes an application.

- [6 — No application proxy for intranet access](#6--no-application-proxy-for-intranet-access)

### Rule ADR-AZ-CAFIAM:7

A standby Entra Connect server is not adopted, because the repository synchronises no on-premises directory.

- [7 — Entra Connect staging server for recovery](#7--entra-connect-staging-server-for-recovery)

### Rule ADR-AZ-CAFIAM:8

Redundant Cloud Sync agents are not adopted, because the repository synchronises no on-premises directory.

- [8 — Three Cloud Sync agents across regions](#8--three-cloud-sync-agents-across-regions)

### Rule ADR-AZ-CAFIAM:9

The choice of a synchronisation tool is not adopted, because the repository synchronises no on-premises directory.

- [9 — Choose the synchronisation tool](#9--choose-the-synchronisation-tool)

### Rule ADR-AZ-CAFIAM:10

AD FS in Azure is not adopted, because nothing in the repository federates through AD FS.

- [10 — AD FS deployed by the Azure guide](#10--ad-fs-deployed-by-the-azure-guide)

### Rule ADR-AZ-CAFIAM:11

Password hash sync beside AD FS is not adopted, because nothing in the repository federates through AD FS.

- [11 — Password hash sync beside AD FS](#11--password-hash-sync-beside-ad-fs)

### Rule ADR-AZ-CAFIAM:12

Application proxy for on-premises applications is not adopted, because there is no on-premises application and no on-premises connectivity.

- [12 — Application proxy for remote access to on-premises applications](#12--application-proxy-for-remote-access-to-on-premises-applications)

### Rule ADR-AZ-CAFIAM:13

A compatibility check against the directory services is not adopted, because no workload depends on a directory service.

- [13 — Check workload compatibility with the directory services](#13--check-workload-compatibility-with-the-directory-services)

### Rule ADR-AZ-CAFIAM:14

Directory servers in an identity subscription are not adopted, because no template deploys a directory server (ADR-AZ-CAFSEC#28).

- [14 — Directory servers in the identity subscription](#14--directory-servers-in-the-identity-subscription)

### Rule ADR-AZ-CAFIAM:15

An isolated network for directory servers is not adopted, because `network.yml` plans no directory subnet and no template deploys one.

- [15 — Isolate the network of the directory servers](#15--isolate-the-network-of-the-directory-servers)

### Rule ADR-AZ-CAFIAM:16

Virtual Network Manager rules for directory access are not adopted, because there is no directory subnet to reach.

- [16 — Virtual Network Manager rules for directory access](#16--virtual-network-manager-rules-for-directory-access)

### Rule ADR-AZ-CAFIAM:17

Restricting control-plane roles over directory servers is not adopted, because there are no directory servers to protect.

- [17 — Restrict control-plane roles over directory servers](#17--restrict-control-plane-roles-over-directory-servers)

### Rule ADR-AZ-CAFIAM:18

Arc-managed directory servers are not adopted, because the repository manages no server outside Azure.

- [18 — Arc-managed directory servers in the identity subscription](#18--arc-managed-directory-servers-in-the-identity-subscription)

### Rule ADR-AZ-CAFIAM:19

Placing core applications near replica sets is not adopted, because no template deploys a managed directory.

- [19 — Keep core applications near the replica sets](#19--keep-core-applications-near-the-replica-sets)

### Rule ADR-AZ-CAFIAM:20

Directory servers across regions and zones are not adopted, because no template deploys a directory server.

- [20 — Directory servers across regions and availability zones](#20--directory-servers-across-regions-and-availability-zones)

### Rule ADR-AZ-CAFIAM:21

The choice of Entra authentication methods is not adopted, because it is a setting of the tenant, not of a template.

- [21 — Evaluate the Entra authentication methods](#21--evaluate-the-entra-authentication-methods)

### Rule ADR-AZ-CAFIAM:22

Entra Kerberos for Azure Files is not adopted, because no template deploys a file share.

- [22 — Entra Kerberos for Azure Files](#22--entra-kerberos-for-azure-files)

### Rule ADR-AZ-CAFIAM:23

Multi-factor authentication is not adopted as a repository rule, because it is enforced by the tenant's Conditional Access, not by a
template.

- [23 — Multi-factor authentication for everyone with Azure rights](#23--multi-factor-authentication-for-everyone-with-azure-rights)

### Rule ADR-AZ-CAFIAM:24

Conditional Access is not adopted, because it is a policy of the tenant, not a resource a template deploys.

- [24 — Conditional Access for Azure users](#24--conditional-access-for-azure-users)

### Rule ADR-AZ-CAFIAM:25

Defender for Identity is not adopted, because there are no directory servers for its sensors and it is licensed for the tenant.

- [25 — Defender for Identity](#25--defender-for-identity)

### Rule ADR-AZ-CAFIAM:26

Sentinel for identity threats is not adopted, for the reason of ADR-AZ-CAFSEC#43.

- [26 — Sentinel for identity threats](#26--sentinel-for-identity-threats)

### Rule ADR-AZ-CAFIAM:27

Separate administrative accounts are not adopted, because accounts are objects of the tenant's directory.

- [27 — Separate administrative from everyday accounts](#27--separate-administrative-from-everyday-accounts)

### Rule ADR-AZ-CAFIAM:28

Every principal the templates name is a group or a role, never a user: the SQL administrator is an Entra ID group and the budget alerts go
to the `Owner` role; role assignments as code are planned (ADR-AZ-WAFSE#5).

- [28 — Assign roles to groups, not to users](#28--assign-roles-to-groups-not-to-users)

### Rule ADR-AZ-CAFIAM:29

Tenant emergency-access accounts are not adopted; at the level the repository owns, the break-glass SQL login of ADR-AZ-LZ#6 keeps a SQL
server reachable, and monitoring its use is planned.

- [29 — Emergency-access accounts](#29--emergency-access-accounts)

### Rule ADR-AZ-CAFIAM:30

Streaming Entra ID logs to a workspace is not adopted, because a tenant diagnostic setting needs rights above any subscription.

- [30 — Entra logs in Azure Monitor](#30--entra-logs-in-azure-monitor)

### Rule ADR-AZ-CAFIAM:31

Access packages are not adopted, because group membership is managed in the tenant's directory.

- [31 — Access packages for group membership](#31--access-packages-for-group-membership)

### Rule ADR-AZ-CAFIAM:32

Entra built-in roles for identity settings are not adopted, because directory roles belong to the tenant's administrators.

- [32 — Entra built-in roles for identity settings](#32--entra-built-in-roles-for-identity-settings)

### Rule ADR-AZ-CAFIAM:33

The least-privileged Entra role is not adopted, because the repository grants no directory role.

- [33 — The least-privileged Entra role](#33--the-least-privileged-entra-role)

### Rule ADR-AZ-CAFIAM:34

Administrative units are not adopted, because they divide the tenant's directory, which the repository does not manage.

- [34 — Administrative units](#34--administrative-units)

### Rule ADR-AZ-CAFIAM:35

Restricted management administrative units are not adopted, for the reason of rule 34.

- [35 — Restricted management administrative units](#35--restricted-management-administrative-units)

### Rule ADR-AZ-CAFIAM:36

Every subscription gets the same landing zone from `discovery`, but it assigns no role; one standard role set, declared once and deployed to
every landing zone, is planned.

- [36 — Standard roles in every landing zone](#36--standard-roles-in-every-landing-zone)

### Rule ADR-AZ-CAFIAM:37

Key Vault and storage authorize their data plane through Entra ID and Azure RBAC, and SQL through its Entra ID administrator group; the data
roles themselves are planned as code.

- [37 — Azure RBAC for the data plane](#37--azure-rbac-for-the-data-plane)

### Rule ADR-AZ-CAFIAM:38

One workspace per subscription keeps each customer's logs apart; pinning resource-context access as a default of the workspace module is
planned.

- [38 — The permission model of the log workspaces](#38--the-permission-model-of-the-log-workspaces)

### Rule ADR-AZ-CAFIAM:39

The one role grant the modules make uses built-in role definitions, and no custom role is defined; the planned role assignments start from
built-in roles.

- [39 — Built-in roles first, custom roles when needed](#39--built-in-roles-first-custom-roles-when-needed)

### Rule ADR-AZ-CAFIAM:40

Reviewing the combined effect of stacked assignments is planned with the standard role set of rule 36.

- [40 — The combined effect of stacked assignments](#40--the-combined-effect-of-stacked-assignments)

### Rule ADR-AZ-CAFIAM:41

Tracking new role definitions is not adopted as a process of its own; the record carries its retrieval date and is revisited with the vendor
guidance.

- [41 — Track new role definitions](#41--track-new-role-definitions)

### Rule ADR-AZ-CAFIAM:42

The custom roles of the CAF reference architecture are not adopted, because the repository defines no custom role and owns no management
group.

- [42 — The custom roles of the reference architecture](#42--the-custom-roles-of-the-reference-architecture)

### Rule ADR-AZ-CAFIAM:43

`discovery` provisions every landing zone but creates no group, no role assignment, and no user-assigned identity; role assignments are
planned, and creating Entra ID groups is not adopted.

- [43 — Landing zone provisioning creates groups, assignments, and identities](#43--landing-zone-provisioning-creates-groups-assignments-and-identities)

### Rule ADR-AZ-CAFIAM:44

Role assignments are planned at subscription level in `discovery` and at resource level in `expedition`, never above a subscription.

- [44 — Role assignments at subscription or resource group level](#44--role-assignments-at-subscription-or-resource-group-level)

### Rule ADR-AZ-CAFIAM:45

Every `expedition` config names the same SQL administrator group; a group per customer and environment is planned.

- [45 — Groups and assignments per landing zone](#45--groups-and-assignments-per-landing-zone)

### Rule ADR-AZ-CAFIAM:46

The same as rule 28: every principal the templates name is a group or a role.

- [46 — Groups, not users, as role holders](#46--groups-not-users-as-role-holders)

### Rule ADR-AZ-CAFIAM:47

Managed identities are per resource and vaults and service connections per tier, but the environments of one tier share their service
connection and their vault secret, and every environment shares the SQL administrator group; separating them is planned.

- [47 — Separate security configuration per environment](#47--separate-security-configuration-per-environment)

### Rule ADR-AZ-CAFIAM:48

Just-in-time platform access is not adopted, because Privileged Identity Management is a tenant setting (ADR-AZ-CAFSEC#37).

- [48 — Just-in-time platform access to workload landing zones](#48--just-in-time-platform-access-to-workload-landing-zones)

### Rule ADR-AZ-CAFIAM:49

A condition that limits which roles the deploying identity may assign is planned together with the role assignments as code.

- [49 — Constrain delegated role assignment with conditions](#49--constrain-delegated-role-assignment-with-conditions)

### Rule ADR-AZ-CAFIAM:50

The example role assignment structure is not adopted as a table; its principle, a specific group in a specific landing zone, is planned
through rules 45 and 47.

- [50 — An example role assignment structure](#50--an-example-role-assignment-structure)

### Rule ADR-AZ-CAFIAM:51

`policy-assignment.bicep` gives a remediating policy a system-assigned identity and grants it the listed built-in roles directly, on the
subscription; no landing-zone policy needs it.

- [51 — Remediation identities of deploy-if-not-exists policies](#51--remediation-identities-of-deploy-if-not-exists-policies)

### Rule ADR-AZ-CAFIAM:52

Privileged Identity Management is not adopted, for the reason of ADR-AZ-CAFSEC#37.

- [52 — Privileged Identity Management for least privilege](#52--privileged-identity-management-for-least-privilege)

### Rule ADR-AZ-CAFIAM:53

Access reviews are not adopted, because they are a tenant process over the tenant's role holders.

- [53 — Access reviews in Privileged Identity Management](#53--access-reviews-in-privileged-identity-management)

### Rule ADR-AZ-CAFIAM:54

Every deploy runs through the service connection of its subscription, pinned by `-SubscriptionIdAssertIs`, and the infrastructure CI needs
no Azure identity; separating the landing-zone identity from the workload identity is planned.

- [54 — Govern privileged automation like privileged people](#54--govern-privileged-automation-like-privileged-people)

### Rule ADR-AZ-CAFIAM:55

Owner and User Access Administrator behind PIM for groups are not adopted, because role eligibility is a tenant setting.

- [55 — Owner and User Access Administrator behind PIM for groups](#55--owner-and-user-access-administrator-behind-pim-for-groups)

### Rule ADR-AZ-CAFIAM:56

Protected actions are not adopted, because they are a tenant setting.

- [56 — Protected actions](#56--protected-actions)

### Rule ADR-AZ-CAFIAM:57

Pipelines sign in through Azure DevOps service connections whose kind is set outside the repository; workload identity federation for every
service connection is planned.

- [57 — OpenID Connect for pipelines](#57--openid-connect-for-pipelines)

### Rule ADR-AZ-CAFIAM:58

Attribute-based access conditions are not adopted, because no data role is granted yet; they are weighed with the data roles of rule 37.

- [58 — Attribute-based access conditions](#58--attribute-based-access-conditions)

### Rule ADR-AZ-CAFIAM:59

Entra ID sign-in for virtual machines is not adopted, because no template deploys a virtual machine.

- [59 — Entra ID sign-in for virtual machines](#59--entra-id-sign-in-for-virtual-machines)

### Rule ADR-AZ-CAFIAM:60

The storage account and the SQL server carry system-assigned managed identities, but nothing grants them a role; access between resources
through them is planned.

- [60 — Managed identities between resources](#60--managed-identities-between-resources)

### Rule ADR-AZ-CAFIAM:61

No managed identity is shared, because each is system-assigned to one resource of one configuration slot; the shared break-glass secret per
tier is planned to split (ADR-AZ-CAFSEC#26).

- [61 — No identity shared across environments or applications](#61--no-identity-shared-across-environments-or-applications)

### Rule ADR-AZ-CAFIAM:62

User-assigned identities at scale are not adopted, because no template deploys a fleet of machines.

- [62 — User-assigned identities at scale](#62--user-assigned-identities-at-scale)

### Rule ADR-AZ-CAFIAM:63

Secrets live in Key Vault, authorized through Azure RBAC with no access policies; data roles for the identities that read them are planned.

- [63 — Key Vault for application secrets](#63--key-vault-for-application-secrets)

### Rule ADR-AZ-CAFIAM:64

Each subscription has its own vault, deployed by `foundation`, not one per application environment; a secret name per configuration slot is
planned, and a vault inside each workload is not adopted.

- [64 — A key vault per application environment](#64--a-key-vault-per-application-environment)

### Rule ADR-AZ-CAFIAM:65

The same as rule 12: application proxy is not adopted.

- [65 — Application proxy for on-premises applications](#65--application-proxy-for-on-premises-applications)

### Rule ADR-AZ-CAFIAM:66

Network paths to directory servers are not adopted, because no workload uses a legacy protocol and no directory server exists.

- [66 — Network paths for legacy protocols](#66--network-paths-for-legacy-protocols)

### Rule ADR-AZ-CAFIAM:67

The Microsoft identity platform is not adopted as a template concern, because no template deploys an application that users sign in to.

- [67 — The Microsoft identity platform for cloud-native applications](#67--the-microsoft-identity-platform-for-cloud-native-applications)

### Rule ADR-AZ-CAFIAM:68

The integration checklist is not adopted, for the reason of rule 67.

- [68 — The identity platform integration checklist](#68--the-identity-platform-integration-checklist)

## Context

Microsoft's Cloud Adoption Framework (CAF) is its guidance for adopting Azure across an organisation. Its landing-zone part splits the
platform that workloads land in into design areas, each with considerations and numbered design recommendations: billing and tenant,
identity and access, resource organisation, network, security, management, governance, and platform automation.

The identity and access design area covers how people and workloads authenticate, how they are granted access to resources, how duties are
separated, and how an on-premises directory is synchronised into Entra ID. Its area page holds no recommendations; they sit on three
sub-pages, numbered here in the area page's order: hybrid identity (1–22, under the page's hybrid identity recommendations and its Entra ID
and AD DS recommendations), landing-zone identity and access (23–56: general, Entra ID, Azure RBAC with built-in roles and role assignments,
and Privileged Identity Management), and application identity and access (57–68).

These rules are vendor recommendation, not principled theory: they record what one platform vendor advises for its own cloud, and what this
repository does about each item. CAF items carry no codes, so each rule's number is the item's order across the three pages. Each rule cites
Microsoft's page — the page title, the link, and the retrieval date — and summarises the item in our words. The live CAF text falls under
the Microsoft Learn Terms of Use, which grant no right to copy it into a shared repository, so nothing here is quoted.

The [CAF reference](../../../references/caf/index.md) lists every CAF record in this repository and the Microsoft pages each one cites.

The repository's identity model is small, and most of this area falls outside it. Entra ID is the one identity provider; there is no
on-premises directory, no synchronisation, no directory server in Azure, and no on-premises connectivity (the hub reserves `GatewaySubnet`
and deploys nothing into it, [ADR-AZ-LZ#2](../landing-zones.md#rule-adr-az-lz2)). The directory, its accounts and groups, Conditional
Access, and Privileged Identity Management belong to the tenant's administrators, because the repository deploys into subscriptions it is
given and owns nothing above them ([ADR-AZ-LZ#1](../landing-zones.md#rule-adr-az-lz1)). Within that boundary it has a SQL administrator that
is an Entra ID group, a break-glass SQL login whose password is a Key Vault reference ([ADR-AZ-LZ#6](../landing-zones.md#rule-adr-az-lz6)),
RBAC-authorized vaults, system-assigned managed identities on the storage account and the SQL server, no role assignment in any template
([ADR-AZ-WAFSE#5](../waf/security.md#rule-adr-az-wafse5)), and one service connection per subscription whose target every deploy pins
([az-session-verification](../az-session-verification.md)). So the hybrid-identity items and the tenant items take the compact form, and the
items that bear on a template, a module, a config, or a pipeline take the full one.

Microsoft's
[DevOps security considerations](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/security-considerations-overview)
page (retrieved 2026-10-15) has no recommendations section, so it is not a rule here. It informs the pipeline items (47, 54, 57): it advises
pipelines to sign in through OpenID Connect workload identity federation, to use one deploying identity per application and environment, to
give the preview of a change (what-if) its own read-only identity, and to put approvals on the service connection.

The examples are the three templates the [landing-zones](../landing-zones.md) record describes: `foundation` (the Log Analytics workspace
and the Key Vault of each subscription), `discovery` (the landing zone: network, policies, budget), and `expedition` (the workload: a
storage account and a SQL database behind private endpoints).

### 1 — Inventory the authentication of each application

```text
CAF identity and access — Hybrid identity with Active Directory and Microsoft Entra ID — recommendation 1
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity (retrieved 2026-10-14)
Summary (ours): Record which authentication provider each application relies on, and choose the identity services from that
  inventory with the help of the identity architecture guidance.
```

#### What 1 means here

The inventory has one row. Every resource the templates deploy authenticates through Entra ID: the SQL server through its Entra ID
administrator group, the storage account through Entra ID only (shared-key access is off), and the vault through Azure RBAC
([ADR-AZ-WAFSE#5](../waf/security.md#rule-adr-az-wafse5)). The item would apply with the first workload whose users authenticate elsewhere.

##### 1 status

**Not adopted**, because there is one authentication provider and nothing to choose between.

### 2 — Prefer a managed directory for legacy protocols

```text
CAF identity and access — Hybrid identity with Active Directory and Microsoft Entra ID — recommendation 2
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity (retrieved 2026-10-14)
Summary (ours): For applications that need legacy domain protocols, prefer a new Entra Domain Services managed domain with the
  legacy protocols turned off over extending an on-premises domain that keeps them on.
```

#### What 2 means here

No workload speaks Kerberos, NTLM, or LDAP: the storage account and the database are platform services reached with Entra ID tokens through
private endpoints. A managed directory becomes a question with the first workload that needs one.

##### 2 status

**Not adopted**, because no workload uses a legacy directory protocol.

### 3 — Design directory services for resilience

```text
CAF identity and access — Hybrid identity with Active Directory and Microsoft Entra ID — recommendation 3
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity (retrieved 2026-10-14)
Summary (ours): Entra ID is globally redundant, but Domain Services and self-run AD DS are not; design them for resilience,
  considering deployment to more than one region.
```

#### What 3 means here

The only identity service the repository relies on is Entra ID, whose redundancy is Microsoft's. Each environment maps to one region
([ADR-AZ-NETWORK#3](../azure-network-model.md#rule-adr-az-network3)), so a multi-region directory would also need a second region the
network plan does not have.

##### 3 status

**Not adopted**, because the repository runs no directory service of its own.

### 4 — An Active Directory site per Azure region

```text
CAF identity and access — Hybrid identity with Active Directory and Microsoft Entra ID — recommendation 4
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity (retrieved 2026-10-14)
Summary (ours): When extending on-premises AD DS into Azure, define each Azure region as an AD site with subnet objects for its
  address ranges, so clients authenticate against directory servers in their own region.
```

#### What 4 means here

There is no on-premises directory to extend and no on-premises connectivity. Were one added, the subnet objects would come from the ranges
of `automation/Catzc.Azure/configs/network.yml`, the one home of every address ([ADR-AZ-LZ#2](../landing-zones.md#rule-adr-az-lz2)).

##### 4 status

**Not adopted**, because no template extends an on-premises directory into Azure.

### 5 — Guest and partner access

```text
CAF identity and access — Hybrid identity with Active Directory and Microsoft Entra ID — recommendation 5
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity (retrieved 2026-10-14)
Summary (ours): For access by guests, customers, or partners, decide between Entra B2B collaboration and Entra External ID.
```

#### What 5 means here

The example customers (`apex`, `flux`, `nova`) are deployment targets with their own subscriptions, not users who sign in. No workload has
an audience outside the tenant, and inviting guests is a directory operation.

##### 5 status

**Not adopted**, because no workload has users from outside the tenant.

### 6 — No application proxy for intranet access

```text
CAF identity and access — Hybrid identity with Active Directory and Microsoft Entra ID — recommendation 6
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity (retrieved 2026-10-14)
Summary (ours): Do not route internal (intranet) access through Entra application proxy, because it adds latency.
```

#### What 6 means here

No template publishes an application, through application proxy or otherwise; the workload's data services are reached only through private
endpoints ([ADR-AZ-LZ#4](../landing-zones.md#rule-adr-az-lz4)).

##### 6 status

**Not adopted**, because no template publishes an application.

### 7 — Entra Connect staging server for recovery

```text
CAF identity and access — Hybrid identity with Active Directory and Microsoft Entra ID — recommendation 7
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity (retrieved 2026-10-14)
Summary (ours): When Entra Connect is the synchronisation tool, keep a staging server in a second region for recovery, or spread
  it across availability zones when there is only one region.
```

#### What 7 means here

Synchronisation runs between an on-premises directory and the tenant; the repository has neither the directory nor a server to run it on.

##### 7 status

**Not adopted**, because the repository synchronises no on-premises directory.

### 8 — Three Cloud Sync agents across regions

```text
CAF identity and access — Hybrid identity with Active Directory and Microsoft Entra ID — recommendation 8
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity (retrieved 2026-10-14)
Summary (ours): When Entra Cloud Sync is the synchronisation tool, install at least three agents on separate servers spread over
  regions or availability zones.
```

#### What 8 means here

As rule 7: there is no directory to synchronise.

##### 8 status

**Not adopted**, because the repository synchronises no on-premises directory.

### 9 — Choose the synchronisation tool

```text
CAF identity and access — Hybrid identity with Active Directory and Microsoft Entra ID — recommendation 9
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity (retrieved 2026-10-14)
Summary (ours): Pick the synchronisation tool that fits the requirements, Entra Connect or Entra Cloud Sync.
```

#### What 9 means here

As rule 7: there is no directory to synchronise, so there is no tool to choose.

##### 9 status

**Not adopted**, because the repository synchronises no on-premises directory.

### 10 — AD FS deployed by the Azure guide

```text
CAF identity and access — Hybrid identity with Active Directory and Microsoft Entra ID — recommendation 10
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity (retrieved 2026-10-14)
Summary (ours): When AD FS is a requirement, deploy it in Azure by following Microsoft's AD FS deployment guide.
```

#### What 10 means here

Sign-in to Azure, to the SQL server, and to the pipelines' service connections goes through Entra ID directly; nothing federates through AD
FS.

##### 10 status

**Not adopted**, because nothing in the repository federates through AD FS.

### 11 — Password hash sync beside AD FS

```text
CAF identity and access — Hybrid identity with Active Directory and Microsoft Entra ID — recommendation 11
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity (retrieved 2026-10-14)
Summary (ours): When AD FS federates with Entra ID, keep password hash synchronisation as a fallback; Microsoft also advises
  moving off AD FS to Entra ID authentication unless AD FS is truly needed.
```

#### What 11 means here

As rule 10: there is no AD FS, so the end state Microsoft advises, Entra ID authentication alone, is where the repository starts.

##### 11 status

**Not adopted**, because nothing in the repository federates through AD FS.

### 12 — Application proxy for remote access to on-premises applications

```text
CAF identity and access — Hybrid identity with Active Directory and Microsoft Entra ID — recommendation 12
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity (retrieved 2026-10-14)
Summary (ours): Publish web applications that use on-premises authentication to remote users through Entra application proxy,
  with no VPN; it is one instance for the whole tenant, so application owners and the identity team configure it together.
```

#### What 12 means here

There is no on-premises application and no on-premises connectivity, and application proxy is a tenant-wide service that the tenant's
administrators would run.

##### 12 status

**Not adopted**, because there is no on-premises application to publish.

### 13 — Check workload compatibility with the directory services

```text
CAF identity and access — Hybrid identity with Active Directory and Microsoft Entra ID — recommendation 13
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity (retrieved 2026-10-14)
Summary (ours): Check each workload against both AD DS on Windows Server and Entra Domain Services before choosing one.
```

#### What 13 means here

The workload of `expedition` is two platform services that need no directory beyond Entra ID; a compatibility check has nothing to compare.

##### 13 status

**Not adopted**, because no workload depends on a directory service.

### 14 — Directory servers in the identity subscription

```text
CAF identity and access — Hybrid identity with Active Directory and Microsoft Entra ID — recommendation 14
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity (retrieved 2026-10-14)
Summary (ours): Deploy domain controller virtual machines or Domain Services replica sets into the identity platform
  subscription, under the platform management group.
```

#### What 14 means here

The subscriptions of `azure.yml` are a shared pair (non-production, production) and one or two per customer; none is an identity
subscription, because no template deploys an identity resource, and there is no management group to place one under
([ADR-AZ-CAFSEC#28](landing-zone-security.md#rule-adr-az-cafsec28)).

##### 14 status

**Not adopted**, because no template deploys a directory server.

### 15 — Isolate the network of the directory servers

```text
CAF identity and access — Hybrid identity with Active Directory and Microsoft Entra ID — recommendation 15
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity (retrieved 2026-10-14)
Summary (ours): Put the domain controllers in their own subnet behind a network security group, with no direct path to the
  internet, and route to that subnet only from applications that need identity services.
```

#### What 15 means here

`network.yml` plans the hub's `GatewaySubnet`, `AzureFirewallSubnet`, and `shared-services`, and each spoke's `private-endpoints` and
workload subnets; none holds directory servers. Should one be added, the landing zone's pattern applies as it stands: its own subnet in the
plan, its own network security group denying inbound internet traffic ([ADR-AZ-WAFSE#4](../waf/security.md#rule-adr-az-wafse4)).

##### 15 status

**Not adopted**, because `network.yml` plans no directory subnet and no template deploys one.

### 16 — Virtual Network Manager rules for directory access

```text
CAF identity and access — Hybrid identity with Active Directory and Microsoft Entra ID — recommendation 16
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity (retrieved 2026-10-14)
Summary (ours): Use Azure Virtual Network Manager network groups, filled by policy or by tags, so that only the virtual networks
  that need AD services can reach the domain controller subnet.
```

#### What 16 means here

There is no directory subnet to reach. The repository declares peering statically in configs rather than through Virtual Network Manager
([ADR-AZ-LZ#2](../landing-zones.md#rule-adr-az-lz2)).

##### 16 status

**Not adopted**, because there is no directory subnet to reach.

### 17 — Restrict control-plane roles over directory servers

```text
CAF identity and access — Hybrid identity with Active Directory and Microsoft Entra ID — recommendation 17
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity (retrieved 2026-10-14)
Summary (ours): Control-plane roles such as Contributor or Virtual Machine Contributor can run commands on domain controllers;
  limit who holds them in the identity subscription and keep broad roles from being inherited from above.
```

#### What 17 means here

No template deploys a directory server or a virtual machine. The general point, that a control-plane role over a machine reaches inside it,
returns with the first template that deploys one.

##### 17 status

**Not adopted**, because there are no directory servers to protect.

### 18 — Arc-managed directory servers in the identity subscription

```text
CAF identity and access — Hybrid identity with Active Directory and Microsoft Entra ID — recommendation 18
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity (retrieved 2026-10-14)
Summary (ours): When Azure Arc manages on-premises domain controllers or identity servers, keep their Arc resources in the
  identity subscription under the same strict access.
```

#### What 18 means here

The repository manages no server outside Azure, through Arc or otherwise.

##### 18 status

**Not adopted**, because the repository manages no server outside Azure.

### 19 — Keep core applications near the replica sets

```text
CAF identity and access — Hybrid identity with Active Directory and Microsoft Entra ID — recommendation 19
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity (retrieved 2026-10-14)
Summary (ours): Keep core applications in or near the region of the Domain Services replica sets; deploy Domain Services in the
  core platform's region and extend it with up to four more replica sets in peered virtual networks of one subscription.
```

#### What 19 means here

No template deploys a managed directory, so there is no replica set to place applications near.

##### 19 status

**Not adopted**, because no template deploys a managed directory.

### 20 — Directory servers across regions and availability zones

```text
CAF identity and access — Hybrid identity with Active Directory and Microsoft Entra ID — recommendation 20
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity (retrieved 2026-10-14)
Summary (ours): Spread AD DS domain controllers over several regions and availability zones, or availability sets, for resilience.
```

#### What 20 means here

No directory server exists to spread. The workload's own resilience comes from zone-redundant storage and, in production, a zone-redundant
database ([ADR-AZ-LZ#5](../landing-zones.md#rule-adr-az-lz5)).

##### 20 status

**Not adopted**, because no template deploys a directory server.

### 21 — Evaluate the Entra authentication methods

```text
CAF identity and access — Hybrid identity with Active Directory and Microsoft Entra ID — recommendation 21
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity (retrieved 2026-10-14)
Summary (ours): Weigh the Entra ID authentication methods (cloud only, hybrid, or on-premises) as part of identity planning.
```

#### What 21 means here

How users authenticate to the tenant is the tenant's choice. The repository uses whatever it decides: a person signs in with `az login`, a
pipeline through its service connection, and both are verified against `azure.yml`
([ADR-AZ-SESSION#4](../az-session-verification.md#rule-adr-az-session4)).

##### 21 status

**Not adopted**, because the authentication methods are a setting of the tenant.

### 22 — Entra Kerberos for Azure Files

```text
CAF identity and access — Hybrid identity with Active Directory and Microsoft Entra ID — recommendation 22
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity (retrieved 2026-10-14)
Summary (ours): For Kerberos access to Azure Files, use Entra Kerberos rather than deploying domain controllers in the cloud.
```

#### What 22 means here

`storage-account.bicep` deploys blob storage, reached through the `blob` private endpoint; no template creates a file share. A file share
added later would follow this item, since there are no directory servers to authenticate against.

##### 22 status

**Not adopted**, because no template deploys a file share.

### 23 — Multi-factor authentication for everyone with Azure rights

```text
CAF identity and access — Landing zone identity and access management — recommendation 23
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (retrieved 2026-10-14)
Summary (ours): Require Entra multi-factor authentication from every user with any rights in Azure, the platform, application
  subscriptions, and the tenant alike, including readers; prefer phishing-resistant methods over SMS, email, or push.
```

#### What 23 means here

Multi-factor authentication is enforced at sign-in by the tenant's Conditional Access, not by a resource in a subscription. The repository's
sign-in paths respect it: `Connect-AzCli` signs a person in interactively or by device code, so the tenant's prompt applies, and the
verification functions check where a session points, not how it signed in
([ADR-AZ-SESSION#2](../az-session-verification.md#rule-adr-az-session2)).

##### 23 status

**Not adopted** as a repository rule, because the tenant enforces it at sign-in.

### 24 — Conditional Access for Azure users

```text
CAF identity and access — Landing zone identity and access management — recommendation 24
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (retrieved 2026-10-14)
Summary (ours): Apply Entra Conditional Access to Azure users, with stricter policies for administrators, for example on
  location, trusted workstations, and sign-in risk.
```

#### What 24 means here

Conditional Access policies are objects of the tenant's directory; no template can deploy one at subscription scope.

##### 24 status

**Not adopted**, because Conditional Access is a policy of the tenant.

### 25 — Defender for Identity

```text
CAF identity and access — Landing zone identity and access management — recommendation 25
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (retrieved 2026-10-14)
Summary (ours): Turn on Microsoft Defender for Identity with sensors on the domain controllers, on-premises and in Azure, and
  combine it with Conditional Access to block risky sign-ins.
```

#### What 25 means here

Its sensors watch directory servers, and there are none. The subscription-level Defender for Cloud plans that do bear on the templates are
planned by [ADR-AZ-CAFSEC#3](landing-zone-security.md#rule-adr-az-cafsec3).

##### 25 status

**Not adopted**, because there are no directory servers for its sensors.

### 26 — Sentinel for identity threats

```text
CAF identity and access — Landing zone identity and access management — recommendation 26
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (retrieved 2026-10-14)
Summary (ours): Use Microsoft Sentinel over Azure Monitor, Entra ID, and Microsoft 365 logs for threat detection and response.
```

#### What 26 means here

The choice of a security information and event management tool belongs to the tenant's security operations
([ADR-AZ-CAFSEC#43](landing-zone-security.md#rule-adr-az-cafsec43)); `foundation`'s workspace in each subscription is where Sentinel would
attach.

##### 26 status

**Not adopted**, for the reason of ADR-AZ-CAFSEC#43.

### 27 — Separate administrative from everyday accounts

```text
CAF identity and access — Landing zone identity and access management — recommendation 27
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (retrieved 2026-10-14)
Summary (ours): Keep administration off everyday accounts: separate cloud-only accounts for highly privileged roles, and
  just-in-time elevation through PIM or separate accounts for lesser management roles.
```

#### What 27 means here

Accounts live in the tenant's directory. The repository never names a user: its principals are groups and roles (rule 28), so whichever
accounts the tenant uses for administration reach the resources through group membership.

##### 27 status

**Not adopted**, because accounts are objects of the tenant's directory.

### 28 — Assign roles to groups, not to users

```text
CAF identity and access — Landing zone identity and access management — recommendation 28
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (retrieved 2026-10-14)
Summary (ours): Do not assign roles to users directly, since a subscription has a limit on assignments; assign them to groups,
  manage membership through PIM for groups and entitlement management, and use cloud-only groups for control-plane access so
  that a change in an on-premises directory cannot grant it.
```

#### What 28 means here

The templates name a principal in two places, and neither is a user. `sql-server.bicep` makes an Entra ID principal the server's
administrator with `entraAdminPrincipalType` defaulting to `Group` ([ADR-AZ-LZ#6](../landing-zones.md#rule-adr-az-lz6)), and every
`expedition` config names the group `zct-exped-sql-admins` with a placeholder object id registered in the managed-GUID registry as
`entra_sql_admin_group` ([ADR-AUTO-GUIDS#1](../../automation/managed-guids.md#rule-adr-auto-guids1)). `budget.bicep` sends its alerts to the
holders of a role (`contactRoles`, `Owner` by default), so no address or person is kept in a config.

No template makes an Azure role assignment for a person ([ADR-AZ-WAFSE#5](../waf/security.md#rule-adr-az-wafse5)). The groups are created in
the tenant's directory, which is cloud-only as far as the repository knows: there is no on-premises directory to synchronise from.

##### 28 in `foundation`

Makes no role assignment; who may read the vault is decided outside the repository.

##### 28 in `discovery`

The budget alerts go to the subscription's `Owner` role. The landing zone should carry the standard role assignments of rule 36, each to a
group.

##### 28 in `expedition`

The SQL administrator is the group `zct-exped-sql-admins`. The data roles of its consumers should go to groups, at the narrowest resource
(rule 37).

##### 28 status

**Partly realised.** Every principal the templates name is a group or a role, but role assignments are made outside the repository and are
planned (follow-up) as code, to groups.

### 29 — Emergency-access accounts

```text
CAF identity and access — Landing zone identity and access management — recommendation 29
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (retrieved 2026-10-14)
Summary (ours): Keep a small number of highly privileged emergency-access (break-glass) accounts, assigned to named people,
  with their credentials stored safely, their use monitored, and their working regularly tested.
```

#### What 29 means here

CAF means tenant accounts that survive a broken sign-in policy; those are the tenant's. The repository applies the same idea at the level it
owns, the SQL server: beside the Entra ID administrator group sits one break-glass SQL login, `exped-break-glass`, so the server stays
reachable when the directory or the group is not ([ADR-AZ-LZ#6](../landing-zones.md#rule-adr-az-lz6)). Its password is stored safely: it is
the secret `exped-sql-admin-password` in `foundation`'s vault, resolved by Azure Resource Manager at deploy time, so the repository never
holds it ([ADR-AZ-WAFSE#9](../waf/security.md#rule-adr-az-wafse9)).

Its use is not monitored: no SQL audit log is sent to the workspace ([ADR-AZ-WAFSE#10](../waf/security.md#rule-adr-az-wafse10)), and the
vault's reads are not logged ([ADR-AZ-CAFSEC#22](landing-zone-security.md#rule-adr-az-cafsec22)). Nothing tests that the login works.

##### 29 in `foundation`

Holds the password in the subscription's vault, with `enabledForTemplateDeployment: true` so a deploy can resolve the reference. Its vault
diagnostics are planned (ADR-AZ-CAFSEC#22), so that each read of the secret is logged.

##### 29 in `discovery`

Not applicable: the landing zone has no login of its own.

##### 29 in `expedition`

Sets `entraOnlyAuthentication: false` to keep the login, with `administratorLogin: exped-break-glass` and the password as a Key Vault
reference. The SQL server should send its audit log to the workspace, so that a sign-in with the login can be found and alerted on.

##### 29 status

**Partly realised.** The break-glass login exists and its credential is in a vault, but its use is not monitored and its working is not
tested; tenant emergency-access accounts are not adopted, because they belong to the tenant.

### 30 — Entra logs in Azure Monitor

```text
CAF identity and access — Landing zone identity and access management — recommendation 30
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (retrieved 2026-10-14)
Summary (ours): Send the Entra ID sign-in and audit logs, through a diagnostic setting, to the central Log Analytics workspace in
  the management subscription.
```

#### What 30 means here

An Entra ID diagnostic setting is a tenant-level resource, which no service connection of the repository may deploy
([ADR-AZ-LZ#1](../landing-zones.md#rule-adr-az-lz1)), and there is no central workspace: each subscription has its own in `foundation`
([ADR-AZ-CAFSEC#7](landing-zone-security.md#rule-adr-az-cafsec7)). The tenant's administrators choose where the directory's logs go.

##### 30 status

**Not adopted**, because a tenant diagnostic setting needs rights above any subscription.

### 31 — Access packages for group membership

```text
CAF identity and access — Landing zone identity and access management — recommendation 31
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (retrieved 2026-10-14)
Summary (ours): Control group membership through access packages of Entra ID Governance entitlement management, with approval
  flows and periodic reviews of privileged members.
```

#### What 31 means here

The repository names groups (rule 28) but does not manage their members; membership is the tenant's process.

##### 31 status

**Not adopted**, because group membership is managed in the tenant's directory.

### 32 — Entra built-in roles for identity settings

```text
CAF identity and access — Landing zone identity and access management — recommendation 32
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (retrieved 2026-10-14)
Summary (ours): Manage the tenant's identity settings with the matching Entra built-in roles, such as Global Administrator
  (held by no more than five people), Hybrid Identity Administrator, Security Administrator, and Application Administrator;
  the page's table maps settings to roles.
```

#### What 32 means here

Directory roles govern the tenant, which the repository does not administer; none of its identities needs one.

##### 32 status

**Not adopted**, because directory roles belong to the tenant's administrators.

### 33 — The least-privileged Entra role

```text
CAF identity and access — Landing zone identity and access management — recommendation 33
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (retrieved 2026-10-14)
Summary (ours): Do not use a more privileged Entra role for a task a less privileged one can do, for example User Administrator
  rather than Global Administrator for managing users.
```

#### What 33 means here

The repository grants no directory role. The same principle for Azure roles is rule 39.

##### 33 status

**Not adopted**, because the repository grants no directory role.

### 34 — Administrative units

```text
CAF identity and access — Landing zone identity and access management — recommendation 34
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (retrieved 2026-10-14)
Summary (ours): Restrict administrators to a part of the directory with administrative units, which also separates Microsoft
  365 administration from Azure administration without a second tenant.
```

#### What 34 means here

Administrative units divide the tenant's directory, which the repository does not manage.

##### 34 status

**Not adopted**, because the repository does not manage the directory.

### 35 — Restricted management administrative units

```text
CAF identity and access — Landing zone identity and access management — recommendation 35
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (retrieved 2026-10-14)
Summary (ours): Protect sensitive directory objects, such as service accounts and privileged groups, with restricted management
  administrative units, so only designated administrators can change them and privileges cannot be escalated through them.
```

#### What 35 means here

As rule 34. The groups the repository depends on, the SQL administrator group above all, are the kind of object this protects; protecting
them is the tenant's decision.

##### 35 status

**Not adopted**, for the reason of rule 34.

### 36 — Standard roles in every landing zone

```text
CAF identity and access — Landing zone identity and access management — recommendation 36
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (retrieved 2026-10-14)
Summary (ours): Use the same roles and the same assignment patterns in every workload landing zone, which simplifies
  administration and lowers the risk of misconfiguration.
```

#### What 36 means here

Standardisation is the landing zone's premise: every subscription gets the same landing zone from one template
([ADR-AZ-LZ#1](../landing-zones.md#rule-adr-az-lz1)), so one change reaches all of them. But the landing zone assigns no role, so the
standard role set is empty, and who holds what in each subscription is decided by hand outside the repository
([ADR-AZ-WAFSE#5](../waf/security.md#rule-adr-az-wafse5)).

The standard set belongs in `discovery`: each role assignment a resource of the template, the role definitions declared once with their
sensible default, and the groups per subscription in its config ([ADR-AZ-DATAMOD#11](../azure-data-model.md#rule-adr-az-datamod11) gives the
pattern, as `policy_enforcement` does for the policies).

##### 36 in `foundation`

Not applicable: the subscription-wide roles belong to the landing zone; the vault's data roles are rule 63.

##### 36 in `discovery`

Assigns no role. It should deploy the standard role assignments at subscription scope, the same set for every landing zone, each to the
group its config names.

##### 36 in `expedition`

Not applicable: a workload owns no landing-zone setting ([ADR-AZ-LZ#4](../landing-zones.md#rule-adr-az-lz4)); its resource-level data roles
are rule 37.

##### 36 status

**Planned (follow-up).** Every landing zone is the same, but no role is part of it; `discovery` gains the standard role set.

### 37 — Azure RBAC for the data plane

```text
CAF identity and access — Landing zone identity and access management — recommendation 37
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (retrieved 2026-10-14)
Summary (ours): Use Azure RBAC for access to data as well, for example in Key Vault, storage, and databases, and keep data-plane
  rights separate from control-plane rights.
```

#### What 37 means here

The authorization model is in place. `key-vault.bicep` fixes `enableRbacAuthorization: true` with no access policies
([ADR-AZ-CAFSEC#16](landing-zone-security.md#rule-adr-az-cafsec16)), so a control-plane role such as Contributor does not read a secret; a
data role does. `storage-account.bicep` turns shared-key access off, so every data request carries an Entra ID token and is authorized by an
Azure RBAC data role. SQL has no Azure RBAC data plane: access inside the database goes to Entra ID principals, and the server's
administrator is a group ([ADR-AZ-LZ#6](../landing-zones.md#rule-adr-az-lz6)).

What is missing is the roles: no template grants a Key Vault, storage, or SQL data role
([ADR-AZ-WAFSE#5](../waf/security.md#rule-adr-az-wafse5)).

##### 37 in `foundation`

The vault is RBAC-authorized. The data role that lets a deploy resolve the break-glass reference, and the roles of the vault's readers, are
granted outside the repository.

##### 37 in `discovery`

Not applicable: the landing zone holds no data.

##### 37 in `expedition`

The storage account refuses shared keys and the SQL server's administrator is a group. It should grant the storage data roles its consumers
need, to groups or managed identities, on the storage account itself.

##### 37 status

**Partly realised.** Key Vault and storage authorize data access through Azure RBAC alone, but no data role is granted in code; the data
roles are planned (follow-up).

### 38 — The permission model of the log workspaces

```text
CAF identity and access — Landing zone identity and access management — recommendation 38
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (retrieved 2026-10-14)
Summary (ours): Give a shared central Log Analytics workspace the resource-context permission model, so each team reads only the
  logs of the resources it has rights to.
```

#### What 38 means here

There is no central workspace. `foundation` deploys one per subscription, so a customer's logs never share a workspace with another
customer's ([ADR-AZ-CAFSEC#7](landing-zone-security.md#rule-adr-az-cafsec7)). Within a subscription the workspace is shared: in the shared
non-production subscription, the landing zone and the `dev` and `test` slots of `expedition` all send their diagnostics to the same
workspace.

`log-analytics.bicep` sets the name, the SKU, the retention, and the tags, and leaves the access-control mode to the platform's default. A
secure default that pins resource-context access (`enableLogAccessUsingOnlyResourcePermissions`) would make the mode a decision of the
module, like the other secure defaults ([ADR-AZ-WAFSE#8](../waf/security.md#rule-adr-az-wafse8)).

##### 38 in `foundation`

Deploys the workspace with the module's settings. The module should pin resource-context access, so a reader of one workload's resource
group reads only that workload's logs.

##### 38 in `discovery`

Sends the activity log and the network diagnostics to the subscription's workspace; nothing to change.

##### 38 in `expedition`

Sends its diagnostics to the subscription's workspace; nothing to change.

##### 38 status

**Partly realised.** Customers' logs are apart by subscription, but the access-control mode inside a workspace is not pinned; a module
default is planned (follow-up).

### 39 — Built-in roles first, custom roles when needed

```text
CAF identity and access — Landing zone identity and access management — recommendation 39
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (retrieved 2026-10-14)
Summary (ours): Check whether built-in roles meet the requirement, combining several where they fit, and define a custom role
  only where the built-in ones would grant more than least privilege allows.
```

#### What 39 means here

The one place a module grants a role is `policy-assignment.bicep`, which takes role definition ids and assigns them to a remediating
policy's identity (rule 51); none of the landing zone's policies uses it. No custom role definition exists anywhere in the templates, which
matches the landing zone's preference for built-in policy definitions over custom ones
([ADR-AZ-CAFGOV#6](governance.md#rule-adr-az-cafgov6)): Microsoft maintains their meaning.

The planned role assignments (rule 36) start from built-in roles; a custom role is defined only when a built-in one grants too much, and it
is then a resource of the template that uses it.

##### 39 in `foundation`

Not applicable: it grants no role.

##### 39 in `discovery`

Passes no role definition to the policy module. Its planned standard role set should name built-in roles by their definition ids, registered
in the managed-GUID registry like the policy definition ids.

##### 39 in `expedition`

Its planned data roles should be the built-in data roles of storage.

##### 39 status

**Planned (follow-up).** No custom role is defined, and the role assignments planned by rule 36 start from built-in roles.

### 40 — The combined effect of stacked assignments

```text
CAF identity and access — Landing zone identity and access management — recommendation 40
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (retrieved 2026-10-14)
Summary (ours): Many built-in roles overlap, so when a principal holds several assignments, check what they grant together.
```

#### What 40 means here

There is nothing to stack while no role is assigned. Once the standard role set of rule 36 exists, it is declared in one place, so its
combined effect is reviewed in one change.

##### 40 status

**Planned (follow-up)**, with the standard role set of rule 36.

### 41 — Track new role definitions

```text
CAF identity and access — Landing zone identity and access management — recommendation 41
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (retrieved 2026-10-14)
Summary (ours): Watch Microsoft's announcements of new role definitions, because a new role may fit a need better than an
  existing one.
```

#### What 41 means here

The repository keeps no watch process of its own; each CAF and WAF record carries its retrieval date and is revisited when the vendor
guidance changes ([ADR-AZ-CAFSEC#13](landing-zone-security.md#rule-adr-az-cafsec13)).

##### 41 status

**Not adopted** as a process of its own, for the reason of ADR-AZ-CAFSEC#13.

### 42 — The custom roles of the reference architecture

```text
CAF identity and access — Landing zone identity and access management — recommendation 42
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (retrieved 2026-10-14)
Summary (ours): The CAF reference landing zone defines custom roles beside the built-in ones, for the platform owner, the
  subscription owner, the application owner, network operations, and security operations, each with its permitted and denied
  actions in the page's table; extend them to match the organisation's split of responsibilities.
```

#### What 42 means here

Those roles are defined at a management group and serve a platform team that owns the hierarchy. The repository owns no management group
([ADR-AZ-LZ#1](../landing-zones.md#rule-adr-az-lz1)) and defines no custom role (rule 39).

##### 42 status

**Not adopted**, because the repository defines no custom role and owns no management group.

### 43 — Landing zone provisioning creates groups, assignments, and identities

```text
CAF identity and access — Landing zone identity and access management — recommendation 43
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (retrieved 2026-10-14)
Summary (ours): When the platform team provisions a workload landing zone, the provisioning creates the security groups, the
  standard role assignments, and the user-assigned managed identities the workload needs.
```

#### What 43 means here

`discovery` is the provisioning: one config per subscription deploys the landing zone ([ADR-AZ-LZ#1](../landing-zones.md#rule-adr-az-lz1)).
It creates none of the three things this item lists.

- **Role assignments** are planned as the standard role set of rule 36.
- **Security groups** are directory objects. Creating them would need rights in the tenant's directory, which the service connections do not
  have and the landing zone does not assume. The groups are created by the tenant's administrators, and their object ids enter the configs
  as registered GUIDs (rule 28).
- **User-assigned managed identities** are not needed: the workload's services carry system-assigned identities, which live and die with
  their resource (rule 60).

##### 43 in `foundation`

Not applicable: it provisions the subscription's workspace and vault, not identities.

##### 43 in `discovery`

Creates the network, the policies, and the budget. It should also create the standard role assignments of rule 36, to groups that exist in
the directory beforehand.

##### 43 in `expedition`

Not applicable: a workload is what lands in the provisioned landing zone.

##### 43 status

**Planned (follow-up)** for the role assignments; creating groups is not adopted, because groups are objects of the tenant's directory, and
user-assigned identities are not adopted, because system-assigned ones serve the workload.

### 44 — Role assignments at subscription or resource group level

```text
CAF identity and access — Landing zone identity and access management — recommendation 44
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (retrieved 2026-10-14)
Summary (ours): Make landing-zone role assignments at a subscription or a resource group, below the management groups where the
  policies are assigned, so that landing-zone owners act on their own but cannot change the policies that govern them.
```

#### What 44 means here

The planned assignments fall where this item puts them: the standard set of rule 36 at subscription scope in `discovery`, and the data roles
of rule 37 on the resources of `expedition`. None goes above a subscription, because the repository owns nothing there.

The item's second half does not hold here. The landing zone's policies are assigned at the subscription too
([ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3)), so an `Owner` of the subscription can change them. The safeguard is that the
assignments are code: a changed policy differs from its template and is set back at the next deploy. A role that may change policy belongs
to the deploying identity and the subscription's owners only, never to a workload team (rule 49).

##### 44 in `foundation`

Not applicable: it makes no role assignment.

##### 44 in `discovery`

Should assign the standard roles at subscription scope.

##### 44 in `expedition`

Should assign its data roles on its storage account, inside its own resource group.

##### 44 status

**Planned (follow-up).** The assignments are planned at subscription and resource level; the separation from policy that management groups
give is not adopted, because the repository owns none.

### 45 — Groups and assignments per landing zone

```text
CAF identity and access — Landing zone identity and access management — recommendation 45
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (retrieved 2026-10-14)
Summary (ours): Give each workload landing zone its own groups and role assignments rather than generic groups shared across
  landing zones; people who need access to several get it through Entra ID Governance.
```

#### What 45 means here

The one group the templates name is shared by every landing zone. All six `expedition` configs, for `apex`, `nova`, and the shared platform,
production and non-production alike, set `entraAdminLogin: zct-exped-sql-admins` and the same placeholder object id
(`entra_sql_admin_group`). A member of that group administers every customer's SQL server in every environment.

The group is a config value, so splitting it needs no template change: each config names the group of its customer and environment, each
with its own registered object id.

##### 45 in `foundation`

Not applicable: it names no group.

##### 45 in `discovery`

Names no group. The groups of the planned standard role set (rule 36) should be per subscription, in each landing zone's config.

##### 45 in `expedition`

Every config names `zct-exped-sql-admins`. Each should name a group of its own customer and environment, for example one for `apex`
production and another for `apex` development.

##### 45 status

**Planned (follow-up).** The SQL administrator group is one for all landing zones; a group per customer and environment in each `expedition`
config is the change.

### 46 — Groups, not users, as role holders

```text
CAF identity and access — Landing zone identity and access management — recommendation 46
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (retrieved 2026-10-14)
Summary (ours): Assign roles to groups rather than users, so that access stays right as people join, move, and leave, and manage
  membership through Entra ID Governance rather than by hand.
```

#### What 46 means here

This repeats rule 28, which decides it: every principal the templates name is a group or a role, and membership is the tenant's process
(rule 31).

##### 46 in `foundation`

As rule 28.

##### 46 in `discovery`

As rule 28.

##### 46 in `expedition`

As rule 28.

##### 46 status

**Partly realised**, as rule 28.

### 47 — Separate security configuration per environment

```text
CAF identity and access — Landing zone identity and access management — recommendation 47
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (retrieved 2026-10-14)
Summary (ours): Treat each environment of an application (development, test, production) as its own landing zone, with its own
  groups and role assignments, and never share a managed identity or service principal between environments.
```

#### What 47 means here

The separation follows the tier, not the environment. Each customer has a non-production and a production subscription, and each
subscription has its own service connection (`sc-apex-nonprod`, `sc-apex-prod`, `sc-shared-nonprod`, …), its own vault, and its own
workspace ([ADR-AZ-WAFSE#4](../waf/security.md#rule-adr-az-wafse4)). Production shares no subscription, service connection, vault, or
workspace with non-production.

Within a tier, the environments share. In the shared non-production subscription, the `dev` and `test` slots of `expedition` deploy through
the one service connection `sc-shared-nonprod`, read the same break-glass secret from the same vault
([ADR-AZ-CAFSEC#26](landing-zone-security.md#rule-adr-az-cafsec26)), and name the same SQL administrator group (rule 45). Managed identities
are the exception: each is system-assigned to one resource of one configuration slot, so none is shared (rule 61).

The DevOps security considerations advise one deploying identity per application and environment. Here that would be one service connection
per environment, each with rights on its environment's resource group, rather than per subscription.

##### 47 in `foundation`

One vault per subscription, so per tier. Its secrets are separated per environment by name (rule 64).

##### 47 in `discovery`

One landing zone per subscription, so per tier; the environments of a tier land in the same spoke by design
([ADR-AZ-LZ#4](../landing-zones.md#rule-adr-az-lz4)).

##### 47 in `expedition`

Each configuration slot has its own resource group and its own managed identities. Its SQL administrator group and its break-glass secret
should be per environment (rules 45 and 64), and its deploying identity per environment as the pipelines allow.

##### 47 status

**Partly realised.** Production and non-production share no service connection, vault, or workspace, but the environments of one tier share
a service connection and a secret, and every environment shares the SQL administrator group; per-environment groups and secrets are planned
(follow-up), and a service connection per environment is a decision for the user.

### 48 — Just-in-time platform access to workload landing zones

```text
CAF identity and access — Landing zone identity and access management — recommendation 48
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (retrieved 2026-10-14)
Summary (ours): Decide whether platform administrators need rights on workload landing zones; where they do, grant them just in
  time through PIM, with approval and least privilege, never as standing access.
```

#### What 48 means here

Eligibility and activation are settings of Privileged Identity Management in the tenant
([ADR-AZ-CAFSEC#37](landing-zone-security.md#rule-adr-az-cafsec37)). The repository's platform access is its deploying identity, one service
connection per subscription (rule 54), not a person.

##### 48 status

**Not adopted**, because Privileged Identity Management is a tenant setting.

### 49 — Constrain delegated role assignment with conditions

```text
CAF identity and access — Landing zone identity and access management — recommendation 49
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (retrieved 2026-10-14)
Summary (ours): When delegating the right to assign roles, for example User Access Administrator or Role Based Access Control
  Administrator to a workload team, delegate only what is needed and constrain it with conditions on which roles and which
  principal types may be assigned; keep Owner, User Access Administrator, and RBAC Administrator themselves out of delegation,
  review existing privileged assignments for conditions, and know the documented limits of conditions.
```

#### What 49 means here

The repository delegates no right to a workload team. The one identity that will need to assign roles is the deploying one: once the
standard role set (rule 36) and the data roles (rule 37) are code, each service connection needs the right to write role assignments in its
subscription. The least privilege for that is Role Based Access Control Administrator with a condition limiting it to the role definitions
the templates declare, rather than Owner or User Access Administrator. The condition is set on the service connection's own assignment,
which the tenant's administrators make.

##### 49 in `foundation`

Not applicable: it assigns no role.

##### 49 in `discovery`

Will assign the standard roles; its service connection's right to do so should be conditioned on that list.

##### 49 in `expedition`

Will assign its data roles; the same condition should list them.

##### 49 status

**Planned (follow-up)**, with the role assignments as code; the condition itself is set by the tenant's administrators on the service
connection.

### 50 — An example role assignment structure

```text
CAF identity and access — Landing zone identity and access management — recommendation 50
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (retrieved 2026-10-14)
Summary (ours): The page's table shows an example structure: per application and environment, groups for owners, security
  administrators, data administrators, and testers on that application's subscriptions; an Owner group for sandboxes; a PIM
  group for platform Contributor; and tenant-wide groups for security operations, Conditional Access administrators, network
  operations, and FinOps (Billing Reader). Adapt it, but always assign to a specific group in a specific landing zone.
```

#### What 50 means here

The table is an example, not a recommendation to copy. Its principle, a specific group in a specific landing zone, is rules 45 and 47; its
tenant-wide groups belong to the tenant's administrators.

##### 50 status

**Planned (follow-up)** through rules 45 and 47; the table itself is not adopted.

### 51 — Remediation identities of deploy-if-not-exists policies

```text
CAF identity and access — Landing zone identity and access management — recommendation 51
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (retrieved 2026-10-14)
Summary (ours): A policy assignment with a deploy-if-not-exists effect needs a managed identity: a system-assigned one receives
  its rights automatically, a user-assigned one needs them granted by hand. Grant least privilege, directly to the identity
  rather than through a group, and use built-in roles only.
```

#### What 51 means here

`policy-assignment.bicep` follows the item. With `assignIdentity` set, the assignment gets a system-assigned identity, and each role
definition id in `roleDefinitionIds` is granted directly to that identity's principal (`principalType: 'ServicePrincipal'`) on the
subscription, not through a group. The roles are those the caller lists, so least privilege is the caller's choice; built-in roles are the
practice (rule 39).

No landing-zone policy uses it: the three built-in policies deny or audit, and the activity log streams through a diagnostic setting rather
than a deploy-if-not-exists policy ([ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3)).

##### 51 in `foundation`

Not applicable: it assigns no policy.

##### 51 in `discovery`

Assigns its three policies without `assignIdentity`, so no remediation identity exists.

##### 51 in `expedition`

Not applicable: a workload assigns no policy ([ADR-AZ-LZ#4](../landing-zones.md#rule-adr-az-lz4)).

##### 51 status

**Realised.** The module grants a remediation identity its listed roles directly; no landing-zone policy needs one.

### 52 — Privileged Identity Management for least privilege

```text
CAF identity and access — Landing zone identity and access management — recommendation 52
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (retrieved 2026-10-14)
Summary (ours): Use Entra Privileged Identity Management so that each role holds only the minimum access it needs, in line with
  Zero Trust and least privilege.
```

#### What 52 means here

Privileged Identity Management is a tenant setting, not a resource a template deploys
([ADR-AZ-CAFSEC#37](landing-zone-security.md#rule-adr-az-cafsec37)).

##### 52 status

**Not adopted**, for the reason of ADR-AZ-CAFSEC#37.

### 53 — Access reviews in Privileged Identity Management

```text
CAF identity and access — Landing zone identity and access management — recommendation 53
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (retrieved 2026-10-14)
Summary (ours): Run recurring access reviews of resource entitlements through Privileged Identity Management.
```

#### What 53 means here

Reviews are a process of the tenant over its role holders. What the repository grants is reviewable in code: every principal it names is in
a config, and every planned role assignment will be a resource of a template.

##### 53 status

**Not adopted**, because access reviews are a tenant process.

### 54 — Govern privileged automation like privileged people

```text
CAF identity and access — Landing zone identity and access management — recommendation 54
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (retrieved 2026-10-14)
Summary (ours): Give privileged automation, such as runbooks and deployment pipelines, the same governance as privileged
  people, and make sure a workload's pipeline cannot be used to raise the privileges of the team that owns it.
```

#### What 54 means here

The repository's privileged automation is its CD pipelines. Each deploy runs through the step template
`pipelines/steps/invoke-automation.yaml` in `azcli` mode, signed in by the service connection of its subscription, and pins its target with
`-SubscriptionIdAssertIs`, which `Deploy-Bicep` requires in a pipeline ([ADR-AZ-DATAMOD#7](../azure-data-model.md#rule-adr-az-datamod7),
[ADR-AZ-SESSION#5](../az-session-verification.md#rule-adr-az-session5)). A mis-wired service connection therefore fails before it changes
anything. Every deploy job is bound to an Azure DevOps environment (`shared-psub`, `apex-prod`, …), where approvals and checks can be
attached. The infrastructure CI needs no Azure identity at all: `ci-infrastructure.yaml` builds offline with `Mode: none`. Credentials never
reach an environment variable in any mode ([ADR-FLOW-CD-RUNNER#3](../../flow/pipeline-runner-pattern.md#rule-adr-flow-cd-runner3)).

Two gaps remain. One service connection per subscription deploys `foundation`, `discovery`, and `expedition` alike, so a workload deploy
runs with the rights the landing zone needs, to assign policies and, once rule 36 lands, roles. And the preview of a change,
`Deploy-Bicep -DryRun` (an Azure what-if), has no identity of its own: it runs as whatever the session signed in with, in a pipeline the
same service connection that deploys, where the DevOps security considerations advise a read-only one.

##### 54 in `foundation`

Deployed by the subscription's service connection; needs rights to create a vault and a workspace in its resource group.

##### 54 in `discovery`

Deployed by the same service connection; needs subscription-wide rights for policies, the budget, and the activity-log setting. This is the
identity that should stay with the landing zone.

##### 54 in `expedition`

Deployed by the same service connection as the landing zone. It should deploy through an identity of its own, with rights on its resource
group and the network join it needs, so a change to the workload cannot change the landing zone's policies or roles.

##### 54 status

**Partly realised.** Every deploy is pinned to its subscription and the infrastructure CI holds no Azure identity, but the workload deploys
with the landing zone's identity and the what-if preview has no read-only identity; both splits are planned (follow-up).

### 55 — Owner and User Access Administrator behind PIM for groups

```text
CAF identity and access — Landing zone identity and access management — recommendation 55
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (retrieved 2026-10-14)
Summary (ours): Put highly privileged roles such as Owner and User Access Administrator on subscriptions and management groups
  behind PIM for groups, for example a standing least-privileged administrators group and an eligible owners group that is
  activated on demand.
```

#### What 55 means here

Group eligibility is a setting of Privileged Identity Management in the tenant
([ADR-AZ-CAFSEC#37](landing-zone-security.md#rule-adr-az-cafsec37)). The planned standard role set (rule 36) would name such groups once
they exist.

##### 55 status

**Not adopted**, because role eligibility is a tenant setting.

### 56 — Protected actions

```text
CAF identity and access — Landing zone identity and access management — recommendation 56
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (retrieved 2026-10-14)
Summary (ours): Attach Conditional Access requirements, such as phishing-resistant multi-factor authentication, to sensitive
  permissions through protected actions.
```

#### What 56 means here

Protected actions are configured on the tenant's directory permissions, with Conditional Access (rule 24).

##### 56 status

**Not adopted**, because protected actions are a tenant setting.

### 57 — OpenID Connect for pipelines

```text
CAF identity and access — Application identity and access management — recommendation 57
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-application-access (retrieved 2026-10-14)
Summary (ours): CI/CD pipelines, in GitHub or Azure DevOps, should sign in to Azure with OpenID Connect workload identity
  federation, which issues short-lived tokens and needs no stored secret; only where it is not supported, fall back to a service
  principal with a credential.
```

#### What 57 means here

The pipelines name their service connections (`sc-apex-nonprod`, `sc-shared-prod`, `sc-azure-test`, …) and hand them to `AzureCLI@2` or
`AzurePowerShell@5` in `pipelines/steps/invoke-automation.yaml`. How a service connection signs in, by workload identity federation or by a
secret, is a property of the connection in Azure DevOps, not of the YAML. Both tasks take a federated connection unchanged, so the
repository's pipelines need no edit for it. The names in the pipelines are illustrative until real service connections exist.

Outside a pipeline, `Connect-AzCli` signs in a person interactively or by device code, a managed identity, or a service principal with a
client secret; it has no federated-token sign-in.

##### 57 in `foundation`

Deployed through the subscription's service connection; the item applies to that connection.

##### 57 in `discovery`

As `foundation`.

##### 57 in `expedition`

As `foundation`; a workload identity of its own (rule 54) would be a federated connection as well.

##### 57 status

**Planned (follow-up).** The pipelines are ready for federated service connections, but nothing in the repository records or checks that
every connection is one; that rule belongs with the pipelines' setup.

### 58 — Attribute-based access conditions

```text
CAF identity and access — Application identity and access management — recommendation 58
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-application-access (retrieved 2026-10-14)
Summary (ours): Narrow data access further with attribute-based access control conditions where the service supports them, for
  example on Blob Storage.
```

#### What 58 means here

A condition narrows a role assignment, and no data role is assigned (rule 37). When the storage data roles become code, a condition by
container is the tool to keep one consumer out of another's data in the same account.

##### 58 status

**Not adopted**, because no data role is granted yet; conditions are weighed with the data roles of rule 37.

### 59 — Entra ID sign-in for virtual machines

```text
CAF identity and access — Application identity and access management — recommendation 59
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-application-access (retrieved 2026-10-14)
Summary (ours): Where possible, sign in to Linux and Windows virtual machines with Entra ID identities instead of local accounts,
  which brings Conditional Access, multi-factor authentication, and audit.
```

#### What 59 means here

No template deploys a virtual machine ([ADR-AZ-CAFSEC#38](landing-zone-security.md#rule-adr-az-cafsec38)). `vm.bicep` exists as a module and
takes a local administrator name and password; the first template that uses it should give the machine Entra ID sign-in instead.

##### 59 status

**Not adopted**, because no template deploys a virtual machine.

### 60 — Managed identities between resources

```text
CAF identity and access — Application identity and access management — recommendation 60
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-application-access (retrieved 2026-10-14)
Summary (ours): Use managed identities for access between Azure resources, so that no credential is needed.
```

#### What 60 means here

`storage-account.bicep` and `sql-server.bicep` give their resource a system-assigned managed identity and output its `principalId`
([ADR-AZ-CAFSEC#29](landing-zone-security.md#rule-adr-az-cafsec29)). Nothing uses them: no role is granted to either, and no resource calls
another. The one credential between resources, the break-glass password, is read by Azure Resource Manager on behalf of the deploying
identity, not by a resource.

The identities become useful with the first access between resources, for example the SQL server writing its audit log or a workload reading
from the storage account; each is then a role assignment to the identity, in the template that deploys the resource.

##### 60 in `foundation`

The vault and the workspace carry no managed identity and need none.

##### 60 in `discovery`

Not applicable: its resources call nothing.

##### 60 in `expedition`

Both services have system-assigned identities that hold no role. Any access between them, or to the vault, should go through these
identities, with the role granted in the template.

##### 60 status

**Partly realised.** The identities exist and no credential passes between resources, but no access between resources uses them yet; the
role assignments are planned (follow-up).

### 61 — No identity shared across environments or applications

```text
CAF identity and access — Application identity and access management — recommendation 61
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-application-access (retrieved 2026-10-14)
Summary (ours): Give each application instance and environment its own credentials and identities, and never reuse a production
  identity in development or test.
```

#### What 61 means here

Managed identities are never shared: each is system-assigned to one resource, and each configuration slot deploys its own resources
([ADR-AZ-DATAMOD#2](../azure-data-model.md#rule-adr-az-datamod2)). Production never shares a credential with development, because the two
live in different subscriptions with different vaults and service connections (rule 47); the SQL administrator group they share is an access
group, not a credential (rule 45).

The shared credential is the break-glass login. Every `expedition` config names the login `exped-break-glass` and the secret
`exped-sql-admin-password`, read from its tier's vault, so the environments of one tier share one password
([ADR-AZ-CAFSEC#26](landing-zone-security.md#rule-adr-az-cafsec26)).

##### 61 in `foundation`

One vault per tier holds the secret every environment of that tier reads. It should hold one secret per configuration slot.

##### 61 in `discovery`

Not applicable: the landing zone has no credential.

##### 61 in `expedition`

Each config should name a secret of its own slot, so `dev`, `test`, and `dev-blu` each have their own password.

##### 61 status

**Partly realised.** No managed identity is shared and production shares nothing with development, but the break-glass password is shared
within a tier; a secret per configuration slot is planned (follow-up), as ADR-AZ-CAFSEC#26 decides.

### 62 — User-assigned identities at scale

```text
CAF identity and access — Application identity and access management — recommendation 62
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-application-access (retrieved 2026-10-14)
Summary (ours): Where managed identities are needed at scale, such as the Azure Monitor Agent on many virtual machines, use one
  user-assigned identity per resource type and region, assigned by Azure Policy, to avoid churn of identities.
```

#### What 62 means here

No template deploys a fleet of machines or an agent; the managed identities are system-assigned to a few platform resources (rule 60).

##### 62 status

**Not adopted**, because no template deploys a fleet of machines.

### 63 — Key Vault for application secrets

```text
CAF identity and access — Application identity and access management — recommendation 63
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-application-access (retrieved 2026-10-14)
Summary (ours): Keep application secrets, keys, and certificates in Key Vault, authorize both its data plane and its control
  plane through Azure RBAC, and let applications reach it with managed identities.
```

#### What 63 means here

The repository's one secret, the break-glass password, lives in Key Vault, and a secure parameter takes a Key Vault reference, never a
literal ([ADR-AZ-WAFSE#9](../waf/security.md#rule-adr-az-wafse9)). `key-vault.bicep` authorizes both planes through Azure RBAC, with no
access policies ([ADR-AZ-CAFSEC#16](landing-zone-security.md#rule-adr-az-cafsec16)). No application reads the vault: Azure Resource Manager
resolves the reference at deploy time (`enabledForTemplateDeployment: true`). A workload that reads a secret at run time would do so with
its managed identity and a data role such as Key Vault Secrets User, granted on the vault.

##### 63 in `foundation`

Deploys the RBAC-authorized vault of each subscription; the roles on it are granted outside the repository.

##### 63 in `discovery`

Not applicable: the landing zone uses no secret.

##### 63 in `expedition`

References its one secret from the vault; no service reads the vault at run time.

##### 63 status

**Partly realised.** Secrets are in RBAC-authorized vaults, but the roles on the vaults are granted outside the repository; they are planned
(follow-up) with the role assignments as code.

### 64 — A key vault per application environment

```text
CAF identity and access — Application identity and access management — recommendation 64
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-application-access (retrieved 2026-10-14)
Summary (ours): Use a separate key vault for each application environment in each region, governed by RBAC and deployed in the
  workload landing zone.
```

#### What 64 means here

Vaults are per subscription: `foundation` deploys one in each, so every customer and every tier has its own
([ADR-AZ-CAFSEC#15](landing-zone-security.md#rule-adr-az-cafsec15)), in the one region of its environment
([ADR-AZ-NETWORK#3](../azure-network-model.md#rule-adr-az-network3)). They are not per application environment: the environments of a tier
share their tier's vault ([ADR-AZ-CAFSEC#26](landing-zone-security.md#rule-adr-az-cafsec26)), and the workload's secret sits in the
platform's vault, not in one of its own ([ADR-AZ-CAFSEC#25](landing-zone-security.md#rule-adr-az-cafsec25)).

A vault inside the workload is not adopted, because the workload's secret must exist before the workload deploys: the SQL server reads the
break-glass password at creation, so the vault that holds it belongs to the template deployed before it. Separation per environment comes
instead from a secret name per configuration slot (rule 61).

##### 64 in `foundation`

One vault per subscription (`keyVaultName`, for example `ps-weu-zct-fnd-ap-kv` for `apex` production).

##### 64 in `discovery`

Not applicable: the landing zone holds no vault.

##### 64 in `expedition`

Reads its secret from its subscription's vault; with the planned secret name per configuration slot, each environment has its own secret in
its tier's vault.

##### 64 status

**Partly realised.** Vaults are separate per customer and tier, and a secret name per configuration slot is planned (follow-up); a vault per
workload is not adopted, because the secret must exist before the workload.

### 65 — Application proxy for on-premises applications

```text
CAF identity and access — Application identity and access management — recommendation 65
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-application-access (retrieved 2026-10-14)
Summary (ours): Expose web applications that use on-premises authentication through Entra application proxy; configuring it
  needs Application Administrator, so either the platform team does it for application owners, or the owners automate it
  through Microsoft Graph from a pipeline with the right privileges.
```

#### What 65 means here

This repeats rule 12, which decides it: there is no on-premises application to publish.

##### 65 status

**Not adopted**, for the reason of rule 12.

### 66 — Network paths for legacy protocols

```text
CAF identity and access — Application identity and access management — recommendation 66
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-application-access (retrieved 2026-10-14)
Summary (ours): Applications that use legacy protocols such as Kerberos need a network path from their landing zone to the domain
  controllers in the identity subscription.
```

#### What 66 means here

No workload uses a legacy protocol (rule 2) and no directory server exists (rule 14). Were one added, the path would be a peering and a
subnet in `network.yml`, like every other path ([ADR-AZ-LZ#2](../landing-zones.md#rule-adr-az-lz2)).

##### 66 status

**Not adopted**, because no workload uses a legacy protocol.

### 67 — The Microsoft identity platform for cloud-native applications

```text
CAF identity and access — Application identity and access management — recommendation 67
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-application-access (retrieved 2026-10-14)
Summary (ours): Cloud-native applications should use the Microsoft identity platform, which is OpenID Connect compliant, as their
  identity provider, for work and school accounts, personal Microsoft accounts, and social or local accounts.
```

#### What 67 means here

The workload of `expedition` is a storage account and a database with no user-facing application
([ADR-AZ-CAFSEC#34](landing-zone-security.md#rule-adr-az-cafsec34)). An application registration and its sign-in are the application's
concern, outside the templates.

##### 67 status

**Not adopted**, because no template deploys an application that users sign in to.

### 68 — The identity platform integration checklist

```text
CAF identity and access — Application identity and access management — recommendation 68
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-application-access (retrieved 2026-10-14)
Summary (ours): Follow the Microsoft identity platform's checklist of best practices when integrating an application.
```

#### What 68 means here

As rule 67: there is no application to integrate.

##### 68 status

**Not adopted**, for the reason of rule 67.

## Decision

The repository adopts the CAF identity and access design area as a review list for its templates and pipelines, item by item, and records
for each item what it does, what it plans, and what it does not adopt and why. Entra ID is the one identity provider, and the repository's
part of identity is what a subscription holds: the principals its templates name, always groups or roles; the managed identities of its
resources, always system-assigned; its vaults, always RBAC-authorized; and the role assignments, planned as resources of the templates. The
directory, its accounts and groups, Conditional Access, Privileged Identity Management, and hybrid identity are not adopted, because they
belong to the tenant's administrators and the repository owns nothing above a subscription
([ADR-AZ-LZ#1](../landing-zones.md#rule-adr-az-lz1)). Where the workload view decides an item, the rule cites
[ADR-AZ-WAFSE#5](../waf/security.md#rule-adr-az-wafse5); where the platform security record does, it cites ADR-AZ-CAFSEC. Every
`partly realised` or `planned` status names the module, template, config, or pipeline that the change touches.

### How this is enforced

- `sql-server.bicep` defaults `entraAdminPrincipalType` to `Group` and `entraOnlyAuthentication` to `true`; a SQL login exists only when a
  template turns Entra-only authentication off and supplies the password (rules 28 and 29).
- `key-vault.bicep` fixes RBAC authorization with no parameter to turn it off, and `storage-account.bicep` turns shared-key access off by
  default (rules 37 and 63).
- `ci-infrastructure.yaml` runs `Assert-BicepTemplate` and `Build-Bicep` for `foundation`, `discovery`, and `expedition`, so every rendered
  parameters file satisfies its template's contract, including a Key Vault reference for the break-glass password
  ([ADR-AZ-DATAMOD#9](../azure-data-model.md#rule-adr-az-datamod9)).
- `Test-ManagedGuids` fails a GUID in tracked text that is not in the managed-GUID registry, so the SQL administrator group's object id
  enters a config only as the registered `entra_sql_admin_group`
  ([ADR-AUTO-GUIDS#4](../../automation/managed-guids.md#rule-adr-auto-guids4)).
- `Deploy-Bicep` requires `-SubscriptionIdAssertIs` in a pipeline and verifies the session's subscription against `azure.yml`
  ([ADR-AZ-DATAMOD#7](../azure-data-model.md#rule-adr-az-datamod7), [az-session-verification](../az-session-verification.md)) (rule 54).
- **Planned (follow-up):** the standard role set in `discovery` and the data roles in `expedition` (rules 36, 37, 60, 63); a group per
  customer and environment in the `expedition` configs (rule 45); a secret per configuration slot (rules 61 and 64); a resource-context
  default in `log-analytics.bicep` (rule 38); a separate deploying identity for the workload and a read-only one for the what-if preview
  (rule 54); workload identity federation for every service connection (rule 57). These are plans, not checks that run.

## Consequences

- Identity in the templates is small and reviewable: every principal is a group or a role in a config, and every planned role assignment
  will be a resource of a template, so a change of access is a reviewed change.
- The repository needs no rights in the tenant's directory, at the cost of leaving accounts, groups, Conditional Access, Privileged Identity
  Management, and the directory's logs to the tenant's administrators; the groups the configs name must exist before a deploy.
- Until the role assignments are code, who may read a vault, a storage account, or a database is decided by hand outside the repository, and
  the system-assigned identities hold no role.
- One SQL administrator group for every customer and environment, and one break-glass password per tier, widen what one membership or one
  secret reaches; the per-environment split is a config change, not a template change.
- A single deploying identity per subscription keeps the pipelines simple, but gives a workload deploy the landing zone's rights; splitting
  it adds a service connection per subscription.
- Each item cites Microsoft's page and a retrieval date; when the vendor guidance changes, the summary and the takeaways are revisited
  together.
