# EDR: CAF naming and tagging — Microsoft's naming and tagging recommendations, as the repository reads them

Binds to [`naming-standard`](../../../azure/azure-naming-standard.md) (the repository's own naming standard, which this record compares with
Microsoft's) and [`landing-zones`](../../../azure/landing-zones.md) (the landing zone whose policy requires a tag).

## Rules: EDR-AZ-CAF-NAME

Each rule is one of Microsoft's twenty-two naming and tagging items, numbered in page order: 1 to 10 from the naming page (with the
abbreviation table under 7), 11 to 22 from the tagging page. Every source line names the page under `https://learn.microsoft.com/en-us` and
the retrieval date; the sentence is the repository's own summary, never a quotation. The repository's decision on each item is in the rule
it binds to.

### Rule EDR-AZ-CAF-NAME-R01

Most resource names cannot be changed once the resource exists, so a name should carry only facts that stay true for the resource's life,
and everything else belongs in tags.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming (recommendation 1, retrieved 2026-10-15)

Binds to [ADR-AZ-NAMING-DETERMINISTICNAMES](../../../azure/azure-naming-standard.md#rule-adr-az-naming-deterministicnames) and
[ADR-AZ-NAMING-CAFALIGNMENT](../../../azure/azure-naming-standard.md#rule-adr-az-naming-cafalignment).

### Rule EDR-AZ-CAF-NAME-R02

Every resource type has its own rules: where its name must be unique, how long it may be, and which characters it may use.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming (recommendation 2, retrieved 2026-10-15)

Binds to [ADR-AZ-NAMING-NEVERTRUNCATE](../../../azure/azure-naming-standard.md#rule-adr-az-naming-nevertruncate) and
[ADR-AZ-NAMING-PATTERNPERRESOURCETYPE](../../../azure/azure-naming-standard.md#rule-adr-az-naming-patternperresourcetype).

### Rule EDR-AZ-CAF-NAME-R03

A name is unique either globally (services with a public DNS name), within its resource group (a virtual network), or within its parent
resource (a subnet in its virtual network).

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming (recommendation 3, retrieved 2026-10-15)

Binds to [ADR-AZ-NAMING-DETERMINISTICNAMES](../../../azure/azure-naming-standard.md#rule-adr-az-naming-deterministicnames) and
[ADR-AZ-NAMING-CAFALIGNMENT](../../../azure/azure-naming-standard.md#rule-adr-az-naming-cafalignment).

### Rule EDR-AZ-CAF-NAME-R04

Typical name components are the resource-type abbreviation, the workload or application, the environment, the region, and an instance
number.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming (recommendation 4, retrieved 2026-10-15)

Binds to [ADR-AZ-NAMING-DETERMINISTICNAMES](../../../azure/azure-naming-standard.md#rule-adr-az-naming-deterministicnames) and
[ADR-AZ-NAMING-SUBSCRIPTIONNOTCOMPONENT](../../../azure/azure-naming-standard.md#rule-adr-az-naming-subscriptionnotcomponent).

### Rule EDR-AZ-CAF-NAME-R05

Decide once in which order the name components appear, and keep to it.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming (recommendation 5, retrieved 2026-10-15)

Binds to [ADR-AZ-NAMING-ORDERISVARIANT](../../../azure/azure-naming-standard.md#rule-adr-az-naming-orderisvariant) and
[ADR-AZ-NAMING-ENVIRONMENTFIRST](../../../azure/azure-naming-standard.md#rule-adr-az-naming-environmentfirst).

### Rule EDR-AZ-CAF-NAME-R06

Hyphens make names easier to read, but some types forbid them; choose between readability (the common choice) and one form for every type
(no delimiter).

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming (recommendation 6, retrieved 2026-10-15)

Binds to [ADR-AZ-NAMING-PATTERNPERRESOURCETYPE](../../../azure/azure-naming-standard.md#rule-adr-az-naming-patternperresourcetype).

### Rule EDR-AZ-CAF-NAME-R07

Use CAF's resource-type abbreviations to keep names within their length limits. The abbreviation page lists one per resource type, by
category, with its provider namespace.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming and learn
/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations (recommendation 7, retrieved 2026-10-15)

Binds to [ADR-AZ-NAMING-CAFALIGNMENT](../../../azure/azure-naming-standard.md#rule-adr-az-naming-cafalignment).

### Rule EDR-AZ-CAF-NAME-R08

Microsoft's Azure Naming Tool generates names from a convention you configure in it.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming (recommendation 8, retrieved 2026-10-15)

Binds to [ADR-AZ-NAMING-CAFALIGNMENT](../../../azure/azure-naming-standard.md#rule-adr-az-naming-cafalignment).

### Rule EDR-AZ-CAF-NAME-R09

Azure does not treat names and tags as customer data, so neither may hold personal, sensitive, or confidential information.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming (recommendation 9, retrieved 2026-10-15)

Binds to [ADR-AZ-NAMING-CAFALIGNMENT](../../../azure/azure-naming-standard.md#rule-adr-az-naming-cafalignment) and
[ADR-AZ-LZ-CAFTAGS](../../../azure/landing-zones.md#rule-adr-az-lz-caftags).

### Rule EDR-AZ-CAF-NAME-R10

Example name patterns for common types: a resource group by workload and environment, a virtual network and a subnet by subscription
purpose, region, and number, a network security group by policy or application, a route table by its purpose, a SQL database by workload and
environment, a storage account by workload and number without hyphens; management groups by GUID with an editable display name;
subscriptions by descriptive display names.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming (recommendation 10, retrieved 2026-10-15)

Binds to [ADR-AZ-NAMING-CAFALIGNMENT](../../../azure/azure-naming-standard.md#rule-adr-az-naming-cafalignment).

### Rule EDR-AZ-CAF-NAME-R11

Before tagging, line up with the existing naming and governance standards, decide whether cost must be split below the subscription (tag
inheritance can help), list the operational and compliance facts the tags must carry, and decide which tags are mandatory and centrally
enforced and which are optional.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging (recommendation 11, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFTAGS](../../../azure/landing-zones.md#rule-adr-az-lz-caftags) and
[ADR-AZ-LZ-THREEBUILTINPOLICIES](../../../azure/landing-zones.md#rule-adr-az-lz-threebuiltinpolicies).

### Rule EDR-AZ-CAF-NAME-R12

Enforce one tagging schema everywhere with Azure Policy, using resource selectors such as the resource location for rules that apply only in
some regions.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging (recommendation 12, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-THREEBUILTINPOLICIES](../../../azure/landing-zones.md#rule-adr-az-lz-threebuiltinpolicies) and
[ADR-AZ-DATAMOD-POLICYENFORCEMENTMODE](../../../azure/azure-data-model.md#rule-adr-az-datamod-policyenforcementmode).

### Rule EDR-AZ-CAF-NAME-R13

Tags are plain text that shows up in cost reports, the APIs, deployment history, exports, and logs, so no secret or personal value belongs
in one.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging (recommendation 13, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFTAGS](../../../azure/landing-zones.md#rule-adr-az-lz-caftags).

### Rule EDR-AZ-CAF-NAME-R14

Tag keys are case-insensitive but values are case-sensitive, so use lowercase keys and one casing for values, or reports split one value
into several.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging (recommendation 14, retrieved 2026-10-15)

Binds to [ADR-AZ-NAMING-LOWERCASECOMPONENTS](../../../azure/azure-naming-standard.md#rule-adr-az-naming-lowercasecomponents) and
[ADR-AZ-LZ-CAFTAGS](../../../azure/landing-zones.md#rule-adr-az-lz-caftags).

### Rule EDR-AZ-CAF-NAME-R15

Add a tag naming the region, for reporting and compliance across regions.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging (recommendation 15, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFTAGS](../../../azure/landing-zones.md#rule-adr-az-lz-caftags) and
[ADR-AZ-NAMING-ENVIRONMENTFIRST](../../../azure/azure-naming-standard.md#rule-adr-az-naming-environmentfirst).

### Rule EDR-AZ-CAF-NAME-R16

Not every resource type takes tags; check Microsoft's support list.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging (recommendation 16, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFTAGS](../../../azure/landing-zones.md#rule-adr-az-lz-caftags).

### Rule EDR-AZ-CAF-NAME-R17

Functional tags describe a resource's technical role: its application, tier, environment, and region, for example an app, tier, environment,
region, or repository tag.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging (recommendation 17, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFTAGS](../../../azure/landing-zones.md#rule-adr-az-lz-caftags).

### Rule EDR-AZ-CAF-NAME-R18

Classification tags record sensitivity, compliance, and service level, for example criticality, confidentiality, and SLA tags.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging (recommendation 18, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFTAGS](../../../azure/landing-zones.md#rule-adr-az-lz-caftags).

### Rule EDR-AZ-CAF-NAME-R19

Accounting tags attribute cost to organisational units and projects for chargeback, showback, budgets, and alerts, for example department,
program, business centre, budget, and cost centre tags.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging (recommendation 19, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFTAGS](../../../azure/landing-zones.md#rule-adr-az-lz-caftags) and
[ADR-AZ-LZ-COSTATTRIBUTION](../../../azure/landing-zones.md#rule-adr-az-lz-costattribution).

### Rule EDR-AZ-CAF-NAME-R20

Purpose tags link a resource to the business process it serves and its business and revenue impact.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging (recommendation 20, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFTAGS](../../../azure/landing-zones.md#rule-adr-az-lz-caftags).

### Rule EDR-AZ-CAF-NAME-R21

Ownership tags name the business unit and the operations team responsible for a resource.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging (recommendation 21, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFTAGS](../../../azure/landing-zones.md#rule-adr-az-lz-caftags).

### Rule EDR-AZ-CAF-NAME-R22

Tag workloads so that Microsoft's assessment tooling can find them, following its guidance on labelling mission-critical workloads.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging (recommendation 22, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFTAGS](../../../azure/landing-zones.md#rule-adr-az-lz-caftags).

## Context

Microsoft's Cloud Adoption Framework (CAF) is its guidance for taking an organisation to Azure. Naming and tagging belongs to the resource
organisation design area and has three pages of its own: how to build a naming convention, a table of resource abbreviations, and how to
build a tagging strategy. Names identify a resource for its whole life; tags carry the facts about it that cost reports, policies, and
automation read and that may change. The live text is published under the
[Microsoft Learn Terms of Use](https://learn.microsoft.com/en-us/legal/termsofuse), which grant no licence to copy it into a shared
repository, so nothing is quoted.

The [CAF reference](../../../../references/caf/index.md) lists every CAF record in this repository and the Microsoft pages each one cites.
