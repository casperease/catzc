---
catzc:
  derived:
    path: docs/adr/azure/caf/landing-zone-security.md
    kind: adr
    body_sha: acf70e0b97e3
    defines:
      - ADR-AZ-CAFSEC#{1-45}
    adrs:
      - ADR-AZ-DATAMOD#{2,9,11}
      - ADR-AZ-LZ#{1,3,4,6}
      - ADR-AZ-NETWORK#{1,3,6}
      - ADR-AZ-WAFOE#7
      - ADR-AZ-WAFRE#{1,5}
      - ADR-AZ-WAFSE#{1,3-10,12}
    links:
      - docs/adr/azure/az-session-verification.md
      - docs/adr/azure/azure-data-model.md#rule-adr-az-datamod11
      - docs/adr/azure/azure-data-model.md#rule-adr-az-datamod2
      - docs/adr/azure/azure-data-model.md#rule-adr-az-datamod9
      - docs/adr/azure/azure-naming-standard.md
      - docs/adr/azure/azure-network-model.md#rule-adr-az-network1
      - docs/adr/azure/azure-network-model.md#rule-adr-az-network3
      - docs/adr/azure/azure-network-model.md#rule-adr-az-network6
      - docs/adr/azure/landing-zones.md
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz1
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz3
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz4
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz6
      - docs/adr/azure/waf/operational-excellence.md#rule-adr-az-wafoe7
      - docs/adr/azure/waf/reliability.md#rule-adr-az-wafre1
      - docs/adr/azure/waf/reliability.md#rule-adr-az-wafre5
      - docs/adr/azure/waf/security.md
      - docs/adr/azure/waf/security.md#rule-adr-az-wafse1
      - docs/adr/azure/waf/security.md#rule-adr-az-wafse10
      - docs/adr/azure/waf/security.md#rule-adr-az-wafse12
      - docs/adr/azure/waf/security.md#rule-adr-az-wafse3
      - docs/adr/azure/waf/security.md#rule-adr-az-wafse4
      - docs/adr/azure/waf/security.md#rule-adr-az-wafse5
      - docs/adr/azure/waf/security.md#rule-adr-az-wafse6
      - docs/adr/azure/waf/security.md#rule-adr-az-wafse7
      - docs/adr/azure/waf/security.md#rule-adr-az-wafse8
      - docs/adr/azure/waf/security.md#rule-adr-az-wafse9
      - docs/references/caf/index.md
---

# ADR: CAF security — what the repository does about each recommendation of the landing-zone security design area

Pairs with [`waf-security`](../waf/security.md) (the workload view of the same concerns; its rules are cited here, not repeated) and
[`landing-zones`](../landing-zones.md) (the landing zone these recommendations apply to).

## Rules: ADR-AZ-CAFSEC

### Rule ADR-AZ-CAFSEC:1

Access audit reports from Entra ID are not adopted, because the directory and its reports belong to the tenant's administrators.

