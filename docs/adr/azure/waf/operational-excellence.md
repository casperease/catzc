---
catzc:
  derived:
    path: docs/adr/azure/waf/operational-excellence.md
    kind: adr
    language: markdown
    filetype: md
    track: docs
    body_sha: be1d73e111ce
    defines:
      - ADR-AZ-WAFOE#{1-11}
    adrs:
      - ADR-AUTO-DEPS#1
      - ADR-AUTO-FAILFAST#7
      - ADR-AUTO-TEST#{33,35,41}
      - ADR-AZ-DATAMOD#{2,9-11}
      - ADR-AZ-LZ#{2,3,5-7}
      - ADR-AZ-NAMING#1
      - ADR-DSGN-REMOTE#4
      - ADR-FLOW-CD#{2,3,5,6,8,9,12}
      - ADR-FLOW-CD-GLOBS#6
      - ADR-FLOW-CD-TYPE#{2,3,5,6,10}
      - ADR-PRIN-EAC#{1,3}
      - ADR-PROC-ANDON#1
      - ADR-PROC-KAIZEN#3
      - ADR-REPO-FORMAT#8
    links:
      - docs/adr/automation/controlling-systemwide-deps.md#rule-adr-auto-deps1
      - docs/adr/automation/devbox-pipeline-parity.md
      - docs/adr/automation/dry-run.md
      - docs/adr/automation/fail-fast-with-asserts.md#rule-adr-auto-failfast7
      - docs/adr/automation/idempotent-state-functions.md
      - docs/adr/automation/test-automation.md
      - docs/adr/automation/test-automation.md#rule-adr-auto-test33
      - docs/adr/automation/test-automation.md#rule-adr-auto-test35
      - docs/adr/automation/test-automation.md#rule-adr-auto-test41
      - docs/adr/azure/azure-data-model.md
      - docs/adr/azure/azure-data-model.md#rule-adr-az-datamod10
      - docs/adr/azure/azure-data-model.md#rule-adr-az-datamod11
      - docs/adr/azure/azure-data-model.md#rule-adr-az-datamod2
      - docs/adr/azure/azure-data-model.md#rule-adr-az-datamod9
      - docs/adr/azure/azure-naming-standard.md
      - docs/adr/azure/azure-naming-standard.md#rule-adr-az-naming1
      - docs/adr/azure/landing-zones.md
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz2
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz3
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz5
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz6
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz7
      - docs/adr/azure/prefer-az-cli.md
      - docs/adr/design/server-remote-integration.md#rule-adr-dsgn-remote4
      - docs/adr/flow/cd-discipline-and-promotion-flow.md
      - docs/adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd12
      - docs/adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd2
      - docs/adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd3
      - docs/adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd5
      - docs/adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd6
      - docs/adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd8
      - docs/adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd9
      - docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs6
      - docs/adr/flow/pipeline-types.md#rule-adr-flow-cd-type10
      - docs/adr/flow/pipeline-types.md#rule-adr-flow-cd-type2
      - docs/adr/flow/pipeline-types.md#rule-adr-flow-cd-type3
      - docs/adr/flow/pipeline-types.md#rule-adr-flow-cd-type5
      - docs/adr/flow/pipeline-types.md#rule-adr-flow-cd-type6
      - docs/adr/principles/everything-as-code.md#rule-adr-prin-eac1
      - docs/adr/principles/everything-as-code.md#rule-adr-prin-eac3
      - docs/adr/process/agile.md
      - docs/adr/process/holding-the-line.md
      - docs/adr/process/holding-the-line.md#rule-adr-proc-andon1
      - docs/adr/process/inspect-and-adapt.md
      - docs/adr/process/inspect-and-adapt.md#rule-adr-proc-kaizen3
      - docs/adr/repository/uniform-formatting.md#rule-adr-repo-format8
      - docs/adr/research/generative-organizational-culture.md
      - docs/adr/research/monitoring-and-observability.md
      - docs/adr/research/trunk-based-development.md
      - docs/references/dora/index.md
      - docs/references/dora/metrics.md
      - docs/references/waf/index.md
      - "https://learn.microsoft.com/en-us/azure/well-architected/operational-excellence/checklist"
      - "https://learn.microsoft.com/en-us/legal/termsofuse"
---

# ADR: Operational excellence — the Well-Architected checklist, item by item, as this repository delivers and runs its infrastructure

Pairs with [`landing-zones`](../landing-zones.md) (the landing zone and the workload these items are judged on) and
[`cd-discipline-and-promotion-flow`](../../flow/cd-discipline-and-promotion-flow.md) (the delivery flow most of these items map to).

## Rules: ADR-AZ-WAFOE

### Rule ADR-AZ-WAFOE:1

The repository's standard practices for building and operating its infrastructure are its ADRs, enforced by quality gates, and every
resource names its owning team in the `owner` tag; team roles and decision authority belong to the operating organisation, outside the
repository.

