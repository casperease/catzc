# ADR: CAF billing and tenant — what the repository does about each of Microsoft's billing and Entra tenant design recommendations

Pairs with [`landing-zones`](../landing-zones.md) (the landing zone that stops at the subscription), [`data-model`](../azure-data-model.md)
(the tenants and subscriptions in `azure.yml`), and [`customer-model`](../azure-customer-model.md) (customers separated by subscription).

## Rules: ADR-AZ-CAF-BILL

### Rule ADR-AZ-CAF-BILL-VENDSUBSCRIPTIONSASSELFSERVICECAPABILITYEA

Partly realised: a subscription is onboarded by pull request, as
[ADR-AZ-CAF-RESORG-SUBSCRIPTIONVENDINGPROCESS](resource-organization.md#rule-adr-az-caf-resorg-subscriptionvendingprocess) records; creating
it from an Enterprise Agreement enrollment is not adopted, because the repository holds no billing role.

- [1 — Vend subscriptions as a self-service capability (EA)](#1--vend-subscriptions-as-a-self-service-capability-ea)

### Rule ADR-AZ-CAF-BILL-USEWORKORSCHOOLACCOUNTSEVERYEAROLE

Not adopted, because the repository administers no enrollment account; every identity it names is an Entra object of the one tenant.

- [2 — Use work or school accounts for every EA role](#2--use-work-or-school-accounts-for-every-ea-role)

### Rule ADR-AZ-CAF-BILL-SENDEANOTIFICATIONSGROUPMAILBOX

Not adopted, because the enrollment's notification contact is billing administration above the repository; its budget alerts go to the
subscription's `Owner` role.

- [3 — Send EA notifications to a group mailbox](#3--send-ea-notifications-to-a-group-mailbox)

### Rule ADR-AZ-CAF-BILL-MODELORGANISATIONEADEPARTMENTSACCOUNTS

Not adopted, because departments and accounts are billing structure above the subscriptions the repository is given.

- [4 — Model the organisation with EA departments and accounts](#4--model-the-organisation-with-ea-departments-and-accounts)

### Rule ADR-AZ-CAF-BILL-ANALYSECOSTBYTAGLOCATION

Partly realised: every resource carries the CAF tags and lands in its environment's one region, so Cost Management can slice spend by tag
and location; the resource groups that `Deploy-Bicep` creates carry no CAF tags, which is planned.

- [5 — Analyse cost by tag and location](#5--analyse-cost-by-tag-and-location)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AZ-CAF-BILL-KEEPEAACCOUNTOWNERSFEW

Not adopted, because EA account owners are billing roles the repository neither grants nor holds.

- [6 — Keep EA account owners few](#6--keep-ea-account-owners-few)

### Rule ADR-AZ-CAF-BILL-BUDGETEVERYEADEPARTMENTACCOUNT

Not adopted at department and account level, because the repository holds no billing role; it budgets each subscription instead
([ADR-AZ-CAF-GOV-OVERSEESPENDCOSTMANAGEMENT](governance.md#rule-adr-az-caf-gov-overseespendcostmanagement)).

- [7 — Budget every EA department and account](#7--budget-every-ea-department-and-account)

### Rule ADR-AZ-CAF-BILL-ADDITDEPARTMENTONLYWHEREBUSINESSUNITRUNSOWNIT

Not adopted, because departments are billing structure above the repository.

- [8 — Add an IT department only where a business unit runs its own IT](#8--add-an-it-department-only-where-a-business-unit-runs-its-own-it)

### Rule ADR-AZ-CAF-BILL-KEEPACCOUNTOWNERSTENANTTHEIRSUBSCRIPTIONS

Not adopted, because account owners are set on the enrollment; the repository declares the one tenant every subscription lives in.

- [9 — Keep account owners in the tenant of their subscriptions](#9--keep-account-owners-in-the-tenant-of-their-subscriptions)

### Rule ADR-AZ-CAF-BILL-USEENTERPRISEDEVTESTOFFERNONPRODUCTION

Not adopted, because the offer is chosen when a subscription is created, outside the repository.

- [10 — Use the Enterprise Dev/Test offer for non-production](#10--use-the-enterprise-devtest-offer-for-non-production)

### Rule ADR-AZ-CAF-BILL-ACTEANOTIFICATIONMAIL

Not adopted, because the notification mailbox belongs to billing administration above the repository.

- [11 — Act on EA notification mail](#11--act-on-ea-notification-mail)

### Rule ADR-AZ-CAF-BILL-LEAVEENTRAUSERENROLLMENTACCOUNTUNTOUCHED

Not adopted, because the repository manages no Entra user, the one behind an enrollment account included.

- [12 — Leave the Entra user of an enrollment account untouched](#12--leave-the-entra-user-of-an-enrollment-account-untouched)

### Rule ADR-AZ-CAF-BILL-AUDITWHOCANREACHCOSTMANAGEMENT

Not adopted, because access to Cost Management at billing level is granted and reviewed above the repository.

- [13 — Audit who can reach Cost Management](#13--audit-who-can-reach-cost-management)

### Rule ADR-AZ-CAF-BILL-LETDEPARTMENTADMINSACCOUNTOWNERSSEECHARGES

Not adopted, because charge visibility is an enrollment setting above the repository.

- [14 — Let department admins and account owners see charges](#14--let-department-admins-and-account-owners-see-charges)

### Rule ADR-AZ-CAF-BILL-PROTECTEASUBSCRIPTIONCREATORSMFA

Not adopted, because the repository grants no right to create subscriptions and protects no identity's sign-in.

- [15 — Protect EA subscription creators with MFA](#15--protect-ea-subscription-creators-with-mfa)

### Rule ADR-AZ-CAF-BILL-VENDSUBSCRIPTIONSASSELFSERVICECAPABILITYMCA

Partly realised, as [1](#rule-adr-az-caf-bill-vendsubscriptionsasselfservicecapabilityea): onboarding by pull request; creating the
subscription from a Microsoft Customer Agreement is not adopted.

- [16 — Vend subscriptions as a self-service capability (MCA)](#16--vend-subscriptions-as-a-self-service-capability-mca)

### Rule ADR-AZ-CAF-BILL-SENDMCANOTIFICATIONSGROUPMAILBOX

Not adopted, because the billing account's notification contact is administration above the repository.

- [17 — Send MCA notifications to a group mailbox](#17--send-mca-notifications-to-a-group-mailbox)

### Rule ADR-AZ-CAF-BILL-BUDGETEVERYINVOICESECTIONORBILLINGPROFILE

Not adopted at invoice-section and billing-profile level, because the repository holds no billing role; it budgets each subscription
instead.

- [18 — Budget every invoice section or billing profile](#18--budget-every-invoice-section-or-billing-profile)

### Rule ADR-AZ-CAF-BILL-MAPORGANISATIONONTOMCAHIERARCHY

Not adopted, because the MCA hierarchy is billing structure above the repository.

- [19 — Map the organisation onto the MCA hierarchy](#19--map-the-organisation-onto-the-mca-hierarchy)

### Rule ADR-AZ-CAF-BILL-GIVEBUSINESSUNITOWNITOWNINVOICESECTION

Not adopted, because invoice sections are billing structure above the repository.

- [20 — Give a business unit with its own IT its own invoice section](#20--give-a-business-unit-with-its-own-it-its-own-invoice-section)

### Rule ADR-AZ-CAF-BILL-ACTMCANOTIFICATIONMAIL

Not adopted, because the contact mailbox belongs to billing administration above the repository.

- [21 — Act on MCA notification mail](#21--act-on-mca-notification-mail)

### Rule ADR-AZ-CAF-BILL-AUDITBILLINGROLEASSIGNMENTSAGREEMENT

Not adopted, because billing role assignments are made and reviewed above the repository.

- [22 — Audit billing role assignments on the agreement](#22--audit-billing-role-assignments-on-the-agreement)

### Rule ADR-AZ-CAF-BILL-USEMCADEVTESTPLANNONPRODUCTION

Not adopted, because the offer is chosen when a subscription is created, outside the repository.

- [23 — Use the MCA dev/test plan for non-production](#23--use-the-mca-devtest-plan-for-non-production)

### Rule ADR-AZ-CAF-BILL-PROTECTMCASUBSCRIPTIONCREATORSMFA

Not adopted, because the repository grants no right to create subscriptions and protects no identity's sign-in.

- [24 — Protect MCA subscription creators with MFA](#24--protect-mca-subscription-creators-with-mfa)

### Rule ADR-AZ-CAF-BILL-HAVECSPPARTNERUSEAZURELIGHTHOUSESUPPORTACCESS

Not adopted, because the repository's subscriptions come from no CSP partner and it delegates no access across tenants.

- [25 — Have the CSP partner use Azure Lighthouse for support access](#25--have-the-csp-partner-use-azure-lighthouse-for-support-access)

### Rule ADR-AZ-CAF-BILL-HAVEPARTNERHOLDGRANULARDELEGATEDADMINPRIVILEGES

Not adopted, because partner admin privileges are granted between organisations, above the repository.

- [26 — Have the partner hold granular delegated admin privileges](#26--have-the-partner-hold-granular-delegated-admin-privileges)

### Rule ADR-AZ-CAF-BILL-APPLYCUSTOMERSECURITYBESTPRACTICES

Not adopted, because Partner Center's customer security practices concern tenant administration above the repository.

- [27 — Apply the customer security best practices](#27--apply-the-customer-security-best-practices)

### Rule ADR-AZ-CAF-BILL-HAVEPARTNERAPPLYCSPSECURITYBESTPRACTICES

Not adopted, because the partner's own security practices are outside the repository.

- [28 — Have the partner apply the CSP security best practices](#28--have-the-partner-apply-the-csp-security-best-practices)

### Rule ADR-AZ-CAF-BILL-AGREEHOWSUPPORTCASESARERAISED

Not adopted, because support arrangements with a partner are outside the repository.

- [29 — Agree how support cases are raised](#29--agree-how-support-cases-are-raised)

### Rule ADR-AZ-CAF-BILL-AGREEHOWSELFSERVICESUBSCRIPTIONSARECREATED

Not adopted, because creating a subscription is outside the repository; onboarding a given one is
[1](#rule-adr-az-caf-bill-vendsubscriptionsasselfservicecapabilityea).

- [30 — Agree how self-service subscriptions are created](#30--agree-how-self-service-subscriptions-are-created)

### Rule ADR-AZ-CAF-BILL-ANALYSECSPCOSTBYTAGLOCATION

Partly realised, as [5](#rule-adr-az-caf-bill-analysecostbytaglocation): every resource carries the CAF tags and one region; CAF tags on the
resource groups `Deploy-Bicep` creates are planned.

- [31 — Analyse CSP cost by tag and location](#31--analyse-csp-cost-by-tag-and-location)

### Rule ADR-AZ-CAF-BILL-PROTECTCSPSUBSCRIPTIONCREATORSMFA

Not adopted, because the repository grants no right to create subscriptions and protects no identity's sign-in.

- [32 — Protect CSP subscription creators with MFA](#32--protect-csp-subscription-creators-with-mfa)

### Rule ADR-AZ-CAF-BILL-PROVISIONCSPSUBSCRIPTIONSINTOORGANISATIONSOWNTENANT

Not adopted, because the repository's subscriptions come from no CSP partner; they all sit in the one tenant `azure.yml` declares.

- [33 — Provision CSP subscriptions into the organisation's own tenant](#33--provision-csp-subscriptions-into-the-organisations-own-tenant)

### Rule ADR-AZ-CAF-BILL-REGISTERCUSTOMNAMESTENANT

Not adopted, because custom names and directory synchronisation are tenant administration above the repository.

- [34 — Register custom names on the tenant](#34--register-custom-names-on-the-tenant)

### Rule ADR-AZ-CAF-BILL-DECIDESINGLESIGNAPPROACH

Not adopted, because single sign-on is tenant administration above the repository.

- [35 — Decide the single sign-on approach](#35--decide-the-single-sign-on-approach)

### Rule ADR-AZ-CAF-BILL-STARTCLOUDONLYWHENTHEREISNOIDENTITYESTATE

Not adopted, because the repository builds no identity estate; it uses the tenant it is given.

- [36 — Start cloud-only when there is no identity estate](#36--start-cloud-only-when-there-is-no-identity-estate)

### Rule ADR-AZ-CAF-BILL-REQUIREMFACONDITIONALACCESSPRIVILEGEDACCOUNTS

Not adopted, because MFA and Conditional Access are tenant configuration; the templates route SQL administration through an Entra group, so
the tenant's sign-in policies reach it, and only the break-glass login sits outside them.

- [37 — Require MFA and Conditional Access for privileged accounts](#37--require-mfa-and-conditional-access-for-privileged-accounts)

### Rule ADR-AZ-CAF-BILL-PLANEMERGENCYACCESSACCOUNTS

Not adopted for the tenant, because emergency accounts are tenant administration; each SQL server carries the same idea one level down, its
break-glass SQL login of [ADR-AZ-LZ-SQLENTRAADMINS](../landing-zones.md#rule-adr-az-lz-sqlentraadmins).

- [38 — Plan emergency access accounts](#38--plan-emergency-access-accounts)

### Rule ADR-AZ-CAF-BILL-GOVERNPRIVILEGEDACCESSPIM

Not adopted, because PIM is tenant configuration; the templates make SQL administrators a group, which PIM can govern without a change here.

- [39 — Govern privileged access with PIM](#39--govern-privileged-access-with-pim)

### Rule ADR-AZ-CAF-BILL-STREAMENTRALOGSCENTRALWORKSPACE

Not adopted, because Entra's diagnostic settings are made at tenant level, where the repository deploys nothing; `foundation`'s workspace is
where they would go.

- [40 — Stream Entra logs to the central workspace](#40--stream-entra-logs-to-the-central-workspace)

### Rule ADR-AZ-CAF-BILL-AVOIDSEVERALTENANTS

Realised: `azure.yml` declares one tenant and every subscription names it; every deploy verifies the session's subscription against the
declaration, and a deploy-time check of its tenant is planned.

- [41 — Avoid several tenants](#41--avoid-several-tenants)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AZ-CAF-BILL-GRANTPARTNERACCESSAZURELIGHTHOUSE

Not adopted, because the repository grants no partner access across tenants.

- [42 — Grant partner access with Azure Lighthouse](#42--grant-partner-access-with-azure-lighthouse)

### Rule ADR-AZ-CAF-BILL-DEFAULTONETENANT

Realised: all customers share the one tenant and are separated by subscription ([ADR-AZ-CUSTOMER](../azure-customer-model.md)), and the
landing zone's joins across subscriptions rely on it.

- [43 — Default to one tenant](#43--default-to-one-tenant)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AZ-CAF-BILL-EXPERIMENTSANDBOXSUBSCRIPTIONSNOTTENANTS

Not adopted, because experiments run as a configuration slot of a non-production subscription; they stay inside the one tenant, which is the
recommendation's point.

- [44 — Experiment in sandbox subscriptions, not tenants](#44--experiment-in-sandbox-subscriptions-not-tenants)

### Rule ADR-AZ-CAF-BILL-INTEGRATETOOLSACROSSTENANTSASMULTITENANTAPPS

Not adopted, because the repository integrates no operational tool across tenants.

- [45 — Integrate tools across tenants as multitenant apps](#45--integrate-tools-across-tenants-as-multitenant-apps)

### Rule ADR-AZ-CAF-BILL-READISVLANDINGZONEGUIDANCE

Not adopted, because the repository is not an ISV offering; its customers are subscriptions in one tenant.

- [46 — Read the ISV landing zone guidance](#46--read-the-isv-landing-zone-guidance)

### Rule ADR-AZ-CAF-BILL-MANAGEACROSSTENANTSAZURELIGHTHOUSE

Not adopted, because the repository manages one tenant and nothing across tenants.

- [47 — Manage across tenants with Azure Lighthouse](#47--manage-across-tenants-with-azure-lighthouse)

### Rule ADR-AZ-CAF-BILL-KEEPSUBSCRIPTIONCREATORSDESTINATIONTENANT

Not adopted, because billing roles are set above the repository; it declares the tenant of every subscription, and a deploy-time check that
fails a subscription in another directory is planned.

- [48 — Keep subscription creators in the destination tenant](#48--keep-subscription-creators-in-the-destination-tenant)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AZ-CAF-BILL-FOLLOWENTRASECURITYOPERATIONSGUIDE

Not adopted, because security operations for the tenant are outside the repository.

- [49 — Follow the Entra security operations guide](#49--follow-the-entra-security-operations-guide)

### Rule ADR-AZ-CAF-BILL-KEEPGLOBALADMINISTRATORSFEW

Not adopted, because Global Administrators are tenant administration above the repository.

- [50 — Keep Global Administrators few](#50--keep-global-administrators-few)

### Rule ADR-AZ-CAF-BILL-PUTEVERYADMINACCOUNTUNDERPIM

Not adopted, because PIM is tenant configuration, as [39](#rule-adr-az-caf-bill-governprivilegedaccesspim).

- [51 — Put every admin account under PIM](#51--put-every-admin-account-under-pim)

### Rule ADR-AZ-CAF-BILL-REQUIREAPPROVALACTIVATECRITICALROLES

Not adopted, because PIM approval is tenant configuration.

- [52 — Require approval to activate critical roles](#52--require-approval-to-activate-critical-roles)

### Rule ADR-AZ-CAF-BILL-ALERTWHENGLOBALADMINISTRATORISACTIVATED

Not adopted, because alerting on Global Administrator activation is tenant configuration.

- [53 — Alert when Global Administrator is activated](#53--alert-when-global-administrator-is-activated)

### Rule ADR-AZ-CAF-BILL-LEAVEELEVATEDACCESSAZURERESOURCESOFF

Not adopted, because the elevation setting belongs to the tenant's Global Administrators; the repository needs no right above a
subscription.

- [54 — Leave elevated access to Azure resources off](#54--leave-elevated-access-to-azure-resources-off)

### Rule ADR-AZ-CAF-BILL-CONFIGURECROSSTENANTCOLLABORATIONFEATURES

Not adopted, because the repository works in one tenant and configures no cross-tenant collaboration.

- [55 — Configure cross-tenant collaboration features](#55--configure-cross-tenant-collaboration-features)

### Rule ADR-AZ-CAF-BILL-CONFIGURECROSSCLOUDCOLLABORATION

Not adopted, because the repository targets one tenant in one Microsoft cloud.

- [56 — Configure cross-cloud collaboration](#56--configure-cross-cloud-collaboration)

### Rule ADR-AZ-CAF-BILL-READMULTITENANTSOLUTIONGUIDANCE

Not adopted, because the example workload is deployed per customer subscription, not built as a multitenant application.

- [57 — Read the multitenant solution guidance](#57--read-the-multitenant-solution-guidance)

### Rule ADR-AZ-CAF-BILL-READLIGHTHOUSEENTERPRISEGUIDANCE

Not adopted, because the repository uses no Azure Lighthouse.

- [58 — Read the Lighthouse enterprise guidance](#58--read-the-lighthouse-enterprise-guidance)

### Rule ADR-AZ-CAF-BILL-READLIGHTHOUSEISVGUIDANCE

Not adopted, because the repository is not an ISV offering and uses no Azure Lighthouse.

- [59 — Read the Lighthouse ISV guidance](#59--read-the-lighthouse-isv-guidance)

### Rule ADR-AZ-CAF-BILL-DELEGATELIGHTHOUSEBOTHDIRECTIONS

Not adopted, because the repository delegates nothing between tenants.

- [60 — Delegate with Lighthouse in both directions](#60--delegate-with-lighthouse-in-both-directions)

### Rule ADR-AZ-CAF-BILL-MAKELIGHTHOUSEDELEGATIONSELIGIBLETHROUGHPIM

Not adopted, because the repository makes no Lighthouse delegation.

- [61 — Make Lighthouse delegations eligible through PIM](#61--make-lighthouse-delegations-eligible-through-pim)

## Context

Microsoft's Cloud Adoption Framework (CAF) is its guidance for adopting Azure across an organisation: strategy, planning, readiness,
governance, and operations. Its landing-zone guidance splits the platform an organisation builds into design areas, each with considerations
to weigh and design recommendations; the landing zone that a subscription receives here is CAF's application landing zone
([ADR-AZ-LZ-LANDINGZONE](../landing-zones.md#rule-adr-az-lz-landingzone)).

The billing and Microsoft Entra tenant design area covers the two decisions that sit above every deployment: which billing offer pays for
the subscriptions — an Enterprise Agreement (EA), a Microsoft Customer Agreement (MCA), or the Cloud Solution Provider (CSP) programme — and
which Entra tenant the offer and its subscriptions belong to ([area page][b]). How identities are managed inside the tenant belongs to the
identity and access design area. The three billing pages are alternatives, one per offer, so several of their recommendations repeat
(vending, the notification contact, budgets, MFA for subscription creators); each repeat is its own rule here and points at the first.

[b]: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-microsoft-entra-tenant

These rules are vendor recommendation, not principled theory. They do not argue from first principles the way the axioms and DORA's research
do; they record what the repository does about each of Microsoft's sixty-one recommendations in this area, numbered in the order of the
pages: EA (1–15), MCA (16–24), CSP (25–33), defining Entra tenants (34–42), multitenant landing zones (43–57), and Azure Lighthouse in
multitenant landing zones (58–61). Each rule cites Microsoft's page — area, page, section, link, retrieval date — and summarises it in our
own words, because the live CAF text is published under the Microsoft Learn Terms of Use, which grant no licence to copy it into a shared
repository. Nothing is quoted.

The [CAF reference](../../../references/caf/index.md) lists every CAF record in this repository and the Microsoft pages each one cites.

Most of the area sits above this repository. It deploys into subscriptions it is given and owns nothing at management-group or tenant level
([ADR-AZ-LZ-LANDINGZONE](../landing-zones.md#rule-adr-az-lz-landingzone)): it holds no billing role, chooses no offer, and administers no
Entra user, role, or sign-in policy. Those recommendations take the compact form below: why the item does not apply here, and what would
make it apply. What the repository does touch is the tenant and the subscriptions it declares in `azure.yml`
([ADR-AZ-DATAMOD-TWOCONFIGLAYERS](../azure-data-model.md#rule-adr-az-datamod-twoconfiglayers)), one tenant for every customer, with
customers separated by subscription ([ADR-AZ-CUSTOMER](../azure-customer-model.md)), one service connection per subscription in the CD
pipelines, the CAF tags that cost analysis reads, and the Entra administrator group and break-glass login of each SQL server. Those rules
take the full form.

The multitenant part of the area has two further pages without recommendations: one on automating landing zones across several tenants, and
one on keeping a separate canary tenant to try tenant-level changes before they reach production. They inform rules
[41](#41--avoid-several-tenants) and [43](#43--default-to-one-tenant): with one tenant, the repository needs one identity per subscription,
not per tenant, and it makes no tenant-level change that a canary tenant would test; its subscription-level changes reach non-production
before production through the CD pipelines.

The example basis is the repository's three templates: `foundation` (a Log Analytics workspace and a Key Vault per subscription),
`discovery` (the landing zone), and `expedition` (a workload that lands in it,
[ADR-AZ-LZ-WORKLOADOWNSNONE](../landing-zones.md#rule-adr-az-lz-workloadownsnone)). Every full-form takeaway below points at what those
three do, or says plainly what they do not.

### 1 — Vend subscriptions as a self-service capability (EA)

```text
CAF billing and tenant — Azure Enterprise Agreement enrollment design area guidance, Design recommendations — recommendation 1
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-enterprise-agreement
  (retrieved 2026-10-14)
Summary (ours): Make creating and managing subscriptions an automated, self-service process: subscription vending.
```

#### What 1 means here

The repository onboards a subscription it is given by pull request — an `azure.yml` entry, its range in `network.yml`, and one config per
once-per-subscription template — as
[ADR-AZ-CAF-RESORG-SUBSCRIPTIONVENDINGPROCESS](resource-organization.md#rule-adr-az-caf-resorg-subscriptionvendingprocess) sets out.
Creating the subscription from an enrollment account needs a billing role, which the repository does not hold. Holding one would be the
trigger to add a tenant-level subscription-creation template ahead of `foundation`.

##### 1 status

Partly realised — onboarding by pull request; creating the subscription is not adopted, because it needs a billing role.

### 2 — Use work or school accounts for every EA role

```text
CAF billing and tenant — Azure Enterprise Agreement enrollment design area guidance, Design recommendations — recommendation 2
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-enterprise-agreement
  (retrieved 2026-10-14)
Summary (ours): Give every EA role a work or school (Entra) account, never a personal Microsoft account.
```

#### What 2 means here

EA roles are assigned on the enrollment, which the repository never touches. The identities the repository does name — the Entra
administrator group of each SQL server, the service connection behind each subscription — are objects of the one tenant, so a personal
account has no place in them either.

##### 2 status

Not adopted, because the repository administers no enrollment account.

### 3 — Send EA notifications to a group mailbox

```text
CAF billing and tenant — Azure Enterprise Agreement enrollment design area guidance, Design recommendations — recommendation 3
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-enterprise-agreement
  (retrieved 2026-10-14)
Summary (ours): Set the enrollment's notification contact to a shared group mailbox.
```

#### What 3 means here

The enrollment's contact is billing administration. The repository's own cost alerts follow the same thought by other means: each landing
zone's budget alerts the holders of the subscription's `Owner` role, not a named person, so no address is kept in a config
([ADR-AZ-CAF-GOV-OVERSEESPENDCOSTMANAGEMENT](governance.md#rule-adr-az-caf-gov-overseespendcostmanagement)).

##### 3 status

Not adopted, because the notification contact is set on the enrollment, above the repository.

### 4 — Model the organisation with EA departments and accounts

```text
CAF billing and tenant — Azure Enterprise Agreement enrollment design area guidance, Design recommendations — recommendation 4
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-enterprise-agreement
  (retrieved 2026-10-14)
Summary (ours): Shape EA departments and accounts after the organisation (by function, division, geography, or a mix) to split billing.
```

#### What 4 means here

Departments and accounts group subscriptions for billing above them. The repository groups its own cost by subscription, one pair per
customer and one shared pair, and by the `cost-center` tag; an EA structure would sit above those subscriptions and need no change here.

##### 4 status

Not adopted, because departments and accounts are billing structure above the repository.

### 5 — Analyse cost by tag and location

```text
CAF billing and tenant — Azure Enterprise Agreement enrollment design area guidance, Design recommendations — recommendation 5
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-enterprise-agreement
  (retrieved 2026-10-14)
Summary (ours): Use Cost Management's reports and views to analyse spend, sliced by Azure metadata such as tags and location.
```

#### What 5 means here

Cost Management can slice only by what the resources carry. Every template takes the six CAF tags as one `tags` parameter from its config
and passes them to every resource: `cost-center` names the paying team, `workload` the project, `owner` and `environment` the rest
([ADR-AZ-CAF-GOV-TAGRESOURCESCOSTANALYSIS](governance.md#rule-adr-az-caf-gov-tagresourcescostanalysis)). Location is fixed per environment:
`azure.yml` gives each environment its one `region`, and the landing zone's allowed-locations policy keeps every resource of the
subscription there ([ADR-AZ-LZ-THREEBUILTINPOLICIES](../landing-zones.md#rule-adr-az-lz-threebuiltinpolicies)), so a view by location shows
one region per environment, with nothing stray.

The gap is the resource groups. `Deploy-Bicep` creates the resource group of a resource-group template (`foundation`, `expedition`) with the
deployment-provenance tags only, so a view grouped by a resource group's tags has nothing to read for those; the fix is planned under
[ADR-AZ-CAF-GOV-TAGRESOURCESCOSTANALYSIS](governance.md#rule-adr-az-caf-gov-tagresourcescostanalysis).

##### 5 in `foundation`

Tags its workspace and Key Vault from the config (for example `cost-center: platform` in `nsub.yml`, `cost-center: apex` in
`apex/psub.yml`); its resource group carries only the provenance tags.

##### 5 in `discovery`

Creates its own resource group through `infrastructure/modules/resource-group.bicep`, so the resource group and every resource in it carry
the CAF tags, and assigns the allowed-locations policy that keeps them in the region.

##### 5 in `expedition`

Tags every resource of each configuration slot (for example `cost-center: apex` in `apex/prod.yml`); each configuration slot's resource
group carries only the provenance tags.

##### 5 status

Partly realised — every resource is tagged and kept in one region; CAF tags on the resource groups `Deploy-Bicep` creates are planned
(follow-up).

### 6 — Keep EA account owners few

```text
CAF billing and tenant — Azure Enterprise Agreement enrollment design area guidance, Design recommendations — recommendation 6
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-enterprise-agreement
  (retrieved 2026-10-14)
Summary (ours): Restrict account owners to a few people, because each one gains administrative reach over subscriptions and resources.
```

#### What 6 means here

Account owners are billing roles granted on the enrollment. The repository grants no role to a person; its reach over each subscription is
the one service connection that deploys into it.

##### 6 status

Not adopted, because account owners are billing roles the repository neither grants nor holds.

### 7 — Budget every EA department and account

```text
CAF billing and tenant — Azure Enterprise Agreement enrollment design area guidance, Design recommendations — recommendation 7
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-enterprise-agreement
  (retrieved 2026-10-14)
Summary (ours): Give each department and account a budget, with an alert on it.
```

#### What 7 means here

A department or account budget is set on the enrollment. The repository budgets one level down: every landing zone deploys a monthly budget
for its subscription, alerting the subscription's `Owner` role at 50, 80, and 100 percent
([ADR-AZ-CAF-GOV-OVERSEESPENDCOSTMANAGEMENT](governance.md#rule-adr-az-caf-gov-overseespendcostmanagement)). An organisation that holds the
enrollment adds department budgets above those.

##### 7 status

Not adopted at department and account level, because the repository holds no billing role.

### 8 — Add an IT department only where a business unit runs its own IT

```text
CAF billing and tenant — Azure Enterprise Agreement enrollment design area guidance, Design recommendations — recommendation 8
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-enterprise-agreement
  (retrieved 2026-10-14)
Summary (ours): Create a separate IT department in the enrollment only where a business unit genuinely runs its own IT.
```

#### What 8 means here

Departments are billing structure above the subscriptions the repository is given; nothing here creates or names one.

##### 8 status

Not adopted, because departments are billing structure above the repository.

### 9 — Keep account owners in the tenant of their subscriptions

```text
CAF billing and tenant — Azure Enterprise Agreement enrollment design area guidance, Design recommendations — recommendation 9
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-enterprise-agreement
  (retrieved 2026-10-14)
Summary (ours): With several tenants, make each account owner a member of the tenant its account's subscriptions are created in.
```

#### What 9 means here

The repository has one tenant ([41](#41--avoid-several-tenants)), and every subscription in `azure.yml` names it. Where an account owner
lives is decided on the enrollment; the effect that matters here — a subscription created in the wrong directory — is the subject of
[48](#48--keep-subscription-creators-in-the-destination-tenant).

##### 9 status

Not adopted, because account owners are set on the enrollment, above the repository.

### 10 — Use the Enterprise Dev/Test offer for non-production

```text
CAF billing and tenant — Azure Enterprise Agreement enrollment design area guidance, Design recommendations — recommendation 10
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-enterprise-agreement
  (retrieved 2026-10-14)
Summary (ours): Run development and test workloads on the Enterprise Dev/Test offer where it is available, within its terms of use.
```

#### What 10 means here

The offer is a property of a subscription, fixed when it is created outside the repository. The non-production subscriptions in `azure.yml`
(`shared_nonprod`, and each customer's `_nonprod` subscription) are the natural candidates; choosing the offer changes nothing in the
repository, since a template deploys the same way under either.

##### 10 status

Not adopted, because the offer is chosen when a subscription is created, outside the repository.

### 11 — Act on EA notification mail

```text
CAF billing and tenant — Azure Enterprise Agreement enrollment design area guidance, Design recommendations — recommendation 11
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-enterprise-agreement
  (retrieved 2026-10-14)
Summary (ours): Read and act on the mail sent to the notification address, because Microsoft uses it for important enrollment prompts.
```

#### What 11 means here

The mailbox belongs to whoever administers the enrollment; the repository sends nothing to it and reads nothing from it.

##### 11 status

Not adopted, because the notification mailbox belongs to billing administration above the repository.

### 12 — Leave the Entra user of an enrollment account untouched

```text
CAF billing and tenant — Azure Enterprise Agreement enrollment design area guidance, Design recommendations — recommendation 12
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-enterprise-agreement
  (retrieved 2026-10-14)
Summary (ours): Do not move, rename, or delete the Entra user behind an EA enrollment account.
```

#### What 12 means here

The repository creates, renames, and deletes no Entra user, so it cannot disturb one behind an enrollment account.

##### 12 status

Not adopted, because the repository manages no Entra user.

### 13 — Audit who can reach Cost Management

```text
CAF billing and tenant — Azure Enterprise Agreement enrollment design area guidance, Design recommendations — recommendation 13
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-enterprise-agreement
  (retrieved 2026-10-14)
Summary (ours): Review regularly who has access in Cost Management, and keep personal Microsoft accounts out of it.
```

#### What 13 means here

Billing-level access to Cost Management is granted on the enrollment. At subscription level, the repository's cost data is reachable by
whoever holds a role on the subscription, which the repository does not assign.

##### 13 status

Not adopted, because access to Cost Management is granted and reviewed above the repository.

### 14 — Let department admins and account owners see charges

```text
CAF billing and tenant — Azure Enterprise Agreement enrollment design area guidance, Design recommendations — recommendation 14
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-enterprise-agreement
  (retrieved 2026-10-14)
Summary (ours): Turn on charge visibility for both department admins and account owners on every enrollment, so authorised users can see
  Cost Management data.
```

#### What 14 means here

Charge visibility is an enrollment setting. Without it, the subscription budgets the landing zones deploy go on alerting, but the owners of
a subscription cannot see its charges in Cost Management; an organisation adopting the repository on an EA turns it on for that reason.

##### 14 status

Not adopted, because charge visibility is an enrollment setting above the repository.

### 15 — Protect EA subscription creators with MFA

```text
CAF billing and tenant — Azure Enterprise Agreement enrollment design area guidance, Design recommendations — recommendation 15
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-enterprise-agreement
  (retrieved 2026-10-14)
Summary (ours): Treat anyone who can create subscriptions from the enrollment as privileged, and protect them with MFA like other
  privileged accounts.
```

#### What 15 means here

The repository grants no right to create subscriptions and sets no sign-in policy; both belong to the enrollment and the tenant.

##### 15 status

Not adopted, because the repository grants no right to create subscriptions and protects no identity's sign-in.

### 16 — Vend subscriptions as a self-service capability (MCA)

```text
CAF billing and tenant — Microsoft customer agreement and Microsoft Entra tenants, Design recommendations — recommendation 16
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-microsoft-customer-agreement
  (retrieved 2026-10-14)
Summary (ours): As for an EA, automate creating and managing subscriptions as a self-service vending process.
```

#### What 16 means here

The same as [1](#1--vend-subscriptions-as-a-self-service-capability-ea): the repository onboards a given subscription by pull request, and
creating one from an MCA billing profile or invoice section needs a billing role it does not hold.

##### 16 status

Partly realised — onboarding by pull request; creating the subscription is not adopted, because it needs a billing role.

### 17 — Send MCA notifications to a group mailbox

```text
CAF billing and tenant — Microsoft customer agreement and Microsoft Entra tenants, Design recommendations — recommendation 17
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-microsoft-customer-agreement
  (retrieved 2026-10-14)
Summary (ours): Route the MCA billing account's notifications to a group mailbox.
```

#### What 17 means here

As [3](#3--send-ea-notifications-to-a-group-mailbox): the contact is set on the billing account, and the repository's own cost alerts go to
the subscription's `Owner` role.

##### 17 status

Not adopted, because the billing account's notification contact is administration above the repository.

### 18 — Budget every invoice section or billing profile

```text
CAF billing and tenant — Microsoft customer agreement and Microsoft Entra tenants, Design recommendations — recommendation 18
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-microsoft-customer-agreement
  (retrieved 2026-10-14)
Summary (ours): Give each invoice section or billing profile a budget with an alert.
```

#### What 18 means here

As [7](#7--budget-every-ea-department-and-account): the repository budgets each subscription, one level below the invoice section.

##### 18 status

Not adopted at invoice-section and billing-profile level, because the repository holds no billing role.

### 19 — Map the organisation onto the MCA hierarchy

```text
CAF billing and tenant — Microsoft customer agreement and Microsoft Entra tenants, Design recommendations — recommendation 19
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-microsoft-customer-agreement
  (retrieved 2026-10-14)
Summary (ours): Map the organisation's structure onto the MCA hierarchy; invoice sections fit most cases.
```

#### What 19 means here

As [4](#4--model-the-organisation-with-ea-departments-and-accounts): the hierarchy sits above the subscriptions, and a per-customer invoice
section would need no change here.

##### 19 status

Not adopted, because the MCA hierarchy is billing structure above the repository.

### 20 — Give a business unit with its own IT its own invoice section

```text
CAF billing and tenant — Microsoft customer agreement and Microsoft Entra tenants, Design recommendations — recommendation 20
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-microsoft-customer-agreement
  (retrieved 2026-10-14)
Summary (ours): Give a business unit that runs its own IT its own invoice section.
```

#### What 20 means here

As [8](#8--add-an-it-department-only-where-a-business-unit-runs-its-own-it): billing structure above the repository.

##### 20 status

Not adopted, because invoice sections are billing structure above the repository.

### 21 — Act on MCA notification mail

```text
CAF billing and tenant — Microsoft customer agreement and Microsoft Entra tenants, Design recommendations — recommendation 21
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-microsoft-customer-agreement
  (retrieved 2026-10-14)
Summary (ours): Watch the contact mailbox, because it carries important prompts from Microsoft.
```

#### What 21 means here

As [11](#11--act-on-ea-notification-mail): the mailbox belongs to billing administration.

##### 21 status

Not adopted, because the contact mailbox belongs to billing administration above the repository.

### 22 — Audit billing role assignments on the agreement

```text
CAF billing and tenant — Microsoft customer agreement and Microsoft Entra tenants, Design recommendations — recommendation 22
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-microsoft-customer-agreement
  (retrieved 2026-10-14)
Summary (ours): Review the billing role assignments on the agreement on a regular schedule.
```

#### What 22 means here

As [13](#13--audit-who-can-reach-cost-management): billing roles are granted and reviewed on the agreement, which the repository never
touches.

##### 22 status

Not adopted, because billing role assignments are made and reviewed above the repository.

### 23 — Use the MCA dev/test plan for non-production

```text
CAF billing and tenant — Microsoft customer agreement and Microsoft Entra tenants, Design recommendations — recommendation 23
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-microsoft-customer-agreement
  (retrieved 2026-10-14)
Summary (ours): Put non-production on the MCA dev/test plan where it is available, within its terms.
```

#### What 23 means here

As [10](#10--use-the-enterprise-devtest-offer-for-non-production): the plan is chosen when a subscription is created, and the non-production
subscriptions in `azure.yml` are its candidates.

##### 23 status

Not adopted, because the offer is chosen when a subscription is created, outside the repository.

### 24 — Protect MCA subscription creators with MFA

```text
CAF billing and tenant — Microsoft customer agreement and Microsoft Entra tenants, Design recommendations — recommendation 24
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-microsoft-customer-agreement
  (retrieved 2026-10-14)
Summary (ours): Require MFA for every identity that can create subscriptions on any MCA billing level, as for all privileged accounts.
```

#### What 24 means here

As [15](#15--protect-ea-subscription-creators-with-mfa): the repository grants no right to create subscriptions and sets no sign-in policy.

##### 24 status

Not adopted, because the repository grants no right to create subscriptions and protects no identity's sign-in.

### 25 — Have the CSP partner use Azure Lighthouse for support access

```text
CAF billing and tenant — Cloud Solution Provider service, Design recommendations — recommendation 25
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-cloud-solution-provider
  (retrieved 2026-10-14)
Summary (ours): Have the CSP partner reach the organisation's resources for support through Azure Lighthouse.
```

#### What 25 means here

The repository's subscriptions come from no partner in its examples, and it delegates no access to another tenant. A Lighthouse delegation
is made by a deployment into the delegating subscription; a repository whose subscriptions a partner supports could carry it as a
once-per-subscription template, which none of the three is.

##### 25 status

Not adopted, because the repository's subscriptions come from no CSP partner and it delegates no access across tenants.

### 26 — Have the partner hold granular delegated admin privileges

```text
CAF billing and tenant — Cloud Solution Provider service, Design recommendations — recommendation 26
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-cloud-solution-provider
  (retrieved 2026-10-14)
Summary (ours): Partners should hold granular delegated admin privileges (GDAP) rather than the broad, older delegated admin privileges.
```

#### What 26 means here

Admin privileges between a partner and an organisation are granted in Partner Center, between tenants, above anything the repository
deploys.

##### 26 status

Not adopted, because partner admin privileges are granted between organisations, above the repository.

### 27 — Apply the customer security best practices

```text
CAF billing and tenant — Cloud Solution Provider service, Design recommendations — recommendation 27
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-cloud-solution-provider
  (retrieved 2026-10-14)
Summary (ours): Apply Partner Center's security best practices for customers.
```

#### What 27 means here

Here "customer" is the organisation that buys from the partner, not a customer of [ADR-AZ-CUSTOMER](../azure-customer-model.md). Its
security practices concern the tenant and its administrators, which the repository does not administer.

##### 27 status

Not adopted, because Partner Center's customer security practices concern tenant administration above the repository.

### 28 — Have the partner apply the CSP security best practices

```text
CAF billing and tenant — Cloud Solution Provider service, Design recommendations — recommendation 28
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-cloud-solution-provider
  (retrieved 2026-10-14)
Summary (ours): The partner should apply Partner Center's security best practices for CSP partners.
```

#### What 28 means here

The partner's practices are the partner's; nothing in the repository reaches them.

##### 28 status

Not adopted, because the partner's own security practices are outside the repository.

### 29 — Agree how support cases are raised

```text
CAF billing and tenant — Cloud Solution Provider service, Design recommendations — recommendation 29
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-cloud-solution-provider
  (retrieved 2026-10-14)
Summary (ours): Agree with the partner how support cases are raised and escalated.
```

#### What 29 means here

Support arrangements are an agreement between organisations; the repository raises no support case.

##### 29 status

Not adopted, because support arrangements with a partner are outside the repository.

### 30 — Agree how self-service subscriptions are created

```text
CAF billing and tenant — Cloud Solution Provider service, Design recommendations — recommendation 30
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-cloud-solution-provider
  (retrieved 2026-10-14)
Summary (ours): Agree with the partner how subscriptions will be created on a self-service basis.
```

#### What 30 means here

Creating the subscription stays outside the repository under any offer; once a partner has created one, onboarding it is the same pull
request as [1](#1--vend-subscriptions-as-a-self-service-capability-ea).

##### 30 status

Not adopted, because creating a subscription is outside the repository.

### 31 — Analyse CSP cost by tag and location

```text
CAF billing and tenant — Cloud Solution Provider service, Design recommendations — recommendation 31
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-cloud-solution-provider
  (retrieved 2026-10-14)
Summary (ours): Use Cost Management's reports and views, filtered by tags and location, to analyse spend.
```

#### What 31 means here

The same as [5](#5--analyse-cost-by-tag-and-location): the CAF tags and the one region per environment are what Cost Management slices by,
whatever the offer.

##### 31 status

Partly realised — every resource is tagged and kept in one region; CAF tags on the resource groups `Deploy-Bicep` creates are planned
(follow-up).

### 32 — Protect CSP subscription creators with MFA

```text
CAF billing and tenant — Cloud Solution Provider service, Design recommendations — recommendation 32
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-cloud-solution-provider
  (retrieved 2026-10-14)
Summary (ours): Protect every identity that can create subscriptions with MFA.
```

#### What 32 means here

As [15](#15--protect-ea-subscription-creators-with-mfa): the repository grants no right to create subscriptions and sets no sign-in policy.

##### 32 status

Not adopted, because the repository grants no right to create subscriptions and protects no identity's sign-in.

### 33 — Provision CSP subscriptions into the organisation's own tenant

```text
CAF billing and tenant — Cloud Solution Provider service, Design recommendations — recommendation 33
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-billing-cloud-solution-provider
  (retrieved 2026-10-14)
Summary (ours): A CSP partner should create subscriptions in the organisation's own, well-defined Entra tenant, never in a tenant the
  partner manages.
```

#### What 33 means here

The repository's subscriptions come from no partner in its examples. Its model matches the recommendation's intent all the same: every
subscription in `azure.yml` names the one tenant the organisation owns ([41](#41--avoid-several-tenants)), and a subscription a partner
created in a tenant of its own contradicts that declaration ([48](#48--keep-subscription-creators-in-the-destination-tenant)).

##### 33 status

Not adopted, because the repository's subscriptions come from no CSP partner.

### 34 — Register custom names on the tenant

```text
CAF billing and tenant — Define Microsoft Entra tenants, Design recommendations — recommendation 34
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-ad-define (retrieved 2026-10-14)
Summary (ours): Add the organisation's custom domain names to the tenant; when synchronising with Entra Connect, check that the user
  principal names in on-premises Active Directory use them.
```

#### What 34 means here

Custom names and directory synchronisation are tenant administration. The repository has no on-premises directory and no on-premises
connectivity, and it registers no name on the tenant.

##### 34 status

Not adopted, because custom names and directory synchronisation are tenant administration above the repository.

### 35 — Decide the single sign-on approach

```text
CAF billing and tenant — Define Microsoft Entra tenants, Design recommendations — recommendation 35
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-ad-define (retrieved 2026-10-14)
Summary (ours): Decide how single sign-on works through Entra Connect, choosing one of its supported topologies.
```

#### What 35 means here

Sign-on is decided for the tenant, not for a subscription. The repository's people sign in to Azure and to the SQL servers through the
tenant, however its single sign-on is set up.

##### 35 status

Not adopted, because single sign-on is tenant administration above the repository.

### 36 — Start cloud-only when there is no identity estate

```text
CAF billing and tenant — Define Microsoft Entra tenants, Design recommendations — recommendation 36
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-ad-define (retrieved 2026-10-14)
Summary (ours): An organisation with no identity infrastructure starts cloud-only on Entra ID, adding Entra Domain Services and Intune or
  EMS to protect its SaaS, applications, and devices.
```

#### What 36 means here

The repository uses the tenant it is given and needs nothing from it beyond Entra objects: a service connection per subscription and the SQL
administrator group. A cloud-only tenant serves it as well as a synchronised one.

##### 36 status

Not adopted, because the repository builds no identity estate.

### 37 — Require MFA and Conditional Access for privileged accounts

```text
CAF billing and tenant — Define Microsoft Entra tenants, Design recommendations — recommendation 37
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-ad-define (retrieved 2026-10-14)
Summary (ours): Use Entra multifactor authentication, and enforce phishing-resistant MFA through Conditional Access on every privileged
  account.
```

#### What 37 means here

MFA and Conditional Access are policies of the tenant, and the repository sets none. What it decides is whether its privileged access goes
through the tenant at all, and for SQL it does: each SQL server's administrator is an Entra group
([ADR-AZ-LZ-SQLENTRAADMINS](../landing-zones.md#rule-adr-az-lz-sqlentraadmins)), so an administrator signs in through Entra and meets
whatever MFA and Conditional Access the tenant enforces. The one path outside the tenant's policies is the break-glass SQL login, kept for
the case where the directory is unavailable ([38](#38--plan-emergency-access-accounts)). Deployment identities are service connections,
which sign in without MFA by nature; the pipelines use one per subscription.

##### 37 in `foundation`

Not applicable: it deploys no SQL server; its Key Vault takes the tenant from the deploying subscription.

##### 37 in `discovery`

Not applicable: it deploys no SQL server and grants no role.

##### 37 in `expedition`

Makes the Entra group `zct-exped-sql-admins` the administrator of each SQL server through `infrastructure/modules/sql-server.bicep`, so SQL
administration is subject to the tenant's sign-in policies; the break-glass login `exped-break-glass` is not.

##### 37 status

Not adopted, because MFA and Conditional Access are tenant configuration; the templates route SQL administration through Entra so the
tenant's policies reach it.

### 38 — Plan emergency access accounts

```text
CAF billing and tenant — Define Microsoft Entra tenants, Design recommendations — recommendation 38
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-ad-define (retrieved 2026-10-14)
Summary (ours): Keep emergency access (break-glass) accounts so the tenant cannot be locked out entirely.
```

#### What 38 means here

Emergency accounts for the tenant are created and guarded by its administrators. The repository applies the same idea where it owns the
access: a SQL server authenticates its administrators through an Entra group first, and beside it sits one break-glass SQL login whose
password is a Key Vault reference to `foundation`'s vault in the same subscription
([ADR-AZ-LZ-SQLENTRAADMINS](../landing-zones.md#rule-adr-az-lz-sqlentraadmins)). When the directory or the group is unavailable, the server
stays reachable, and the repository holds no secret
([ADR-AZ-DATAMOD-PARAMETERCONTRACT](../azure-data-model.md#rule-adr-az-datamod-parametercontract)).

##### 38 in `foundation`

Holds the vault that the break-glass password lives in, one per subscription; the secret itself is put there outside the repository.

##### 38 in `discovery`

Not applicable: it holds no access path of its own.

##### 38 in `expedition`

Turns off Entra-only authentication (`entraOnlyAuthentication: false`) for exactly this reason and passes the login `exped-break-glass` with
its password as a Key Vault reference, for example to `ps-weu-zct-fnd-ap-kv` in `apex/prod.yml`.

##### 38 status

Not adopted for the tenant, because emergency accounts are tenant administration; each SQL server carries its own break-glass login.

### 39 — Govern privileged access with PIM

```text
CAF billing and tenant — Define Microsoft Entra tenants, Design recommendations — recommendation 39
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-ad-define (retrieved 2026-10-14)
Summary (ours): Manage privileged identities and their access through Entra Privileged Identity Management (PIM).
```

#### What 39 means here

PIM is configured in the tenant. The repository keeps the door open for it by never granting a privilege to a person: SQL administration
goes to a group, named by its display name and object id in each `expedition` config, so the tenant can make membership of that group
eligible and time-bound through PIM with no change to a template or a config. The repository makes no role assignment to people at all
([ADR-AZ-WAF-SE-SE05](../waf/security.md#rule-adr-az-waf-se-se05)), so there is no standing assignment of its own for PIM to replace.

##### 39 in `foundation`

Not applicable: it grants no access to people.

##### 39 in `discovery`

Not applicable: it grants no access to people.

##### 39 in `expedition`

Names the group `zct-exped-sql-admins` (object id registered in `guids.yml` as `entra_sql_admin_group`) as every SQL server's administrator;
whether membership is permanent or eligible is the tenant's choice.

##### 39 status

Not adopted, because PIM is tenant configuration; SQL administrators are a group that PIM can govern.

### 40 — Stream Entra logs to the central workspace

```text
CAF billing and tenant — Define Microsoft Entra tenants, Design recommendations — recommendation 40
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-ad-define (retrieved 2026-10-14)
Summary (ours): Send every Microsoft Entra diagnostic log to a central Azure Monitor Log Analytics workspace.
```

#### What 40 means here

Entra's diagnostic settings belong to the tenant, not to a subscription, so making one is a tenant-level deployment that needs a directory
role; the repository deploys nothing at that level ([ADR-AZ-LZ-LANDINGZONE](../landing-zones.md#rule-adr-az-lz-landingzone)). The
subscription-level counterpart is realised: each landing zone streams its subscription's activity log to `foundation`'s workspace
([ADR-AZ-LZ-THREEBUILTINPOLICIES](../landing-zones.md#rule-adr-az-lz-threebuiltinpolicies)). A tenant administrator who adopts the
recommendation can point Entra's logs at the shared production subscription's workspace, which would then hold both kinds of log side by
side.

##### 40 in `foundation`

Deploys the Log Analytics workspace of each subscription; the shared ones are where tenant logs would go. It receives no Entra log.

##### 40 in `discovery`

Deploys the subscription's activity-log diagnostic setting through `infrastructure/modules/subscription-diagnostic-setting.bicep`; it makes
no tenant-level setting.

##### 40 in `expedition`

Not applicable: its diagnostics are resource logs, sent to the workspace of its subscription.

##### 40 status

Not adopted, because Entra's diagnostic settings are made at tenant level, where the repository deploys nothing.

### 41 — Avoid several tenants

```text
CAF billing and tenant — Define Microsoft Entra tenants, Design recommendations — recommendation 41
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-ad-define (retrieved 2026-10-14)
Summary (ours): Keep one tenant per organisation unless a concrete business need requires more, because each extra tenant adds management
  effort and security risk; a note points to the landing zone testing approach for anyone considering a separate test tenant.
```

#### What 41 means here

`azure.yml` holds the tenants as a map keyed by name
([ADR-AZ-DATAMOD-NAMEKEYEDMAPS](../azure-data-model.md#rule-adr-az-datamod-namekeyedmaps)), and the shipped file declares exactly one,
`placeholder`, whose id is a minted GUID registered in `guids.yml` as `tenant_placeholder`. Every subscription, shared and customer alike,
names it in its `tenant` field, and `AzureConfig` rejects a subscription whose tenant is not declared. The data model could hold more
tenants; the repository uses one, so test and production, shared platform and customers, all live in it. `ado.yml` names the same tenant as
the directory behind the DevOps organisation.

Each deploy proves its subscription. In a pipeline, the session is whatever the stage's service connection logged into;
`Get-AzCliSessionSubscription` resolves its subscription against `azure.yml` and throws on one the file does not declare, and
`-SubscriptionIdAssertIs` pins the expected subscription
([ADR-AZ-DATAMOD-JOINSINPOWERSHELL](../azure-data-model.md#rule-adr-az-datamod-joinsinpowershell)). The tenant is declared beside it; the
config-aware session check `Assert-AzCliIsConnected` compares both tenant and subscription with the declaration
([ADR-AZ-SESSION-CONFIGDEFINESCORRECT](../az-session-verification.md#rule-adr-az-session-configdefinescorrect)), but the deploy path does
not call it, so a deploy-time tenant check is planned (see [48](#48--keep-subscription-creators-in-the-destination-tenant)). The CD
pipelines carry one service connection per subscription (`sc-shared-nonprod`, `sc-shared-prod`, `sc-apex-nonprod`, `sc-apex-prod`, …). CAF's
page on automating several tenants describes one deployment identity per tenant; with one tenant, the identity per subscription is the finer
split, and a second tenant would need no new mechanism, only a second `tenants` entry and the service connections of its subscriptions.

CAF's testing note concerns tenant-level changes, which the repository does not make, so it keeps no separate test tenant; its changes reach
non-production subscriptions before production ones.

##### 41 in `foundation`

Deploys into each subscription of the one tenant; its Key Vault takes its tenant from the deploying subscription
(`subscription().tenantId`), so the vault always belongs to the tenant the subscription lives in.

##### 41 in `discovery`

Deploys the landing zone of every subscription of the one tenant, each through that subscription's service connection.

##### 41 in `expedition`

Every config names the same tenant's SQL administrator group, and the SQL server module takes the tenant from the deploying subscription.

##### 41 status

Realised — one tenant, declared once and named by every subscription; the deploy-time tenant check belongs to
[48](#48--keep-subscription-creators-in-the-destination-tenant) and is planned (follow-up).

### 42 — Grant partner access with Azure Lighthouse

```text
CAF billing and tenant — Define Microsoft Entra tenants, Design recommendations — recommendation 42
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/azure-ad-define (retrieved 2026-10-14)
Summary (ours): Give partners and other third parties access to resources in the organisation's tenant, and centralise access across
  tenants, through Azure Lighthouse.
```

#### What 42 means here

The repository grants no third party access and works in one tenant. A repository whose subscriptions a partner operates would add the
Lighthouse delegation as a once-per-subscription template beside `foundation`.

##### 42 status

Not adopted, because the repository grants no partner access across tenants.

### 43 — Default to one tenant

```text
CAF billing and tenant — Considerations and recommendations for multitenant Azure landing zone scenarios, Recommendations —
  recommendation 43
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/multi-tenant/considerations-recommendations
  (retrieved 2026-10-15)
Summary (ours): Use the organisation's one corporate tenant by default, and add a tenant only for a requirement it genuinely cannot meet.
```

#### What 43 means here

The question this recommendation raises here is whether each customer should get a tenant of its own. It does not. A customer is a
subscription pair in the one tenant, bound by the subscription's `customer` field
([ADR-AZ-CUSTOMER-TWOBINDINGS](../azure-customer-model.md#rule-adr-az-customer-twobindings)), and its isolation comes from the subscription:
its own landing zone, network, budget, workspace, and vault, its own CD pipeline, and its own service connections.

The landing zone depends on that choice. A customer's spoke peers to the hub in a shared subscription, the hub's private DNS zones link to
every spoke, and a workload registers its private endpoints in the hub's zones
([ADR-AZ-LZ-HUBANDSPOKE](../landing-zones.md#rule-adr-az-lz-hubandspoke)). Within one tenant, each of those joins across subscriptions needs
only a role on the other side; across tenants each would need an identity known in both, and the one SQL administrator group could not
administer every customer's server.

A customer whose contract or regulation demands its own directory is the requirement that would justify a second tenant; the data model
holds it as a second `tenants` entry, and that customer's subscriptions would then need a hub of their own, since a cross-tenant join is
what the model avoids.

##### 43 in `foundation`

One config per customer subscription (`apex/nsub.yml`, `apex/psub.yml`, `nova/nsub.yml`, `flux/nsub.yml`), all in the one tenant, each
giving the customer its own workspace and vault.

##### 43 in `discovery`

Each customer's spoke peers to the shared hub of its tier and resolves through the hub's private DNS zones, a join between subscriptions of
the one tenant.

##### 43 in `expedition`

Reads the hub's subscription by config address (`privateDnsZoneSubscriptionId: { address: global.azure.subscriptions.shared_prod.id }` in
`apex/prod.yml`) to register its private endpoints in the hub's zones, and every customer's SQL server shares the one administrator group.

##### 43 status

Realised — every customer lives in the one tenant, separated by subscription.

### 44 — Experiment in sandbox subscriptions, not tenants

```text
CAF billing and tenant — Considerations and recommendations for multitenant Azure landing zone scenarios, Recommendations —
  recommendation 44
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/multi-tenant/considerations-recommendations
  (retrieved 2026-10-15)
Summary (ours): Give workload teams safe, isolated room to experiment as sandbox subscriptions inside the same tenant, not as separate
  tenants.
```

#### What 44 means here

The recommendation's point is that experiments stay in the organisation's tenant. Here they do, though not in a sandbox subscription: an
experiment runs as an extra configuration slot of a non-production subscription, behind the same landing zone and guardrails as the rest of
non-production ([ADR-AZ-CAF-RESORG-SANDBOXMANAGEMENTGROUP](resource-organization.md#rule-adr-az-caf-resorg-sandboxmanagementgroup)). An
experiment that needs what the landing zone denies would be the trigger for a sandbox subscription, declared in `azure.yml` in the same
tenant like any other.

##### 44 in `foundation`

Not applicable: it has no configuration slots; an experiment uses the workspace and vault of its subscription.

##### 44 in `discovery`

Not applicable: an experiment lands in the existing landing zone of a non-production subscription.

##### 44 in `expedition`

`apex/dev-blu.yml` is an extra configuration slot beside `apex/dev.yml` in the apex non-production subscription: its own resource group, the
same tenant, the same spoke.

##### 44 status

Not adopted, because experiments run as configuration slots of non-production subscriptions; they stay inside the one tenant.

### 45 — Integrate tools across tenants as multitenant apps

```text
CAF billing and tenant — Considerations and recommendations for multitenant Azure landing zone scenarios, Recommendations —
  recommendation 45
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/multi-tenant/considerations-recommendations
  (retrieved 2026-10-15)
Summary (ours): Build integrations of operational tools that span tenants (an IT service management tool, for example) as multitenant Entra
  applications.
```

#### What 45 means here

The repository works in one tenant and integrates no operational tool across tenants; its pipelines reach Azure through per-subscription
service connections in that tenant.

##### 45 status

Not adopted, because the repository integrates no operational tool across tenants.

### 46 — Read the ISV landing zone guidance

```text
CAF billing and tenant — Considerations and recommendations for multitenant Azure landing zone scenarios, Recommendations —
  recommendation 46
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/multi-tenant/considerations-recommendations
  (retrieved 2026-10-15)
Summary (ours): An independent software vendor (ISV) should read the landing zone guidance written for ISVs.
```

#### What 46 means here

The repository's customers resemble an ISV's in that each gets its own deployment, but they are subscriptions in the organisation's own
tenant, not tenants of their own, and no offer is sold through a marketplace. A repository that hosted a product for outside customers would
be the trigger to read that guidance.

##### 46 status

Not adopted, because the repository is not an ISV offering.

### 47 — Manage across tenants with Azure Lighthouse

```text
CAF billing and tenant — Considerations and recommendations for multitenant Azure landing zone scenarios, Recommendations —
  recommendation 47
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/multi-tenant/considerations-recommendations
  (retrieved 2026-10-15)
Summary (ours): Simplify management across tenants with Azure Lighthouse.
```

#### What 47 means here

With one tenant there is nothing to manage across ([41](#41--avoid-several-tenants)).

##### 47 status

Not adopted, because the repository manages one tenant.

### 48 — Keep subscription creators in the destination tenant

```text
CAF billing and tenant — Considerations and recommendations for multitenant Azure landing zone scenarios, Recommendations —
  recommendation 48
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/multi-tenant/considerations-recommendations
  (retrieved 2026-10-15)
Summary (ours): Create the EA and MCA account owners, invoice-section owners, and subscription creators in the destination tenant, so that
  new subscriptions are born there and never need a change of directory afterwards.
```

#### What 48 means here

Who creates subscriptions is decided on the billing account. What the repository owns is the consequence of getting it wrong: a subscription
in the wrong directory. Every subscription in `azure.yml` names its tenant, but a deploy verifies only the subscription id (see
[41](#41--avoid-several-tenants)), so a subscription created in another directory deploys, and its first sign of trouble is an `expedition`
SQL server whose administrator group does not exist in that directory. The planned closure is a tenant comparison in the deploy path:
`Get-BicepDeploymentContext` compares the session's tenant with the tenant `azure.yml` declares for the resolved subscription, as
`Assert-AzCliIsConnected` does for a named subscription, and fails naming both.

A later change of directory would be worse than a wrong start, because some resources fix their tenant when they are created. The Key Vault
module and the SQL server module both default their tenant to the deploying subscription's (`subscription().tenantId`); after a move, the
vault keeps the old tenant until it is updated, and the SQL server's administrator group belongs to the old directory. Creating
subscriptions in the right tenant from the start avoids that repair.

##### 48 in `foundation`

The vault's tenant comes from the subscription at creation, so `foundation` is correct for a subscription born in the right tenant and stale
after a move.

##### 48 in `discovery`

Nothing tenant-bound: its network, policies, and budget live in the subscription and move with it.

##### 48 in `expedition`

The SQL server's Entra administrator is an object of the tenant; after a move, the group id `59100000-ad01-0000-6000-000000000000` would
name a group in the old directory.

##### 48 status

Not adopted, because billing roles are set above the repository; the tenant of every subscription is declared, and a deploy-time tenant
check is planned (follow-up).

### 49 — Follow the Entra security operations guide

```text
CAF billing and tenant — Considerations and recommendations for multitenant Azure landing zone scenarios, Recommendations —
  recommendation 49
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/multi-tenant/considerations-recommendations
  (retrieved 2026-10-15)
Summary (ours): Follow the Microsoft Entra security operations guide.
```

#### What 49 means here

Security operations for the tenant belong to its administrators; the repository runs none.

##### 49 status

Not adopted, because security operations for the tenant are outside the repository.

### 50 — Keep Global Administrators few

```text
CAF billing and tenant — Considerations and recommendations for multitenant Azure landing zone scenarios, Recommendations —
  recommendation 50
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/multi-tenant/considerations-recommendations
  (retrieved 2026-10-15)
Summary (ours): Keep fewer than five Global Administrator accounts.
```

#### What 50 means here

The repository assigns no directory role and needs none; it works with rights on the subscriptions only.

##### 50 status

Not adopted, because Global Administrators are tenant administration above the repository.

### 51 — Put every admin account under PIM

```text
CAF billing and tenant — Considerations and recommendations for multitenant Azure landing zone scenarios, Recommendations —
  recommendation 51
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/multi-tenant/considerations-recommendations
  (retrieved 2026-10-15)
Summary (ours): Manage every admin account through PIM, with no standing privilege and just-in-time elevation.
```

#### What 51 means here

As [39](#39--govern-privileged-access-with-pim): PIM is configured in the tenant, and the repository's one grant of privilege, SQL
administration, goes to a group that PIM can govern.

##### 51 status

Not adopted, because PIM is tenant configuration.

### 52 — Require approval to activate critical roles

```text
CAF billing and tenant — Considerations and recommendations for multitenant Azure landing zone scenarios, Recommendations —
  recommendation 52
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/multi-tenant/considerations-recommendations
  (retrieved 2026-10-15)
Summary (ours): Require an approval in PIM before a critical role such as Global Administrator activates, ideally from approvers in more
  than one team.
```

#### What 52 means here

Approval rules are part of PIM in the tenant; the repository configures none.

##### 52 status

Not adopted, because PIM approval is tenant configuration.

### 53 — Alert when Global Administrator is activated

```text
CAF billing and tenant — Considerations and recommendations for multitenant Azure landing zone scenarios, Recommendations —
  recommendation 53
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/multi-tenant/considerations-recommendations
  (retrieved 2026-10-15)
Summary (ours): Notify the relevant people whenever the Global Administrator role is activated.
```

#### What 53 means here

The activation happens in the tenant and its alert is configured there; the repository's alerts are subscription budgets.

##### 53 status

Not adopted, because alerting on Global Administrator activation is tenant configuration.

### 54 — Leave elevated access to Azure resources off

```text
CAF billing and tenant — Considerations and recommendations for multitenant Azure landing zone scenarios, Recommendations —
  recommendation 54
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/multi-tenant/considerations-recommendations
  (retrieved 2026-10-15)
Summary (ours): Keep the setting that lets Global Administrators elevate themselves over all Azure resources off unless it is needed; a
  callout repeats Microsoft's least-privilege advice for the Global Administrator role.
```

#### What 54 means here

The setting belongs to each Global Administrator. The repository needs no access above a subscription
([ADR-AZ-LZ-LANDINGZONE](../landing-zones.md#rule-adr-az-lz-landingzone)), so it never asks for the elevation.

##### 54 status

Not adopted, because the elevation setting belongs to the tenant's Global Administrators.

### 55 — Configure cross-tenant collaboration features

```text
CAF billing and tenant — Considerations and recommendations for multitenant Azure landing zone scenarios, Recommendations —
  recommendation 55
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/multi-tenant/considerations-recommendations
  (retrieved 2026-10-15)
Summary (ours): To ease work across tenants, configure B2B collaboration, B2B direct connect, cross-tenant access settings, cross-tenant
  synchronisation, and the multitenant organisation feature.
```

#### What 55 means here

With one tenant there is no collaboration across tenants to configure ([43](#43--default-to-one-tenant)).

##### 55 status

Not adopted, because the repository works in one tenant.

### 56 — Configure cross-cloud collaboration

```text
CAF billing and tenant — Considerations and recommendations for multitenant Azure landing zone scenarios, Recommendations —
  recommendation 56
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/multi-tenant/considerations-recommendations
  (retrieved 2026-10-15)
Summary (ours): An organisation with tenants in several Microsoft clouds (commercial, the China cloud, government) configures the B2B
  settings between clouds.
```

#### What 56 means here

The repository targets one tenant in the commercial cloud, in the region each environment names.

##### 56 status

Not adopted, because the repository targets one tenant in one Microsoft cloud.

### 57 — Read the multitenant solution guidance

```text
CAF billing and tenant — Considerations and recommendations for multitenant Azure landing zone scenarios, Recommendations —
  recommendation 57
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/multi-tenant/considerations-recommendations
  (retrieved 2026-10-15)
Summary (ours): Workload teams building multitenant applications should read the Architecture Center's guidance on multitenant solutions.
```

#### What 57 means here

`expedition` is deployed once per customer subscription, not built as one application serving many customers, so the guidance on multitenant
application design does not bear on it. A workload that served several customers from one deployment would be the trigger.

##### 57 status

Not adopted, because the example workload is deployed per customer subscription.

### 58 — Read the Lighthouse enterprise guidance

```text
CAF billing and tenant — Azure Lighthouse usage in Azure landing zones multitenant scenarios, Recommendations — recommendation 58
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/multi-tenant/lighthouse
  (retrieved 2026-10-15)
Summary (ours): Read the guidance on Azure Lighthouse in enterprise scenarios.
```

#### What 58 means here

The repository uses no Azure Lighthouse ([42](#42--grant-partner-access-with-azure-lighthouse)).

##### 58 status

Not adopted, because the repository uses no Azure Lighthouse.

### 59 — Read the Lighthouse ISV guidance

```text
CAF billing and tenant — Azure Lighthouse usage in Azure landing zones multitenant scenarios, Recommendations — recommendation 59
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/multi-tenant/lighthouse
  (retrieved 2026-10-15)
Summary (ours): An ISV should read the guidance on Azure Lighthouse in ISV scenarios.
```

#### What 59 means here

The repository is not an ISV offering ([46](#46--read-the-isv-landing-zone-guidance)) and uses no Azure Lighthouse.

##### 59 status

Not adopted, because the repository is not an ISV offering and uses no Azure Lighthouse.

### 60 — Delegate with Lighthouse in both directions

```text
CAF billing and tenant — Azure Lighthouse usage in Azure landing zones multitenant scenarios, Recommendations — recommendation 60
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/multi-tenant/lighthouse
  (retrieved 2026-10-15)
Summary (ours): Delegate with Azure Lighthouse in both directions between tenants, which for many tasks removes the need for B2B guest
  accounts and duplicate accounts.
```

#### What 60 means here

With one tenant there is no direction to delegate in.

##### 60 status

Not adopted, because the repository delegates nothing between tenants.

### 61 — Make Lighthouse delegations eligible through PIM

```text
CAF billing and tenant — Azure Lighthouse usage in Azure landing zones multitenant scenarios, Recommendations — recommendation 61
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/multi-tenant/lighthouse
  (retrieved 2026-10-15)
Summary (ours): Make Lighthouse delegations eligible through PIM rather than permanent; only the managing tenant needs Entra ID P2 for it.
```

#### What 61 means here

The repository makes no Lighthouse delegation. A repository that added one ([42](#42--grant-partner-access-with-azure-lighthouse)) would
declare its authorisations as eligible in the same template.

##### 61 status

Not adopted, because the repository makes no Lighthouse delegation.

## Decision

The repository answers each of Microsoft's billing and tenant recommendations with what it does, what it plans, or why it does not adopt it.
It works in one Entra tenant: `azure.yml` declares it, every subscription names it, every customer lives in it as a pair of subscriptions,
and every deploy verifies the session's subscription against the declaration, through one service connection per subscription. Cost is
analysable by the CAF tags and the one region per environment. SQL administration goes through an Entra group, which the tenant's sign-in
policies and PIM can govern, with a break-glass login beside it whose password stays in Key Vault.

Everything that sits on the billing agreement or administers the tenant — offers, departments and invoice sections, billing roles and
budgets, notification contacts, custom names and sign-on, Global Administrators, PIM, Conditional Access, partner access and Azure
Lighthouse — is not adopted, because the repository deploys into subscriptions it is given and needs no right above them
([ADR-AZ-LZ-LANDINGZONE](../landing-zones.md#rule-adr-az-lz-landingzone)). Each of those rules names what would make it apply. Two items are
planned: a deploy-time check of the session's tenant against the declaration, and the CAF tags on the resource groups `Deploy-Bicep`
creates, shared with [ADR-AZ-CAF-GOV-TAGRESOURCESCOSTANALYSIS](governance.md#rule-adr-az-caf-gov-tagresourcescostanalysis).

### How this is enforced

- `AzureConfig` requires a non-empty `tenants` map and rejects a subscription whose `tenant` is not declared
  ([ADR-AZ-DATAMOD-SCHEMAANDINTEGRITY](../azure-data-model.md#rule-adr-az-datamod-schemaandintegrity)).
- On every deploy, `Get-AzCliSessionSubscription` resolves the session's subscription against `azure.yml` and throws on one it does not
  declare ([ADR-AZ-SESSION-REVERSELOOKUP](../az-session-verification.md#rule-adr-az-session-reverselookup)); outside the deploy path,
  `Assert-AzCliIsConnected` compares a session's tenant and subscription with the declaration
  ([ADR-AZ-SESSION-CONFIGDEFINESCORRECT](../az-session-verification.md#rule-adr-az-session-configdefinescorrect)).
- `Deploy-Bicep` throws in a pipeline without `-SubscriptionIdAssertIs`, and every CD pipeline entry pairs its service connection with the
  subscription id it must reach ([ADR-AZ-DATAMOD-JOINSINPOWERSHELL](../azure-data-model.md#rule-adr-az-datamod-joinsinpowershell)).
- `Test-ManagedGuids` fails an unregistered GUID in tracked text, so the tenant id and the SQL administrator group id enter configs only
  with their `guids.yml` entries ([ADR-AUTO-GUIDS](../../automation/managed-guids.md)).
- The parameter-model test checks every rendered parameters file against the compiled parameter model, so a config without its `tags`, its
  Entra administrator, or a Key Vault reference for the break-glass password fails the build
  ([ADR-AZ-DATAMOD-PARAMETERCONTRACT](../azure-data-model.md#rule-adr-az-datamod-parametercontract)).
- The landing zone's allowed-locations policy keeps every resource in its region
  ([ADR-AZ-LZ-THREEBUILTINPOLICIES](../landing-zones.md#rule-adr-az-lz-threebuiltinpolicies)).
- Planned (follow-up), not existing: a tenant comparison in `Get-BicepDeploymentContext` that fails a session whose tenant differs from the
  one `azure.yml` declares for its subscription, and CAF tags on the resource groups `Deploy-Bicep` creates.

## Consequences

- A new customer is a subscription pair and its configs in the one tenant, never a new directory, so the landing zone's joins across
  subscriptions — peering, DNS zone links, private endpoint registration — keep working with no cross-tenant authorisation.
- Every subscription's tenant is on record in `azure.yml`; without the planned tenant check, a subscription in the wrong directory is caught
  by what fails in it (the SQL administrator group), not by name.
- The repository needs no billing role and no directory role; billing structure, tenant security, and partner access stay with the
  organisation's administrators, at the cost that the repository cannot create its own subscriptions.
- SQL administration follows the tenant's sign-in policies and PIM with no change here; the break-glass login is the one deliberate
  exception, kept for when the directory is unavailable.
- A customer that requires its own tenant is a design change, not a config entry: it needs a hub of its own, because the model has no join
  across tenants.
