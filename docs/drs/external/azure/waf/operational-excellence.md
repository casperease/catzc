# EDR: WAF operational excellence — Microsoft's operational excellence checklist OE:01 to OE:11, as the repository reads it

Binds to [`landing-zones`](../../../azure/landing-zones.md) (the landing zone and the workload these items are judged on) and
[`cd-discipline-and-promotion-flow`](../../../flow/cd-discipline-and-promotion-flow.md) (the delivery flow most of these items map to).

## Rules: EDR-AZ-WAF-OE

Each rule is one of Microsoft's eleven operational excellence items (OE:01 to OE:11), keeping its native id. Every source line names the
guide page under `https://learn.microsoft.com/en-us` and the retrieval date; the sentence is the repository's own summary, never a
quotation. The repository's decision on each item is in the rule it binds to.

### Rule EDR-AZ-WAF-OE-OE01

OE:01, define your standard practices to develop and operate your workload: the workload team owns design, deployment, and operation end to
end, with clear roles, a named decision-maker for disputes, and practices that each member's specialism maps onto. A blameless, respectful
culture and protected time for improvement keep those practices getting better; compliance requirements are built into the practices as
guardrails that tests and governance verify.

Source: learn /azure/well-architected/operational-excellence/devops-culture (OE:01, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-OPSASCODE](../../../azure/landing-zones.md#rule-adr-az-lz-opsascode),
[ADR-AZ-LZ-THREEBUILTINPOLICIES](../../../azure/landing-zones.md#rule-adr-az-lz-threebuiltinpolicies),
[ADR-AZ-DATAMOD-POLICYENFORCEMENTMODE](../../../azure/azure-data-model.md#rule-adr-az-datamod-policyenforcementmode), and
[ADR-AUTO-TEST-QUALITYGATE](../../../automation/test-automation.md#rule-adr-auto-test-qualitygate).

### Rule EDR-AZ-WAF-OE-OE02

OE:02, standardize operations: make routine, ad-hoc, and emergency operations predictable by doing them the same way every time, through
written, actionable procedures and through automation where it reduces variation. The team owns its procedures, keeps them under version
control with an author and a review date, and keeps them current.

Source: learn /azure/well-architected/operational-excellence/formalize-operations-tasks (OE:02, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-OPSASCODE](../../../azure/landing-zones.md#rule-adr-az-lz-opsascode),
[ADR-AZ-LZ-LINKSNEEDBOTHNETWORKS](../../../azure/landing-zones.md#rule-adr-az-lz-linksneedbothnetworks),
[FDR-TYPE-CRONISSCHEDULER](../../../flow/pipeline-types.md#rule-fdr-type-cronisscheduler), and
[PDR-EAC-NOUNVERSIONEDSTATE](../../../principles/everything-as-code.md#rule-pdr-eac-nounversionedstate).

### Rule EDR-AZ-WAF-OE-OE03

OE:03, formalize software development practices: run the whole development lifecycle, from idea to delivery, through consistent and visible
practices. Standard ways to record work, write and review code, and integrate changes (a branching strategy, peer-reviewed pull requests,
automated builds and tests, static analysis, dependency and secret scanning, versioned artifacts, and traceability from production back to
code) deliver quality and surface risk early.

Source: learn /azure/well-architected/operational-excellence/formalize-development-practices (OE:03, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-OPSASCODE](../../../azure/landing-zones.md#rule-adr-az-lz-opsascode),
[DDR-REMOTE-PULLREQUESTISINGRESS](../../../design/server-remote-integration.md#rule-ddr-remote-pullrequestisingress),
[FDR-CD-SHORTINTEGRATIONCYCLE](../../../flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-shortintegrationcycle), and
[ADR-AZ-LZ-CAFDELIVERY](../../../azure/landing-zones.md#rule-adr-az-lz-cafdelivery).

### Rule EDR-AZ-WAF-OE-OE04

OE:04, enhance software development and quality assurance: use mature, standard tools and industry-proven practices for development and
testing instead of building your own, and standardise them: version control, branching with policies, a style guide with enforced formatting
and IaC linting, naming and tagging standards, version-controlled architecture decision records, shift-left testing, and delivery metrics.

Source: learn /azure/well-architected/operational-excellence/tools-processes (OE:04, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-OPSASCODE](../../../azure/landing-zones.md#rule-adr-az-lz-opsascode),
[ADR-AZ-LZ-CAFTAGS](../../../azure/landing-zones.md#rule-adr-az-lz-caftags),
[ADR-AZ-NAMING-DETERMINISTICNAMES](../../../azure/azure-naming-standard.md#rule-adr-az-naming-deterministicnames),
[ADR-AZ-CLI-AZBYDEFAULT](../../../azure/prefer-az-cli.md#rule-adr-az-cli-azbydefault), and
[ADR-AUTO-DEPS-LOCKEDTOOLVERSIONS](../../../automation/controlling-systemwide-deps.md#rule-adr-auto-deps-lockedtoolversions).

### Rule EDR-AZ-WAF-OE-OE05

OE:05, use a standardized infrastructure as code (IaC) approach to prepare resources and configurations: all infrastructure and
configuration changes go through code deployed by pipelines, so environments stay consistent and free of drift. Declarative, platform-native
tools with pinned versions are preferred; one parameterised set of assets serves every environment; pipelines are split by rate of change;
the code is scanned for misconfiguration and secrets; and manual steps and orphaned resources are documented and cleaned up.

Source: learn /azure/well-architected/operational-excellence/infrastructure-as-code-design (OE:05, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-OPSASCODE](../../../azure/landing-zones.md#rule-adr-az-lz-opsascode),
[PDR-EAC-EVERYTHINGCOMMITTED](../../../principles/everything-as-code.md#rule-pdr-eac-everythingcommitted),
[ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION](../../../azure/azure-data-model.md#rule-adr-az-datamod-onefileonesubscription),
[ADR-AZ-DATAMOD-VALUEBYADDRESS](../../../azure/azure-data-model.md#rule-adr-az-datamod-valuebyaddress),
[ADR-AZ-DATAMOD-PARAMETERCONTRACT](../../../azure/azure-data-model.md#rule-adr-az-datamod-parametercontract), and
[ADR-AZ-LZ-HUBANDSPOKE](../../../azure/landing-zones.md#rule-adr-az-lz-hubandspoke).

### Rule EDR-AZ-WAF-OE-OE06

OE:06, build a workload supply chain that drives changes: every change to an environment in the promotion chain travels one standard supply
chain of automated CI/CD pipelines that test it and move it through environments behind quality gates. Manual changes to those environments
are not allowed, the same artifacts reach every environment varied only by parameters, and pipelines are split by what they deploy.

Source: learn /azure/well-architected/operational-excellence/workload-supply-chain (OE:06, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-OPSASCODE](../../../azure/landing-zones.md#rule-adr-az-lz-opsascode),
[FDR-GLOBS-NATIVEPATHFILTER](../../../flow/durable-sha-globs.md#rule-fdr-globs-nativepathfilter),
[FDR-TYPE-ONECIENGINE](../../../flow/pipeline-types.md#rule-fdr-type-oneciengine),
[FDR-CD-SEPARATEPIPELINEKINDS](../../../flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-separatepipelinekinds),
[FDR-CD-CDSTAYSINNONPROD](../../../flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-cdstaysinnonprod),
[FDR-CD-PRODPROGRESSIONISDEPLOY](../../../flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-prodprogressionisdeploy), and
[FDR-TYPE-CONFIGENTERSTHROUGHINPUT](../../../flow/pipeline-types.md#rule-fdr-type-configentersthroughinput).

### Rule EDR-AZ-WAF-OE-OE07

OE:07, design a monitoring stack: build a monitoring stack beside the functional stack that collects logs, metrics, traces, and events from
infrastructure and code, organised around a health model and key indicators. Consolidate telemetry into central stores kept separate per
environment, with retention chosen per access pattern, and build dashboards and alerts on changes in health.

Source: learn /azure/well-architected/operational-excellence/observability (OE:07, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-OPSASCODE](../../../azure/landing-zones.md#rule-adr-az-lz-opsascode),
[ADR-AZ-LZ-CAFMANAGEMENT](../../../azure/landing-zones.md#rule-adr-az-lz-cafmanagement),
[ADR-AZ-LZ-THREEBUILTINPOLICIES](../../../azure/landing-zones.md#rule-adr-az-lz-threebuiltinpolicies), and
[ADR-AZ-LZ-EVERYPILLAR](../../../azure/landing-zones.md#rule-adr-az-lz-everypillar).

### Rule EDR-AZ-WAF-OE-OE08

OE:08, establish a clear, structured incident management process: prepare a documented incident response plan with named roles, a
communication and escalation path, and procedures for detection, triage, containment, and recovery, and design the architecture to make
those steps fast. Rehearse the plan, and turn each incident's root cause analysis into improvements.

Source: learn /azure/well-architected/operational-excellence/incident-response (OE:08, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-OPSASCODE](../../../azure/landing-zones.md#rule-adr-az-lz-opsascode) and
[ADR-AZ-LZ-SQLENTRAADMINS](../../../azure/landing-zones.md#rule-adr-az-lz-sqlentraadmins).

### Rule EDR-AZ-WAF-OE-OE09

OE:09, enhance the quality of your workload: testing confirms each change works and introduces no new problems, so set a test strategy per
workload and a test plan per release. Test from design onwards, in layers (unit, integration, end to end) with fast tests in the build
pipeline, keep test code in the same repository under the same review rules, and test in production-like or purpose-built environments.

Source: learn /azure/well-architected/operational-excellence/testing (OE:09, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-OPSASCODE](../../../azure/landing-zones.md#rule-adr-az-lz-opsascode),
[ADR-AUTO-TEST](../../../automation/test-automation.md),
[ADR-AZ-DATAMOD-PARAMETERCONTRACT](../../../azure/azure-data-model.md#rule-adr-az-datamod-parametercontract),
[FDR-CD-INNERANDOUTERLOOP](../../../flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-innerandouterloop),
[ADR-AUTO-TEST-SYSTEMTESTSATLTHREE](../../../automation/test-automation.md#rule-adr-auto-test-systemtestsatlthree), and
[ADR-AUTO-TEST-TESTINGINPRODUCTION](../../../automation/test-automation.md#rule-adr-auto-test-testinginproduction).

### Rule EDR-AZ-WAF-OE-OE10

OE:10, design automation to be reliable, secure, and maintainable: design the workload so routine work such as provisioning, scaling,
deployment, and maintenance can be automated, and automate the repetitive tasks that clearly repay the effort. Treat automation as part of
the workload (under version control, authenticated by managed identities, tested, monitored, and revisited) and hold desired state with
orchestration or policy tools.

Source: learn /azure/well-architected/operational-excellence/enable-automation (OE:10, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-OPSASCODE](../../../azure/landing-zones.md#rule-adr-az-lz-opsascode),
[ADR-AUTO-IDEM](../../../automation/idempotent-state-functions.md), [ADR-AUTO-DRYRUN](../../../automation/dry-run.md),
[ADR-AUTO-FAILFAST-BOUNDEVERYWAIT](../../../automation/fail-fast-with-asserts.md#rule-adr-auto-failfast-boundeverywait),
[FDR-TYPE-ALLTHROUGHRUNNER](../../../flow/pipeline-types.md#rule-fdr-type-allthroughrunner), and
[ADR-AUTO-PARITY](../../../automation/devbox-pipeline-parity.md).

### Rule EDR-AZ-WAF-OE-OE11

OE:11, clearly define your workload's safe deployment practices: treat every production change as risky and deploy it through a consistent,
automated process in small, frequent, quality-gated increments. Expose changes progressively with health checks and bake time between
stages, keep defined rollback or roll-forward options and versioned artifacts, check changes before deployment, and define faster but still
controlled protocols for emergencies.

Source: learn /azure/well-architected/operational-excellence/safe-deployments (OE:11, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-OPSASCODE](../../../azure/landing-zones.md#rule-adr-az-lz-opsascode),
[FDR-CD-SEPARATEPIPELINEKINDS](../../../flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-separatepipelinekinds),
[FDR-CD-TWORELEASEGATES](../../../flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-tworeleasegates),
[FDR-CD-TWOENVIRONMENTACTIVATION](../../../flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-twoenvironmentactivation), and
[FDR-TYPE-DEPLOYISPINNED](../../../flow/pipeline-types.md#rule-fdr-type-deployispinned).

## Context

Microsoft's Azure Well-Architected Framework (WAF) is a set of guidance for judging an Azure workload's quality, arranged in five pillars:
reliability, security, cost optimization, operational excellence, and performance efficiency. Each pillar publishes a design review
checklist of numbered recommendations. Operational excellence is the pillar of how a workload is built, changed, and run: standard
practices, a cohesive team, automation where it pays, observability, and safe, repeatable delivery of both infrastructure and code.

The current WAF text is published under the [Microsoft Learn Terms of Use](https://learn.microsoft.com/en-us/legal/termsofuse), not under a
licence that permits copying it into a shared repository, so nothing is quoted. The checklist itself is at
[learn.microsoft.com](https://learn.microsoft.com/en-us/azure/well-architected/operational-excellence/checklist).

The [WAF reference](../../../../references/waf/index.md) lists the five pillar records in this repository and the Microsoft checklist each
one cites.
