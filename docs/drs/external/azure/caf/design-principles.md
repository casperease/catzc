# EDR: CAF design principles — Microsoft's five landing zone principles, as the repository reads them

Binds to [`landing-zones`](../../../azure/landing-zones.md) (the landing zone these principles frame) and
[`data-model`](../../../azure/azure-data-model.md) (the subscriptions, the configuration tree, and the policy enforcement setting).

## Rules: EDR-AZ-CAF-PRIN

Each rule is one of Microsoft's five design principles. Every source line names the page under `https://learn.microsoft.com/en-us` and the
retrieval date; the sentence is the repository's own summary, never a quotation. The repository's decision on each principle is in the rule
it binds to.

### Rule EDR-AZ-CAF-PRIN-R01

Subscription democratization: workload teams own and run their own subscriptions inside the platform's guardrails. The subscription is the
unit of management, development, test and production are separated by subscription, subscriptions come from a self-service vending process,
and they sit in a scalable management group hierarchy. A design that runs operations centrally pays in adapted resource organisation and in
teams that wait for subscriptions or create ungoverned ones.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-principles#subscription-democratization (recommendation 1, retrieved
2026-10-14)

Binds to [ADR-AZ-LZ-CAFPRINCIPLES](../../../azure/landing-zones.md#rule-adr-az-lz-cafprinciples),
[ADR-AZ-LZ-LANDINGZONE](../../../azure/landing-zones.md#rule-adr-az-lz-landingzone) and
[ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION](../../../azure/azure-data-model.md#rule-adr-az-datamod-onefileonesubscription).

### Rule EDR-AZ-CAF-PRIN-R02

Policy-driven governance: Azure Policy gives tool-agnostic guardrails that keep deployments within security, governance and regulatory
controls, and lets the platform team enforce and audit control-plane and data-plane configuration. Without them, keeping the estate
compliant takes more operational effort.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-principles#policy-driven-governance (recommendation 2, retrieved
2026-10-14)

Binds to [ADR-AZ-LZ-CAFPRINCIPLES](../../../azure/landing-zones.md#rule-adr-az-lz-cafprinciples),
[ADR-AZ-LZ-THREEBUILTINPOLICIES](../../../azure/landing-zones.md#rule-adr-az-lz-threebuiltinpolicies) and
[ADR-AZ-DATAMOD-POLICYENFORCEMENTMODE](../../../azure/azure-data-model.md#rule-adr-az-datamod-policyenforcementmode).

### Rule EDR-AZ-CAF-PRIN-R03

Single control and management plane: put no custom portal or tooling abstraction in front of Azure. Azure Resource Manager is the one
control plane for central and workload operations, governed by role-based access control and policy. Mixing the tooling of several vendors
adds integration complexity and hidden dependencies.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-principles#single-control-and-management-plane (recommendation 3,
retrieved 2026-10-14)

Binds to [ADR-AZ-LZ-CAFPRINCIPLES](../../../azure/landing-zones.md#rule-adr-az-lz-cafprinciples) and
[ADR-AZ-CLI-AZBYDEFAULT](../../../azure/prefer-az-cli.md#rule-adr-az-cli-azbydefault).

### Rule EDR-AZ-CAF-PRIN-R04

Application-centric service model: organise migration and development around applications rather than moving infrastructure as it is, treat
old and new, IaaS and PaaS applications alike, and give every application a secure environment. Segmenting workloads other than by the
reference management group options complicates policy and access control.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-principles#application-centric-service-model (recommendation 4,
retrieved 2026-10-14)

Binds to [ADR-AZ-LZ-CAFPRINCIPLES](../../../azure/landing-zones.md#rule-adr-az-lz-cafprinciples) and
[ADR-AZ-LZ-WORKLOADOWNSNONE](../../../azure/landing-zones.md#rule-adr-az-lz-workloadownsnone).

### Rule EDR-AZ-CAF-PRIN-R05

Alignment with Azure-native design and roadmaps: prefer Azure-native platform services wherever possible, and follow the Azure roadmaps so
new capabilities reach the environment. Third-party solutions create dependencies for feature support and for integration with first-party
services.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-principles#alignment-with-azure-native-design-and-roadmaps
(recommendation 5, retrieved 2026-10-14)

Binds to [ADR-AZ-LZ-CAFPRINCIPLES](../../../azure/landing-zones.md#rule-adr-az-lz-cafprinciples) and
[ADR-AZ-CLI-AZBYDEFAULT](../../../azure/prefer-az-cli.md#rule-adr-az-cli-azbydefault).

## Context

Microsoft's Cloud Adoption Framework (CAF) is its guidance for taking an organisation onto Azure. Its "Ready" methodology describes the
Azure landing zone: the platform an organisation prepares before workloads arrive, built from design areas (billing and tenant, identity,
resource organisation, network, security, management, governance, platform automation). Above the design areas stand five design principles,
which Microsoft states as aspirational targets and for each of which it names the cost of deviating. The live text is published under the
[Microsoft Learn Terms of Use](https://learn.microsoft.com/en-us/legal/termsofuse), which grant no licence to copy it into a shared
repository, so nothing is quoted.

The [CAF reference](../../../../references/caf/index.md) lists every CAF record in this repository and the Microsoft pages each one cites.
