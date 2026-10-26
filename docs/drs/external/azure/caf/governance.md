# EDR: CAF governance — Microsoft's governance design recommendations, as the repository reads them

Binds to [`landing-zones`](../../../azure/landing-zones.md) (the landing zone that assigns the policies and carries the budget) and
[`data-model`](../../../azure/azure-data-model.md) (the repository-wide `policy_enforcement` setting).

## Rules: EDR-AZ-CAF-GOV

Each rule is one of Microsoft's ten governance recommendations, numbered in the order the area page lists them (eight under deployment
acceleration, two under cost management). Every source line names the page under `https://learn.microsoft.com/en-us` and the retrieval date;
the sentence is the repository's own summary, never a quotation. The repository's decision on each recommendation is in the rule it binds
to.

### Rule EDR-AZ-CAF-GOV-R01

Decide which tags are mandatory and have Azure Policy enforce them, using the append mode so a missing tag is added rather than left out;
the tagging strategy page holds the detail.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/governance (recommendation 1, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-THREEBUILTINPOLICIES](../../../azure/landing-zones.md#rule-adr-az-lz-threebuiltinpolicies) and
[ADR-AZ-DATAMOD-POLICYENFORCEMENTMODE](../../../azure/azure-data-model.md#rule-adr-az-datamod-policyenforcementmode).

### Rule EDR-AZ-CAF-GOV-R02

Translate the regulatory and compliance obligations that apply into concrete policy definitions and role assignments.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/governance (recommendation 2, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-GOVERNANCELIMITS](../../../azure/landing-zones.md#rule-adr-az-lz-governancelimits).

### Rule EDR-AZ-CAF-GOV-R03

Create custom policy definitions at the top-level root management group, so they can be assigned at any level beneath it.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/governance (recommendation 3, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-GOVERNANCELIMITS](../../../azure/landing-zones.md#rule-adr-az-lz-governancelimits) and
[ADR-AZ-LZ-LANDINGZONE](../../../azure/landing-zones.md#rule-adr-az-lz-landingzone).

### Rule EDR-AZ-CAF-GOV-R04

Assign each policy at the highest level where it fits, and exclude a lower level only when it needs to differ.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/governance (recommendation 4, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-THREEBUILTINPOLICIES](../../../azure/landing-zones.md#rule-adr-az-lz-threebuiltinpolicies).

### Rule EDR-AZ-CAF-GOV-R05

Use Azure Policy at subscription or management-group level to control which resource providers may be registered.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/governance (recommendation 5, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-GOVERNANCELIMITS](../../../azure/landing-zones.md#rule-adr-az-lz-governancelimits).

### Rule EDR-AZ-CAF-GOV-R06

Use built-in policy definitions wherever they fit, to keep the effort of maintaining policy low. The pages on keeping a landing zone up to
date, migrating its policies, and updating custom policies carry procedures rather than recommendations, so they are not rules here.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/governance (recommendation 6, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-THREEBUILTINPOLICIES](../../../azure/landing-zones.md#rule-adr-az-lz-threebuiltinpolicies).

### Rule EDR-AZ-CAF-GOV-R07

Give application teams the built-in Resource Policy Contributor role where they work, so they can govern their own applications.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/governance (recommendation 7, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-GOVERNANCELIMITS](../../../azure/landing-zones.md#rule-adr-az-lz-governancelimits) and
[ADR-AZ-LZ-WORKLOADOWNSNONE](../../../azure/landing-zones.md#rule-adr-az-lz-workloadownsnone).

### Rule EDR-AZ-CAF-GOV-R08

Make few assignments at the root management group, so exclusions do not have to be managed at every level beneath it.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/governance (recommendation 8, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-GOVERNANCELIMITS](../../../azure/landing-zones.md#rule-adr-az-lz-governancelimits).

### Rule EDR-AZ-CAF-GOV-R09

Use Microsoft Cost Management to keep financial oversight of the whole environment.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/governance (recommendation 9, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-COSTATTRIBUTION](../../../azure/landing-zones.md#rule-adr-az-lz-costattribution).

### Rule EDR-AZ-CAF-GOV-R10

Tag resources with metadata such as the cost centre or the project, so cost can be analysed at a finer grain.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/governance (recommendation 10, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-COSTATTRIBUTION](../../../azure/landing-zones.md#rule-adr-az-lz-costattribution) and
[ADR-AZ-LZ-THREEBUILTINPOLICIES](../../../azure/landing-zones.md#rule-adr-az-lz-threebuiltinpolicies).

## Context

Microsoft's Cloud Adoption Framework (CAF) is its guidance for adopting Azure across an organisation. Its landing-zone guidance splits the
platform into design areas, each with considerations and numbered design recommendations; the governance area covers what to audit, what to
enforce, and what to deploy automatically by Azure Policy, plus the cost oversight that keeps spend visible. The live text is published
under the Microsoft Learn Terms of Use, which grant no licence to copy it into a shared repository, so nothing is quoted.

The [CAF reference](../../../../references/caf/index.md) lists every CAF record in this repository and the Microsoft pages each one cites.
