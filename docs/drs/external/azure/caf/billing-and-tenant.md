# EDR: CAF billing and tenant — Microsoft's billing and Entra tenant design recommendations, as the repository reads them

Binds to [`landing-zones`](../../../azure/landing-zones.md) (the landing zone that stops at the subscription),
[`data-model`](../../../azure/azure-data-model.md) (the tenants and subscriptions in `azure.yml`), and
[`customer-model`](../../../azure/azure-customer-model.md) (customers separated by subscription).

## Rules: EDR-AZ-CAF-BILL

Each rule is one of Microsoft's sixty-one billing and tenant recommendations, numbered in the order the area's pages list them (Enterprise
Agreement 1–15, Microsoft Customer Agreement 16–24, Cloud Solution Provider 25–33, Entra tenants 34–42, multitenant considerations 43–57,
Azure Lighthouse 58–61). Every source line names the page under `https://learn.microsoft.com/en-us` and the retrieval date; the sentence is
the repository's own summary, never a quotation. The repository's decision on each recommendation is in the rule it binds to.

### Rule EDR-AZ-CAF-BILL-R01

Make creating and managing subscriptions an automated, self-service process: subscription vending, for an Enterprise Agreement (EA).

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-enterprise-agreement (recommendation 1, retrieved
2026-10-14)

