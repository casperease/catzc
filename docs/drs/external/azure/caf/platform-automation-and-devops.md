# EDR: CAF platform automation and DevOps — Microsoft's recommendations for the design area, as the repository reads them

Binds to [`waf-operational-excellence`](../waf/operational-excellence.md) (the workload view of the same delivery concerns; its rules are
cited here, not repeated) and [`cd-discipline-and-promotion-flow`](../../../flow/cd-discipline-and-promotion-flow.md) (the flow model every
pipeline below is measured against).

## Rules: EDR-AZ-CAF-DEVOPS

Each rule is one of the area's 37 recommendations, numbered in the order of the area's pages: 1 to 12 automation, 13 to 17 DevOps principles
and practices, 18 to 35 the development lifecycle, and 36 and 37 the toolchain. Every source line names the page under
`https://learn.microsoft.com/en-us` and the retrieval date; the sentence is the repository's own summary, never a quotation. The
repository's decision on each recommendation is in the rule it binds to.

### Rule EDR-AZ-CAF-DEVOPS-R01

Treat the platform, its documentation, its deployment, and its tests as code, for full transparency and control.

Source: learn /azure/cloud-adoption-framework/ready/considerations/automation (recommendation 1, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFDELIVERY](../../../azure/landing-zones.md#rule-adr-az-lz-cafdelivery).

### Rule EDR-AZ-CAF-DEVOPS-R02

Put infrastructure, policy, configuration, deployment, and documentation code under version control.

Source: learn /azure/cloud-adoption-framework/ready/considerations/automation (recommendation 2, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFDELIVERY](../../../azure/landing-zones.md#rule-adr-az-lz-cafdelivery).

### Rule EDR-AZ-CAF-DEVOPS-R03

Have every change reviewed by a second person, by pair programming or peer review, before it reaches production.

Source: learn /azure/cloud-adoption-framework/ready/considerations/automation (recommendation 3, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFDELIVERY](../../../azure/landing-zones.md#rule-adr-az-lz-cafdelivery).

### Rule EDR-AZ-CAF-DEVOPS-R04

Choose a branching strategy and protect the important branches with policies, so changes merge only through pull requests.

Source: learn /azure/cloud-adoption-framework/ready/considerations/automation (recommendation 4, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFDELIVERY](../../../azure/landing-zones.md#rule-adr-az-lz-cafdelivery).

### Rule EDR-AZ-CAF-DEVOPS-R05

Automate testing and the deployment to each environment with continuous integration and continuous delivery.

Source: learn /azure/cloud-adoption-framework/ready/considerations/automation (recommendation 5, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFDELIVERY](../../../azure/landing-zones.md#rule-adr-az-lz-cafdelivery).

### Rule EDR-AZ-CAF-DEVOPS-R06

Automate the provisioning, configuration, and management of the platform, and the provisioning of landing zone subscriptions.

Source: learn /azure/cloud-adoption-framework/ready/considerations/automation (recommendation 6, retrieved 2026-10-15)

Binds to [ADR-AZ-DATAMOD-SUBSCRIPTIONUNIT](../../../azure/azure-data-model.md#rule-adr-az-datamod-subscriptionunit),
[ADR-AZ-LZ-CAFDELIVERY](../../../azure/landing-zones.md#rule-adr-az-lz-cafdelivery).

### Rule EDR-AZ-CAF-DEVOPS-R07

Begin with the landing zone accelerator that suits the team's maturity.

Source: learn /azure/cloud-adoption-framework/ready/considerations/automation (recommendation 7, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFDELIVERY](../../../azure/landing-zones.md#rule-adr-az-lz-cafdelivery).

### Rule EDR-AZ-CAF-DEVOPS-R08

Plan to deploy in stages, adding your own automation over the accelerator for what it does not cover.

Source: learn /azure/cloud-adoption-framework/ready/considerations/automation (recommendation 8, retrieved 2026-10-15)

Binds to [ADR-AZ-IACKIND-THREEIACKINDS](../../../azure/infrastructure-kinds.md#rule-adr-az-iackind-threeiackinds),
[ADR-AZ-LZ-CAFDELIVERY](../../../azure/landing-zones.md#rule-adr-az-lz-cafdelivery).

### Rule EDR-AZ-CAF-DEVOPS-R09

Make emergency fixes through code as well, and record each in the backlog so it is reworked properly and debt stays small.

Source: learn /azure/cloud-adoption-framework/ready/considerations/automation (recommendation 9, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFDELIVERY](../../../azure/landing-zones.md#rule-adr-az-lz-cafdelivery).

### Rule EDR-AZ-CAF-DEVOPS-R10

Deploy and manage Azure Policy with infrastructure as code.

Source: learn /azure/cloud-adoption-framework/ready/considerations/automation (recommendation 10, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-LANDINGZONEPOLICIES](../../../azure/landing-zones.md#rule-adr-az-lz-landingzonepolicies),
[ADR-AZ-LZ-CAFDELIVERY](../../../azure/landing-zones.md#rule-adr-az-lz-cafdelivery).

### Rule EDR-AZ-CAF-DEVOPS-R11

Give workload teams a process to request a policy exemption, so a policy does not leave them stuck.

Source: learn /azure/cloud-adoption-framework/ready/considerations/automation (recommendation 11, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-GOVERNANCELIMITS](../../../azure/landing-zones.md#rule-adr-az-lz-governancelimits),
[ADR-AZ-LZ-CAFDELIVERY](../../../azure/landing-zones.md#rule-adr-az-lz-cafdelivery).

### Rule EDR-AZ-CAF-DEVOPS-R12

Stop a non-compliant deployment with a deny policy rather than correcting it quietly at deploy time, so the code and what is deployed do not
drift apart; the considerations name modify effects as the risk.

Source: learn /azure/cloud-adoption-framework/ready/considerations/automation (recommendation 12, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-LANDINGZONEPOLICIES](../../../azure/landing-zones.md#rule-adr-az-lz-landingzonepolicies),
[ADR-AZ-LZ-CAFDELIVERY](../../../azure/landing-zones.md#rule-adr-az-lz-cafdelivery).

### Rule EDR-AZ-CAF-DEVOPS-R13

Start from available frameworks, the Microsoft DevOps Resource Center and the DevOps Dojo taxonomy, rather than inventing one.

Source: learn /azure/cloud-adoption-framework/ready/considerations/devops-principles-and-practices (recommendation 13, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFDELIVERY](../../../azure/landing-zones.md#rule-adr-az-lz-cafdelivery).

### Rule EDR-AZ-CAF-DEVOPS-R14

For the landing zone's management, follow the pages on its development lifecycle and on DevOps security.

Source: learn /azure/cloud-adoption-framework/ready/considerations/devops-principles-and-practices (recommendation 14, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFDELIVERY](../../../azure/landing-zones.md#rule-adr-az-lz-cafdelivery).

### Rule EDR-AZ-CAF-DEVOPS-R15

Assess current practices, team structure, and operating model, define the target from the adoption plan, and get there by an incremental
roadmap.

Source: learn /azure/cloud-adoption-framework/ready/considerations/devops-principles-and-practices (recommendation 15, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFDELIVERY](../../../azure/landing-zones.md#rule-adr-az-lz-cafdelivery).

### Rule EDR-AZ-CAF-DEVOPS-R16

Pick visible, outcome-oriented metrics for business outcomes, software delivery performance (the four DORA metrics), and quality.

Source: learn /azure/cloud-adoption-framework/ready/considerations/devops-principles-and-practices (recommendation 16, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFDELIVERY](../../../azure/landing-zones.md#rule-adr-az-lz-cafdelivery).

### Rule EDR-AZ-CAF-DEVOPS-R17

Choose tools per DevOps activity, balancing team fit against standardisation; the toolchain shapes practices, security, and the landing zone
lifecycle.

Source: learn /azure/cloud-adoption-framework/ready/considerations/devops-principles-and-practices (recommendation 17, retrieved 2026-10-15)

Binds to [ADR-AZ-CLI-AZBYDEFAULT](../../../azure/prefer-az-cli.md#rule-adr-az-cli-azbydefault),
[ADR-AZ-LZ-CAFDELIVERY](../../../azure/landing-zones.md#rule-adr-az-lz-cafdelivery).

### Rule EDR-AZ-CAF-DEVOPS-R18

Use Git for version control.

Source: learn /azure/cloud-adoption-framework/ready/considerations/development-strategy-development-lifecycle (recommendation 18, retrieved
2026-10-15)

Binds to [ADR-AZ-LZ-CAFDELIVERY](../../../azure/landing-zones.md#rule-adr-az-lz-cafdelivery).

### Rule EDR-AZ-CAF-DEVOPS-R19

Keep the code of Azure landing zones in private repositories.

Source: learn /azure/cloud-adoption-framework/ready/considerations/development-strategy-development-lifecycle (recommendation 19, retrieved
2026-10-15)

Binds to [ADR-AZ-LZ-CAFDELIVERY](../../../azure/landing-zones.md#rule-adr-az-lz-cafdelivery).

### Rule EDR-AZ-CAF-DEVOPS-R20

Use public repositories only for material that is not confidential: samples, documentation, and openly licensed code.

Source: learn /azure/cloud-adoption-framework/ready/considerations/development-strategy-development-lifecycle (recommendation 20, retrieved
2026-10-15)

Binds to [ADR-AZ-LZ-CAFDELIVERY](../../../azure/landing-zones.md#rule-adr-az-lz-cafdelivery).

### Rule EDR-AZ-CAF-DEVOPS-R21

Deploy, manage, and govern cloud resources through infrastructure as code.

Source: learn /azure/cloud-adoption-framework/ready/considerations/development-strategy-development-lifecycle (recommendation 21, retrieved
2026-10-15)

Binds to [ADR-AZ-IACKIND-THREEIACKINDS](../../../azure/infrastructure-kinds.md#rule-adr-az-iackind-threeiackinds),
[ADR-AZ-LZ-CAFDELIVERY](../../../azure/landing-zones.md#rule-adr-az-lz-cafdelivery).

### Rule EDR-AZ-CAF-DEVOPS-R22

Use trunk-based development: everyone integrates into one branch and resolves conflicts as they commit.

Source: learn /azure/cloud-adoption-framework/ready/considerations/development-strategy-development-lifecycle (recommendation 22, retrieved
2026-10-15)

Binds to [ADR-AZ-LZ-CAFDELIVERY](../../../azure/landing-zones.md#rule-adr-az-lz-cafdelivery).

### Rule EDR-AZ-CAF-DEVOPS-R23

Agree branch naming conventions that show what kind of work a branch holds.

Source: learn /azure/cloud-adoption-framework/ready/considerations/development-strategy-development-lifecycle (recommendation 23, retrieved
2026-10-15)

Binds to [ADR-AZ-LZ-CAFDELIVERY](../../../azure/landing-zones.md#rule-adr-az-lz-cafdelivery).

### Rule EDR-AZ-CAF-DEVOPS-R24

Set read and write permissions per branch for users and groups.

Source: learn /azure/cloud-adoption-framework/ready/considerations/development-strategy-development-lifecycle (recommendation 24, retrieved
2026-10-15)

Binds to [ADR-AZ-LZ-CAFDELIVERY](../../../azure/landing-zones.md#rule-adr-az-lz-cafdelivery).

### Rule EDR-AZ-CAF-DEVOPS-R25

Protect main with branch policies: pull requests required, a minimum number of reviewers, approvals reset on new changes, reviewers added
automatically, and comments resolved before merge.

Source: learn /azure/cloud-adoption-framework/ready/considerations/development-strategy-development-lifecycle (recommendation 25, retrieved
2026-10-15)

Binds to [ADR-AZ-LZ-CAFDELIVERY](../../../azure/landing-zones.md#rule-adr-az-lz-cafdelivery).

### Rule EDR-AZ-CAF-DEVOPS-R26

Squash-merge pull requests so each lands on the default branch as one commit.

Source: learn /azure/cloud-adoption-framework/ready/considerations/development-strategy-development-lifecycle (recommendation 26, retrieved
2026-10-15)

Binds to [ADR-AZ-LZ-CAFDELIVERY](../../../azure/landing-zones.md#rule-adr-az-lz-cafdelivery).

### Rule EDR-AZ-CAF-DEVOPS-R27

Use continuous integration so every commit is built and tested automatically.

Source: learn /azure/cloud-adoption-framework/ready/considerations/development-strategy-development-lifecycle (recommendation 27, retrieved
2026-10-15)

Binds to [ADR-AZ-DATAMOD-PARAMETERCONTRACT](../../../azure/azure-data-model.md#rule-adr-az-datamod-parametercontract),
[ADR-AZ-LZ-CAFDELIVERY](../../../azure/landing-zones.md#rule-adr-az-lz-cafdelivery).

### Rule EDR-AZ-CAF-DEVOPS-R28

Include unit tests for both infrastructure code and application code in the build.

Source: learn /azure/cloud-adoption-framework/ready/considerations/development-strategy-development-lifecycle (recommendation 28, retrieved
2026-10-15)

Binds to [ADR-AZ-DATAMOD-PARAMETERCONTRACT](../../../azure/azure-data-model.md#rule-adr-az-datamod-parametercontract),
[ADR-AZ-LZ-CAFDELIVERY](../../../azure/landing-zones.md#rule-adr-az-lz-cafdelivery).

### Rule EDR-AZ-CAF-DEVOPS-R29

Prefer Microsoft-hosted agents over self-hosted ones, for an isolated, fresh machine on every run.

Source: learn /azure/cloud-adoption-framework/ready/considerations/development-strategy-development-lifecycle (recommendation 29, retrieved
2026-10-15)

Binds to [ADR-AZ-LZ-CAFDELIVERY](../../../azure/landing-zones.md#rule-adr-az-lz-cafdelivery).

### Rule EDR-AZ-CAF-DEVOPS-R30

When pipelines connect to Azure through service connections or stored secrets, limit each connection to the resources it needs.

Source: learn /azure/cloud-adoption-framework/ready/considerations/development-strategy-development-lifecycle (recommendation 30, retrieved
2026-10-15)

Binds to [ADR-AZ-DATAMOD-JOINSINPOWERSHELL](../../../azure/azure-data-model.md#rule-adr-az-datamod-joinsinpowershell),
[ADR-AZ-LZ-CAFDELIVERY](../../../azure/landing-zones.md#rule-adr-az-lz-cafdelivery).

### Rule EDR-AZ-CAF-DEVOPS-R31

Pull credentials, certificates, and keys from Key Vault into pipeline variables instead of writing them into code.

Source: learn /azure/cloud-adoption-framework/ready/considerations/development-strategy-development-lifecycle (recommendation 31, retrieved
2026-10-15)

Binds to [ADR-AZ-LZ-SQLENTRAADMINS](../../../azure/landing-zones.md#rule-adr-az-lz-sqlentraadmins),
[ADR-AZ-LZ-CAFDELIVERY](../../../azure/landing-zones.md#rule-adr-az-lz-cafdelivery).

### Rule EDR-AZ-CAF-DEVOPS-R32

Deliver continuously to production-like environments, so the code is always ready to deploy and defects show early.

Source: learn /azure/cloud-adoption-framework/ready/considerations/development-strategy-development-lifecycle (recommendation 32, retrieved
2026-10-15)

Binds to [ADR-AZ-LZ-CAFDELIVERY](../../../azure/landing-zones.md#rule-adr-az-lz-cafdelivery).

### Rule EDR-AZ-CAF-DEVOPS-R33

Use pipeline environments for deployment history, traceability to commits and work items, resource health, and security.

Source: learn /azure/cloud-adoption-framework/ready/considerations/development-strategy-development-lifecycle (recommendation 33, retrieved
2026-10-15)

Binds to [ADR-AZ-LZ-CAFDELIVERY](../../../azure/landing-zones.md#rule-adr-az-lz-cafdelivery).

### Rule EDR-AZ-CAF-DEVOPS-R34

Before deploying infrastructure code, preview what it will create, change, and delete (what-if or plan).

Source: learn /azure/cloud-adoption-framework/ready/considerations/development-strategy-development-lifecycle (recommendation 34, retrieved
2026-10-15)

Binds to [ADR-AZ-CLI-AZBYDEFAULT](../../../azure/prefer-az-cli.md#rule-adr-az-cli-azbydefault),
[ADR-AZ-LZ-CAFDELIVERY](../../../azure/landing-zones.md#rule-adr-az-lz-cafdelivery).

### Rule EDR-AZ-CAF-DEVOPS-R35

Roll back by Git's undo operations: revert, discard, or reset.

Source: learn /azure/cloud-adoption-framework/ready/considerations/development-strategy-development-lifecycle (recommendation 35, retrieved
2026-10-15)

Binds to [ADR-AZ-LZ-CAFDELIVERY](../../../azure/landing-zones.md#rule-adr-az-lz-cafdelivery).

### Rule EDR-AZ-CAF-DEVOPS-R36

A toolchain covers planning, CI and CD with infrastructure as code, operations, and collaboration; the first option is Azure DevOps for all
of it, for organisations deep in Microsoft's ecosystem.

Source: learn /azure/cloud-adoption-framework/ready/considerations/devops-toolchain (recommendation 36, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFDELIVERY](../../../azure/landing-zones.md#rule-adr-az-lz-cafdelivery).

### Rule EDR-AZ-CAF-DEVOPS-R37

The second option combines Azure DevOps and GitHub, to use the strengths of each.

Source: learn /azure/cloud-adoption-framework/ready/considerations/devops-toolchain (recommendation 37, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFDELIVERY](../../../azure/landing-zones.md#rule-adr-az-lz-cafdelivery).

## Context

Microsoft's Cloud Adoption Framework (CAF) is its guidance for taking an organisation onto Azure. The platform automation and DevOps design
area covers treating the platform as code, the branching and review of changes, continuous integration and delivery, the policies deployed
as code, the DevOps principles and metrics behind them, the development lifecycle of a landing zone, and the toolchain. The live text is
published under the [Microsoft Learn Terms of Use](https://learn.microsoft.com/en-us/legal/termsofuse), which grant no licence to copy it
into a shared repository, so nothing is quoted.

The [CAF reference](../../../../references/caf/index.md) lists every CAF record in this repository and the Microsoft pages each one cites.