- [OE:01 — Define your standard practices to develop and operate your workload](#oe01--define-your-standard-practices-to-develop-and-operate-your-workload)

### Rule ADR-AZ-WAFOE:2

Routine operations run as version-controlled automation functions and pipelines, never as manual runbooks kept elsewhere; every manual step
that remains — seeding the break-glass secret, the rollout order of a new spoke — gets a written, version-controlled procedure.

- [OE:02 — Standardize operations](#oe02--standardize-operations)

### Rule ADR-AZ-WAFOE:3

Every change reaches `main` through a pull request whose build validation runs the CI engine, and every deployment tags its target with the
commit, the build, and the branch it came from, so a deployed resource traces back to its code.

- [OE:03 — Formalize software development practices](#oe03--formalize-software-development-practices)

### Rule ADR-AZ-WAFOE:4

The repository uses standard, version-pinned tools, one formatter per file language, one naming standard, and the CAF tags, and records its
decisions as ADRs; the Bicep linter is a quality gate.

- [OE:04 — Enhance software development and quality assurance](#oe04--enhance-software-development-and-quality-assurance)

### Rule ADR-AZ-WAFOE:5

All Azure infrastructure is declarative Bicep: one parameterised template per rate of change, shared modules, and one config per slot,
deployed only by pipelines; no secret sits in the code, and the compiled templates are scanned for misconfiguration.

- [OE:05 — Use a standardized infrastructure as code (IaC) approach to prepare resources and configurations](#oe05--use-a-standardized-infrastructure-as-code-iac-approach-to-prepare-resources-and-configurations)

### Rule ADR-AZ-WAFOE:6

Every infrastructure change travels one supply chain: a CD pipeline triggered by its deployable-unit's globset builds the artifacts once and
deploys the same bytes, in dependency order, into subscriptions it asserts; production is reached by promotion, not by the same stage that
deploys non-production.

- [OE:06 — Build a workload supply chain that drives changes](#oe06--build-a-workload-supply-chain-that-drives-changes)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AZ-WAFOE:7

Every subscription has one Log Analytics workspace from `foundation`, and every resource that emits logs or metrics sends them there through
a diagnostic setting its own template deploys; alerts on health changes join them.

- [OE:07 — Design a monitoring stack](#oe07--design-a-monitoring-stack)

### Rule ADR-AZ-WAFOE:8

The infrastructure keeps an incident contained and recoverable — segmented networks, private endpoints, a break-glass login — and an
incident is detected by alerts routed to the subscription's owners; the response plan is a version-controlled procedure, and its roles
belong to the operating organisation.

- [OE:08 — Establish a clear, structured incident management process](#oe08--establish-a-clear-structured-incident-management-process)

### Rule ADR-AZ-WAFOE:9

Infrastructure is tested in tiers by `Test-Automation` ([ADR-AUTO-TEST](../../automation/test-automation.md)): the CI engine builds every
template and checks its parameters files against the compiled parameter model, and a deployed template is verified by a system test.

- [OE:09 — Enhance the quality of your workload](#oe09--enhance-the-quality-of-your-workload)

### Rule ADR-AZ-WAFOE:10

Automation is a catzc module: version-controlled, tested, idempotent, dry-runnable, and bounded in time; the desired state of a landing zone
in Azure is held by its policy assignments.

- [OE:10 — Design automation to be reliable, secure, and maintainable](#oe10--design-automation-to-be-reliable-secure-and-maintainable)

### Rule ADR-AZ-WAFOE:11

A change reaches production as the same build-once artifact, promoted behind gates from non-production through pre-prod, with an Azure
what-if preview before every deploy.

- [OE:11 — Clearly define your workload's safe deployment practices](#oe11--clearly-define-your-workloads-safe-deployment-practices)
- [How this is enforced](#how-this-is-enforced)

## Context

Microsoft's Azure Well-Architected Framework (WAF) is a set of guidance for judging an Azure workload's quality, arranged in five pillars:
reliability, security, cost optimisation, operational excellence, and performance efficiency. Each pillar publishes a design review
checklist of numbered recommendations. Operational excellence is the pillar of how a workload is built, changed, and run: standard
practices, a cohesive team, automation where it pays, observability, and safe, repeatable delivery of both infrastructure and code.

These rules are vendor recommendation, not principled theory. The repository's design rests on its own principles and on the DORA research
([DORA](../../../references/dora/index.md)); the WAF is one vendor's checklist that the repository reviews itself against, item by item, and
says for each item what it does about it. Each item below cites Microsoft's page — its code, title, guide link, and retrieval date — and
summarises the recommendation in our own words. Nothing is quoted: the current WAF text is published under the
[Microsoft Learn Terms of Use](https://learn.microsoft.com/en-us/legal/termsofuse), not under a licence that permits copying it into a
shared repository. The checklist itself is at
[learn.microsoft.com](https://learn.microsoft.com/en-us/azure/well-architected/operational-excellence/checklist).

The [WAF reference](../../../references/waf/index.md) lists the five pillar records in this repository and the Microsoft checklist each one
cites.

The example basis is the three templates that tell the repository's infrastructure story: `foundation` (the Log Analytics workspace and the
Key Vault of a subscription), `discovery` (the landing zone of a subscription), and `expedition` (a workload that lands in it), each
deployed after the one before ([landing-zones](../landing-zones.md)). Most of this pillar maps to the repository's delivery machinery — the
flow model, the pipelines under `pipelines/`, the `Catzc.Azure.Templates` module, and the quality gates — so each takeaway names that
machinery first and the templates second.

### OE:01 — Define your standard practices to develop and operate your workload

```text
OE:01 — Define your standard practices to develop and operate your workload
Source: https://learn.microsoft.com/en-us/azure/well-architected/operational-excellence/devops-culture (retrieved 2026-10-15)
Summary (ours): The workload team owns design, deployment, and operation end to end, with clear roles, a named decision-maker for
disputes, and practices that each member's specialism maps onto. A blameless, respectful culture and protected time for improvement and
learning keep those practices getting better; compliance requirements are built into the practices as guardrails that tests and
governance verify.
```

#### What OE:01 means here

The repository's standard practices are its domain rules: the ADRs under `docs/adr/`, each rule cited by code and enforced, where a machine
can enforce it, by a quality gate ([ADR-AUTO-TEST#35](../../automation/test-automation.md#rule-adr-auto-test35)). How the team works is the
process domain — agile values and principles ([ADR-PROC-AGILE](../../process/agile.md)), stopping the line when a gate fails
([ADR-PROC-ANDON](../../process/holding-the-line.md)), and continuous improvement from evidence
([ADR-PROC-KAIZEN](../../process/inspect-and-adapt.md)). A learning, blameless culture is the DORA capability
[generative organizational culture](../../research/generative-organizational-culture.md). Compliance built in as guardrails is the landing
zone's policy assignments ([ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3)).

Who holds which role, and who decides a dispute, belongs to the organisation that operates the repository; a repository cannot name people
without coupling its rules to an organisation chart. What the repository does carry is ownership per resource: the CAF tags on every
resource include `owner`, `criticality`, and `data-classification`.

##### OE:01 in `foundation`

Every config tags the workspace and the vault with `owner: platform` and `criticality: high` (the shared platform's and each customer's
subscription alike), so the platform team owns the baseline of every subscription.

##### OE:01 in `discovery`

A hub carries `owner: platform`; a spoke carries the customer's key as its owner (`owner: apex` in `configuration/apex/`), so the owner of a
landing zone is the owner of the subscription it serves. The three policy assignments are the compliance guardrails, in force in production
and auditing outside it ([ADR-AZ-DATAMOD#11](../azure-data-model.md#rule-adr-az-datamod11)).

##### OE:01 in `expedition`

Each slot's config tags its resources with the workload, the environment, the owner, and a criticality that follows the environment class
(`low` in a development special slot, `high` in production).

##### OE:01 status

Partly realised — the practices are ADRs enforced by quality gates and every resource names its owner, while team roles and decision
authority stay with the operating organisation.

### OE:02 — Standardize operations

```text
OE:02 — Standardize operations
Title: ours — the checklist item has no lead words, so this short title follows its guide page.
Source: https://learn.microsoft.com/en-us/azure/well-architected/operational-excellence/formalize-operations-tasks (retrieved 2026-10-15)
Summary (ours): Make routine, ad-hoc, and emergency operations predictable by doing them the same way every time, through written,
actionable procedures and through automation where it reduces variation. The team owns its procedures, reuses organisational standards
where they exist, keeps them under version control with an author and a review date, and keeps them current.
```

#### What OE:02 means here

Routine operations are automation, not documents: building, deploying, and validating a template are the `Build-Bicep`, `Deploy-Bicep`, and
`Assert-BicepTemplate` functions, run the same way on a devbox and in a pipeline. A scheduled routine is a CRON pipeline invoking an
idempotent function ([ADR-FLOW-CD-TYPE#5](../../flow/pipeline-types.md#rule-adr-flow-cd-type5)). Operational state and runbooks never live
outside version control ([ADR-PRIN-EAC#3](../../principles/everything-as-code.md#rule-adr-prin-eac3)), and the task guides under
`docs/how-to/` — adding a deployable-unit, adding an infrastructure template — are the written procedures for the changes that recur.

Two operations stay manual and have no written procedure: putting the break-glass SQL password into `foundation`'s vault before the first
`expedition` deploy, and the three-step rollout of a new spoke (hub, spoke, hub again — [ADR-AZ-LZ#7](../landing-zones.md#rule-adr-az-lz7)),
which `cd-shared.yaml` and the customer CD pipelines leave to a person. There is no emergency-change procedure.

##### OE:02 in `foundation`

Deployed by a pipeline only. The secret `exped-sql-admin-password` that `expedition` reads from the vault is created by hand; that step
needs a how-to, or a pre-deploy hook that generates it.

##### OE:02 in `discovery`

Deployed by a pipeline only. Adding a spoke runs across two pipelines in a fixed order; the order is stated in ADR-AZ-LZ#7 and in the
pipelines' comments, and needs a step-by-step how-to beside the other task guides.

##### OE:02 in `expedition`

Deployed by a pipeline only; a second deployment beside a base slot is a special slot, which is a config file, not a procedure.

##### OE:02 status

Partly realised — routine operations are version-controlled automation, while the secret seeding, the spoke rollout, and emergency changes
lack a written procedure.

### OE:03 — Formalize software development practices

```text
OE:03 — Formalize software development practices
Title: ours — the checklist item has no lead words, so this short title follows its guide page.
Source: https://learn.microsoft.com/en-us/azure/well-architected/operational-excellence/formalize-development-practices (retrieved 2026-10-15)
Summary (ours): Run the whole development lifecycle, from idea to delivery, through consistent and visible practices, so everyone knows
what is being built, why, and how far it has got. Standard ways to record work, write and review code, and integrate changes — a
branching strategy, peer-reviewed pull requests, automated builds and tests, static analysis, dependency and secret scanning, versioned
artifacts, and traceability from production back to code — deliver quality and surface risk early.
```

#### What OE:03 means here

The branching strategy is trunk-based development on `main` ([trunk-based-development](../../research/trunk-based-development.md)). A pull
request is the authenticated ingress to the server remote
([ADR-DSGN-REMOTE#4](../../design/server-remote-integration.md#rule-adr-dsgn-remote4)), and the build-validation policies in
`build-validation.yml` bind each deployable-unit's and each track's globset to its pipeline as a blocking check on `main`. The CI engine
builds and verifies inside the integration budget ([ADR-FLOW-CD#2](../../flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd2)), and
static analysis is a set of quality gates (`Test-ScriptAnalyzer`, `Test-Markdownlint`, `Test-Spelling`, `Test-Formatting`).

Traceability is built into the deploy: after a successful deploy, `Deploy-Bicep` runs `Set-BicepTrackingTagSet`, which tags the target
resource group or subscription with the commit, the build id, and the branch. Two practices are missing: a secret scan of every change, and
a required-reviewer policy, which the repository does not configure (`build-validation.yml` holds build validations only).

##### OE:03 in `foundation`

Every change under `infrastructure/` runs `ci-infrastructure.yaml` as a pull-request check and again on the merged commit; a deploy tags the
resource group with its provenance.

##### OE:03 in `discovery`

As for `foundation`; `discovery` deploys at subscription scope, so its provenance tags land on the subscription.

##### OE:03 in `expedition`

As for `foundation`, per slot: each slot's resource group carries the commit that last deployed it.

##### OE:03 status

Partly realised — trunk-based, pull-request ingress, blocking CI, and deploy provenance are in place, while secret scanning and a
required-reviewer policy are planned.

### OE:04 — Enhance software development and quality assurance

```text
OE:04 — Enhance software development and quality assurance
Source: https://learn.microsoft.com/en-us/azure/well-architected/operational-excellence/tools-processes (retrieved 2026-10-15)
Summary (ours): Use mature, standard tools and industry-proven practices for development and testing instead of building your own, and
standardise them: version control, branching with policies, a style guide with enforced formatting and IaC linting, naming and tagging
standards, version-controlled architecture decision records, shift-left testing, and delivery metrics. Consistency makes roles clear,
eases onboarding, and reduces defects.
```

#### What OE:04 means here

Tools are standard and pinned: the Bicep CLI, the az CLI ([ADR-AZ-CLI](../prefer-az-cli.md)), Pester, PSScriptAnalyzer, markdownlint, and
Prettier, each locked to a version in `tools.yml` and installed by the same installer on a devbox and in a pipeline
([ADR-AUTO-DEPS#1](../../automation/controlling-systemwide-deps.md#rule-adr-auto-deps1)). Formatting is one standard per file language,
configured in `languages.yml` and applied by `Format-Code` — Bicep by `bicep format`
([ADR-REPO-FORMAT#8](../../repository/uniform-formatting.md#rule-adr-repo-format8)). Every Azure name follows one deterministic naming
standard ([ADR-AZ-NAMING](../azure-naming-standard.md)), every resource carries the CAF tags, and every decision is an ADR in the
repository. The delivery metrics are DORA's ([metrics](../../../references/dora/metrics.md)).

The gap is IaC linting as a gate: the repository has no `bicepconfig.json`, so `az bicep build` runs the Bicep linter with its default rule
levels, and a linter warning does not fail the build.

##### OE:04 in `foundation`

Formatted by `bicep format`, named by the naming standard (`nsub-weu-zct-fnd-log`), tagged with the CAF tags.

##### OE:04 in `discovery`

As for `foundation`; its policy assignments, budgets, and network resources follow the same naming standard.

##### OE:04 in `expedition`

As for `foundation`; a storage account, whose type allows no hyphen, takes the concatenated form of the same name
([ADR-AZ-NAMING#1](../azure-naming-standard.md#rule-adr-az-naming1)).

##### OE:04 status

Partly realised — the tools, formatting, naming, tagging, and ADRs are standard, while the Bicep linter is not a quality gate.

### OE:05 — Use a standardized infrastructure as code (IaC) approach to prepare resources and configurations

```text
OE:05 — Use a standardized infrastructure as code (IaC) approach to prepare resources and configurations
Source: https://learn.microsoft.com/en-us/azure/well-architected/operational-excellence/infrastructure-as-code-design (retrieved 2026-10-15)
Summary (ours): All infrastructure and configuration changes go through code deployed by pipelines, so environments stay consistent and
free of drift. That code meets the same style, modularity, and quality standards as application code; declarative, platform-native
tools with pinned versions are preferred; one parameterised set of assets serves every environment; pipelines are split by rate of
change; the code is scanned for misconfiguration and secrets; and manual steps and orphaned resources are documented and cleaned up.
```

#### What OE:05 means here

Everything the infrastructure needs lives in version control ([ADR-PRIN-EAC#1](../../principles/everything-as-code.md#rule-adr-prin-eac1)):
declarative Bicep under `infrastructure/`, shared modules under `infrastructure/modules/`, and one config per slot under each template's
`configuration/` ([ADR-AZ-DATAMOD#2](../azure-data-model.md#rule-adr-az-datamod2)). One template serves every environment; only its config
varies, and a value that another config owns is read by config address, never copied
([ADR-AZ-DATAMOD#10](../azure-data-model.md#rule-adr-az-datamod10)). The three templates are the split by rate of change: `foundation`
changes least, `discovery` rarely, `expedition` with its workload. Every rendered parameters file is checked against the compiled template's
parameter model ([ADR-AZ-DATAMOD#9](../azure-data-model.md#rule-adr-az-datamod9)), and a secure parameter takes a Key Vault reference, so no
secret sits in a config.

Two practices are missing. No check scans the compiled templates for misconfiguration — public network access, a missing tag, a missing
diagnostic setting. And every template deploys in `Incremental` mode (the default of `deployment_mode`), so a resource removed from a
template stays in Azure until someone deletes it.

##### OE:05 in `foundation`

Two modules and a three-line config per subscription; the vault is RBAC-authorised, with no access policies to drift.

##### OE:05 in `discovery`

The network's kind, address space, and subnets come from `network.yml` by config address, and the policy enforcement mode from `azure.yml`,
so the landing zone's config holds names, never ranges ([ADR-AZ-LZ#2](../landing-zones.md#rule-adr-az-lz2)).

##### OE:05 in `expedition`

The secure defaults — public access off, TLS 1.2, managed identities — are module defaults; what varies by environment class (SKU, zone
redundancy, backup redundancy and retention, the serverless pause) is config. The break-glass password is a Key Vault reference.

##### OE:05 status

Partly realised — the infrastructure is declarative, parameterised, modular, and secret-free, while a misconfiguration scan of the compiled
templates and the cleanup of removed resources are planned.

### OE:06 — Build a workload supply chain that drives changes

```text
OE:06 — Build a workload supply chain that drives changes
Source: https://learn.microsoft.com/en-us/azure/well-architected/operational-excellence/workload-supply-chain (retrieved 2026-10-15)
Summary (ours): Every change to an environment in the promotion chain travels one standard supply chain of automated CI/CD pipelines
that test it and move it through environments behind quality gates. Manual changes to those environments are not allowed, deployments
are template-based with gated write access, the same artifacts reach every environment varied only by parameters, and pipelines are
split by what they deploy (landing zone, core infrastructure, workload).
```

#### What OE:06 means here

This is the repository's delivery flow. Each deployable-unit — the shared platform and each customer — has a globset in `globs.yml` that
triggers its CD pipeline through the globset's native path filter
([ADR-FLOW-CD-GLOBS#6](../../flow/durable-sha-globs.md#rule-adr-flow-cd-globs6)). The CD pipeline runs the same CI engine as
`ci-infrastructure.yaml` ([ADR-FLOW-CD-TYPE#3](../../flow/pipeline-types.md#rule-adr-flow-cd-type3)), publishes one artifact per template,
and its deploy stages consume those artifacts unchanged — build once, deploy many
([ADR-FLOW-CD#3](../../flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd3)). The stages run `foundation`, then `discovery`, then
`expedition`, the split by what they deploy, and each deploy asserts the subscription its service connection logs into
(`-SubscriptionIdAssertIs`, [ADR-AZ-DATAMOD](../azure-data-model.md)). Configuration that reaches the cloud enters only through version
control ([ADR-FLOW-CD-TYPE#6](../../flow/pipeline-types.md#rule-adr-flow-cd-type6)).

The shipped CD pipelines deploy non-production and production in the same stage: `cd-shared.yaml` deploys `nsub` and `psub` side by side,
and `extends/cd-customer.yaml` deploys each customer's `dev` and `prod` side by side. The flow model keeps CD within non-production and
reaches production through a DEPLOY pipeline behind a manual gate
([ADR-FLOW-CD#5](../../flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd5),
[ADR-FLOW-CD#6](../../flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd6)), and `pipelines/` holds no DEPLOY pipeline. Read-only
standing access to the subscriptions is a tenant setting, outside the repository.

##### OE:06 in `foundation`

The first deploy stage of every CD pipeline; its artifact is built once per pipeline run and deployed to each subscription of the unit.

##### OE:06 in `discovery`

The second deploy stage, after `foundation`. The hubs deploy from `cd-shared.yaml` and the spokes from the customer pipelines, so the spoke
rollout order spans two pipelines (see OE:02).

##### OE:06 in `expedition`

The last deploy stage, one deployment job per slot; a customer with no `expedition` config passes an empty list and gets no stage.

##### OE:06 status

Partly realised — one globset-triggered, build-once supply chain deploys every template in order, while production is reached in the same
stage as non-production instead of by a DEPLOY pipeline.

### OE:07 — Design a monitoring stack

```text
OE:07 — Design a monitoring stack
Source: https://learn.microsoft.com/en-us/azure/well-architected/operational-excellence/observability (retrieved 2026-10-15)
Summary (ours): Build a monitoring stack beside the functional stack that collects logs, metrics, traces, and events from
infrastructure and code, organised around a health model and key indicators. Consolidate telemetry into central stores kept separate per
environment, with retention chosen per access pattern, and build dashboards and alerts on changes in health, so problems are found early,
incidents are handled well, and design decisions rest on evidence.
```

#### What OE:07 means here

Monitoring is part of the infrastructure, deployed by the same templates
([monitoring-and-observability](../../research/monitoring-and-observability.md)). `foundation` gives every subscription one Log Analytics
workspace, so telemetry is central per subscription and separate between non-production and production. Each template sends the diagnostics
of the resources it deploys to that workspace through the `diagnostic-setting.bicep` module, and the subscription's activity log through
`subscription-diagnostic-setting.bicep` ([ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3),
[ADR-AZ-LZ#5](../landing-zones.md#rule-adr-az-lz5)). A diagnostic setting in the template exists when the deploy succeeds, which a
deploy-if-not-exists policy cannot promise.

What the stack lacks is the top half: no health model, no alert rule, no dashboard. The only alerts are the landing zone's budget
thresholds, sent to the subscription's `Owner` role.

##### OE:07 in `foundation`

Deploys the workspace (`PerGB2018`, the module's 30-day retention in every config). Its own Key Vault sends no diagnostics, although the
module supports the `keyVault` kind; the vault's access log belongs in the workspace beside it. Retention per environment class is a config
value to add.

##### OE:07 in `discovery`

Sends the subscription's activity log, the virtual network's diagnostics, and each network security group's logs to `foundation`'s
workspace.

##### OE:07 in `expedition`

Sends the storage account's and the blob service's metrics and logs, and the database's logs and metrics, to `foundation`'s workspace. It
deploys no compute, so it has no application telemetry to trace.

##### OE:07 status

Partly realised — the workspace and the diagnostic settings are in place, while the vault's diagnostics, alert rules on health, and a health
model are planned.

### OE:08 — Establish a clear, structured incident management process

```text
OE:08 — Establish a clear, structured incident management process
Source: https://learn.microsoft.com/en-us/azure/well-architected/operational-excellence/incident-response (retrieved 2026-10-15)
Summary (ours): Prepare a documented incident response plan with named roles, a communication and escalation path, and procedures for
detection, triage, containment, and recovery, and design the architecture to make those steps fast — segmentation and decoupling for
containment, structured telemetry for detection, audit trails and fallbacks for recovery. Rehearse the plan, and turn each incident's
root cause analysis into improvements.
```

#### What OE:08 means here

The architecture carries the containment and recovery side. Workloads sit behind private endpoints with public access off, each subnet that
carries workloads has a network security group that denies inbound traffic from the internet, and a SQL server keeps a break-glass login
beside its Entra ID administrator group ([ADR-AZ-LZ#6](../landing-zones.md#rule-adr-az-lz6)). The activity log of every subscription is the
audit trail, and the provenance tags of OE:03 name the commit behind any deployed resource, so a bad change is found and redeployed from the
commit before it.

The process side is absent from the repository: no alert routes an incident to anyone, and no response plan, escalation path, or drill
exists as a version-controlled procedure. Named roles belong to the operating organisation, like the roles of OE:01. A blameless review that
changes a rule, a gate, or an ADR is how the repository learns
([ADR-PROC-KAIZEN#3](../../process/inspect-and-adapt.md#rule-adr-proc-kaizen3)).

##### OE:08 in `foundation`

Holds the vault the break-glass password lives in. Alert routing — an action group to the subscription's owners, as the budget does — is a
`foundation` resource to add, so every later template can point its alerts at it.

##### OE:08 in `discovery`

Segments the network: a network security group per workload subnet, a route table on every spoke subnet, and the hub's reserved
`AzureFirewallSubnet` for a firewall when containment needs one.

##### OE:08 in `expedition`

Reachable only through private endpoints; the break-glass login keeps the database reachable when the directory is not.

##### OE:08 status

Planned (follow-up) — the containment and recovery design is in place, while alert routing and a version-controlled response procedure are
not.

### OE:09 — Enhance the quality of your workload

```text
OE:09 — Enhance the quality of your workload
Source: https://learn.microsoft.com/en-us/azure/well-architected/operational-excellence/testing (retrieved 2026-10-15)
Summary (ours): Testing confirms each change works and introduces no new problems, so set a test strategy per workload and a test plan
per release, both tied to business objectives. Test from design onwards, in layers (unit, integration, end to end) with fast tests in
the build pipeline, keep test code in the same repository under the same review rules, fix or remove flaky tests, and test in
production-like or purpose-built environments.
```

#### What OE:09 means here

The test strategy is [ADR-AUTO-TEST](../../automation/test-automation.md): tests in tiers from L0 to L4, each tagged with its tier and its
category, kept in the module they test and reviewed with it. For infrastructure, `ci-infrastructure.yaml` runs `Assert-BicepTemplate` and
`Build-Bicep` for every template and then `Test-Automation -Suite infrastructure`, whose L2 test builds every shipped template and checks
each rendered parameters file against the compiled parameter model ([ADR-AZ-DATAMOD#9](../azure-data-model.md#rule-adr-az-datamod9)). A
build that leaves the literal `UNDEFINED` in a config fails.

What the infrastructure lacks is the outer loop: no L3 system test deploys a template to an on-demand environment and checks the result
([ADR-FLOW-CD#8](../../flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd8),
[ADR-AUTO-TEST#33](../../automation/test-automation.md#rule-adr-auto-test33)), and no L4 test observes a deployed landing zone or workload
([ADR-AUTO-TEST#41](../../automation/test-automation.md#rule-adr-auto-test41)).

##### OE:09 in `foundation`

Covered by the build and the parameter-model check; a system test would check that the workspace and the vault exist with their tags.

##### OE:09 in `discovery`

Covered by the build, the parameter-model check, and the network plan check (`Test-AzureNetworkPlan`); a system test would check the
peerings, the DNS zone links, and the policy assignments.

##### OE:09 in `expedition`

Covered by the build and the parameter-model check. A special slot (`dev-blu`) is a purpose-built second deployment beside a base slot, the
natural target of a system test.

##### OE:09 status

Partly realised — the inner loop tests every template on every change, while system tests against a deployed template are planned.

### OE:10 — Design automation to be reliable, secure, and maintainable

```text
OE:10 — Design automation to be reliable, secure, and maintainable
Source: https://learn.microsoft.com/en-us/azure/well-architected/operational-excellence/enable-automation (retrieved 2026-10-15)
Summary (ours): Design the workload so routine work such as provisioning, scaling, deployment, and maintenance can be automated, and
automate the repetitive tasks that clearly repay the effort, with off-the-shelf tools the team knows. Treat automation as part of the
workload — kept under version control, authenticated by managed identities, tested, monitored, and revisited — and hold desired state
with orchestration or policy tools.
```

#### What OE:10 means here

The automation is the catzc module system itself: every operation is a function in a module under `automation/`, tested by
[ADR-AUTO-TEST](../../automation/test-automation.md), idempotent ([ADR-AUTO-IDEM](../../automation/idempotent-state-functions.md)),
previewable with `-DryRun` ([ADR-AUTO-DRYRUN](../../automation/dry-run.md)), and bounded in time
([ADR-AUTO-FAILFAST#7](../../automation/fail-fast-with-asserts.md#rule-adr-auto-failfast7)). Pipelines call it through one runner and keep
their YAML declarative ([ADR-FLOW-CD-TYPE#2](../../flow/pipeline-types.md#rule-adr-flow-cd-type2)), so the same function runs on a devbox
and in a pipeline ([ADR-AUTO-PARITY](../../automation/devbox-pipeline-parity.md)). It drives Azure through the az CLI
([ADR-AZ-CLI](../prefer-az-cli.md)).

Desired state in Azure is held by the landing zone's policy assignments, which deny a resource that breaks them in production and audit it
elsewhere. Monitoring-driven self-healing is not adopted: the templates deploy platform services (storage, SQL Database, networking) whose
recovery Azure performs.

##### OE:10 in `foundation`

Deployed by the same `Deploy-Bicep` call as every template; it needs no bootstrap beyond the resource group `Deploy-Bicep` creates.

##### OE:10 in `discovery`

Holds the desired state of its subscription through its three policy assignments, whose enforcement mode is one repository-wide setting.

##### OE:10 in `expedition`

Its storage account and SQL server each take a system-assigned managed identity; its database's serverless pause outside production is
platform automation set by config.

##### OE:10 status

Realised — automation is version-controlled, tested, idempotent, dry-runnable, and bounded in time, and policy holds the desired state.

### OE:11 — Clearly define your workload's safe deployment practices

```text
OE:11 — Clearly define your workload's safe deployment practices
Source: https://learn.microsoft.com/en-us/azure/well-architected/operational-excellence/safe-deployments (retrieved 2026-10-15)
Summary (ours): Treat every production change as risky and deploy it through a consistent, automated process in small, frequent,
quality-gated increments. Expose changes progressively with health checks and bake time between stages, stop at the first sign of
trouble, keep defined rollback or roll-forward options and versioned artifacts, check changes before deployment, and define faster but
still controlled protocols for emergencies.
```

#### What OE:11 means here

The flow model defines safe deployment: one tagged artifact, built once and never rebuilt
([ADR-FLOW-CD#3](../../flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd3)), promoted through non-production behind the RC and RBC
gates ([ADR-FLOW-CD#9](../../flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd9)), then staged inactive in pre-prod and activated to
production ([ADR-FLOW-CD#12](../../flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd12)). A gate that fails stops the line
([ADR-PROC-ANDON#1](../../process/holding-the-line.md#rule-adr-proc-andon1)), and a DEPLOY pipeline deploys one pinned commit's artifact, so
rolling back is deploying the commit before it ([ADR-FLOW-CD-TYPE#10](../../flow/pipeline-types.md#rule-adr-flow-cd-type10)).

The shipped pipelines realise part of this: they deploy only on `main`, after the CI stage, in dependency order, each into an asserted
subscription. They deploy non-production and production in the same stage with no bake time between them (see OE:06), and they do not run
the Azure what-if preview that `Deploy-Bicep -DryRun` offers before each deploy.

##### OE:11 in `foundation`

Low risk per change, but production and non-production deploy together; production belongs behind the non-production deploy.

##### OE:11 in `discovery`

The riskiest template: a change to peering, routing, or a policy assignment reaches every workload of the subscription. A what-if preview
before the deploy shows a network rule's impact before it lands.

##### OE:11 in `expedition`

A slot is a deployment of its own, so a special slot can take a change before the base slot; production follows the non-production configs
of the same customer.

##### OE:11 status

Partly realised — build once, main-only, ordered, asserted deploys are in place, while staged promotion to production and a what-if preview
are planned.

## Decision

The repository reviews its infrastructure against the Operational Excellence checklist one item at a time, and each rule above states what
it does about that item. Most items map to machinery the repository defines for its own reasons — everything as code, the CI discipline and
the promotion flow, the quality gates, the templates' secure defaults — so a WAF item adds no second mechanism; it names the gap between the
checklist and that machinery. Where an item is the operating organisation's — roles, decision authority, standing access — the rule says so
and the repository carries what a repository can: the `owner` tag, the written procedure, the alert route.

A `partly realised` or `planned` status is follow-up work: a check, a template change, a pipeline change, or a how-to, each citing the rule
it realises.

### How this is enforced

Checks that exist:

- `ci-infrastructure.yaml` runs `Assert-BicepTemplate` and `Build-Bicep` for every template on every change under `infrastructure/`, as a
  pull-request check and on the merged commit, then `Test-Automation -Suite infrastructure`, whose L2 test checks every rendered parameters
  file against the compiled parameter model ([ADR-AZ-DATAMOD#9](../azure-data-model.md#rule-adr-az-datamod9)).
- `build-validation.yml` binds each declared globset to its pipeline as a blocking build validation on `main`, and the drift quality gate
  `Test-AdoPipelineTriggerGlob` keeps each pipeline's trigger equal to its globset's projection
  ([ADR-FLOW-CD-GLOBS#6](../../flow/durable-sha-globs.md#rule-adr-flow-cd-globs6)).
- `Deploy-Bicep` asserts the target subscription and tags every deployed resource group or subscription with its commit, build, and branch
  (`Set-BicepTrackingTagSet`).
- `Format-Code` and `Test-Formatting` hold the Bicep formatting; `Test-Pipelines` holds the pipeline naming and placement.

Checks that are planned (follow-up), none of which exists:

- A quality gate that reads each compiled `main.json` and reports a resource without a diagnostic setting, without the CAF tags, or with
  public network access, citing ADR-AZ-WAFOE#5 and ADR-AZ-WAFOE#7.
- The Bicep linter as a quality gate, through an `infrastructure/bicepconfig.json` that sets its rules to error (ADR-AZ-WAFOE#4).
- A secret scan of every change in the CI engine (ADR-AZ-WAFOE#3).
- A what-if preview before every pipeline deploy, and production reached by a DEPLOY pipeline rather than a CD stage (ADR-AZ-WAFOE#6,
  ADR-AZ-WAFOE#11).
- L3 system tests that deploy each template to an on-demand environment (ADR-AZ-WAFOE#9).

## Consequences

- Every item of the checklist has a status a reader can check against the files it names, and the follow-up is the list of items that are
  not realised.
- The repository adds no WAF-specific mechanism: a gap is closed in the template, pipeline, or check that owns the concern.
- Items that belong to the operating organisation stay outside the repository, at the cost that the repository cannot show them to be met.
- Microsoft's checklist changes; each item carries its retrieval date, and a refresh compares the cited pages against these summaries.
