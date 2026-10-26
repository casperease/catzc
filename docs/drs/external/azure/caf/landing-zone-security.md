# EDR: CAF security — Microsoft's landing-zone security recommendations, as the repository reads them

Binds to [`waf-security`](../waf/security.md) (the workload view of the same concerns; its rules are cited here, not repeated) and
[`landing-zones`](../../../azure/landing-zones.md) (the landing zone these recommendations apply to).

## Rules: EDR-AZ-CAF-SEC

Each rule is one of the area's 45 security recommendations, numbered in the order of the area's pages: 1 to 14 the security design area, 15
to 26 encryption and keys, and 27 to 45 Zero Trust. Every source line names the page under `https://learn.microsoft.com/en-us` and the
retrieval date; the sentence is the repository's own summary, never a quotation. The repository's decision on each recommendation is in the
rule it binds to.

### Rule EDR-AZ-CAF-SEC-R01

Produce access-control audit reports from the reporting features of Microsoft Entra ID.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/security (recommendation 1, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R02

Keep the activity logs in Azure Monitor Logs, and archive them to a storage account when they must be kept longer than two years.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/security (recommendation 2, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFMANAGEMENT](../../../azure/landing-zones.md#rule-adr-az-lz-cafmanagement),
[ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R03

Turn on the paid plans of Microsoft Defender for Cloud on every subscription, and use Azure Policy to keep them on.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/security (recommendation 3, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R04

Track drift in operating system patching with Azure Monitor Logs and Defender for Cloud.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/security (recommendation 4, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R05

Use Azure Policy to deploy virtual machine extensions, so every machine gets a compliant baseline configuration.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/security (recommendation 5, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R06

Use Azure Policy to watch the security configuration of virtual machines for drift.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/security (recommendation 6, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R07

Have the default configuration of every resource report its logs into a central Log Analytics workspace.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/security (recommendation 7, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFMANAGEMENT](../../../azure/landing-zones.md#rule-adr-az-lz-cafmanagement),
[ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R08

Drive real-time alerts from logs through a solution built on Azure Event Grid.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/security (recommendation 8, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFMANAGEMENT](../../../azure/landing-zones.md#rule-adr-az-lz-cafmanagement),
[ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R09

Use Azure Attestation to prove a virtual machine's boot chain, to release the disk keys of confidential virtual machines securely, and to
verify trusted execution environments.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/security (recommendation 9, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R10

Review each required service against the organisation's requirements together, for example whether it supports bring-your-own-key, close the
gaps found, and choose region pairs and disaster recovery regions that keep latency low.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/security (recommendation 10, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-ONEADDRESSSPACE](../../../azure/azure-network-model.md#rule-adr-az-network-oneaddressspace),
[ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R11

Plan how a service is assessed before it is allowed: its security configuration, monitoring, and alerts, and how it joins the systems in
place.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/security (recommendation 11, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-EVERYPILLAR](../../../azure/landing-zones.md#rule-adr-az-lz-everypillar),
[ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R12

Have an incident response plan for a service before the service goes to production.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/security (recommendation 12, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R13

Follow the Azure roadmaps so new security controls are adopted as they ship.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/security (recommendation 13, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R14

Apply a Zero Trust approach to access to the platform where it fits.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/security (recommendation 14, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-THREEBUILTINPOLICIES](../../../azure/landing-zones.md#rule-adr-az-lz-threebuiltinpolicies),
[ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R15

Spread the load over many vaults, a federated model, so no vault reaches its transaction limits.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/encryption-and-keys (recommendation 15, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R16

Authorise the Key Vault data plane with Azure RBAC rather than the older vault access policies.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/encryption-and-keys (recommendation 16, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R17

Create every vault with soft delete and purge protection turned on.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/encryption-and-keys (recommendation 17, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R18

Let only dedicated custom Entra ID roles permanently delete (purge) keys, secrets, and certificates.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/encryption-and-keys (recommendation 18, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R19

Automate the issuing and renewal of certificates with public certificate authorities.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/encryption-and-keys (recommendation 19, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R20

Rotate keys and certificates by an automated process.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/encryption-and-keys (recommendation 20, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-SQLENTRAADMINS](../../../azure/landing-zones.md#rule-adr-az-lz-sqlentraadmins),
[ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R21

Limit network access to a vault with its firewall and virtual network service endpoints.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/encryption-and-keys (recommendation 21, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFPRIVATEACCESS](../../../azure/azure-network-model.md#rule-adr-az-network-cafprivateaccess),
[ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R22

Audit how every vault's keys, certificates, and secrets are used in the platform's central Log Analytics workspace.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/encryption-and-keys (recommendation 22, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFMANAGEMENT](../../../azure/landing-zones.md#rule-adr-az-lz-cafmanagement),
[ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R23

Let application teams create their own vaults and hold privileged access to them, with Azure Policy keeping every vault's configuration
consistent and compliant.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/encryption-and-keys (recommendation 23, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R24

Use Microsoft-managed keys by default, and customer-managed keys only where a requirement calls for them.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/encryption-and-keys (recommendation 24, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R25

Do not keep application keys or secrets in one shared central vault (Managed HSM aside): many vaults shrink the blast radius, cut latency
and throttling, and follow the boundaries of the workloads.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/encryption-and-keys (recommendation 25, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R26

Never share a vault between applications or between environments, so no secret is shared across them.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/encryption-and-keys (recommendation 26, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R27

Plan identity management in Entra ID beyond Azure resources: federation with on-premises directories, Conditional Access, and signals from
the user, device, location, and behaviour that feed authorisation.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/security-zero-trust (recommendation 27, retrieved 2026-10-15)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant),
[ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R28

Deploy the landing zone with its own subscription for identity resources such as domain controllers.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/security-zero-trust (recommendation 28, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R29

Use Microsoft Entra managed identities wherever a service supports them.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/security-zero-trust (recommendation 29, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-SQLENTRAADMINS](../../../azure/landing-zones.md#rule-adr-az-lz-sqlentraadmins),
[ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R30

Plan the management of endpoints with Zero Trust practices, alongside the landing zone rather than inside it.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/security-zero-trust (recommendation 30, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R31

A pointer: devices and servers are covered by the Zero Trust infrastructure pillar.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/security-zero-trust (recommendation 31, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R32

Manage access to applications with Microsoft Defender for Cloud Apps.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/security-zero-trust (recommendation 32, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R33

Enforce application practices with the standard policies that Defender for Cloud Apps provides.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/security-zero-trust (recommendation 33, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R34

Onboard every application to the organisation's access practices, trusting self-hosted applications no more than third-party ones.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/security-zero-trust (recommendation 34, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R35

Use Microsoft Purview to govern data, protect it, and manage its risk.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/security-zero-trust (recommendation 35, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFTAGS](../../../azure/landing-zones.md#rule-adr-az-lz-caftags),
[ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R36

Apply the standard Azure landing zone policies, so non-compliant deployments are blocked and logging is enforced.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/security-zero-trust (recommendation 36, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-THREEBUILTINPOLICIES](../../../azure/landing-zones.md#rule-adr-az-lz-threebuiltinpolicies),
[ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R37

Grant highly privileged roles just in time through Privileged Identity Management in Entra ID.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/security-zero-trust (recommendation 37, retrieved 2026-10-15)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant),
[ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R38

Use the just-in-time access of Defender for Cloud for virtual machines.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/security-zero-trust (recommendation 38, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R39

Plan how each workload is monitored and managed on its own.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/security-zero-trust (recommendation 39, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFMANAGEMENT](../../../azure/landing-zones.md#rule-adr-az-lz-cafmanagement),
[ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R40

Deploy with the Zero Trust network variants of the landing-zone accelerators (portal, Bicep, Terraform).

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/security-zero-trust (recommendation 40, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R41

A pointer to the Zero Trust pattern for web applications, with Application Gateway in front of Azure Firewall.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/security-zero-trust (recommendation 41, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R42

Plan each workload's networking with the Zero Trust deployment plans for Azure.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/security-zero-trust (recommendation 42, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity),
[ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R43

Deploy Microsoft Sentinel as part of the Azure landing zone.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/security-zero-trust (recommendation 43, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R44

Plan how the signals of Entra ID and the Microsoft 365 tools are fed into the Sentinel workspace.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/security-zero-trust (recommendation 44, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-CAF-SEC-R45

Plan regular threat-hunting exercises and a continuous improvement of the security posture.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/security-zero-trust (recommendation 45, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

## Context

Microsoft's Cloud Adoption Framework (CAF) is its guidance for taking an organisation onto Azure. The security design area covers the
platform's security baseline (logging, Defender for Cloud, incident response), the encryption and key management of Key Vault, and the Zero
Trust approach to identity, endpoints, applications, data, infrastructure, and networks. The live text is published under the
[Microsoft Learn Terms of Use](https://learn.microsoft.com/en-us/legal/termsofuse), which grant no licence to copy it into a shared
repository, so nothing is quoted.

The [CAF reference](../../../../references/caf/index.md) lists every CAF record in this repository and the Microsoft pages each one cites.
