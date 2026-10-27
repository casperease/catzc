# EDR: CAF identity and access — Microsoft's landing-zone identity and access recommendations, as the repository reads them

Binds to [`waf-security`](../waf/security.md) (the workload view of identity,
[EDR-AZ-WAF-SE-SE05](../waf/security.md#rule-edr-az-waf-se-se05), whose analysis is cited here, not repeated),
[`caf-security`](landing-zone-security.md) (the platform's Key Vault and privileged-access rules), and
[`landing-zones`](../../../azure/landing-zones.md) (the SQL authentication of
[ADR-AZ-LZ-SQLENTRAADMINS](../../../azure/landing-zones.md#rule-adr-az-lz-sqlentraadmins)).

## Rules: EDR-AZ-CAF-IAM

Each rule is one of the area's 68 identity and access recommendations, numbered in the order of the area's pages: 1 to 22 active directory
and hybrid identity, 23 to 56 identity and access for landing zones, and 57 to 68 application access. Every source line names the page under
`https://learn.microsoft.com/en-us` and the retrieval date; the sentence is the repository's own summary, never a quotation. The
repository's decision on each recommendation is in the rule it binds to.

### Rule EDR-AZ-CAF-IAM-R01

Record which authentication provider each application relies on, and choose the identity services from that inventory with the help of the
identity architecture guidance.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity
(recommendation 1, retrieved 2026-10-14)

Binds to [ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R02

For applications that need legacy directory protocols, prefer a new Entra managed directory with the legacy protocols turned off over
extending an on-premises directory that keeps them on.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity
(recommendation 2, retrieved 2026-10-14)

Binds to [ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R03

Entra ID is globally redundant, but the managed directory service and a self-run directory are not; design them for resilience, considering
deployment to more than one region.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity
(recommendation 3, retrieved 2026-10-14)

Binds to [ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R04

When extending an on-premises directory into Azure, define each Azure region as a directory site with subnet objects for its address ranges,
so clients authenticate against directory servers in their own region.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity
(recommendation 4, retrieved 2026-10-14)

Binds to [ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R05

For access by guests, customers, or partners, decide between Entra B2B collaboration and Entra External ID.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity
(recommendation 5, retrieved 2026-10-14)

Binds to [ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R06

Do not route internal (intranet) access through Entra application proxy, because it adds latency.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity
(recommendation 6, retrieved 2026-10-14)

Binds to [ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R07

When Entra Connect is the synchronisation tool, keep a staging server in a second region for recovery, or spread it across availability
zones when there is only one region.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity
(recommendation 7, retrieved 2026-10-14)

Binds to [ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R08

When Entra Cloud Sync is the synchronisation tool, install at least three agents on separate servers spread over regions or availability
zones.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity
(recommendation 8, retrieved 2026-10-14)

Binds to [ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R09

Pick the synchronisation tool that fits the requirements, Entra Connect or Entra Cloud Sync.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity
(recommendation 9, retrieved 2026-10-14)

Binds to [ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R10

When AD FS is a requirement, deploy it in Azure by following Microsoft's AD FS deployment guide.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity
(recommendation 10, retrieved 2026-10-14)

Binds to [ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R11

When AD FS federates with Entra ID, keep password hash synchronisation as a fallback; Microsoft also advises moving off AD FS to Entra ID
authentication unless AD FS is truly needed.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity
(recommendation 11, retrieved 2026-10-14)

Binds to [ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R12

Publish web applications that use on-premises authentication to remote users through Entra application proxy, with no VPN; it is one
instance for the whole tenant, so application owners and the identity team configure it together.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity
(recommendation 12, retrieved 2026-10-14)

Binds to [ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R13

Check each workload against both the Windows Server directory and the Entra managed directory service before choosing one.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity
(recommendation 13, retrieved 2026-10-14)

Binds to [ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R14

Deploy directory server virtual machines or managed-directory replica sets into the identity platform subscription, under the platform
management group.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity
(recommendation 14, retrieved 2026-10-14)

Binds to [ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R15

Put the directory servers in their own subnet behind a network security group, with no direct path to the internet, and route to that subnet
only from applications that need identity services.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity
(recommendation 15, retrieved 2026-10-14)

Binds to [ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R16

Use Azure Virtual Network Manager network groups, filled by policy or by tags, so that only the virtual networks that need directory
services can reach the directory server subnet.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity
(recommendation 16, retrieved 2026-10-14)

Binds to [ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R17

Control-plane roles such as Contributor or Virtual Machine Contributor can run commands on directory servers; limit who holds them in the
identity subscription and keep broad roles from being inherited from above.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity
(recommendation 17, retrieved 2026-10-14)

Binds to [ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R18

When Azure Arc manages on-premises directory servers or identity servers, keep their Arc resources in the identity subscription under the
same strict access.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity
(recommendation 18, retrieved 2026-10-14)

Binds to [ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R19

Keep core applications in or near the region of the managed-directory replica sets; deploy the service in the core platform's region and
extend it with up to four more replica sets in peered virtual networks of one subscription.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity
(recommendation 19, retrieved 2026-10-14)

Binds to [ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R20

Spread directory servers over several regions and availability zones, or availability sets, for resilience.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity
(recommendation 20, retrieved 2026-10-14)

Binds to [ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R21

Weigh the Entra ID authentication methods (cloud only, hybrid, or on-premises) as part of identity planning.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity
(recommendation 21, retrieved 2026-10-14)

Binds to [ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R22

For Kerberos access to Azure Files, use Entra Kerberos rather than deploying directory servers in the cloud.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-active-directory-hybrid-identity
(recommendation 22, retrieved 2026-10-14)

Binds to [ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R23

Require Entra multi-factor authentication from every user with any rights in Azure, the platform, application subscriptions, and the tenant
alike, including readers; prefer phishing-resistant methods over SMS, email, or push.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (recommendation 23, retrieved
2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant),
[ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R24

Apply Entra Conditional Access to Azure users, with stricter policies for administrators, for example on location, trusted workstations, and
sign-in risk.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (recommendation 24, retrieved
2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant),
[ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R25

Turn on Microsoft Defender for Identity with sensors on the directory servers, on-premises and in Azure, and combine it with Conditional
Access to block risky sign-ins.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (recommendation 25, retrieved
2026-10-14)

Binds to [ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R26

Use Microsoft Sentinel over Azure Monitor, Entra ID, and Microsoft 365 logs for threat detection and response.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (recommendation 26, retrieved
2026-10-14)

Binds to [ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R27

Keep administration off everyday accounts: separate cloud-only accounts for highly privileged roles, and just-in-time elevation through PIM
or separate accounts for lesser management roles.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (recommendation 27, retrieved
2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant),
[ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R28

Do not assign roles to users directly, since a subscription has a limit on assignments; assign them to groups, manage membership through PIM
for groups and entitlement management, and use cloud-only groups for control-plane access so that a change in an on-premises directory
cannot grant it.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (recommendation 28, retrieved
2026-10-14)

Binds to [ADR-AZ-LZ-SQLENTRAADMINS](../../../azure/landing-zones.md#rule-adr-az-lz-sqlentraadmins),
[ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R29

Keep a small number of highly privileged emergency-access (break-glass) accounts, assigned to named people, with their credentials stored
safely, their use monitored, and their working regularly tested.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (recommendation 29, retrieved
2026-10-14)

Binds to [ADR-AZ-LZ-SQLENTRAADMINS](../../../azure/landing-zones.md#rule-adr-az-lz-sqlentraadmins),
[ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R30

Send the Entra ID sign-in and audit logs, through a diagnostic setting, to the central Log Analytics workspace in the management
subscription.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (recommendation 30, retrieved
2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant),
[ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R31

Control group membership through access packages of Entra ID Governance entitlement management, with approval flows and periodic reviews of
privileged members.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (recommendation 31, retrieved
2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant),
[ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R32

Manage the tenant's identity settings with the matching Entra built-in roles, such as Global Administrator (held by no more than five
people), Hybrid Identity Administrator, Security Administrator, and Application Administrator; the page's table maps settings to roles.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (recommendation 32, retrieved
2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant),
[ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R33

Do not use a more privileged Entra role for a task a less privileged one can do, for example User Administrator rather than Global
Administrator for managing users.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (recommendation 33, retrieved
2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant),
[ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R34

Restrict administrators to a part of the directory with administrative units, which also separates Microsoft 365 administration from Azure
administration without a second tenant.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (recommendation 34, retrieved
2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant),
[ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R35

Protect sensitive directory objects, such as service accounts and privileged groups, with restricted management administrative units, so
only designated administrators can change them and privileges cannot be escalated through them.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (recommendation 35, retrieved
2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant),
[ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R36

Use the same roles and the same assignment patterns in every workload landing zone, which simplifies administration and lowers the risk of
misconfiguration.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (recommendation 36, retrieved
2026-10-14)

Binds to [ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R37

Use Azure RBAC for access to data as well, for example in Key Vault, storage, and databases, and keep data-plane rights separate from
control-plane rights.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (recommendation 37, retrieved
2026-10-14)

Binds to [ADR-AZ-LZ-SQLENTRAADMINS](../../../azure/landing-zones.md#rule-adr-az-lz-sqlentraadmins),
[ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R38

Give a shared central Log Analytics workspace the resource-context permission model, so each team reads only the logs of the resources it
has rights to.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (recommendation 38, retrieved
2026-10-14)

Binds to [ADR-AZ-LZ-CAFMANAGEMENT](../../../azure/landing-zones.md#rule-adr-az-lz-cafmanagement),
[ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R39

Check whether built-in roles meet the requirement, combining several where they fit, and define a custom role only where the built-in ones
would grant more than least privilege allows.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (recommendation 39, retrieved
2026-10-14)

Binds to [ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R40

Many built-in roles overlap, so when a principal holds several assignments, check what they grant together.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (recommendation 40, retrieved
2026-10-14)

Binds to [ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R41

Watch Microsoft's announcements of new role definitions, because a new role may fit a need better than an existing one.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (recommendation 41, retrieved
2026-10-14)

Binds to [ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R42

The CAF reference landing zone defines custom roles beside the built-in ones, for the platform owner, the subscription owner, the
application owner, network operations, and security operations, each with its permitted and denied actions in the page's table; extend them
to match the organisation's split of responsibilities.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (recommendation 42, retrieved
2026-10-14)

Binds to [ADR-AZ-LZ-GOVERNANCELIMITS](../../../azure/landing-zones.md#rule-adr-az-lz-governancelimits),
[ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R43

When the platform team provisions a workload landing zone, the provisioning creates the security groups, the standard role assignments, and
the user-assigned managed identities the workload needs.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (recommendation 43, retrieved
2026-10-14)

Binds to [ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R44

Make landing-zone role assignments at a subscription or a resource group, below the management groups where the policies are assigned, so
that landing-zone owners act on their own but cannot change the policies that govern them.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (recommendation 44, retrieved
2026-10-14)

Binds to [ADR-AZ-LZ-GOVERNANCELIMITS](../../../azure/landing-zones.md#rule-adr-az-lz-governancelimits),
[ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R45

Give each workload landing zone its own groups and role assignments rather than generic groups shared across landing zones; people who need
access to several get it through Entra ID Governance.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (recommendation 45, retrieved
2026-10-14)

Binds to [ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R46

Assign roles to groups rather than users, so that access stays right as people join, move, and leave, and manage membership through Entra ID
Governance rather than by hand.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (recommendation 46, retrieved
2026-10-14)

Binds to [ADR-AZ-LZ-SQLENTRAADMINS](../../../azure/landing-zones.md#rule-adr-az-lz-sqlentraadmins),
[ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R47

Treat each environment of an application (development, test, production) as its own landing zone, with its own groups and role assignments,
and never share a managed identity or service principal between environments.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (recommendation 47, retrieved
2026-10-14)

Binds to [ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R48

Decide whether platform administrators need rights on workload landing zones; where they do, grant them just in time through PIM, with
approval and least privilege, never as standing access.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (recommendation 48, retrieved
2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant),
[ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R49

When delegating the right to assign roles, for example User Access Administrator or Role Based Access Control Administrator to a workload
team, delegate only what is needed and constrain it with conditions on which roles and which principal types may be assigned; keep Owner,
User Access Administrator, and RBAC Administrator themselves out of delegation, review existing privileged assignments for conditions, and
know the documented limits of conditions.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (recommendation 49, retrieved
2026-10-14)

Binds to [ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R50

The page's table shows an example structure: per application and environment, groups for owners, security administrators, data
administrators, and testers on that application's subscriptions; an Owner group for sandboxes; a PIM group for platform Contributor; and
tenant-wide groups for security operations, Conditional Access administrators, network operations, and FinOps (Billing Reader). Adapt it,
but always assign to a specific group in a specific landing zone.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (recommendation 50, retrieved
2026-10-14)

Binds to [ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R51

A policy assignment with a deploy-if-not-exists effect needs a managed identity: a system-assigned one receives its rights automatically, a
user-assigned one needs them granted by hand. Grant least privilege, directly to the identity rather than through a group, and use built-in
roles only.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (recommendation 51, retrieved
2026-10-14)

Binds to [ADR-AZ-LZ-THREEBUILTINPOLICIES](../../../azure/landing-zones.md#rule-adr-az-lz-threebuiltinpolicies),
[ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R52

Use Entra Privileged Identity Management so that each role holds only the minimum access it needs, in line with Zero Trust and least
privilege.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (recommendation 52, retrieved
2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant),
[ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R53

Run recurring access reviews of resource entitlements through Privileged Identity Management.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (recommendation 53, retrieved
2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant),
[ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R54

Give privileged automation, such as runbooks and deployment pipelines, the same governance as privileged people, and make sure a workload's
pipeline cannot be used to raise the privileges of the team that owns it.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (recommendation 54, retrieved
2026-10-14)

Binds to [ADR-AZ-DATAMOD-JOINSINPOWERSHELL](../../../azure/azure-data-model.md#rule-adr-az-datamod-joinsinpowershell),
[ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R55

Put highly privileged roles such as Owner and User Access Administrator on subscriptions and management groups behind PIM for groups, for
example a standing least-privileged administrators group and an eligible owners group that is activated on demand.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (recommendation 55, retrieved
2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant),
[ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R56

Attach Conditional Access requirements, such as phishing-resistant multi-factor authentication, to sensitive permissions through protected
actions.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones (recommendation 56, retrieved
2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant),
[ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R57

CI/CD pipelines, in GitHub or Azure DevOps, should sign in to Azure with OpenID Connect workload identity federation, which issues
short-lived tokens and needs no stored secret; only where it is not supported, fall back to a service principal with a credential.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-application-access (recommendation 57,
retrieved 2026-10-14)

Binds to [ADR-AZ-DATAMOD-JOINSINPOWERSHELL](../../../azure/azure-data-model.md#rule-adr-az-datamod-joinsinpowershell),
[ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R58

Narrow data access further with attribute-based access control conditions where the service supports them, for example on Blob Storage.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-application-access (recommendation 58,
retrieved 2026-10-14)

Binds to [ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R59

Where possible, sign in to Linux and Windows virtual machines with Entra ID identities instead of local accounts, which brings Conditional
Access, multi-factor authentication, and audit.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-application-access (recommendation 59,
retrieved 2026-10-14)

Binds to [ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R60

Use managed identities for access between Azure resources, so that no credential is needed.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-application-access (recommendation 60,
retrieved 2026-10-14)

Binds to [ADR-AZ-LZ-SQLENTRAADMINS](../../../azure/landing-zones.md#rule-adr-az-lz-sqlentraadmins),
[ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R61

Give each application instance and environment its own credentials and identities, and never reuse a production identity in development or
test.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-application-access (recommendation 61,
retrieved 2026-10-14)

Binds to [ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R62

Where managed identities are needed at scale, such as the Azure Monitor Agent on many virtual machines, use one user-assigned identity per
resource type and region, assigned by Azure Policy, to avoid churn of identities.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-application-access (recommendation 62,
retrieved 2026-10-14)

Binds to [ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R63

Keep application secrets, keys, and certificates in Key Vault, authorize both its data plane and its control plane through Azure RBAC, and
let applications reach it with managed identities.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-application-access (recommendation 63,
retrieved 2026-10-14)

Binds to [ADR-AZ-LZ-SQLENTRAADMINS](../../../azure/landing-zones.md#rule-adr-az-lz-sqlentraadmins),
[ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R64

Use a separate key vault for each application environment in each region, governed by RBAC and deployed in the workload landing zone.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-application-access (recommendation 64,
retrieved 2026-10-14)

Binds to [ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R65

Expose web applications that use on-premises authentication through Entra application proxy; configuring it needs Application Administrator,
so either the platform team does it for application owners, or the owners automate it through Microsoft Graph from a pipeline with the right
privileges.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-application-access (recommendation 65,
retrieved 2026-10-14)

Binds to [ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R66

Applications that use legacy protocols such as Kerberos need a network path from their landing zone to the directory servers in the identity
subscription.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-application-access (recommendation 66,
retrieved 2026-10-14)

Binds to [ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R67

Cloud-native applications should use the Microsoft identity platform, which is OpenID Connect compliant, as their identity provider, for
work and school accounts, personal Microsoft accounts, and social or local accounts.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-application-access (recommendation 67,
retrieved 2026-10-14)

Binds to [ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-CAF-IAM-R68

Follow the Microsoft identity platform's checklist of best practices when integrating an application.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-application-access (recommendation 68,
retrieved 2026-10-14)

Binds to [ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

## Context

Microsoft's Cloud Adoption Framework (CAF) is its guidance for taking an organisation onto Azure. The identity and access design area covers
the directory services and hybrid identity behind the platform, who may do what in the landing zones (authentication, administrative
accounts, role-based access, privileged access, and the identities of automation), and how applications authenticate. The live text is
published under the [Microsoft Learn Terms of Use](https://learn.microsoft.com/en-us/legal/termsofuse), which grant no licence to copy it
into a shared repository, so nothing is quoted.

The [CAF reference](../../../../references/caf/index.md) lists every CAF record in this repository and the Microsoft pages each one cites.
