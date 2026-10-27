# EDR: WAF cost optimization — Microsoft's cost optimization checklist, as the repository reads it

Binds to [`landing-zones`](../../../azure/landing-zones.md) (the landing zone that carries the budget and the guardrails) and
[`data-model`](../../../azure/azure-data-model.md) (the configuration tree every cost value lives in).

## Rules: EDR-AZ-WAF-CO

Each rule is one of Microsoft's fourteen cost optimization items (CO:01 to CO:14), keeping its native id. Every source line names the guide
page under `https://learn.microsoft.com/en-us` and the retrieval date; the sentence is the repository's own summary, never a quotation. The
repository's decision on each item is in the rule it binds to.

### Rule EDR-AZ-WAF-CO-CO01

CO:01, create a culture of financial responsibility: the workload team shares ownership of what the workload costs and has the skills and
figures to spend well. Open budgets and cost data, ongoing training, room to propose savings, and clearly stated financial goals build that
ownership.

Source: learn /azure/well-architected/cost-optimization/create-culture-financial-responsibility (CO:01, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-COSTBYCLASS](../../../azure/landing-zones.md#rule-adr-az-lz-costbyclass) and
[ADR-AZ-LZ-COSTATTRIBUTION](../../../azure/landing-zones.md#rule-adr-az-lz-costattribution).

### Rule EDR-AZ-WAF-CO-CO02

CO:02, create and maintain a cost model: forecast what the workload costs up front, at its running rate, and over time, covering services,
licences, reliability, operations, and supporting services such as monitoring and security. The model is the basis for a budget with a
buffer for unplanned spend, and it is kept current with usage data and design changes.

Source: learn /azure/well-architected/cost-optimization/cost-model (CO:02, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-COSTBYCLASS](../../../azure/landing-zones.md#rule-adr-az-lz-costbyclass).

### Rule EDR-AZ-WAF-CO-CO03

CO:03, collect and review cost data: gather daily cost data, actual and amortized, into one central place where it can be grouped and
reported. Stakeholders review spend regularly against the budget and the cost model, and automated alerts flag threshold crossings and
deviations from the trend.

Source: learn /azure/well-architected/cost-optimization/collect-review-cost-data (CO:03, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-COSTATTRIBUTION](../../../azure/landing-zones.md#rule-adr-az-lz-costattribution),
[ADR-AZ-LZ-CAFTAGS](../../../azure/landing-zones.md#rule-adr-az-lz-caftags), and
[ADR-AZ-LZ-LANDINGZONEPOLICIES](../../../azure/landing-zones.md#rule-adr-az-lz-landingzonepolicies).

### Rule EDR-AZ-WAF-CO-CO04

CO:04, set spending guardrails: use automated controls, enforced by the platform rather than by manual review, to keep the workload within
its budget and away from what it should not use. Guardrails span governance policies, access control, release gates, alerts, and
infrastructure as code.

Source: learn /azure/well-architected/cost-optimization/set-spending-guardrails (CO:04, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-LANDINGZONEPOLICIES](../../../azure/landing-zones.md#rule-adr-az-lz-landingzonepolicies),
[ADR-AZ-DATAMOD-POLICYENFORCEMENTMODE](../../../azure/azure-data-model.md#rule-adr-az-datamod-policyenforcementmode),
[ADR-AZ-DATAMOD-PARAMETERCONTRACT](../../../azure/azure-data-model.md#rule-adr-az-datamod-parametercontract), and
[ADR-AZ-LZ-COSTBYCLASS](../../../azure/landing-zones.md#rule-adr-az-lz-costbyclass).

### Rule EDR-AZ-WAF-CO-CO05

CO:05, get the best rates from providers: lower the unit price of what the workload uses, without changing its design, by choosing the right
billing model and using discounts and licence benefits. Start with the most expensive items and revisit the rates regularly.

Source: learn /azure/well-architected/cost-optimization/get-best-rates (CO:05, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-COSTBYCLASS](../../../azure/landing-zones.md#rule-adr-az-lz-costbyclass) and
[ADR-AZ-LZ-LANDINGZONE](../../../azure/landing-zones.md#rule-adr-az-lz-landingzone).

### Rule EDR-AZ-WAF-CO-CO06

CO:06, align usage to billing increments: learn how each service is metered (time, requests, data transferred, storage) and shape the
service choice or the usage so consumption matches the meter. A short proof of concept confirms the billing assumptions for the main cost
drivers before the design is committed.

Source: learn /azure/well-architected/cost-optimization/align-usage-to-billing-increments (CO:06, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-COSTBYCLASS](../../../azure/landing-zones.md#rule-adr-az-lz-costbyclass).

### Rule EDR-AZ-WAF-CO-CO07

CO:07, optimize component costs: review the running workload for application features, platform features, and resources that cost more than
they return, and remove, right-size, or rework them. Avoid new waste by finding the root cause before changing a solution and by keeping
every resource tracked.

Source: learn /azure/well-architected/cost-optimization/optimize-component-costs (CO:07, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-COSTBYCLASS](../../../azure/landing-zones.md#rule-adr-az-lz-costbyclass),
[ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION](../../../azure/azure-data-model.md#rule-adr-az-datamod-onefileonesubscription), and
[ADR-AZ-NAMING-DETERMINISTICNAMES](../../../azure/azure-naming-standard.md#rule-adr-az-naming-deterministicnames).

### Rule EDR-AZ-WAF-CO-CO08

CO:08, optimize environment costs: spend on each environment (production, pre-production, recovery, operations) in proportion to its value
and risk instead of making them all alike. Non-production stays close enough to production to catch problems, with deliberate, governed
reductions in scale, tier, and running hours.

Source: learn /azure/well-architected/cost-optimization/optimize-environment-costs (CO:08, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-COSTBYCLASS](../../../azure/landing-zones.md#rule-adr-az-lz-costbyclass),
[ADR-AZ-LZ-EVERYPILLAR](../../../azure/landing-zones.md#rule-adr-az-lz-everypillar), and
[ADR-AZ-DATAMOD-POLICYENFORCEMENTMODE](../../../azure/azure-data-model.md#rule-adr-az-datamod-policyenforcementmode).

### Rule EDR-AZ-WAF-CO-CO09

CO:09, optimize flow costs: match what each user or system flow costs to how much it matters, putting money into critical flows and running
lower-priority ones on cheaper configurations. That can mean separating flows with different needs onto different resources, or combining
similar flows onto shared ones.

Source: learn /azure/well-architected/cost-optimization/optimize-flow-costs (CO:09, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-COSTBYCLASS](../../../azure/landing-zones.md#rule-adr-az-lz-costbyclass).

### Rule EDR-AZ-WAF-CO-CO10

CO:10, optimize data costs: spend on storing and handling data according to how important it is and how often it is read. That covers
lifecycle management (tiering and retention), how much data is kept, how it is replicated and backed up, which file formats are used, and
which storage service holds it.

Source: learn /azure/well-architected/cost-optimization/optimize-data-costs (CO:10, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-COSTBYCLASS](../../../azure/landing-zones.md#rule-adr-az-lz-costbyclass).

### Rule EDR-AZ-WAF-CO-CO11

CO:11, optimize code costs: change application code so it gives the same functional and nonfunctional results with fewer or cheaper
resources, once scaling and sizing are in place. Instrumentation shows hot paths and waste that autoscaling or serverless can otherwise
hide.

Source: learn /azure/well-architected/cost-optimization/optimize-code-costs (CO:11, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-COSTBYCLASS](../../../azure/landing-zones.md#rule-adr-az-lz-costbyclass).

### Rule EDR-AZ-WAF-CO-CO12

CO:12, optimize scaling costs: scale out or up only when needed and back down as soon as practical, choosing the scaling approach that is
cheapest for the required result. Compare options against the cost model and the service limits, and manage both demand and supply.

Source: learn /azure/well-architected/cost-optimization/optimize-scaling-costs (CO:12, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-COSTBYCLASS](../../../azure/landing-zones.md#rule-adr-az-lz-costbyclass).

### Rule EDR-AZ-WAF-CO-CO13

CO:13, optimize personnel time: people are usually a workload's largest cost, so spend each hour by the priority of the task without
lowering the quality of the outcome, with faster feedback in development, smoother collaboration and processes, and less noise in
operations.

Source: learn /azure/well-architected/cost-optimization/optimize-personnel-time (CO:13, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-COSTBYCLASS](../../../azure/landing-zones.md#rule-adr-az-lz-costbyclass) and
[ADR-AZ-DATAMOD-VALUEBYADDRESS](../../../azure/azure-data-model.md#rule-adr-az-datamod-valuebyaddress).

### Rule EDR-AZ-WAF-CO-CO14

CO:14, consolidate resources and responsibility: run more on fewer resources inside the workload, and use shared resources and specialist
teams the organisation has instead of duplicating them. Weigh every consolidation against its effect on isolation, security, compliance, and
redundancy.

Source: learn /azure/well-architected/cost-optimization/consolidation (CO:14, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-COSTBYCLASS](../../../azure/landing-zones.md#rule-adr-az-lz-costbyclass),
[ADR-AZ-LZ-LANDINGZONE](../../../azure/landing-zones.md#rule-adr-az-lz-landingzone), and
[ADR-AZ-LZ-HUBANDSPOKE](../../../azure/landing-zones.md#rule-adr-az-lz-hubandspoke).

## Context

The Azure Well-Architected Framework (WAF) is Microsoft's guidance for designing and running a workload on Azure. It groups its advice into
five pillars (reliability, security, cost optimization, operational excellence, and performance efficiency) and gives each pillar a
checklist of numbered recommendations, each with its own guide. The cost optimization pillar asks a workload to get, and keep, a good return
on what it costs: spend weighed against the value it delivers, as an ongoing practice rather than a one-off review.

The current WAF text is published under the Microsoft Learn Terms of Use, which grant no licence to copy it into a shared repository, so
nothing is quoted.

The [WAF reference](../../../../references/waf/index.md) lists the five pillar records in this repository and the Microsoft checklist each
one cites.
