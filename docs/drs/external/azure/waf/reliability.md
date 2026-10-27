# EDR: WAF reliability — Microsoft's reliability checklist RE:01 to RE:10, as the repository reads it

Binds to [`landing-zones`](../../../azure/landing-zones.md) (the landing zone and the workload these rules review) and
[`network-model`](../../../azure/azure-network-model.md) (the one region per environment that bounds every redundancy rule here).

## Rules: EDR-AZ-WAF-RE

Each rule is one of Microsoft's ten reliability items (RE:01 to RE:10), keeping its native id. Every source line names the guide page under
`https://learn.microsoft.com/en-us` and the retrieval date; the sentence is the repository's own summary, never a quotation. The
repository's decision on each item is in the rule it binds to.

### Rule EDR-AZ-WAF-RE-RE01

RE:01, focus your workload design on simplicity and efficiency: trace every component and design choice back to a business requirement,
because each extra moving part adds coordination and new ways to fail. Managed platform services take building and running work off the
team, loose coupling stops one failure from cascading, cross-cutting concerns such as authentication belong in one shared service, and code
nothing uses is removed.

Source: learn /azure/well-architected/reliability/simplify (RE:01, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-ONEREGIONRELIABILITY](../../../azure/landing-zones.md#rule-adr-az-lz-oneregionreliability),
[ADR-AZ-LZ-EVERYPILLAR](../../../azure/landing-zones.md#rule-adr-az-lz-everypillar),
[ADR-AZ-LZ-WORKLOADOWNSNONE](../../../azure/landing-zones.md#rule-adr-az-lz-workloadownsnone), and
[ADR-AZ-LZ-SQLENTRAADMINS](../../../azure/landing-zones.md#rule-adr-az-lz-sqlentraadmins).

### Rule EDR-AZ-WAF-RE-RE02

RE:02, identify and rate user and system flows: early in design, list every user flow and system flow with its start, end, steps and
dependencies, and tie each to the business process it serves, its owner and its business impact. Rate each flow's criticality (high, medium,
low) so reliability investment goes to the most critical first, and revisit the rating as priorities and usage change.

Source: learn /azure/well-architected/reliability/identify-flows (RE:02, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-ONEREGIONRELIABILITY](../../../azure/landing-zones.md#rule-adr-az-lz-oneregionreliability) and
[ADR-AZ-LZ-CAFTAGS](../../../azure/landing-zones.md#rule-adr-az-lz-caftags).

### Rule EDR-AZ-WAF-RE-RE03

RE:03, use failure mode analysis (FMA) to identify potential failures in your workload: failures happen however much resiliency is built in,
so walk each critical flow step by step, list the components and the internal and external dependencies it uses, class each dependency as
strong or weak, and ask how each failure mode would affect it. For each relevant failure, decide the mitigation and how it is detected.

Source: learn /azure/well-architected/reliability/failure-mode-analysis (RE:03, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-ONEREGIONRELIABILITY](../../../azure/landing-zones.md#rule-adr-az-lz-oneregionreliability),
[ADR-AZ-LZ-HUBANDSPOKE](../../../azure/landing-zones.md#rule-adr-az-lz-hubandspoke), and
[ADR-AZ-NETWORK-ONEADDRESSSPACE](../../../azure/azure-network-model.md#rule-adr-az-network-oneaddressspace).

### Rule EDR-AZ-WAF-RE-RE04

RE:04, define reliability and recovery targets: agree realistic availability, correctness and recovery targets with the business and use
them both to drive the design and to build the workload's health model. Measure each SLO through SLIs, treat a provider SLA as an input
whose real coverage has to be understood, and set RTO, RPO and MTTR targets that recovery testing confirms.

Source: learn /azure/well-architected/reliability/metrics (RE:04, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-ONEREGIONRELIABILITY](../../../azure/landing-zones.md#rule-adr-az-lz-oneregionreliability).

### Rule EDR-AZ-WAF-RE-RE05

RE:05, add redundancy at different levels, especially for critical flows: run several instances of each component, and where the targets
demand it whole copies of the workload, so that one failing resource does not stop a critical flow. Decide the amount and placement per flow
from its targets, weighed against cost and latency, with managed services first, zone-redundant deployment, data replicated across zones or
regions, a resilient network, and delete locks on the resources that carry redundancy.

Source: learn /azure/well-architected/reliability/redundancy (RE:05, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-ONEREGIONRELIABILITY](../../../azure/landing-zones.md#rule-adr-az-lz-oneregionreliability),
[ADR-AZ-LZ-EVERYPILLAR](../../../azure/landing-zones.md#rule-adr-az-lz-everypillar),
[ADR-AZ-NETWORK-ONEADDRESSSPACE](../../../azure/azure-network-model.md#rule-adr-az-network-oneaddressspace), and
[ADR-AZ-NAMING-CAFALIGNMENT](../../../azure/azure-naming-standard.md#rule-adr-az-naming-cafalignment).

### Rule EDR-AZ-WAF-RE-RE06

RE:06, implement a timely and reliable scaling strategy at the application, data, and infrastructure levels: scaling must keep up with
demand without operator effort, so design it from the observed or expected load of each flow and component. Keep the autoscale settings in
infrastructure as code with a cap on scale units, account for slow-scaling services and data stores, and log every scaling event.

Source: learn /azure/well-architected/reliability/scaling (RE:06, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-ONEREGIONRELIABILITY](../../../azure/landing-zones.md#rule-adr-az-lz-oneregionreliability),
[ADR-AZ-LZ-EVERYPILLAR](../../../azure/landing-zones.md#rule-adr-az-lz-everypillar), and
[ADR-AZ-NETWORK-PERSUBSCRIPTION](../../../azure/azure-network-model.md#rule-adr-az-network-persubscription).

### Rule EDR-AZ-WAF-RE-RE07

RE:07, strengthen the resiliency of your workload by implementing self-preservation and self-healing measures: design so a failing component
neither takes the whole workload down (self-preservation) nor needs a person to recover (self-healing). Limit the blast radius with
bulkheads and deployment stamps, turn on automatic failover where a service offers it, and let monitoring trigger automated remediation.

Source: learn /azure/well-architected/reliability/self-preservation (RE:07, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-ONEREGIONRELIABILITY](../../../azure/landing-zones.md#rule-adr-az-lz-oneregionreliability) and
[ADR-AZ-LZ-LANDINGZONE](../../../azure/landing-zones.md#rule-adr-az-lz-landingzone).

### Rule EDR-AZ-WAF-RE-RE08

RE:08, test for resiliency and availability scenarios by applying the principles of chaos engineering: a resiliency mechanism is trusted
only once tested, so test critical flows end to end against their SLO, RTO and RPO. Restore backups regularly and time it, test dependency
failures, run contained chaos experiments and full failover drills, and feed the results back into the analysis and the recovery plans.

Source: learn /azure/well-architected/reliability/reliability-test (RE:08, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-ONEREGIONRELIABILITY](../../../azure/landing-zones.md#rule-adr-az-lz-oneregionreliability) and
[ADR-AZ-DATAMOD-PARAMETERCONTRACT](../../../azure/azure-data-model.md#rule-adr-az-datamod-parametercontract).

### Rule EDR-AZ-WAF-RE-RE09

RE:09, implement structured, tested, and documented disaster recovery (DR) plans: write a disaster recovery plan, derived from business
criticality, that says when an event counts as a disaster, who decides and communicates, and the ordered steps that recover components, data
and the whole workload. Prepare the secondary region, replicate data to match the RPO, automate recovery as idempotent deployments, and
drill the plan regularly.

Source: learn /azure/well-architected/reliability/disaster-recovery (RE:09, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-ONEREGIONRELIABILITY](../../../azure/landing-zones.md#rule-adr-az-lz-oneregionreliability),
[ADR-AZ-LZ-LINKSNEEDBOTHNETWORKS](../../../azure/landing-zones.md#rule-adr-az-lz-linksneedbothnetworks),
[ADR-AZ-NETWORK-ONEADDRESSSPACE](../../../azure/azure-network-model.md#rule-adr-az-network-oneaddressspace), and
[ADR-AZ-DATAMOD-STATICRESOURCENAMES](../../../azure/azure-data-model.md#rule-adr-az-datamod-staticresourcenames).

### Rule EDR-AZ-WAF-RE-RE10

RE:10, continuously measure and track system health using uptime and reliability indicators: monitor whether the workload delivers correct
results to users and meets its availability and recovery targets, from the application, its data stores and its network. Roll the signals up
into a health model, track capacity and recovery metrics, alert on Service Health and Resource Health, and keep telemetry long enough for
incident analysis.

Source: learn /azure/well-architected/reliability/monitoring (RE:10, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-ONEREGIONRELIABILITY](../../../azure/landing-zones.md#rule-adr-az-lz-oneregionreliability),
[ADR-AZ-LZ-CAFMANAGEMENT](../../../azure/landing-zones.md#rule-adr-az-lz-cafmanagement), and
[ADR-AZ-LZ-LANDINGZONEPOLICIES](../../../azure/landing-zones.md#rule-adr-az-lz-landingzonepolicies).

## Context

Microsoft's Azure Well-Architected Framework (WAF) reviews a workload against five pillars: reliability, security, cost optimization,
operational excellence, and performance efficiency. Each pillar publishes a design review checklist of numbered recommendations, and each
recommendation links to a guide that explains it. The reliability pillar asks whether a workload keeps working when parts of it fail and how
it returns to full function afterwards, starting from the availability and recovery targets the business sets.

The current WAF text is published under the [Microsoft Learn Terms of Use](https://learn.microsoft.com/en-us/legal/termsofuse), not under a
reuse licence, so nothing is quoted.

The [WAF reference](../../../../references/waf/index.md) lists the five pillar records in this repository and the Microsoft checklist each
one cites.