Binds to [ADR-AZ-LZ-LANDINGZONE](../../../azure/landing-zones.md#rule-adr-az-lz-landingzone) and
[ADR-AZ-LZ-CAFPRINCIPLES](../../../azure/landing-zones.md#rule-adr-az-lz-cafprinciples).

### Rule EDR-AZ-CAF-BILL-R02

Give every EA role a work or school (Entra) account, never a personal Microsoft account.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-enterprise-agreement (recommendation 2, retrieved
2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R03

Set the enrollment's notification contact to a shared group mailbox.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-enterprise-agreement (recommendation 3, retrieved
2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R04

Shape EA departments and accounts after the organisation (by function, division, geography, or a mix) to split billing.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-enterprise-agreement (recommendation 4, retrieved
2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R05

Use Cost Management's reports and views to analyse spend, sliced by Azure metadata such as tags and location.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-enterprise-agreement (recommendation 5, retrieved
2026-10-14)

Binds to [ADR-AZ-LZ-COSTATTRIBUTION](../../../azure/landing-zones.md#rule-adr-az-lz-costattribution) and
[ADR-AZ-LZ-LANDINGZONEPOLICIES](../../../azure/landing-zones.md#rule-adr-az-lz-landingzonepolicies).

### Rule EDR-AZ-CAF-BILL-R06

Restrict EA account owners to a few people, because each one gains administrative reach over subscriptions and resources.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-enterprise-agreement (recommendation 6, retrieved
2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R07

Give each EA department and account a budget, with an alert on it.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-enterprise-agreement (recommendation 7, retrieved
2026-10-14)

Binds to [ADR-AZ-LZ-COSTATTRIBUTION](../../../azure/landing-zones.md#rule-adr-az-lz-costattribution).

### Rule EDR-AZ-CAF-BILL-R08

Create a separate IT department in the enrollment only where a business unit genuinely runs its own IT.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-enterprise-agreement (recommendation 8, retrieved
2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R09

With several tenants, make each account owner a member of the tenant its account's subscriptions are created in.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-enterprise-agreement (recommendation 9, retrieved
2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R10

Run development and test workloads on the Enterprise Dev/Test offer where it is available, within its terms of use.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-enterprise-agreement (recommendation 10,
retrieved 2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R11

Read and act on the mail sent to the enrollment's notification address, because Microsoft uses it for important prompts.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-enterprise-agreement (recommendation 11,
retrieved 2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R12

Do not move, rename, or delete the Entra user behind an EA enrollment account.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-enterprise-agreement (recommendation 12,
retrieved 2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R13

Review regularly who has access in Cost Management, and keep personal Microsoft accounts out of it.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-enterprise-agreement (recommendation 13,
retrieved 2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R14

Turn on charge visibility for both department admins and account owners on every enrollment, so authorised users can see Cost Management
data.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-enterprise-agreement (recommendation 14,
retrieved 2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R15

Treat anyone who can create subscriptions from the enrollment as privileged, and protect them with multifactor authentication (MFA) like
other privileged accounts.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-enterprise-agreement (recommendation 15,
retrieved 2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R16

As for an EA, automate creating and managing subscriptions as a self-service vending process, for a Microsoft Customer Agreement (MCA).

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-microsoft-customer-agreement (recommendation 16,
retrieved 2026-10-14)

Binds to [ADR-AZ-LZ-LANDINGZONE](../../../azure/landing-zones.md#rule-adr-az-lz-landingzone) and
[ADR-AZ-LZ-CAFPRINCIPLES](../../../azure/landing-zones.md#rule-adr-az-lz-cafprinciples).

### Rule EDR-AZ-CAF-BILL-R17

Route the MCA billing account's notifications to a group mailbox.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-microsoft-customer-agreement (recommendation 17,
retrieved 2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R18

Give each invoice section or billing profile a budget with an alert.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-microsoft-customer-agreement (recommendation 18,
retrieved 2026-10-14)

Binds to [ADR-AZ-LZ-COSTATTRIBUTION](../../../azure/landing-zones.md#rule-adr-az-lz-costattribution).

### Rule EDR-AZ-CAF-BILL-R19

Map the organisation's structure onto the MCA hierarchy; invoice sections fit most cases.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-microsoft-customer-agreement (recommendation 19,
retrieved 2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R20

Give a business unit that runs its own IT its own invoice section.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-microsoft-customer-agreement (recommendation 20,
retrieved 2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R21

Watch the MCA contact mailbox, because it carries important prompts from Microsoft.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-microsoft-customer-agreement (recommendation 21,
retrieved 2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R22

Review the billing role assignments on the agreement on a regular schedule.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-microsoft-customer-agreement (recommendation 22,
retrieved 2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R23

Put non-production on the MCA dev/test plan where it is available, within its terms.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-microsoft-customer-agreement (recommendation 23,
retrieved 2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R24

Require MFA for every identity that can create subscriptions on any MCA billing level, as for all privileged accounts.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-microsoft-customer-agreement (recommendation 24,
retrieved 2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R25

Have a Cloud Solution Provider (CSP) partner reach the organisation's resources for support through Azure Lighthouse.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-cloud-solution-provider (recommendation 25,
retrieved 2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R26

Partners should hold granular delegated admin privileges (GDAP) rather than the broad, older delegated admin privileges.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-cloud-solution-provider (recommendation 26,
retrieved 2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R27

Apply Partner Center's security best practices for customers.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-cloud-solution-provider (recommendation 27,
retrieved 2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R28

The partner should apply Partner Center's security best practices for CSP partners.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-cloud-solution-provider (recommendation 28,
retrieved 2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R29

Agree with the partner how support cases are raised and escalated.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-cloud-solution-provider (recommendation 29,
retrieved 2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R30

Agree with the partner how subscriptions will be created on a self-service basis.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-cloud-solution-provider (recommendation 30,
retrieved 2026-10-14)

Binds to [ADR-AZ-LZ-LANDINGZONE](../../../azure/landing-zones.md#rule-adr-az-lz-landingzone).

### Rule EDR-AZ-CAF-BILL-R31

Use Cost Management's reports and views, filtered by tags and location, to analyse CSP spend.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-cloud-solution-provider (recommendation 31,
retrieved 2026-10-14)

Binds to [ADR-AZ-LZ-COSTATTRIBUTION](../../../azure/landing-zones.md#rule-adr-az-lz-costattribution) and
[ADR-AZ-LZ-LANDINGZONEPOLICIES](../../../azure/landing-zones.md#rule-adr-az-lz-landingzonepolicies).

### Rule EDR-AZ-CAF-BILL-R32

Protect every identity that can create CSP subscriptions with MFA.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-cloud-solution-provider (recommendation 32,
retrieved 2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R33

A CSP partner should create subscriptions in the organisation's own, well-defined Entra tenant, never in a tenant the partner manages.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-cloud-solution-provider (recommendation 33,
retrieved 2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R34

Add the organisation's own DNS names to the tenant; when synchronising with Entra Connect, check that the user principal names in
on-premises Active Directory use them.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-ad-define (recommendation 34, retrieved 2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R35

Decide how single sign-on works through Entra Connect, choosing one of its supported topologies.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-ad-define (recommendation 35, retrieved 2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R36

An organisation with no identity infrastructure starts cloud-only on Entra ID, adding Entra's managed directory service and Intune or EMS to
protect its SaaS, applications, and devices.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-ad-define (recommendation 36, retrieved 2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R37

Use Entra multifactor authentication, and enforce phishing-resistant MFA through Conditional Access on every privileged account.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-ad-define (recommendation 37, retrieved 2026-10-14)

Binds to [ADR-AZ-LZ-SQLENTRAADMINS](../../../azure/landing-zones.md#rule-adr-az-lz-sqlentraadmins) and
[ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R38

Keep emergency access (break-glass) accounts so the tenant cannot be locked out entirely.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-ad-define (recommendation 38, retrieved 2026-10-14)

Binds to [ADR-AZ-LZ-SQLENTRAADMINS](../../../azure/landing-zones.md#rule-adr-az-lz-sqlentraadmins).

### Rule EDR-AZ-CAF-BILL-R39

Manage privileged identities and their access through Entra Privileged Identity Management (PIM).

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-ad-define (recommendation 39, retrieved 2026-10-14)

Binds to [ADR-AZ-LZ-SQLENTRAADMINS](../../../azure/landing-zones.md#rule-adr-az-lz-sqlentraadmins) and
[ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R40

Send every Microsoft Entra diagnostic log to a central Azure Monitor Log Analytics workspace.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-ad-define (recommendation 40, retrieved 2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant) and
[ADR-AZ-LZ-CAFMANAGEMENT](../../../azure/landing-zones.md#rule-adr-az-lz-cafmanagement).

### Rule EDR-AZ-CAF-BILL-R41

Keep one tenant per organisation unless a concrete business need requires more, because each extra tenant adds management effort and
security risk; a note points to the landing zone testing approach for anyone considering a separate test tenant.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-ad-define (recommendation 41, retrieved 2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant) and
[ADR-AZ-DATAMOD-SCHEMAANDINTEGRITY](../../../azure/azure-data-model.md#rule-adr-az-datamod-schemaandintegrity).

### Rule EDR-AZ-CAF-BILL-R42

Give partners and other third parties access to resources in the organisation's tenant, and centralise access across tenants, through Azure
Lighthouse.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-ad-define (recommendation 42, retrieved 2026-10-14)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R43

Use the organisation's one corporate tenant by default, and add a tenant only for a requirement it genuinely cannot meet.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/multi-tenant/considerations-recommendations (recommendation 43,
retrieved 2026-10-15)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant),
[ADR-AZ-CUSTOMER-TWOBINDINGS](../../../azure/azure-customer-model.md#rule-adr-az-customer-twobindings) and
[ADR-AZ-LZ-HUBANDSPOKE](../../../azure/landing-zones.md#rule-adr-az-lz-hubandspoke).

### Rule EDR-AZ-CAF-BILL-R44

Give workload teams safe, isolated room to experiment as sandbox subscriptions inside the same tenant, not as separate tenants.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/multi-tenant/considerations-recommendations (recommendation 44,
retrieved 2026-10-15)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant) and
[ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION](../../../azure/azure-data-model.md#rule-adr-az-datamod-onefileonesubscription).

### Rule EDR-AZ-CAF-BILL-R45

Build integrations of operational tools that span tenants (an IT service management tool, for example) as multitenant Entra applications.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/multi-tenant/considerations-recommendations (recommendation 45,
retrieved 2026-10-15)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R46

An independent software vendor (ISV) should read the landing zone guidance written for ISVs.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/multi-tenant/considerations-recommendations (recommendation 46,
retrieved 2026-10-15)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R47

Simplify management across tenants with Azure Lighthouse.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/multi-tenant/considerations-recommendations (recommendation 47,
retrieved 2026-10-15)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R48

Create the EA and MCA account owners, invoice-section owners, and subscription creators in the destination tenant, so that new subscriptions
are born there and never need a change of directory afterwards.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/multi-tenant/considerations-recommendations (recommendation 48,
retrieved 2026-10-15)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant) and
[ADR-AZ-SESSION-CONFIGDEFINESCORRECT](../../../azure/az-session-verification.md#rule-adr-az-session-configdefinescorrect).

### Rule EDR-AZ-CAF-BILL-R49

Follow the Microsoft Entra security operations guide.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/multi-tenant/considerations-recommendations (recommendation 49,
retrieved 2026-10-15)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R50

Keep fewer than five Global Administrator accounts.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/multi-tenant/considerations-recommendations (recommendation 50,
retrieved 2026-10-15)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R51

Manage every admin account through PIM, with no standing privilege and just-in-time elevation.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/multi-tenant/considerations-recommendations (recommendation 51,
retrieved 2026-10-15)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R52

Require an approval in PIM before a critical role such as Global Administrator activates, ideally from approvers in more than one team.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/multi-tenant/considerations-recommendations (recommendation 52,
retrieved 2026-10-15)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R53

Notify the relevant people whenever the Global Administrator role is activated.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/multi-tenant/considerations-recommendations (recommendation 53,
retrieved 2026-10-15)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R54

Keep the setting that lets Global Administrators elevate themselves over all Azure resources off unless it is needed; a callout repeats
Microsoft's least-privilege advice for the Global Administrator role.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/multi-tenant/considerations-recommendations (recommendation 54,
retrieved 2026-10-15)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R55

To ease work across tenants, configure B2B collaboration, B2B direct connect, cross-tenant access settings, cross-tenant synchronisation,
and the multitenant organisation feature.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/multi-tenant/considerations-recommendations (recommendation 55,
retrieved 2026-10-15)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R56

An organisation with tenants in several Microsoft clouds (commercial, the China cloud, government) configures the B2B settings between
clouds.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/multi-tenant/considerations-recommendations (recommendation 56,
retrieved 2026-10-15)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R57

Workload teams building multitenant applications should read the Architecture Center's guidance on multitenant solutions.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/multi-tenant/considerations-recommendations (recommendation 57,
retrieved 2026-10-15)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R58

Read the guidance on Azure Lighthouse in enterprise scenarios.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/multi-tenant/lighthouse (recommendation 58, retrieved
2026-10-15)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R59

An ISV should read the guidance on Azure Lighthouse in ISV scenarios.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/multi-tenant/lighthouse (recommendation 59, retrieved
2026-10-15)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R60

Delegate with Azure Lighthouse in both directions between tenants, which for many tasks removes the need for B2B guest accounts and
duplicate accounts.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/multi-tenant/lighthouse (recommendation 60, retrieved
2026-10-15)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-BILL-R61

Make Lighthouse delegations eligible through PIM rather than permanent; only the managing tenant needs Entra ID P2 for it.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/multi-tenant/lighthouse (recommendation 61, retrieved
2026-10-15)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

## Context

Microsoft's Cloud Adoption Framework (CAF) is its guidance for adopting Azure across an organisation. The billing and tenant design area
covers how the organisation pays for Azure (an Enterprise Agreement, a Microsoft Customer Agreement, or a Cloud Solution Provider partner),
how subscriptions are created and budgeted, and how the Microsoft Entra tenants behind them are defined, secured, and, where unavoidable,
multiplied. The live text is published under the [Microsoft Learn Terms of Use](https://learn.microsoft.com/en-us/legal/termsofuse), which
grant no licence to copy it into a shared repository, so nothing is quoted.

The [CAF reference](../../../../references/caf/index.md) lists every CAF record in this repository and the Microsoft pages each one cites.
