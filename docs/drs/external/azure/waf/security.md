# EDR: WAF security — Microsoft's security checklist SE:01 to SE:12, as the repository reads it

Binds to [`landing-zones`](../../../azure/landing-zones.md) (its Security line,
[ADR-AZ-LZ-EVERYPILLAR](../../../azure/landing-zones.md#rule-adr-az-lz-everypillar), is the summary these rules expand),
[`network-model`](../../../azure/azure-network-model.md) (the segments the network rules rely on), and
[`data-model`](../../../azure/azure-data-model.md) (where a secret may and may not appear in a config).

## Rules: EDR-AZ-WAF-SE

Each rule is one of Microsoft's twelve security items (SE:01 to SE:12), keeping its native id. Every source line names the guide page under
`https://learn.microsoft.com/en-us` and the retrieval date; the sentence is the repository's own summary, never a quotation. The
repository's decision on each item is in the rule it binds to.

### Rule EDR-AZ-WAF-SE-SE01

SE:01, establish a security baseline: write down the minimum security requirements the workload must meet, drawn from compliance
obligations, industry benchmarks, and the platform's own benchmark, and agree them before design begins. The baseline covers technical
controls and operations alike, turns its criteria into guardrails such as policy as code, and is measured continuously so drift is caught.

Source: learn /azure/well-architected/security/establish-baseline (SE:01, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-SECUREBYDEFAULT](../../../azure/landing-zones.md#rule-adr-az-lz-securebydefault),
[ADR-AZ-LZ-EVERYPILLAR](../../../azure/landing-zones.md#rule-adr-az-lz-everypillar),
[ADR-AZ-LZ-THREEBUILTINPOLICIES](../../../azure/landing-zones.md#rule-adr-az-lz-threebuiltinpolicies), and
[ADR-AZ-DATAMOD-POLICYENFORCEMENTMODE](../../../azure/azure-data-model.md#rule-adr-az-datamod-policyenforcementmode).

### Rule EDR-AZ-WAF-SE-SE02

SE:02, align secure development lifecycle (SDL) throughout the software development lifecycle: build security into every stage of
development, from requirements through build, deployment, and decommissioning, and extend it to the whole software supply chain. Threat
modeling, secure coding, automated security testing, keeping secrets out of version control, and staged releases keep design choices and
code from introducing exploitable weaknesses.

Source: learn /azure/well-architected/security/secure-development-lifecycle (SE:02, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-SECUREBYDEFAULT](../../../azure/landing-zones.md#rule-adr-az-lz-securebydefault),
[ADR-AZ-DATAMOD-PARAMETERCONTRACT](../../../azure/azure-data-model.md#rule-adr-az-datamod-parametercontract),
[ADR-AUTO-GUIDS-EVERYGUIDREGISTERED](../../../automation/managed-guids.md#rule-adr-auto-guids-everyguidregistered), and
[EDR-DORA-SECURITY-SECUREPATHAUTOMATED](../../dora/pervasive-security.md#rule-edr-dora-security-securepathautomated).

### Rule EDR-AZ-WAF-SE-SE03

SE:03, classify and consistently apply sensitivity and information type labels: use the organisation's taxonomy to label all workload data,
and the components that process it, by sensitivity, information type, and compliance scope. The labels drive design choices such as
segmentation, encryption strength, masking, and retention, and they travel with the data through every component.

Source: learn /azure/well-architected/security/data-classification (SE:03, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-SECUREBYDEFAULT](../../../azure/landing-zones.md#rule-adr-az-lz-securebydefault) and
[ADR-AZ-LZ-CAFTAGS](../../../azure/landing-zones.md#rule-adr-az-lz-caftags).

### Rule EDR-AZ-WAF-SE-SE04

SE:04, create intentional segmentation and perimeters: divide the workload into segments, each secured as a unit, using identity, network,
roles, and resource organisation together, so a breach in one segment cannot spread to the next. Identity is the main perimeter and the
network adds to it; clear ownership of each segment speeds up incident response.

Source: learn /azure/well-architected/security/segmentation (SE:04, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-SECUREBYDEFAULT](../../../azure/landing-zones.md#rule-adr-az-lz-securebydefault),
[ADR-AZ-LZ-HUBANDSPOKE](../../../azure/landing-zones.md#rule-adr-az-lz-hubandspoke),
[ADR-AZ-LZ-LANDINGZONE](../../../azure/landing-zones.md#rule-adr-az-lz-landingzone),
[ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION](../../../azure/azure-data-model.md#rule-adr-az-datamod-onefileonesubscription),
[ADR-AZ-NETWORK-PERSUBSCRIPTION](../../../azure/azure-network-model.md#rule-adr-az-network-persubscription), and
[ADR-AZ-NETWORK-NOOVERLAP](../../../azure/azure-network-model.md#rule-adr-az-network-nooverlap).

### Rule EDR-AZ-WAF-SE-SE05

SE:05, implement strict, conditional, and auditable identity and access management (IAM): authenticate and authorise every human, workload,
and resource identity through one trusted identity provider using standard protocols, and grant each only the access its role needs, for
only as long as needed. Access that is not identity-based, such as shared keys, is minimised and audited, and every action is logged so it
can be traced.

Source: learn /azure/well-architected/security/identity-access (SE:05, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-SECUREBYDEFAULT](../../../azure/landing-zones.md#rule-adr-az-lz-securebydefault),
[ADR-AZ-LZ-SQLENTRAADMINS](../../../azure/landing-zones.md#rule-adr-az-lz-sqlentraadmins), and
[ADR-AZ-LZ-CAFIDENTITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafidentity).

### Rule EDR-AZ-WAF-SE-SE06

SE:06, isolate, filter, and control network traffic: classify each traffic flow by exposure, direction, and reach, then segment, filter, and
where useful transform traffic at every boundary, assuming any point may be breached. Keep as much of the workload private as possible, use
private endpoints for platform services, force egress through a central firewall, put a web application firewall in front of ingress, and
log flows at the boundaries.

Source: learn /azure/well-architected/security/networking (SE:06, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-SECUREBYDEFAULT](../../../azure/landing-zones.md#rule-adr-az-lz-securebydefault),
[ADR-AZ-LZ-WORKLOADOWNSNONE](../../../azure/landing-zones.md#rule-adr-az-lz-workloadownsnone),
[ADR-AZ-LZ-THREEBUILTINPOLICIES](../../../azure/landing-zones.md#rule-adr-az-lz-threebuiltinpolicies),
[ADR-AZ-NETWORK-ONEIPPLAN](../../../azure/azure-network-model.md#rule-adr-az-network-oneipplan), and
[ADR-AZ-NETWORK-CAFPRIVATEACCESS](../../../azure/azure-network-model.md#rule-adr-az-network-cafprivateaccess).

### Rule EDR-AZ-WAF-SE-SE07

SE:07, encrypt data by using modern, industry-standard methods: protect data at rest, in transit, and where requirements demand it in use,
at a strength set by the data's classification. Prefer the platform's built-in encryption and standard algorithms over custom cryptography,
use TLS 1.2 or later everywhere, and manage keys and certificates, including customer-managed keys where needed, as carefully as the data.

Source: learn /azure/well-architected/security/encryption (SE:07, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-SECUREBYDEFAULT](../../../azure/landing-zones.md#rule-adr-az-lz-securebydefault) and
[ADR-AZ-LZ-CAFSECURITY](../../../azure/landing-zones.md#rule-adr-az-lz-cafsecurity).

### Rule EDR-AZ-WAF-SE-SE08

SE:08, harden all workload components: shrink the attack surface of every component and tighten what remains, so cheap, well-known attacks
stop working. Remove unused features, ports, legacy protocols, and default accounts; keep public endpoints to a minimum; enforce hardening
at scale with policy; and verify it regularly against a benchmark.

Source: learn /azure/well-architected/security/harden-resources (SE:08, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-SECUREBYDEFAULT](../../../azure/landing-zones.md#rule-adr-az-lz-securebydefault),
[ADR-AZ-LZ-EVERYPILLAR](../../../azure/landing-zones.md#rule-adr-az-lz-everypillar), and
[ADR-AZ-LZ-THREEBUILTINPOLICIES](../../../azure/landing-zones.md#rule-adr-az-lz-threebuiltinpolicies).

### Rule EDR-AZ-WAF-SE-SE09

SE:09, protect application secrets: keep the number of secrets as low as possible by letting the platform handle credentials, and keep the
rest in a dedicated, access-controlled, and audited secret store, never in code, infrastructure as code, or pipelines. Secrets are rotated
routinely and can be rotated on demand without disrupting the workload, and a secret found in the wrong place is treated as compromised.

Source: learn /azure/well-architected/security/application-secrets (SE:09, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-SECUREBYDEFAULT](../../../azure/landing-zones.md#rule-adr-az-lz-securebydefault),
[ADR-AZ-LZ-SQLENTRAADMINS](../../../azure/landing-zones.md#rule-adr-az-lz-sqlentraadmins),
[ADR-AZ-DATAMOD-PARAMETERCONTRACT](../../../azure/azure-data-model.md#rule-adr-az-datamod-parametercontract),
[ADR-AZ-DATAMOD-VALUEBYADDRESS](../../../azure/azure-data-model.md#rule-adr-az-datamod-valuebyaddress), and
[ADR-AUTO-ENVVAR-SECRETTOCHILDPROCESS](../../../automation/environment-variables.md#rule-adr-auto-envvar-secrettochildprocess).

### Rule EDR-AZ-WAF-SE-SE10

SE:10, implement a holistic monitoring strategy: capture security-relevant events from every part of the workload (users, identities,
network, builds, and hosts) and keep them as an audit trail of who did what and when, in durable sinks outside the workload. Correlate them
with platform threat detection so alerts reach security operations quickly, and use them after an incident to reconstruct it.

Source: learn /azure/well-architected/security/monitor-threats (SE:10, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-SECUREBYDEFAULT](../../../azure/landing-zones.md#rule-adr-az-lz-securebydefault),
[ADR-AZ-LZ-THREEBUILTINPOLICIES](../../../azure/landing-zones.md#rule-adr-az-lz-threebuiltinpolicies), and
[ADR-AZ-LZ-CAFMANAGEMENT](../../../azure/landing-zones.md#rule-adr-az-lz-cafmanagement).

### Rule EDR-AZ-WAF-SE-SE11

SE:11, establish a comprehensive testing regimen: test security continuously from inside and outside the workload, highest-severity threats
on the most critical flows first. Cover prevention controls, detection and alerting, and compliance evidence, mixing automated and manual
tests, penetration tests, and team exercises, and feed the results back into the threat model and the tests.

Source: learn /azure/well-architected/security/test (SE:11, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-SECUREBYDEFAULT](../../../azure/landing-zones.md#rule-adr-az-lz-securebydefault) and
[ADR-AZ-DATAMOD-PARAMETERCONTRACT](../../../azure/azure-data-model.md#rule-adr-az-datamod-parametercontract).

### Rule EDR-AZ-WAF-SE-SE12

SE:12, define and test effective incident response procedures: prepare one tested incident response process, shared with the central
security operations team, that names who is notified, who triages, and who decides. It covers containment, recovery through the disaster
recovery process where needed, communication, and post-incident learning, so time to detect and mitigate stays short.

Source: learn /azure/well-architected/security/incident-response (SE:12, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-SECUREBYDEFAULT](../../../azure/landing-zones.md#rule-adr-az-lz-securebydefault) and
[ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION](../../../azure/azure-data-model.md#rule-adr-az-datamod-onefileonesubscription).

## Context

The Azure Well-Architected Framework (WAF) is Microsoft's guidance for reviewing a workload on Azure against five pillars: reliability,
security, cost optimization, operational excellence, and performance efficiency. Each pillar publishes a checklist of numbered
recommendations, and each recommendation has a guide that explains it.

The security pillar keeps a workload's data and systems confidential, intact, and available, following the Zero Trust model. Its twelve
items run from a baseline and a secure development lifecycle, through the protection of identities, networks, data, and secrets, to
monitoring, testing, and incident response.

The current WAF text is published under the Microsoft Learn Terms of Use, which grant no right to copy it into a shared repository, so
nothing here is quoted.

The [WAF reference](../../../../references/waf/index.md) lists the five pillar records in this repository and the Microsoft checklist each
one cites.
