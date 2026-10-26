# EDR: WAF performance efficiency — Microsoft's performance efficiency checklist PE:01 to PE:12, as the repository reads it

Binds to [`landing-zones`](../../../azure/landing-zones.md) (ADR-AZ-LZ-EVERYPILLAR names the performance-efficiency line of the workload)
and [`data-model`](../../../azure/azure-data-model.md) (the configuration tree that carries every SKU and capacity per environment class).

## Rules: EDR-AZ-WAF-PE

Each rule is one of Microsoft's twelve performance efficiency items (PE:01 to PE:12), keeping its native id. Every source line names the
guide page under `https://learn.microsoft.com/en-us` and the retrieval date; the sentence is the repository's own summary, never a
quotation. The repository's decision on each item is in the rule it binds to.

### Rule EDR-AZ-WAF-PE-PE01

PE:01, define performance targets: before a workload is deployed, give every flow numeric performance targets tied to business and user
requirements (error rate, throughput, concurrency, and latency, stated as percentiles rather than averages). Numbers instead of words like
"fast" make performance measurable, give the team shared goals, and show where resources should go.

Source: learn /azure/well-architected/performance-efficiency/performance-targets (PE:01, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-PERFBYCONFIG](../../../azure/landing-zones.md#rule-adr-az-lz-perfbyconfig).

### Rule EDR-AZ-WAF-PE-PE02

PE:02, conduct capacity planning: work out the compute, memory, storage, network, and staff a workload needs to meet its targets, ahead of
expected changes in demand. Base it on historical use or, for a new workload, on research and pilots; forecast demand; and know each
service's limits before the design reaches them.

Source: learn /azure/well-architected/performance-efficiency/capacity-planning (PE:02, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-PERFBYCONFIG](../../../azure/landing-zones.md#rule-adr-az-lz-perfbyconfig) and
[ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION](../../../azure/azure-data-model.md#rule-adr-az-datamod-onefileonesubscription).

### Rule EDR-AZ-WAF-PE-PE03

PE:03, select the right services: choose services, infrastructure, and tiers that can meet the performance targets and absorb expected
growth, preferring platform features and managed services over custom builds. Check limits, quotas, and region availability early, and set a
sensible tier and minimum instance count per service.

Source: learn /azure/well-architected/performance-efficiency/select-services (PE:03, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-PERFBYCONFIG](../../../azure/landing-zones.md#rule-adr-az-lz-perfbyconfig),
[ADR-AZ-LZ-EVERYPILLAR](../../../azure/landing-zones.md#rule-adr-az-lz-everypillar), and
[ADR-AZ-LZ-THREEBUILTINPOLICIES](../../../azure/landing-zones.md#rule-adr-az-lz-threebuiltinpolicies).

### Rule EDR-AZ-WAF-PE-PE04

PE:04, establish consistent performance measurement: measure performance the same way over time, so behaviour can be compared with a
baseline and slowdowns, waste, or scaling gaps show early. Keep production and non-production data apart, put a diagnostic setting on every
resource, and alert on the end-to-end experience.

Source: learn /azure/well-architected/performance-efficiency/monitoring (PE:04, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-PERFBYCONFIG](../../../azure/landing-zones.md#rule-adr-az-lz-perfbyconfig),
[ADR-AZ-LZ-CAFMANAGEMENT](../../../azure/landing-zones.md#rule-adr-az-lz-cafmanagement), and
[ADR-AZ-LZ-THREEBUILTINPOLICIES](../../../azure/landing-zones.md#rule-adr-az-lz-threebuiltinpolicies).

### Rule EDR-AZ-WAF-PE-PE05

PE:05, optimize scaling and partitioning: make scaling and partitioning deliberate and dependable, built on a defined scale unit, so the
workload keeps up as demand rises and stops paying when it falls. Choose vertical or horizontal scaling per component, autoscale managed
services with upper limits, add scale units as stamps, and plan data partitioning early.

Source: learn /azure/well-architected/performance-efficiency/scale-partition (PE:05, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-PERFBYCONFIG](../../../azure/landing-zones.md#rule-adr-az-lz-perfbyconfig),
[ADR-AZ-LZ-LINKSNEEDBOTHNETWORKS](../../../azure/landing-zones.md#rule-adr-az-lz-linksneedbothnetworks), and
[ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION](../../../azure/azure-data-model.md#rule-adr-az-datamod-onefileonesubscription).

### Rule EDR-AZ-WAF-PE-PE06

PE:06, optimize your workload's performance by regularly testing in a production-like environment: test performance early and regularly, in
an environment close enough to production that the results mean something. Derive pass and fail criteria from the targets, run performance
tests in deployment pipelines and on a schedule, and record and refresh the baselines.

Source: learn /azure/well-architected/performance-efficiency/performance-test (PE:06, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-PERFBYCONFIG](../../../azure/landing-zones.md#rule-adr-az-lz-perfbyconfig) and
[ADR-AUTO-TEST-TESTINGINPRODUCTION](../../../automation/test-automation.md#rule-adr-auto-test-testinginproduction).

### Rule EDR-AZ-WAF-PE-PE07

PE:07, optimize code and infrastructure: make code efficient and hand responsibilities to the platform, using code and infrastructure only
for their core purpose and only where needed. Profile to find hot paths and fix them at the root instead of adding capacity, keep
infrastructure simple, and offload work such as security filtering.

Source: learn /azure/well-architected/performance-efficiency/optimize-code-infrastructure (PE:07, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-PERFBYCONFIG](../../../azure/landing-zones.md#rule-adr-az-lz-perfbyconfig) and
[ADR-AZ-LZ-SQLENTRAADMINS](../../../azure/landing-zones.md#rule-adr-az-lz-sqlentraadmins).

### Rule EDR-AZ-WAF-PE-PE08

PE:08, optimize data usage: tune data stores, partitions, and indexes to how the workload is meant to use its data and how it actually does,
so reading, writing, and processing data does not become the bottleneck. Profile the data and its access patterns, watch data-specific
metrics such as query time and I/O, and archive and purge.

Source: learn /azure/well-architected/performance-efficiency/optimize-data-performance (PE:08, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-PERFBYCONFIG](../../../azure/landing-zones.md#rule-adr-az-lz-perfbyconfig).

### Rule EDR-AZ-WAF-PE-PE09

PE:09, prioritize the performance of critical flows: give the flows that carry the most important business processes, users, and operations
first claim on resources and on optimisation effort, and let lower-priority flows give way when capacity is short. Inventory every flow,
rate each one by business impact, and isolate critical flows with dedicated resources.

Source: learn /azure/well-architected/performance-efficiency/prioritize-critical-flows (PE:09, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-PERFBYCONFIG](../../../azure/landing-zones.md#rule-adr-az-lz-perfbyconfig) and
[ADR-AZ-LZ-CAFTAGS](../../../azure/landing-zones.md#rule-adr-az-lz-caftags).

### Rule EDR-AZ-WAF-PE-PE10

PE:10, optimize operational tasks: routine operations (deployments, backups, secret rotation, virus scans, index rebuilds) share resources
with the workload, so measure their effect on performance, keep it small, and count it in the performance targets. Test in-place upgrades
first, schedule them off-peak, and use incremental or platform backups.

Source: learn /azure/well-architected/performance-efficiency/optimize-operational-tasks (PE:10, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-PERFBYCONFIG](../../../azure/landing-zones.md#rule-adr-az-lz-perfbyconfig) and
[ADR-AZ-LZ-LINKSNEEDBOTHNETWORKS](../../../azure/landing-zones.md#rule-adr-az-lz-linksneedbothnetworks).

### Rule EDR-AZ-WAF-PE-PE11

PE:11, respond to live performance issues: prepare to handle production performance problems quickly and precisely, with clear lines of
communication, roles, and access to data. Grant time-limited least-privilege access to monitoring data, alert on deviation from baselines,
follow a documented triage plan, and turn each finding into automation or a sharper alert.

Source: learn /azure/well-architected/performance-efficiency/respond-live-performance-issues (PE:11, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-PERFBYCONFIG](../../../azure/landing-zones.md#rule-adr-az-lz-perfbyconfig) and
[ADR-AZ-LZ-CAFMANAGEMENT](../../../azure/landing-zones.md#rule-adr-az-lz-cafmanagement).

### Rule EDR-AZ-WAF-PE-PE12

PE:12, continuously optimize performance: keep optimising performance for the workload's whole life, because usage, data volume, features,
and technical debt change how it behaves. Make targets, baselines, and thresholds visible, evaluate new platform features, and automate
testing, monitoring, and remediation.

Source: learn /azure/well-architected/performance-efficiency/continuous-performance-optimize (PE:12, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-PERFBYCONFIG](../../../azure/landing-zones.md#rule-adr-az-lz-perfbyconfig).

## Context

The Azure Well-Architected Framework (WAF) is Microsoft's guidance for reviewing a cloud workload against five pillars: reliability,
security, cost optimization, operational excellence, and performance efficiency. Each pillar has a checklist of numbered recommendations,
and each recommendation has a guide page that explains it. Performance efficiency is about a workload meeting its demand efficiently: it
stays responsive as load rises and falls, without paying for capacity it does not use.

The current WAF text is published under the Microsoft Learn Terms of Use, which carry no reuse licence for a shared repository, so nothing
is quoted. The checklist lives at
[learn.microsoft.com](https://learn.microsoft.com/en-us/azure/well-architected/performance-efficiency/checklist).

The [WAF reference](../../../../references/waf/index.md) lists the five pillar records in this repository and the Microsoft checklist each
one cites.