- [1 — Access audit reports from Entra ID](#1--access-audit-reports-from-entra-id)

### Rule ADR-AZ-CAFSEC:2

The subscription's activity log streams to `foundation`'s Log Analytics workspace; a retention per environment class is planned, and a
storage archive beyond two years is not adopted.

- [2 — Activity logs in Azure Monitor Logs](#2--activity-logs-in-azure-monitor-logs)

### Rule ADR-AZ-CAFSEC:3

Microsoft Defender for Cloud is planned as a resource of the landing zone, deployed by `discovery` for the services its workloads use, not
through a deploy-if-not-exists policy.

- [3 — Defender for Cloud on every subscription](#3--defender-for-cloud-on-every-subscription)

### Rule ADR-AZ-CAFSEC:4

Operating system patch tracking is not adopted, because no template deploys a virtual machine.

- [4 — Operating system patch drift](#4--operating-system-patch-drift)

### Rule ADR-AZ-CAFSEC:5

Policy-deployed virtual machine extensions are not adopted, because no template deploys a virtual machine.

- [5 — Virtual machine configuration through policy-deployed extensions](#5--virtual-machine-configuration-through-policy-deployed-extensions)

### Rule ADR-AZ-CAFSEC:6

Policy tracking of virtual machine security drift is not adopted, because no template deploys a virtual machine.

- [6 — Virtual machine security drift](#6--virtual-machine-security-drift)

### Rule ADR-AZ-CAFSEC:7

Every resource that emits logs sends them to its subscription's `foundation` workspace, one workspace per subscription rather than one for
the tenant; the Key Vault's diagnostics are planned.

- [7 — Resource diagnostics to the central workspace](#7--resource-diagnostics-to-the-central-workspace)

### Rule ADR-AZ-CAFSEC:8

Real-time log alerts through Event Grid are not adopted, because the templates create no security alert to route to anyone who would act on
it.

- [8 — Real-time log alerts through Event Grid](#8--real-time-log-alerts-through-event-grid)

### Rule ADR-AZ-CAFSEC:9

Azure Attestation is not adopted, because no template runs confidential computing or a virtual machine whose boot chain needs proof.

- [9 — Azure Attestation](#9--azure-attestation)

### Rule ADR-AZ-CAFSEC:10

Each service the templates use is reviewed against the CAF and WAF records item by item; a disaster recovery region is not adopted
(ADR-AZ-NETWORK#3).

- [10 — A joint review of each required service](#10--a-joint-review-of-each-required-service)

### Rule ADR-AZ-CAFSEC:11

The shared Bicep modules are the allowlist of services, each with secure defaults; a policy that denies a resource type outside it is
planned.

- [11 — A security allowlist plan for services](#11--a-security-allowlist-plan-for-services)

### Rule ADR-AZ-CAFSEC:12

An incident response plan is not adopted, because it is the tenant's security operations process (ADR-AZ-WAFSE#12).

- [12 — An incident response plan before production](#12--an-incident-response-plan-before-production)

### Rule ADR-AZ-CAFSEC:13

Tracking Azure roadmaps is not adopted as a process of its own; each CAF and WAF record carries its retrieval date and is revisited when the
vendor guidance changes.

- [13 — Security requirements aligned with Azure roadmaps](#13--security-requirements-aligned-with-azure-roadmaps)

### Rule ADR-AZ-CAFSEC:14

Access to the platform follows Zero Trust through Entra ID identities, a service connection per subscription pinned on every deploy, and
private endpoints for data; `foundation`'s vault and workspace accept public traffic until ADR-AZ-WAFSE#6 closes it.

- [14 — Zero Trust for platform access](#14--zero-trust-for-platform-access)

### Rule ADR-AZ-CAFSEC:15

Key Vault is federated: `foundation` deploys one vault per subscription, so every customer and every tier has its own.

- [15 — A federated Key Vault model](#15--a-federated-key-vault-model)

### Rule ADR-AZ-CAFSEC:16

Every vault authorizes its data plane through Azure RBAC, with no access policies.

- [16 — Azure RBAC for the Key Vault data plane](#16--azure-rbac-for-the-key-vault-data-plane)

### Rule ADR-AZ-CAFSEC:17

Every vault has the platform's soft delete; purge protection is planned as a module default (ADR-AZ-WAFSE#8).

- [17 — Soft delete and purge protection on every vault](#17--soft-delete-and-purge-protection-on-every-vault)

### Rule ADR-AZ-CAFSEC:18

Permanent deletion is closed by purge protection, which is planned; custom roles that alone may purge are not adopted.

- [18 — Least privilege for permanent deletion](#18--least-privilege-for-permanent-deletion)

### Rule ADR-AZ-CAFSEC:19

Certificate automation is not adopted, because no template issues or holds a certificate.

- [19 — Automated certificate management](#19--automated-certificate-management)

### Rule ADR-AZ-CAFSEC:20

The vaults hold no key and no certificate; rotation of the one secret, the break-glass password, is manual and planned to be automated
(ADR-AZ-WAFSE#9).

- [20 — Automated key and certificate rotation](#20--automated-key-and-certificate-rotation)

### Rule ADR-AZ-CAFSEC:21

A vault's network access is planned to be closed: public network access off and a private endpoint in the hub's private DNS, in place of the
service endpoints CAF names (ADR-AZ-WAFSE#6).

- [21 — Vault firewall and network restriction](#21--vault-firewall-and-network-restriction)

### Rule ADR-AZ-CAFSEC:22

Vault usage is planned to be audited in the subscription's workspace through the `keyVault` kind of the diagnostic setting module.

- [22 — Vault usage audited in the central workspace](#22--vault-usage-audited-in-the-central-workspace)

### Rule ADR-AZ-CAFSEC:23

Delegated vault creation is not adopted, because only `foundation` creates a vault, from one module, so every vault has the same
configuration without a policy.

- [23 — Delegated vault creation under policy](#23--delegated-vault-creation-under-policy)

### Rule ADR-AZ-CAFSEC:24

Data at rest uses Microsoft-managed keys; customer-managed keys are not adopted (ADR-AZ-WAFSE#7).

- [24 — Microsoft-managed keys by default](#24--microsoft-managed-keys-by-default)

### Rule ADR-AZ-CAFSEC:25

No vault is central to the tenant: each subscription's vault serves only that subscription, though a workload's secret sits in the
platform's vault, not in one of its own.

- [25 — No central vault for application secrets](#25--no-central-vault-for-application-secrets)

### Rule ADR-AZ-CAFSEC:26

Vaults are separate per customer and per tier, but the environments of one tier share their tier's vault and the same secret name; a secret
name per configuration slot is planned.

- [26 — No vault shared between applications or environments](#26--no-vault-shared-between-applications-or-environments)

### Rule ADR-AZ-CAFSEC:27

An identity plan beyond Azure — federation, conditional access, sign-in signals — is not adopted, because it is the tenant's directory
design.

- [27 — An Entra ID identity plan beyond Azure](#27--an-entra-id-identity-plan-beyond-azure)

### Rule ADR-AZ-CAFSEC:28

A separate identity subscription is not adopted, because the repository deploys no directory server or other identity resource.

- [28 — A separate subscription for identity resources](#28--a-separate-subscription-for-identity-resources)

### Rule ADR-AZ-CAFSEC:29

Services authenticate as system-assigned managed identities; the one non-identity credential is the break-glass SQL login of ADR-AZ-LZ#6.

- [29 — Managed identities where possible](#29--managed-identities-where-possible)

### Rule ADR-AZ-CAFSEC:30

Endpoint management is not adopted, because the repository deploys no user device.

- [30 — Zero Trust endpoint management](#30--zero-trust-endpoint-management)

### Rule ADR-AZ-CAFSEC:31

The pointer to the infrastructure pillar for devices and servers is answered by rules 36–39; no template deploys a server.

- [31 — Devices and servers under the infrastructure pillar](#31--devices-and-servers-under-the-infrastructure-pillar)

### Rule ADR-AZ-CAFSEC:32

Defender for Cloud Apps is not adopted, because no template deploys an application that users sign in to.

- [32 — Application access through Defender for Cloud Apps](#32--application-access-through-defender-for-cloud-apps)

### Rule ADR-AZ-CAFSEC:33

The standard Defender for Cloud Apps policies are not adopted, for the reason of rule 32.

- [33 — The standard Defender for Cloud Apps policies](#33--the-standard-defender-for-cloud-apps-policies)

### Rule ADR-AZ-CAFSEC:34

Onboarding applications to access practices is not adopted, because no template deploys an application that users sign in to.

- [34 — Every application onboarded to access practices](#34--every-application-onboarded-to-access-practices)

### Rule ADR-AZ-CAFSEC:35

Microsoft Purview is not adopted; the CAF `data-classification` tag labels each resource (ADR-AZ-WAFSE#3).

- [35 — Data governance with Microsoft Purview](#35--data-governance-with-microsoft-purview)

### Rule ADR-AZ-CAFSEC:36

The landing zone assigns three built-in policies at subscription level in place of the management-group policy set of the CAF reference
landing zone; a benchmark initiative in audit mode is planned (ADR-AZ-WAFSE#1).

- [36 — The standard landing-zone policies](#36--the-standard-landing-zone-policies)

### Rule ADR-AZ-CAFSEC:37

Privileged Identity Management is not adopted, because it is a tenant setting, not a resource a template deploys.

- [37 — Privileged Identity Management](#37--privileged-identity-management)

### Rule ADR-AZ-CAFSEC:38

Just-in-time virtual machine access is not adopted, because no template deploys a virtual machine.

- [38 — Just-in-time virtual machine access](#38--just-in-time-virtual-machine-access)

### Rule ADR-AZ-CAFSEC:39

Each workload deploys the diagnostic settings of its own resources, so its monitoring travels with its template; alerts per workload are
planned (ADR-AZ-WAFOE#7).

- [39 — Monitoring and management per workload](#39--monitoring-and-management-per-workload)

### Rule ADR-AZ-CAFSEC:40

The Zero Trust variants of Microsoft's landing-zone accelerators are not adopted, because the repository deploys its own templates.

- [40 — The Zero Trust landing-zone deployment guides](#40--the-zero-trust-landing-zone-deployment-guides)

### Rule ADR-AZ-CAFSEC:41

The Zero Trust application delivery pattern is not adopted, because no workload has public ingress.

- [41 — Zero Trust application delivery](#41--zero-trust-application-delivery)

### Rule ADR-AZ-CAFSEC:42

Workload networking is private by plan — `network.yml`, a network security group per workload subnet, private endpoints — and egress
filtering through a hub firewall is planned (ADR-AZ-WAFSE#6).

- [42 — Workload networking planned with Zero Trust](#42--workload-networking-planned-with-zero-trust)

### Rule ADR-AZ-CAFSEC:43

Microsoft Sentinel is not adopted, because the choice of a security information and event management tool belongs to the tenant's security
operations; `foundation`'s workspace is where it would attach.

- [43 — Microsoft Sentinel in the landing zone](#43--microsoft-sentinel-in-the-landing-zone)

### Rule ADR-AZ-CAFSEC:44

Feeding Entra ID and Microsoft 365 signals into Sentinel is not adopted, for the reason of rule 43.

- [44 — Entra ID and Microsoft 365 signals into Sentinel](#44--entra-id-and-microsoft-365-signals-into-sentinel)

### Rule ADR-AZ-CAFSEC:45

Threat hunting is not adopted, because it is a practice of the tenant's security operations; the repository supplies the logs it reads.

- [45 — Threat hunting](#45--threat-hunting)

## Context

Microsoft's Cloud Adoption Framework (CAF) is its guidance for adopting Azure across an organisation. Its landing-zone part splits the
platform that workloads land in into design areas, each with considerations and numbered design recommendations: billing and tenant,
identity and access, resource organisation, network, security, management, governance, and platform automation.

The security design area asks that security requirements are set once and applied the same way to every workload on the platform. It covers
security operations (logs, alerts, threat protection, drift), access control including Zero Trust, the encryption and key management page,
and the Zero Trust page, whose recommendations follow its pillars: identity, endpoints, applications, data, infrastructure, networks, and
visibility.

These rules are vendor recommendation, not principled theory: they record what one platform vendor advises for its own cloud, and what this
repository does about each item. CAF items carry no codes, so each rule's number is the item's order across the three pages. Each rule cites
Microsoft's page — the page title, the section, the link, and the retrieval date — and summarises the item in our words. The live CAF text
falls under the Microsoft Learn Terms of Use, which grant no right to copy it into a shared repository, so nothing here is quoted.

The [CAF reference](../../../references/caf/index.md) lists every CAF record in this repository and the Microsoft pages each one cites.

This record is the platform view. The workload view of the same concerns is [waf-security](../waf/security.md) (ADR-AZ-WAFSE); where a
recommendation is decided there, the rule cites it and adds only what the landing zone changes. The examples are the three templates the
[landing-zones](../landing-zones.md) record describes: `foundation` (the Log Analytics workspace and the Key Vault of each subscription),
`discovery` (the landing zone: network, policies, budget), and `expedition` (the workload: a storage account and a SQL database behind
private endpoints).

### 1 — Access audit reports from Entra ID

```text
CAF security — Security design in Azure — recommendation 1
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/security (retrieved 2026-10-15)
Summary (ours): Produce access-control audit reports from the reporting features of Microsoft Entra ID.
```

#### What 1 means here

Entra ID reporting is a feature of the directory, and the repository deploys into subscriptions it is given, never into the tenant above
them ([ADR-AZ-LZ#1](../landing-zones.md#rule-adr-az-lz1)). The access the templates grant is visible in code: an Entra ID group as SQL
administrator ([ADR-AZ-LZ#6](../landing-zones.md#rule-adr-az-lz6)), and no role assignment at all
([ADR-AZ-WAFSE#5](../waf/security.md#rule-adr-az-wafse5)).

##### 1 status

**Not adopted**, because access reports are the tenant's, run by its administrators.

### 2 — Activity logs in Azure Monitor Logs

```text
CAF security — Security design in Azure — recommendation 2
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/security (retrieved 2026-10-15)
Summary (ours): Keep the activity logs in Azure Monitor Logs, and archive them to a storage account when they must be kept longer
than two years.
```

#### What 2 means here

The landing zone streams the subscription's activity log to `foundation`'s workspace through a diagnostic setting it deploys, never through
a deploy-if-not-exists policy ([ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3)). `subscription-diagnostic-setting.bicep` sends every
category, `Administrative`, `Security`, and `Policy` among them.

The workspace keeps 30 days, the `retentionInDays` default of `log-analytics.bicep`, which accepts up to 730. No requirement in the
repository asks for more than two years, so a storage archive has nothing to serve; a retention per environment class, as a config value, is
the step that matters first ([ADR-AZ-WAFSE#10](../waf/security.md#rule-adr-az-wafse10)).

##### 2 in `foundation`

Deploys the workspace with the default 30 days. `foundation`'s configs should set `retentionInDays` per environment class, longer in
production.

##### 2 in `discovery`

Deploys the activity-log diagnostic setting (`activityLog`, `subscription-diagnostic-setting.bicep`) to the workspace of its subscription.

##### 2 in `expedition`

Not applicable: the activity log belongs to the subscription, not the workload.

##### 2 status

**Partly realised.** The activity log reaches the workspace, but its retention is the module default; a retention per environment class is
planned (follow-up), and a storage archive is not adopted while nothing asks for two years.

### 3 — Defender for Cloud on every subscription

```text
CAF security — Security design in Azure — recommendation 3
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/security (retrieved 2026-10-15)
Summary (ours): Turn on the paid plans of Microsoft Defender for Cloud on every subscription, and use Azure Policy to keep them on.
```

#### What 3 means here

No Defender for Cloud plan is deployed. Every subscription gets one landing zone, so `discovery` is where a plan belongs: a plan is a
subscription-level resource, and deploying it in the template follows the reason ADR-AZ-LZ#3 gives for the activity log — it exists when the
deploy succeeds, with no remediation task and no managed identity. Which plans to turn on is a config value per environment class, since
each plan costs per protected resource; the plans that matter are those of the services the workloads use (storage, SQL, Key Vault). This is
the threat detection [ADR-AZ-WAFSE#10](../waf/security.md#rule-adr-az-wafse10) plans.

##### 3 in `foundation`

Not applicable: its vault is protected by the Key Vault plan the landing zone turns on for the whole subscription.

##### 3 in `discovery`

Should deploy the Defender for Cloud plans, one subscription-level resource each, for the services in use, listed in its config, and send
their alerts to the subscription's workspace.

##### 3 in `expedition`

Not applicable: the workload is covered by its subscription's plans and deploys none.

##### 3 status

**Planned (follow-up).** No plan is deployed; `discovery` is the template that gains them.

### 4 — Operating system patch drift

```text
CAF security — Security design in Azure — recommendation 4
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/security (retrieved 2026-10-15)
Summary (ours): Track drift in operating system patching with Azure Monitor Logs and Defender for Cloud.
```

#### What 4 means here

Every resource the templates deploy is a managed platform service, and no template runs self-managed compute
([ADR-AZ-WAFRE#1](../waf/reliability.md#rule-adr-az-wafre1)). `vm.bicep` exists as a module, but no template uses it. Patch tracking becomes
relevant with the first template that deploys a virtual machine.

##### 4 status

**Not adopted**, because there is no operating system to patch.

### 5 — Virtual machine configuration through policy-deployed extensions

```text
CAF security — Security design in Azure — recommendation 5
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/security (retrieved 2026-10-15)
Summary (ours): Use Azure Policy to deploy virtual machine extensions, so every machine gets a compliant baseline configuration.
```

#### What 5 means here

No template deploys a virtual machine (rule 4). A machine added later would also meet the landing zone's preference for template resources
over deploy-if-not-exists policies ([ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3)): its extensions would be part of its module.

##### 5 status

**Not adopted**, because no template deploys a virtual machine.

### 6 — Virtual machine security drift

```text
CAF security — Security design in Azure — recommendation 6
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/security (retrieved 2026-10-15)
Summary (ours): Use Azure Policy to watch the security configuration of virtual machines for drift.
```

#### What 6 means here

No template deploys a virtual machine (rule 4), so there is no machine configuration to drift.

##### 6 status

**Not adopted**, because no template deploys a virtual machine.

### 7 — Resource diagnostics to the central workspace

```text
CAF security — Security design in Azure — recommendation 7
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/security (retrieved 2026-10-15)
Summary (ours): Have the default configuration of every resource report its logs into a central Log Analytics workspace.
```

#### What 7 means here

The repository's central workspace is one per subscription, not one per tenant: `foundation` deploys it in every subscription, and every
resource that emits logs sends them there through a diagnostic setting its own template deploys
([ADR-AZ-WAFOE#7](../waf/operational-excellence.md#rule-adr-az-wafoe7)). One workspace per subscription keeps a customer's logs in that
customer's subscription, beside its secrets ([ADR-AZ-WAFSE#4](../waf/security.md#rule-adr-az-wafse4)), and needs no rights outside it. The
diagnostic setting is part of each template rather than a default enforced by policy, for the reason of ADR-AZ-LZ#3.

##### 7 in `foundation`

Deploys the workspace. Its Key Vault sends no diagnostics; see rule 22.

##### 7 in `discovery`

Sends the activity log, the virtual network, and every network security group to the workspace.

##### 7 in `expedition`

Sends the storage account, its blob service, and the database to the workspace.

##### 7 status

**Partly realised.** Every resource that emits logs reports to its subscription's workspace except `foundation`'s Key Vault, which is
planned (follow-up).

### 8 — Real-time log alerts through Event Grid

```text
CAF security — Security design in Azure — recommendation 8
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/security (retrieved 2026-10-15)
Summary (ours): Drive real-time alerts from logs through a solution built on Azure Event Grid.
```

#### What 8 means here

The only alerts the templates create are the budget alerts, sent to the subscription's `Owner` role. Security alerts wait on threat
detection (rule 3) and on the alerting of [ADR-AZ-WAFOE#7](../waf/operational-excellence.md#rule-adr-az-wafoe7); whether they travel through
Event Grid or through Azure Monitor alert rules is decided when the first of them is built.

##### 8 status

**Not adopted**, because no security alert exists to route.

### 9 — Azure Attestation

```text
CAF security — Security design in Azure — recommendation 9
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/security (retrieved 2026-10-15)
Summary (ours): Use Azure Attestation to prove a virtual machine's boot chain, to release the disk keys of confidential virtual
machines securely, and to verify trusted execution environments.
```

#### What 9 means here

No template deploys a virtual machine or confidential computing, and the data is at the `confidential` classification, which the platform's
encryption serves ([ADR-AZ-WAFSE#7](../waf/security.md#rule-adr-az-wafse7)).

##### 9 status

**Not adopted**, because nothing deployed has a boot chain or an enclave to attest.

### 10 — A joint review of each required service

```text
CAF security — Security design in Azure — recommendation 10
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/security (retrieved 2026-10-15)
Summary (ours): Review each required service against the organisation's requirements together, for example whether it supports
bring-your-own-key, close the gaps found, and choose region pairs and disaster recovery regions that keep latency low.
```

#### What 10 means here

The review exists as records: the WAF and CAF ADRs take each service the templates use — Log Analytics, Key Vault, storage, SQL, the network
resources — item by item, and say what it does, what is planned, and what is not adopted. Bring-your-own-key is not needed (rule 24). Each
environment maps to one region ([ADR-AZ-NETWORK#3](../azure-network-model.md#rule-adr-az-network3)), so no disaster recovery region is
chosen ([ADR-AZ-WAFRE#5](../waf/reliability.md#rule-adr-az-wafre5)).

##### 10 status

**Partly realised.** Each service in use is reviewed in these records, but a disaster recovery region is not adopted.

### 11 — A security allowlist plan for services

```text
CAF security — Security design in Azure — recommendation 11
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/security (retrieved 2026-10-15)
Summary (ours): Plan how a service is assessed before it is allowed — its security configuration, monitoring, and alerts — and how it
joins the systems in place.
```

#### What 11 means here

A service enters the repository as a shared module in `infrastructure/modules/`, with its secure defaults
([ADR-AZ-WAFSE#8](../waf/security.md#rule-adr-az-wafse8)) and a `diagnostic-setting.bicep` kind, and is reviewed against these records. The
modules are therefore the allowlist in practice. Nothing enforces it: a template can declare a resource of any type, and Azure accepts it in
any landing zone. The built-in "allowed resource types" policy, assigned by `discovery` beside its three guardrails
([ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3)) and listing the types of the shared modules, would turn the convention into a
guardrail.

##### 11 in `foundation`

Uses `log-analytics.bicep` and `key-vault.bicep` only.

##### 11 in `discovery`

Uses the network, policy, budget, and diagnostic modules only. It should assign the allowed-resource-types policy, with the list as a config
value and the enforcement mode of `policy_enforcement` ([ADR-AZ-DATAMOD#11](../azure-data-model.md#rule-adr-az-datamod11)).

##### 11 in `expedition`

Uses `storage-account.bicep`, `sql-server.bicep`, `sql-database.bicep`, `private-endpoint.bicep`, and `diagnostic-setting.bicep` only.

##### 11 status

**Partly realised.** The shared modules are the allowlist by convention; a policy that enforces it is planned (follow-up).

### 12 — An incident response plan before production

```text
CAF security — Security design in Azure — recommendation 12
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/security (retrieved 2026-10-15)
Summary (ours): Have an incident response plan for a service before the service goes to production.
```

#### What 12 means here

Decided by [ADR-AZ-WAFSE#12](../waf/security.md#rule-adr-az-wafse12): incident response is the tenant's security operations process, and the
repository supplies what triage reads — the `owner` and `criticality` tags, the configuration tree as the deployment inventory, and the logs
of each subscription in one workspace. The landing zone adds nothing of its own.

##### 12 status

**Not adopted**, because the plan belongs to the tenant's security operations, not to a template.

### 13 — Security requirements aligned with Azure roadmaps

```text
CAF security — Security design in Azure — recommendation 13
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/security (retrieved 2026-10-15)
Summary (ours): Follow the Azure roadmaps so new security controls are adopted as they ship.
```

#### What 13 means here

Following a roadmap is a reading habit, not a template, config, or check. The records that hold the repository's position on each control —
this one and the WAF records — carry the retrieval date of the vendor guidance they cite and are revisited when it changes, which is where a
new control enters.

##### 13 status

**Not adopted** as a process of its own, because the dated CAF and WAF records are where a new control is weighed.

### 14 — Zero Trust for platform access

```text
CAF security — Security design in Azure — recommendation 14
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/security (retrieved 2026-10-15)
Summary (ours): Apply a Zero Trust approach to access to the platform where it fits.
```

#### What 14 means here

Zero Trust here means three things the templates do. Every identity is an Entra ID identity — a group for people, a managed identity for
services ([ADR-AZ-WAFSE#5](../waf/security.md#rule-adr-az-wafse5)). Every deploy runs through the service connection of its own subscription
and pins the subscription with `-SubscriptionIdAssertIs` ([az-session-verification](../az-session-verification.md)), so a pipeline cannot
reach a subscription it was not built for. And data is reached only through private endpoints
([ADR-AZ-WAFSE#6](../waf/security.md#rule-adr-az-wafse6)). The gaps are the platform's own resources: `foundation`'s vault and workspace
accept public network traffic.

##### 14 in `foundation`

The Key Vault is RBAC-authorized (rule 16) but reachable from public networks; rule 21 closes it.

##### 14 in `discovery`

Denies inbound internet traffic at every workload subnet and, through its policy, a public IP address on any network interface
([ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3)).

##### 14 in `expedition`

Public network access off on storage and SQL, private endpoints only, and Entra ID authentication with the one break-glass login of
[ADR-AZ-LZ#6](../landing-zones.md#rule-adr-az-lz6).

##### 14 status

**Partly realised.** Identities, deploys, and data access follow Zero Trust, but `foundation`'s vault and workspace are public until rule 21
and ADR-AZ-WAFSE#6 close them.

### 15 — A federated Key Vault model

```text
CAF security — Encryption and key management in Azure — recommendation 15
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/encryption-and-keys (retrieved 2026-10-15)
Summary (ours): Spread the load over many vaults, a federated model, so no vault reaches its transaction limits.
```

#### What 15 means here

`foundation` is deployed once per subscription, and each deploy creates one vault from `key-vault.bicep`, named by its config (for example
`ns-weu-zct-fnd-kv` for the shared non-production subscription and `ps-weu-zct-fnd-ap-kv` for apex production,
[ADR-AZ-NAMING](../azure-naming-standard.md)). The vaults are therefore as many as the subscriptions, and each carries only the secrets of
its own subscription.

##### 15 in `foundation`

One vault per config, `keyVaultName`, at the same coordinates as the subscription's workspace.

##### 15 in `discovery`

Not applicable: the landing zone uses no secret.

##### 15 in `expedition`

Reads its break-glass password from the vault of the subscription it deploys to, never from another subscription's.

##### 15 status

**Realised.** One vault per subscription spreads the load and the blast radius.

### 16 — Azure RBAC for the Key Vault data plane

```text
CAF security — Encryption and key management in Azure — recommendation 16
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/encryption-and-keys (retrieved 2026-10-15)
Summary (ours): Authorise the Key Vault data plane with Azure RBAC rather than the older vault access policies.
```

#### What 16 means here

`key-vault.bicep` fixes `enableRbacAuthorization: true` and `accessPolicies: []`; neither is a parameter, so no caller can fall back to
access policies. The roles on a vault are granted outside the repository ([ADR-AZ-WAFSE#5](../waf/security.md#rule-adr-az-wafse5)).

##### 16 in `foundation`

Every vault is RBAC-authorized by the module.

##### 16 in `discovery`

Not applicable: the landing zone deploys no vault.

##### 16 in `expedition`

Not applicable: the workload deploys no vault; the deploy-time reference is read by Azure Resource Manager through
`enabledForTemplateDeployment` (rule 21).

##### 16 status

**Realised.** RBAC is the only authorization model the module offers.

### 17 — Soft delete and purge protection on every vault

```text
CAF security — Encryption and key management in Azure — recommendation 17
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/encryption-and-keys (retrieved 2026-10-15)
Summary (ours): Create every vault with soft delete and purge protection turned on.
```

#### What 17 means here

Soft delete is on for every vault by the platform, and `key-vault.bicep` sets no retention, so the platform's default applies. Purge
protection is not set, so a deleted vault or secret can be purged before its retention ends; the module is planned to set
`enablePurgeProtection: true` by default ([ADR-AZ-WAFSE#8](../waf/security.md#rule-adr-az-wafse8)). Purge protection cannot be turned off
once on, and a deleted vault's name stays taken until its retention ends, so a config that renames or removes a vault waits out the
retention before the name is free.

##### 17 in `foundation`

Every vault has soft delete and no purge protection. It gains purge protection through the module default, with no config change.

##### 17 in `discovery`

Not applicable: no vault.

##### 17 in `expedition`

Not applicable: no vault; its secret is protected by the vault it reads from.

##### 17 status

**Partly realised.** Soft delete is on by the platform; purge protection is planned (follow-up) as a module default.

### 18 — Least privilege for permanent deletion

```text
CAF security — Encryption and key management in Azure — recommendation 18
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/encryption-and-keys (retrieved 2026-10-15)
Summary (ours): Let only dedicated custom Entra ID roles permanently delete (purge) keys, secrets, and certificates.
```

#### What 18 means here

The templates make no role assignment, so who may purge is decided outside the repository. Purge protection (rule 17) closes the path for
everyone until the retention ends, whatever the role, which is the stronger control and needs no custom role to maintain. A custom role
definition would also be a tenant- or management-group-level object, which the landing zone does not own
([ADR-AZ-LZ#1](../landing-zones.md#rule-adr-az-lz1)).

##### 18 in `foundation`

Gains purge protection with rule 17; no role is defined.

##### 18 in `discovery`

Not applicable: no vault, and no role assignment.

##### 18 in `expedition`

Not applicable: no vault.

##### 18 status

**Planned (follow-up)** through purge protection; custom purge roles are not adopted, because purge protection removes the need for them.

### 19 — Automated certificate management

```text
CAF security — Encryption and key management in Azure — recommendation 19
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/encryption-and-keys (retrieved 2026-10-15)
Summary (ours): Automate the issuing and renewal of certificates with public certificate authorities.
```

#### What 19 means here

No template issues, holds, or presents a certificate. The services the workloads use terminate TLS with certificates the platform manages,
and no workload has public ingress with a host name of its own ([ADR-AZ-WAFSE#6](../waf/security.md#rule-adr-az-wafse6)). The first public
endpoint with its own host name makes this item apply.

##### 19 status

**Not adopted**, because there is no certificate to manage.

### 20 — Automated key and certificate rotation

```text
CAF security — Encryption and key management in Azure — recommendation 20
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/encryption-and-keys (retrieved 2026-10-15)
Summary (ours): Rotate keys and certificates by an automated process.
```

#### What 20 means here

The vaults hold no key and no certificate; data is encrypted with Microsoft-managed keys, which the platform rotates (rule 24). The one
secret is the break-glass SQL password, set by hand and read by Azure Resource Manager at the next deploy; its automated rotation is planned
by [ADR-AZ-WAFSE#9](../waf/security.md#rule-adr-az-wafse9).

##### 20 in `foundation`

Its vault holds `exped-sql-admin-password`, rotated by hand.

##### 20 in `discovery`

Not applicable: no secret, key, or certificate.

##### 20 in `expedition`

A rotation should be a vault operation followed by a deploy, with no config change.

##### 20 status

**Planned (follow-up).** Nothing is rotated automatically; the break-glass password is the one secret to rotate.

### 21 — Vault firewall and network restriction

```text
CAF security — Encryption and key management in Azure — recommendation 21
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/encryption-and-keys (retrieved 2026-10-15)
Summary (ours): Limit network access to a vault with its firewall and virtual network service endpoints.
```

#### What 21 means here

`key-vault.bicep` sets no network rules, so every vault accepts public network traffic. The repository restricts data services with private
endpoints rather than service endpoints ([ADR-AZ-LZ#4](../landing-zones.md#rule-adr-az-lz4)), and the vault is planned to follow:
`publicNetworkAccess: 'Disabled'` and a private endpoint (group id `vault`) registered in a `privatelink.vaultcore.azure.net` zone in the
hub ([ADR-AZ-WAFSE#6](../waf/security.md#rule-adr-az-wafse6), [ADR-AZ-WAFSE#8](../waf/security.md#rule-adr-az-wafse8)).

The vault keeps `enabledForTemplateDeployment` on, because Azure Resource Manager resolves `expedition`'s break-glass reference at deploy
time ([ADR-AZ-LZ#6](../landing-zones.md#rule-adr-az-lz6)). The closed vault must let it read the secret, so the change that closes it is
proven by a deploy of `expedition` that resolves the reference.

##### 21 in `foundation`

The vault should turn public access off and take a private endpoint. This makes `foundation` depend on the network of `discovery`, which is
deployed after it; the order of the two templates changes with it.

##### 21 in `discovery`

The hub should host `privatelink.vaultcore.azure.net` beside its SQL and blob DNS zones and link it to every spoke it lists.

##### 21 in `expedition`

Not applicable: it reads the vault through Azure Resource Manager, not over the network.

##### 21 status

**Planned (follow-up).** Every vault is public; private access and the zone are the planned change.

### 22 — Vault usage audited in the central workspace

```text
CAF security — Encryption and key management in Azure — recommendation 22
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/encryption-and-keys (retrieved 2026-10-15)
Summary (ours): Audit how every vault's keys, certificates, and secrets are used in the platform's central Log Analytics workspace.
```

#### What 22 means here

`diagnostic-setting.bicep` supports the `keyVault` kind (all logs and metrics), but `foundation` does not deploy it, so a read of the
break-glass secret leaves no trace in the workspace. The vault and the workspace sit in the same template, so the setting belongs there
([ADR-AZ-WAFSE#10](../waf/security.md#rule-adr-az-wafse10)).

##### 22 in `foundation`

Should deploy a diagnostic setting of kind `keyVault` from its vault to its own workspace.

##### 22 in `discovery`

Not applicable: no vault.

##### 22 in `expedition`

Not applicable: its reads of the vault are logged by the vault's setting.

##### 22 status

**Planned (follow-up).** The module supports it; `foundation` does not deploy it.

### 23 — Delegated vault creation under policy

```text
CAF security — Encryption and key management in Azure — recommendation 23
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/encryption-and-keys (retrieved 2026-10-15)
Summary (ours): Let application teams create their own vaults and hold privileged access to them, with Azure Policy keeping every vault's
configuration consistent and compliant.
```

#### What 23 means here

Only `foundation` creates a vault, and only from `key-vault.bicep`, so every vault has the module's configuration by construction, and a
change to it reaches every vault on the next deploy. A policy over vault settings would repeat the module. The question returns when a
workload creates its own vault (rule 25); its vault then comes from the same module, and the allowlist policy of rule 11 keeps vaults from
being declared any other way.

##### 23 in `foundation`

The one template that creates a vault.

##### 23 in `discovery`

Not applicable: no vault, and no vault policy.

##### 23 in `expedition`

Creates no vault; it uses `foundation`'s.

##### 23 status

**Not adopted**, because one template creates every vault from one module, which keeps them consistent without a policy.

### 24 — Microsoft-managed keys by default

```text
CAF security — Encryption and key management in Azure — recommendation 24
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/encryption-and-keys (retrieved 2026-10-15)
Summary (ours): Use Microsoft-managed keys by default, and customer-managed keys only where a requirement calls for them.
```

#### What 24 means here

Decided by [ADR-AZ-WAFSE#7](../waf/security.md#rule-adr-az-wafse7): storage service encryption and SQL transparent data encryption run with
Microsoft-managed keys, the modules set no encryption key, and customer-managed keys are not adopted because the `confidential`
classification does not require them.

##### 24 in `foundation`

The vault holds secrets, not encryption keys.

##### 24 in `discovery`

Not applicable: the landing zone stores no data.

##### 24 in `expedition`

Storage and SQL encrypt at rest with Microsoft-managed keys.

##### 24 status

**Realised.** Every store uses Microsoft-managed keys; a classification that needs customer-managed keys would make them a config value.

### 25 — No central vault for application secrets

```text
CAF security — Encryption and key management in Azure — recommendation 25
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/encryption-and-keys (retrieved 2026-10-15)
Summary (ours): Do not keep application keys or secrets in one shared central vault (Managed HSM aside): many vaults shrink the blast
radius, cut latency and throttling, and follow the boundaries of the workloads.
```

#### What 25 means here

No vault is central to the tenant: each subscription's vault serves that subscription only (rule 15). Within a subscription, though, the
vault is the platform's, not the workload's: `expedition`'s secret sits in `foundation`'s vault. That fits the one secret in use, the
break-glass password, which is a recovery credential of the platform rather than a secret the application reads at run time. A workload that
needs run-time secrets should create its own vault from `key-vault.bicep`, in its own resource group, so the vault's boundary is the
workload's.

##### 25 in `foundation`

One vault per subscription, holding the break-glass password of every workload in that subscription.

##### 25 in `discovery`

Not applicable: no secret.

##### 25 in `expedition`

Uses no run-time secret, so it creates no vault of its own.

##### 25 status

**Partly realised.** No vault is shared across subscriptions, but the platform's vault holds the workload's recovery secret.

### 26 — No vault shared between applications or environments

```text
CAF security — Encryption and key management in Azure — recommendation 26
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/encryption-and-keys (retrieved 2026-10-15)
Summary (ours): Never share a vault between applications or between environments, so no secret is shared across them.
```

#### What 26 means here

The vaults separate customers and tiers: a production config of `expedition` reads the production vault, a non-production config the
non-production vault. Within a tier they do not separate environments: every non-production config of one subscription references the same
vault and the same secret name, `exped-sql-admin-password` (`dev.yml` and `test.yml` read `ns-weu-zct-fnd-kv`; `apex/dev.yml` and
`apex/dev-blu.yml` read `ns-weu-zct-fnd-ap-kv`). Those environments therefore share one break-glass password.

##### 26 in `foundation`

One vault per tier per customer. Not every environment should get its own vault; the separation that matters is the secret.

##### 26 in `discovery`

Not applicable: no secret.

##### 26 in `expedition`

Each configuration slot should reference a secret of its own (for example a name that carries the slot's environment), so dev and test do
not share a password. The secret name is then a config value per slot, with no change to the template.

##### 26 status

**Partly realised.** Customers and tiers never share a vault, but the environments of one tier share one secret; a secret per configuration
slot is planned (follow-up).

### 27 — An Entra ID identity plan beyond Azure

```text
CAF security — Incorporate Zero Trust practices in your landing zone — recommendation 27
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/security-zero-trust (retrieved 2026-10-15)
Summary (ours): Plan identity management in Entra ID beyond Azure resources: federation with on-premises directories, Conditional
Access, and signals from the user, device, location, and behaviour that feed authorisation.
```

#### What 27 means here

Federation and Conditional Access are settings of the tenant's directory. The repository uses Entra ID identities
([ADR-AZ-WAFSE#5](../waf/security.md#rule-adr-az-wafse5)) and has no on-premises connectivity, so the plan has no part in its templates.

##### 27 status

**Not adopted**, because the directory design belongs to the tenant's administrators.

### 28 — A separate subscription for identity resources

```text
CAF security — Incorporate Zero Trust practices in your landing zone — recommendation 28
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/security-zero-trust (retrieved 2026-10-15)
Summary (ours): Deploy the landing zone with its own subscription for identity resources such as domain controllers.
```

#### What 28 means here

The repository deploys no directory server or other identity resource; its identities live in Entra ID. The subscriptions in `azure.yml` are
shared and customer subscriptions, one per tier ([ADR-AZ-WAFSE#4](../waf/security.md#rule-adr-az-wafse4)), and an identity subscription
would hold nothing.

##### 28 status

**Not adopted**, because there is no identity resource to separate.

### 29 — Managed identities where possible

```text
CAF security — Incorporate Zero Trust practices in your landing zone — recommendation 29
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/security-zero-trust (retrieved 2026-10-15)
Summary (ours): Use Microsoft Entra managed identities wherever a service supports them.
```

#### What 29 means here

`storage-account.bicep` and `sql-server.bicep` give each resource a system-assigned managed identity, and the storage account refuses
shared-key access ([ADR-AZ-WAFSE#5](../waf/security.md#rule-adr-az-wafse5)). The one credential that is not an identity is the break-glass
SQL login ([ADR-AZ-LZ#6](../landing-zones.md#rule-adr-az-lz6)). The managed identities receive no role in code; granting them is part of the
role assignments ADR-AZ-WAFSE#5 plans.

##### 29 in `foundation`

Not applicable: the workspace and the vault call no other service.

##### 29 in `discovery`

The policy assignments take no identity, because none of the three policies deploys or modifies a resource.

##### 29 in `expedition`

The storage account and the SQL server each have a system-assigned identity.

##### 29 status

**Realised.** Every service that can call another has a managed identity; the break-glass login is the deliberate exception.

### 30 — Zero Trust endpoint management

```text
CAF security — Incorporate Zero Trust practices in your landing zone — recommendation 30
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/security-zero-trust (retrieved 2026-10-15)
Summary (ours): Plan the management of endpoints with Zero Trust practices, alongside the landing zone rather than inside it.
```

#### What 30 means here

Endpoints here are user devices, managed by the organisation's device management, not by Azure templates. The repository deploys none.

##### 30 status

**Not adopted**, because the repository manages no user device.

### 31 — Devices and servers under the infrastructure pillar

```text
CAF security — Incorporate Zero Trust practices in your landing zone — recommendation 31
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/security-zero-trust (retrieved 2026-10-15)
Summary (ours): A pointer: devices and servers are covered by the Zero Trust infrastructure pillar.
```

#### What 31 means here

The item points on to the infrastructure recommendations, which are rules 36–39 here. No template deploys a server (rule 4).

##### 31 status

**Not adopted** as a separate item, because it is a pointer that rules 36–39 answer.

### 32 — Application access through Defender for Cloud Apps

```text
CAF security — Incorporate Zero Trust practices in your landing zone — recommendation 32
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/security-zero-trust (retrieved 2026-10-15)
Summary (ours): Manage access to applications with Microsoft Defender for Cloud Apps.
```

#### What 32 means here

Defender for Cloud Apps governs the applications users sign in to, and it is licensed and configured for the tenant. The example workload
has no user-facing application: a storage account and a database behind private endpoints.

##### 32 status

**Not adopted**, because no template deploys an application users sign in to.

### 33 — The standard Defender for Cloud Apps policies

```text
CAF security — Incorporate Zero Trust practices in your landing zone — recommendation 33
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/security-zero-trust (retrieved 2026-10-15)
Summary (ours): Enforce application practices with the standard policies that Defender for Cloud Apps provides.
```

#### What 33 means here

Follows rule 32: without Defender for Cloud Apps, its policies have nothing to apply to.

##### 33 status

**Not adopted**, for the reason of rule 32.

### 34 — Every application onboarded to access practices

```text
CAF security — Incorporate Zero Trust practices in your landing zone — recommendation 34
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/security-zero-trust (retrieved 2026-10-15)
Summary (ours): Onboard every application to the organisation's access practices, trusting self-hosted applications no more than
third-party ones.
```

#### What 34 means here

The workloads the templates deploy have no sign-in of their own; their data services accept Entra ID identities and the break-glass login
only. A workload that adds a user-facing application registers it in the tenant's directory, under the tenant's access practices.

##### 34 status

**Not adopted**, because no template deploys an application users sign in to.

### 35 — Data governance with Microsoft Purview

```text
CAF security — Incorporate Zero Trust practices in your landing zone — recommendation 35
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/security-zero-trust (retrieved 2026-10-15)
Summary (ours): Use Microsoft Purview to govern data, protect it, and manage its risk.
```

#### What 35 means here

Purview is a tenant-wide service for cataloguing and labelling data. The repository labels each resource, not the data inside it, with the
CAF `data-classification` tag ([ADR-AZ-WAFSE#3](../waf/security.md#rule-adr-az-wafse3)); classification inside a database is the workload
owner's.

##### 35 status

**Not adopted**, because data governance across the tenant belongs to its data owners, and the resource label is the repository's part.

### 36 — The standard landing-zone policies

```text
CAF security — Incorporate Zero Trust practices in your landing zone — recommendation 36
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/security-zero-trust (retrieved 2026-10-15)
Summary (ours): Apply the standard Azure landing zone policies, so non-compliant deployments are blocked and logging is enforced.
```

#### What 36 means here

The CAF reference landing zone assigns a large policy set at its management groups. The repository owns no management group
([ADR-AZ-LZ#1](../landing-zones.md#rule-adr-az-lz1)), so its landing zone assigns its own guardrails at subscription level: three built-in
policies — allowed locations, a required tag, no public IP address on a network interface — whose mode is `policy_enforcement` in
`azure.yml` ([ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3), [ADR-AZ-DATAMOD#11](../azure-data-model.md#rule-adr-az-datamod11)). Logging
is not enforced by policy but deployed by each template (rule 7). The Microsoft cloud security benchmark initiative in audit mode is planned
([ADR-AZ-WAFSE#1](../waf/security.md#rule-adr-az-wafse1)), and the allowed-resource-types policy of rule 11 would join the three.

##### 36 in `foundation`

Not applicable: it deploys no policy; its resources carry the CAF tags, so they pass the required-tag policy.

##### 36 in `discovery`

Assigns the three policies through `policy-assignment.bicep`. It should also assign the benchmark initiative in audit mode.

##### 36 in `expedition`

Not applicable: a workload creates no policy ([ADR-AZ-LZ#4](../landing-zones.md#rule-adr-az-lz4)); its resources meet the landing zone's.

##### 36 status

**Partly realised.** Three guardrails are assigned in every landing zone; the benchmark initiative is planned (follow-up), and the
management-group policy set is not adopted, because the repository owns no management group.

### 37 — Privileged Identity Management

```text
CAF security — Incorporate Zero Trust practices in your landing zone — recommendation 37
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/security-zero-trust (retrieved 2026-10-15)
Summary (ours): Grant highly privileged roles just in time through Privileged Identity Management in Entra ID.
```

#### What 37 means here

Privileged Identity Management is configured in the tenant's directory, and the templates make no role assignment for it to govern. The
deploying identities are service connections, one per subscription, and their rights are granted outside the repository.

##### 37 status

**Not adopted**, because privileged access is governed by the tenant, not by a template.

### 38 — Just-in-time virtual machine access

```text
CAF security — Incorporate Zero Trust practices in your landing zone — recommendation 38
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/security-zero-trust (retrieved 2026-10-15)
Summary (ours): Use the just-in-time access of Defender for Cloud for virtual machines.
```

#### What 38 means here

No template deploys a virtual machine (rule 4), and the policy against public IP addresses on network interfaces keeps any machine off the
internet ([ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3)).

##### 38 status

**Not adopted**, because there is no virtual machine to reach.

### 39 — Monitoring and management per workload

```text
CAF security — Incorporate Zero Trust practices in your landing zone — recommendation 39
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/security-zero-trust (retrieved 2026-10-15)
Summary (ours): Plan how each workload is monitored and managed on its own.
```

#### What 39 means here

A workload's monitoring is part of its template: every resource it deploys sends its diagnostics to the subscription's workspace through a
setting the same template deploys ([ADR-AZ-WAFOE#7](../waf/operational-excellence.md#rule-adr-az-wafoe7)), so a second workload brings its
own. The `workload` and `owner` tags tell the workloads apart in the shared workspace. Alerts per workload are planned by ADR-AZ-WAFOE#7.

##### 39 in `foundation`

Holds the workspace every workload of its subscription reports to.

##### 39 in `discovery`

Monitors the landing zone itself: activity log, virtual network, network security groups.

##### 39 in `expedition`

Deploys the diagnostic settings of its storage account, blob service, and database. It should deploy its own alert rules once
ADR-AZ-WAFOE#7's alerts exist.

##### 39 status

**Partly realised.** Each workload deploys its own diagnostics; its alerts are planned (follow-up).

### 40 — The Zero Trust landing-zone deployment guides

```text
CAF security — Incorporate Zero Trust practices in your landing zone — recommendation 40
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/security-zero-trust (retrieved 2026-10-15)
Summary (ours): Deploy with the Zero Trust network variants of the landing-zone accelerators (portal, Bicep, Terraform).
```

#### What 40 means here

The repository deploys its own landing zone, `discovery`, built from its shared modules and its network plan, at subscription level
([ADR-AZ-LZ#1](../landing-zones.md#rule-adr-az-lz1)). The accelerators assume management groups and a platform the repository does not own,
so their Zero Trust variants are ideas, weighed in rules 14 and 42, not a deployment.

##### 40 status

**Not adopted**, because the landing zone is the repository's own template.

### 41 — Zero Trust application delivery

```text
CAF security — Incorporate Zero Trust practices in your landing zone — recommendation 41
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/security-zero-trust (retrieved 2026-10-15)
Summary (ours): A pointer to the Zero Trust pattern for web applications, with Application Gateway in front of Azure Firewall.
```

#### What 41 means here

No workload has public ingress, so there is no application delivery to put a gateway and a firewall in front of
([ADR-AZ-WAFSE#6](../waf/security.md#rule-adr-az-wafse6)). The hub reserves `AzureFirewallSubnet` and deploys nothing into it; the first
public endpoint makes the pattern apply.

##### 41 status

**Not adopted**, because no workload is reached from the internet.

### 42 — Workload networking planned with Zero Trust

```text
CAF security — Incorporate Zero Trust practices in your landing zone — recommendation 42
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/security-zero-trust (retrieved 2026-10-15)
Summary (ours): Plan each workload's networking with the Zero Trust deployment plans for Azure.
```

#### What 42 means here

Workload networking is planned once, in `automation/Catzc.Azure/configs/network.yml`: private ranges only, no overlap, and a subnet map per
subscription ([ADR-AZ-NETWORK#1](../azure-network-model.md#rule-adr-az-network1),
[ADR-AZ-NETWORK#6](../azure-network-model.md#rule-adr-az-network6)). The landing zone gives each workload subnet a network security group
that denies inbound internet traffic, and the workload reaches its data only through private endpoints. What the Zero Trust plans add beyond
that is decided in ADR-AZ-WAFSE: narrower east-west rules ([ADR-AZ-WAFSE#4](../waf/security.md#rule-adr-az-wafse4)), egress through a
firewall, and flow logs ([ADR-AZ-WAFSE#6](../waf/security.md#rule-adr-az-wafse6)).

##### 42 in `foundation`

Not applicable to its network, which it has none of; its vault's private access is rule 21.

##### 42 in `discovery`

Deploys the subnets, the network security groups, and in a spoke the route table. The route table should send egress to a firewall in
`AzureFirewallSubnet` once one is deployed.

##### 42 in `expedition`

Places its private endpoints in the `private-endpoints` subnet of its spoke, or the hub's `shared-services` subnet for the shared platform
([ADR-AZ-LZ#4](../landing-zones.md#rule-adr-az-lz4)).

##### 42 status

**Partly realised.** Workload networks are planned and private, but egress is not filtered and east-west traffic is open; both are planned
(follow-up) by ADR-AZ-WAFSE.

### 43 — Microsoft Sentinel in the landing zone

```text
CAF security — Incorporate Zero Trust practices in your landing zone — recommendation 43
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/security-zero-trust (retrieved 2026-10-15)
Summary (ours): Deploy Microsoft Sentinel as part of the Azure landing zone.
```

#### What 43 means here

Sentinel is enabled on a Log Analytics workspace, and each subscription has one, from `foundation`. Whether to run Sentinel, on which
workspace, and whether the per-subscription workspaces feed one tenant-wide instance, is the choice of the tenant's security operations, and
it costs per gigabyte of data analysed. The repository's part is that every security-relevant log of a subscription is in one workspace a
security tool can read (rules 2 and 7).

##### 43 in `foundation`

The workspace Sentinel would be enabled on. Nothing is deployed for it.

##### 43 in `discovery`

Not applicable: it sends its logs to `foundation`'s workspace.

##### 43 in `expedition`

Not applicable: it sends its logs to `foundation`'s workspace.

##### 43 status

**Not adopted**, because the security information and event management tool is the tenant's choice; the workspace it would read exists.

### 44 — Entra ID and Microsoft 365 signals into Sentinel

```text
CAF security — Incorporate Zero Trust practices in your landing zone — recommendation 44
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/security-zero-trust (retrieved 2026-10-15)
Summary (ours): Plan how the signals of Entra ID and the Microsoft 365 tools are fed into the Sentinel workspace.
```

#### What 44 means here

Follows rule 43: the connectors are tenant-level settings of a Sentinel instance the repository does not deploy.

##### 44 status

**Not adopted**, for the reason of rule 43.

### 45 — Threat hunting

```text
CAF security — Incorporate Zero Trust practices in your landing zone — recommendation 45
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/security-zero-trust (retrieved 2026-10-15)
Summary (ours): Plan regular threat-hunting exercises and a continuous improvement of the security posture.
```

#### What 45 means here

Threat hunting is a practice of a security operations team. The repository supplies what it reads — the activity log and the resource
diagnostics of each subscription in one workspace — and the configuration tree, which says what should exist where
([ADR-AZ-DATAMOD#2](../azure-data-model.md#rule-adr-az-datamod2)).

##### 45 status

**Not adopted**, because hunting is a practice of the tenant's security operations.

## Decision

The repository adopts the CAF security design area as a review list for its platform templates, `foundation` and `discovery`, item by item,
and records for each item what it does, what it plans, and what it does not adopt and why. Where the workload view decides an item, the rule
cites ADR-AZ-WAFSE and adds only what the landing zone changes. Every security control the landing zone owns is a resource of a template — a
policy assignment, a diagnostic setting, a Defender for Cloud plan — never a deploy-if-not-exists policy
([ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3)). Controls of the tenant (the directory, privileged access, conditional access, security
operations) are not adopted, because the repository deploys into subscriptions and owns nothing above them
([ADR-AZ-LZ#1](../landing-zones.md#rule-adr-az-lz1)). Every `partly realised` or `planned` status names the module, template, or config that
the change touches.

### How this is enforced

- `ci-infrastructure.yaml` runs `Assert-BicepTemplate` and `Build-Bicep` for `foundation`, `discovery`, and `expedition`, so every template
  compiles and every rendered parameters file satisfies its contract, including a Key Vault reference for the break-glass password
  ([ADR-AZ-DATAMOD#9](../azure-data-model.md#rule-adr-az-datamod9)).
- `key-vault.bicep` fixes RBAC authorization with no parameter to turn it off (rule 16).
- In Azure, the landing zone's three policy assignments deny or audit non-compliant resources, by `policy_enforcement`
  ([ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3)).
- Every deploy verifies its subscription against `azure.yml` through `-SubscriptionIdAssertIs`
  ([az-session-verification](../az-session-verification.md)).
- **Planned (follow-up):** the quality gate over the compiled templates of ADR-AZ-WAFSE, extended to the vault's purge protection, network
  access, and diagnostic setting (rules 17, 21, 22) and to the Defender for Cloud plans of `discovery` (rule 3). These are plans, not checks
  that run.

## Consequences

- The platform's security controls are reviewed in one place per concern: this record for the landing zone, ADR-AZ-WAFSE for the workload,
  with no analysis repeated between them.
- Per-subscription vaults and workspaces keep each customer's secrets and logs in its own subscription, at the cost of no single tenant-wide
  view; a tenant-wide security tool reads many workspaces.
- Closing the vault's network makes `foundation` depend on the hub's private DNS zone and on a subnet of the landing zone, which changes the
  deploy order of the two templates.
- Purge protection, once on, cannot be turned off, and a deleted vault's name stays taken until its retention ends.
- The tenant's administrators own the directory, privileged access, Sentinel, and incident response; the repository supplies the tags, the
  inventory, and the logs those processes read.
- Each item cites Microsoft's page and a retrieval date; when the vendor guidance changes, the summary and the takeaways are revisited
  together.
