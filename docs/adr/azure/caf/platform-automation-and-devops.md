# ADR: CAF platform automation and DevOps — what the repository does about each recommendation of the design area

Pairs with [`waf-operational-excellence`](../waf/operational-excellence.md) (the workload view of the same delivery concerns; its rules are
cited here, not repeated) and [`cd-discipline-and-promotion-flow`](../../flow/cd-discipline-and-promotion-flow.md) (the flow model every
pipeline below is measured against).

## Rules: ADR-AZ-CAFDEVOPS

### Rule ADR-AZ-CAFDEVOPS:1

Partly realised: everything that builds, tests, deploys, or documents the platform is code in the repository; the service connections, the
Azure DevOps environments and their checks are created outside it.

- [1 — Express the platform and its processes as code](#1--express-the-platform-and-its-processes-as-code)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AZ-CAFDEVOPS:2

Realised: templates, modules, configs, policy assignments, pipelines, automation, and ADRs all live in one Git repository.

- [2 — Keep every kind of code under version control](#2--keep-every-kind-of-code-under-version-control)

### Rule ADR-AZ-CAFDEVOPS:3

Partly realised: in the `main-via-pr` variant every change enters `main` through a pull request with blocking build validation; the
repository runs `main-direct`, and a required-reviewer policy is planned.

- [3 — Have a second person review every change](#3--have-a-second-person-review-every-change)

### Rule ADR-AZ-CAFDEVOPS:4

Partly realised: the branching strategy is trunk-based and the build-validation policies on `main` are applied from config; the rule that
`main` admits merges only through a pull request is a server setting outside the repository.

- [4 — Protect important branches with policies](#4--protect-important-branches-with-policies)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AZ-CAFDEVOPS:5

Partly realised: a CI pipeline builds and tests every template and globset-triggered CD pipelines deploy them in order; production deploys
in the same stage as non-production instead of by promotion.

- [5 — Test and deploy through pipelines](#5--test-and-deploy-through-pipelines)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AZ-CAFDEVOPS:6

Partly realised: provisioning and configuring every landing zone and workload is automated; creating a subscription is not adopted, and the
rollout of a new spoke and the seeding of the break-glass secret are manual.

- [6 — Automate provisioning and management](#6--automate-provisioning-and-management)

### Rule ADR-AZ-CAFDEVOPS:7

Not adopted, because the repository deploys its own templates to its own rules; Microsoft's accelerators assume management groups and a
platform the repository does not own.

- [7 — Start from a landing zone accelerator](#7--start-from-a-landing-zone-accelerator)

### Rule ADR-AZ-CAFDEVOPS:8

Realised in the repository's own form: `foundation`, `discovery`, and `expedition` are deployed in order, each on top of the one before,
with `foundation` as the base an accelerator would otherwise provide.

- [8 — Add your own automation on top of the starting point](#8--add-your-own-automation-on-top-of-the-starting-point)

### Rule ADR-AZ-CAFDEVOPS:9

Partly realised: every fix, urgent or not, is a commit that the same pipelines deploy; a written emergency-change procedure is planned.

- [9 — Make quick fixes in code too](#9--make-quick-fixes-in-code-too)

### Rule ADR-AZ-CAFDEVOPS:10

Realised: the landing zone's three built-in policy assignments are Bicep in `discovery`, pinned by definition id and deployed by its
pipeline.

- [10 — Manage Azure Policy as code](#10--manage-azure-policy-as-code)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AZ-CAFDEVOPS:11

Not adopted, because the landing zone makes no exemption: a team that needs a different policy proposes a change to the landing zone,
reviewed like any other.

- [11 — Offer a way to request a policy exemption](#11--offer-a-way-to-request-a-policy-exemption)

### Rule ADR-AZ-CAFDEVOPS:12

Realised: the landing zone's policies deny in production and audit elsewhere, and none uses a modify or append effect.

- [12 — Block non-compliant deployments instead of fixing them](#12--block-non-compliant-deployments-instead-of-fixing-them)

### Rule ADR-AZ-CAFDEVOPS:13

Not adopted, because the repository's delivery framework is its own flow model grounded in the DORA research, not Microsoft's DevOps
material.

- [13 — Build on existing DevOps frameworks](#13--build-on-existing-devops-frameworks)

### Rule ADR-AZ-CAFDEVOPS:14

Realised: this ADR reviews the development lifecycle page item by item, and the DevOps security page informs rules 30 and 31.

- [14 — Adopt the landing zone DevOps practices](#14--adopt-the-landing-zone-devops-practices)

### Rule ADR-AZ-CAFDEVOPS:15

Not adopted, because the repository improves continuously from evidence rather than through an assessed roadmap.

- [15 — Plan the DevOps journey in steps](#15--plan-the-devops-journey-in-steps)

### Rule ADR-AZ-CAFDEVOPS:16

Partly realised: the delivery metrics are DORA's; nothing in the repository collects them from the pipelines, which is planned.

- [16 — Measure delivery with chosen metrics](#16--measure-delivery-with-chosen-metrics)

### Rule ADR-AZ-CAFDEVOPS:17

Realised: the toolchain is chosen once and pinned — Git, Azure DevOps and GitHub pipelines, Bicep, the az CLI, Pester — and installed the
same way on a devbox and in a pipeline.

- [17 — Choose the toolchain deliberately](#17--choose-the-toolchain-deliberately)

### Rule ADR-AZ-CAFDEVOPS:18

Realised: the repository is a Git repository, and its automation reads changes from Git.

- [18 — Use Git](#18--use-git)

### Rule ADR-AZ-CAFDEVOPS:19

Not adopted, because a repository's visibility is a setting of its server remote, outside the repository; it is built to hold no secret
either way.

- [19 — Keep landing zone code in private repositories](#19--keep-landing-zone-code-in-private-repositories)

### Rule ADR-AZ-CAFDEVOPS:20

Realised: what the repository shares publicly is the built catzc package, published by a manual release workflow, never the infrastructure
templates and their configs.

- [20 — Share only nonconfidential material in public repositories](#20--share-only-nonconfidential-material-in-public-repositories)

### Rule ADR-AZ-CAFDEVOPS:21

Realised: all Azure infrastructure is declarative Bicep with shared modules and one config per configuration slot, deployed only by
pipelines.

- [21 — Deploy and govern through infrastructure as code](#21--deploy-and-govern-through-infrastructure-as-code)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AZ-CAFDEVOPS:22

Realised: development is trunk-based on `main`, with short-lived branches and no release or version branches.

- [22 — Develop on a single trunk](#22--develop-on-a-single-trunk)

### Rule ADR-AZ-CAFDEVOPS:23

Not adopted, because branches are short-lived and carry nothing that automation reads from their names.

- [23 — Name branches consistently](#23--name-branches-consistently)

### Rule ADR-AZ-CAFDEVOPS:24

Not adopted, because branch permissions are a setting of the server remote; the repository relies on the protected `main` and pull-request
ingress.

- [24 — Control who can read and write each branch](#24--control-who-can-read-and-write-each-branch)

### Rule ADR-AZ-CAFDEVOPS:25

Partly realised: blocking build validation per globset is configured in `build-validation.yml`; minimum reviewers, vote reset, automatic
reviewers, and comment resolution are planned.

- [25 — Set branch policies on the main branch](#25--set-branch-policies-on-the-main-branch)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AZ-CAFDEVOPS:26

Partly realised: the delivery design takes `main` to advance by squash merge only, and its change detection relies on it; no policy in the
repository sets the merge type.

- [26 — Merge pull requests by squashing](#26--merge-pull-requests-by-squashing)

### Rule ADR-AZ-CAFDEVOPS:27

Realised: every change under `infrastructure/` builds and tests every template, as a pull-request check and again on the merged commit.

- [27 — Build and test every commit](#27--build-and-test-every-commit)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AZ-CAFDEVOPS:28

Partly realised: every template is validated, compiled, and checked against its parameter model in the build; the Bicep linter as a quality
gate and system tests of a deployed template are planned.

- [28 — Unit-test infrastructure code as well](#28--unit-test-infrastructure-code-as-well)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AZ-CAFDEVOPS:29

Realised: every job of every pipeline runs on a Microsoft-hosted agent.

- [29 — Prefer Microsoft-hosted build agents](#29--prefer-microsoft-hosted-build-agents)

### Rule ADR-AZ-CAFDEVOPS:30

Partly realised: each deploy runs through the service connection of its own subscription and asserts that subscription; federated
credentials, one identity per template and environment, and a read-only identity for previews are planned.

- [30 — Give pipeline connections only the access they need](#30--give-pipeline-connections-only-the-access-they-need)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AZ-CAFDEVOPS:31

Realised: pipelines hold no secret; the one deploy-time secret is a Key Vault reference resolved by Azure Resource Manager.

- [31 — Take pipeline secrets from Key Vault](#31--take-pipeline-secrets-from-key-vault)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AZ-CAFDEVOPS:32

Partly realised: every commit to `main` that touches a deployable-unit is deployed to its non-production subscriptions; system tests in an
on-demand environment are planned.

- [32 — Keep the code always deployable](#32--keep-the-code-always-deployable)

### Rule ADR-AZ-CAFDEVOPS:33

Partly realised: every deployment job names an Azure DevOps environment per template target; the environments' checks and approvals are not
declared in the repository.

- [33 — Deploy through pipeline environments](#33--deploy-through-pipeline-environments)

### Rule ADR-AZ-CAFDEVOPS:34

Partly realised: `Deploy-Bicep -DryRun` runs the Azure what-if preview; running it before every pipeline deploy is planned.

- [34 — Preview each deployment before it runs](#34--preview-each-deployment-before-it-runs)

### Rule ADR-AZ-CAFDEVOPS:35

Partly realised: a rollback is a revert commit that the same pipelines deploy; deploying an earlier commit's artifact by a DEPLOY pipeline,
and removing what a revert takes out of a template, are planned.

- [35 — Roll back with Git](#35--roll-back-with-git)

### Rule ADR-AZ-CAFDEVOPS:36

Partly realised: the infrastructure pipelines run on Azure DevOps; planning and collaboration tools belong to the operating organisation.

- [36 — An all Azure DevOps toolchain](#36--an-all-azure-devops-toolchain)

### Rule ADR-AZ-CAFDEVOPS:37

Realised: the infrastructure runs on Azure DevOps Pipelines, and the catzc automation's CI and release run on GitHub Actions.

- [37 — A combined Azure DevOps and GitHub toolchain](#37--a-combined-azure-devops-and-github-toolchain)

## Context

Microsoft's Cloud Adoption Framework (CAF) is its guidance for adopting Azure across an organisation: strategy, planning, readiness,
governance, and operations. Its landing-zone guidance splits the platform an organisation builds into design areas, each with considerations
to weigh and design recommendations; the landing zone that a subscription receives here is CAF's application landing zone
([ADR-AZ-LZ#1](../landing-zones.md#rule-adr-az-lz1)).

The platform automation and DevOps design area applies DevOps to the landing zone itself: it is provisioned, changed, and operated as code,
through version control, review, and pipelines, by a team with a deliberate toolchain. This is where the repository is strongest, because
its delivery machinery exists for its own reasons: everything as code ([ADR-PRIN-EAC](../../principles/everything-as-code.md)), one living
version on one trunk ([ADR-PRIN-ONELIVE](../../principles/one-living-version.md)), the CI discipline and promotion flow
([ADR-FLOW-CD](../../flow/cd-discipline-and-promotion-flow.md)), the six pipeline types ([ADR-FLOW-CD-TYPE](../../flow/pipeline-types.md)),
the runner ([ADR-FLOW-CD-RUNNER](../../flow/pipeline-runner-pattern.md)), deployable units as globsets
([ADR-FLOW-CD-GLOBS](../../flow/durable-sha-globs.md)), pipeline layout ([ADR-PIPE-NAME](../../pipelines/pipeline-naming-and-placement.md),
[ADR-PIPE-TEMPLATE](../../pipelines/custom-template-discipline.md)), and the test tiers
([ADR-AUTO-TEST](../../automation/test-automation.md)). The Operational Excellence review of the same machinery is
[ADR-AZ-WAFOE](../waf/operational-excellence.md); the rules below cite those decisions rather than derive them again, and name the gap where
a CAF item asks for more.

These rules are vendor recommendation, not principled theory. They do not argue from first principles the way the axioms and DORA's research
do; they record what the repository does about each of Microsoft's 37 recommendations in this area, numbered in the order of the area's
pages: platform automation (1–12), DevOps considerations (13–17), the development lifecycle (18–35), and the DevOps toolchain (36–37). Each
rule cites Microsoft's page — area, page, section, link, retrieval date — and summarises it in our own words, because the live CAF text is
published under the [Microsoft Learn Terms of Use](https://learn.microsoft.com/en-us/legal/termsofuse), which grant no licence to copy it
into a shared repository. Nothing is quoted.

The [CAF reference](../../../references/caf/index.md) lists every CAF record in this repository and the Microsoft pages each one cites.

Several pages of the area carry guidance without a recommendations section, so they are not rules here; they inform the takeaways.
[Subscription vending](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/subscription-vending)
(and its product lines) automates the request, approval, and creation of a subscription with its budget, network, and identities, which
bears on [6](#6--automate-provisioning-and-management).
[Environments](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/environments) asks for at least one
test environment, separate identities for test and production, and automated checks before each environment, which bears on
[33](#33--deploy-through-pipeline-environments).
[Test-driven development](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/development-strategy-test-driven-development)
for landing zones uses policy and resource queries as tests, which bears on [28](#28--unit-test-infrastructure-code-as-well). The
[DevOps security considerations](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/security-considerations-overview)
ask pipelines to sign in to Azure by workload identity federation rather than a stored secret, to use one identity per application and
environment, to give the what-if or plan step its own read-only identity, to put approvals on the service connection, and to keep secrets in
a secret store; they bear on [30](#30--give-pipeline-connections-only-the-access-they-need) and
[31](#31--take-pipeline-secrets-from-key-vault). The pages on DevOps team topologies and on role-based access for DevOps tools describe how
an organisation arranges its teams and tool permissions, which belongs to the operating organisation.

The example basis is the repository's three templates: `foundation` (a Log Analytics workspace and a Key Vault per subscription),
`discovery` (the landing zone), and `expedition` (a workload that lands in it, [ADR-AZ-LZ#4](../landing-zones.md#rule-adr-az-lz4)). They are
delivered by `pipelines/ci-infrastructure.yaml` (the CI pipeline for all three), `pipelines/cd-shared.yaml` (the shared platform), and the
thin customer pipelines `cd-apex.yaml`, `cd-nova.yaml`, and `cd-flux.yaml`, which extend `pipelines/extends/cd-customer.yaml`. Every
takeaway below points at what those do, or says plainly what they do not.

### 1 — Express the platform and its processes as code

```text
CAF platform automation and DevOps — Automation, Platform automation design recommendation — recommendation 1
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/automation (retrieved 2026-10-15)
Summary (ours): Treat the platform, its documentation, its deployment, and its tests as code, for full transparency and control.
```

#### What 1 means here

This is [ADR-PRIN-EAC#1](../../principles/everything-as-code.md#rule-adr-prin-eac1): every artifact needed to build, test, deploy, or
operate the system lives in version control. The templates under `infrastructure/templates/`, the shared modules under
`infrastructure/modules/`, the configs under each template's `configuration/`, the repository-wide settings in `azure.yml`, `network.yml`,
and `customer.yml`, the pipelines under `pipelines/`, the automation under `automation/`, the tests beside it, and the ADRs that decide them
are all files in one repository. The build-validation policies are config too (`build-validation.yml`, applied by
`Sync-AdoBuildValidations`), and a pipeline is registered from its file by `Register-AdoPipeline`.

What stays outside is Azure DevOps state the pipelines depend on: the service connections (`sc-shared-nonprod`, `sc-apex-prod`, …), the
environments the deployment jobs name, and any check or approval on either. They are created in the Azure DevOps portal, which
[ADR-PRIN-EAC#3](../../principles/everything-as-code.md#rule-adr-prin-eac3) counts as configuration outside version control. The break-glass
SQL password is outside on purpose: it is a secret, and the repository holds only its Key Vault reference
([ADR-AZ-LZ#6](../landing-zones.md#rule-adr-az-lz6)).

##### 1 in `foundation`

Template, modules, and one config per subscription are code; its deploy jobs depend on service connections and environments created by hand.

##### 1 in `discovery`

As for `foundation`; its policy assignments, budget, and network are code too, read from `network.yml` and `azure.yml` by config address.

##### 1 in `expedition`

As for `foundation`; the secret its SQL server reads is put into `foundation`'s vault by hand, by design.

##### 1 status

Partly realised — everything that builds, tests, and deploys is code, while the service connections and Azure DevOps environments are
created outside the repository; declaring them as code is planned (follow-up).

### 2 — Keep every kind of code under version control

```text
CAF platform automation and DevOps — Automation, Platform automation design recommendation — recommendation 2
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/automation (retrieved 2026-10-15)
Summary (ours): Put infrastructure, policy, configuration, deployment, and documentation code under version control.
```

#### What 2 means here

Every one of those kinds is in the one Git repository ([ADR-PRIN-EAC#2](../../principles/everything-as-code.md#rule-adr-prin-eac2)), and the
history of each lives in Git, not in retained copies ([ADR-PRIN-ONELIVE#5](../../principles/one-living-version.md#rule-adr-prin-onelive5)).
Version control here is also the DORA capability [version-control](../../research/version-control.md). The recommendation bears on no single
template: all three are versioned the same way.

##### 2 status

Realised — infrastructure, policy, configuration, pipelines, and documentation are all versioned in one Git repository.

### 3 — Have a second person review every change

```text
CAF platform automation and DevOps — Automation, Platform automation design recommendation — recommendation 3
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/automation (retrieved 2026-10-15)
Summary (ours): Have every change reviewed by a second person, by pair programming or peer review, before it reaches production.
```

#### What 3 means here

How a change reaches `main` is a repository variant, `git_workspace`
([ADR-REPO-VARIANT#6](../../repository/repo-variants.md#rule-adr-repo-variant6)). In `main-via-pr` a pull request is the one authenticated
way into `main` ([ADR-DSGN-REMOTE#4](../../design/server-remote-integration.md#rule-adr-dsgn-remote4)), and it carries the blocking build
validations of `build-validation.yml`. Review is a gate the pull request can carry, but the repository configures no required-reviewer
policy, a gap [ADR-AZ-WAFOE#3](../waf/operational-excellence.md#rule-adr-az-wafoe3) records. This repository sets
`git_workspace: main-direct` in `variants.yml`, the single-author trunk, where a second reviewer does not exist; the four-eyes rule starts
to apply when the variant flips.

##### 3 in `foundation`

A change to it runs `ci-infrastructure.yaml` and the CD pipelines' builds as pull-request checks under `main-via-pr`; no reviewer is
required.

##### 3 in `discovery`

As for `foundation`. A change to a policy assignment or a peering reaches every workload of a subscription, so it is the template where a
second reviewer matters most.

##### 3 in `expedition`

As for `foundation`.

##### 3 status

Partly realised — pull-request ingress with blocking build validation exists for the `main-via-pr` variant, while a required-reviewer policy
is planned (follow-up).

### 4 — Protect important branches with policies

```text
CAF platform automation and DevOps — Automation, Platform automation design recommendation — recommendation 4
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/automation (retrieved 2026-10-15)
Summary (ours): Choose a branching strategy and protect the important branches with policies, so changes merge only through pull requests.
```

#### What 4 means here

The branching strategy is trunk-based development on `main` (see [22](#22--develop-on-a-single-trunk)). The policies on `main` that the
repository owns are the build validations: `build-validation.yml` binds each declared globset (`automation`, `infrastructure`, `shared`,
`nova`, `apex`, `flux`) to its pipeline as a blocking check, with the globset's native path projection as the filter
([ADR-FLOW-CD-GLOBS#6](../../flow/durable-sha-globs.md#rule-adr-flow-cd-globs6)), applied to the server by `Sync-AdoBuildValidations`. The
rule that `main` takes no direct push and admits merges only through a pull request is the server's branch protection
([ADR-DSGN-REMOTE#4](../../design/server-remote-integration.md#rule-adr-dsgn-remote4)), set in Azure DevOps, not in a file here.

##### 4 in `foundation`

Covered by the `infrastructure` validation (`ci-infrastructure.yaml`) and by the `shared` and customer validations, whose globsets compose
the template.

##### 4 in `discovery`

As for `foundation`.

##### 4 in `expedition`

As for `foundation`.

##### 4 status

Partly realised — the trunk and its build-validation policies are code, while the protection that forces every merge through a pull request
is a server setting outside the repository.

### 5 — Test and deploy through pipelines

```text
CAF platform automation and DevOps — Automation, Platform automation design recommendation — recommendation 5
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/automation (retrieved 2026-10-15)
Summary (ours): Automate testing and the deployment to each environment with continuous integration and continuous delivery.
```

#### What 5 means here

The repository's pipelines follow its types ([ADR-FLOW-CD-TYPE](../../flow/pipeline-types.md)) and layout
([ADR-PIPE-NAME](../../pipelines/pipeline-naming-and-placement.md)). `ci-infrastructure.yaml` is the CI pipeline: build and verify, no
deploy. Each CD pipeline runs the same CI engine ([ADR-FLOW-CD-TYPE#3](../../flow/pipeline-types.md#rule-adr-flow-cd-type3)), publishes one
artifact per template, and deploys those artifacts unchanged
([ADR-FLOW-CD#3](../../flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd3)); the customer CD structure is one extends template, the
sanctioned large-template case ([ADR-PIPE-TEMPLATE](../../pipelines/custom-template-discipline.md)). Every step calls automation through the
runner ([ADR-FLOW-CD-RUNNER#1](../../flow/pipeline-runner-pattern.md#rule-adr-flow-cd-runner1)), so a pipeline command can be run unchanged
on a devbox.

The gap is the direction CD takes. The flow model keeps CD within non-production and reaches production through a DEPLOY pipeline behind a
manual gate ([ADR-FLOW-CD#5](../../flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd5),
[ADR-FLOW-CD#6](../../flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd6)); the shipped CD pipelines deploy non-production and
production side by side in the same stage, and `pipelines/` holds no DEPLOY pipeline.
[ADR-AZ-WAFOE#6](../waf/operational-excellence.md#rule-adr-az-wafoe6) records the same gap; which way it closes — CD plus DEPLOY, or a CDe
with an internal approval ([ADR-FLOW-CD-TYPE#14](../../flow/pipeline-types.md#rule-adr-flow-cd-type14)) — is a per-unit governance choice
not made here.

##### 5 in `foundation`

The first deploy stage of every CD pipeline: `nsub` and `psub` deploy as two jobs of one stage.

##### 5 in `discovery`

The second deploy stage, after `foundation`; the hubs deploy from `cd-shared.yaml`, the spokes from the customer pipelines.

##### 5 in `expedition`

The last deploy stage, one job per configuration slot; for `apex`, `dev`, `dev-blu`, and `prod` deploy in the same stage.

##### 5 status

Partly realised — CI and build-once CD pipelines exist for every template, while production is reached in the same stage as non-production
instead of by promotion; the choice between DEPLOY and CDe is open.

### 6 — Automate provisioning and management

```text
CAF platform automation and DevOps — Automation, Platform automation design recommendation — recommendation 6
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/automation (retrieved 2026-10-15)
Summary (ours): Automate the provisioning, configuration, and management of the platform, and the provisioning of landing zone
  subscriptions.
```

#### What 6 means here

Everything inside a subscription is automated: `Deploy-Bicep` creates the resource group and deploys the template, and the pipelines run it
for every configuration slot. Routine work is a function, run the same way on a devbox and in a pipeline
([ADR-AZ-WAFOE#2](../waf/operational-excellence.md#rule-adr-az-wafoe2),
[ADR-AZ-WAFOE#10](../waf/operational-excellence.md#rule-adr-az-wafoe10)).

Creating the subscription is not. CAF's subscription vending page describes a request, an approval, and a pipeline that creates the
subscription, places it in a management group, and gives it a budget, a network, and identities. Here subscriptions are given: each is
declared in `azure.yml` with its customer, and the repository owns no management group ([ADR-AZ-LZ#1](../landing-zones.md#rule-adr-az-lz1)).
What follows is vending in all but the creation: the landing zone gives the subscription its network from `network.yml`, its policies, and
its budget. Adding a customer is a change of config files — `customer.yml`, `azure.yml`, `network.yml`, a config per template, a globset,
and a thin CD pipeline — reviewed like any other.

Two operations stay manual: the three-step rollout of a new spoke ([ADR-AZ-LZ#7](../landing-zones.md#rule-adr-az-lz7)), run by hand across
`cd-shared.yaml` and the customer's pipeline, and seeding the break-glass password into `foundation`'s vault before the first `expedition`
deploy.

##### 6 in `foundation`

Fully automated, apart from the secret its vault must hold for `expedition`.

##### 6 in `discovery`

Automated per subscription; adding a spoke needs the hub deployed again by hand after the spoke, in the order ADR-AZ-LZ#7 fixes.

##### 6 in `expedition`

Fully automated; a second deployment beside a base slot is a special slot, which is one config file.

##### 6 status

Partly realised — every subscription's contents are provisioned by automation, while creating a subscription is not adopted, because the
repository is given its subscriptions; encoding the spoke rollout and the secret seeding is planned (follow-up).

### 7 — Start from a landing zone accelerator

```text
CAF platform automation and DevOps — Automation, Platform automation design recommendation — recommendation 7
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/automation (retrieved 2026-10-15)
Summary (ours): Begin with the landing zone accelerator that suits the team's maturity.
```

#### What 7 means here

Microsoft's accelerators deploy a platform landing zone with management groups, central connectivity, and policy across the tenant. The
repository deploys into subscriptions it is given and owns nothing above them ([ADR-AZ-LZ#1](../landing-zones.md#rule-adr-az-lz1)), so an
accelerator's core assumptions do not hold. Its templates are its own, written to its naming standard, data model, and module conventions,
and its sibling ADR on security reaches the same verdict for the accelerators' Zero Trust variants
([ADR-AZ-CAFSEC](landing-zone-security.md)). An accelerator would apply to a repository that owns a tenant's platform.

##### 7 status

Not adopted, because the accelerators assume management groups and a platform the repository does not own.

### 8 — Add your own automation on top of the starting point

```text
CAF platform automation and DevOps — Automation, Platform automation design recommendation — recommendation 8
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/automation (retrieved 2026-10-15)
Summary (ours): Plan to deploy in stages, adding your own automation over the accelerator for what it does not cover.
```

#### What 8 means here

There is no accelerator to build on, but the staged approach is how the templates are arranged: each template is one rate of change, and
each is deployed on top of the one before ([ADR-AZ-WAFOE#5](../waf/operational-excellence.md#rule-adr-az-wafoe5)). `foundation` is the base
every subscription receives, `discovery` the landing zone over it, and `expedition` a workload in that. The CD pipelines encode the order
with stage dependencies, so a template never deploys before what it builds on.

##### 8 in `foundation`

The base: the workspace every diagnostic setting writes to and the vault every Key Vault reference reads from.

##### 8 in `discovery`

Over `foundation`: it sends the activity log to `foundation`'s workspace and adds the network, the policies, and the budget.

##### 8 in `expedition`

Over `discovery`: it lands in the spoke's `private-endpoints` subnet and reads its secret from `foundation`'s vault.

##### 8 status

Realised — three templates deployed in a fixed order, with the repository's own `foundation` as the base an accelerator would otherwise
provide.

### 9 — Make quick fixes in code too

```text
CAF platform automation and DevOps — Automation, Platform automation design recommendation — recommendation 9
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/automation (retrieved 2026-10-15)
Summary (ours): Make emergency fixes through code as well, and record each in the backlog so it is reworked properly and debt stays small.
```

#### What 9 means here

A fix is a commit like any other: it reaches `main`, the globset of the unit it touches starts that unit's CD pipeline, and the pipeline
deploys it. Configuration that reaches the cloud enters only through version control
([ADR-FLOW-CD-TYPE#6](../../flow/pipeline-types.md#rule-adr-flow-cd-type6)), and a red pipeline stops the line until it is fixed
([ADR-PROC-ANDON](../../process/holding-the-line.md)). Nothing stops a person with rights from changing a resource in the portal, though:
outside the three policies, drift is caught only when the next deploy overwrites it. There is no written emergency-change procedure, a gap
[ADR-AZ-WAFOE#2](../waf/operational-excellence.md#rule-adr-az-wafoe2) records, and no convention for logging a quick fix's follow-up.

##### 9 in `foundation`

Fixed and redeployed like any change; its two resources rarely need an urgent fix.

##### 9 in `discovery`

A fix to a network rule or a policy deploys to every subscription the unit's pipeline covers, production included, in one run.

##### 9 in `expedition`

A fix can land first in a special slot (`dev-blu`) and then in the base slots, each a config of its own.

##### 9 status

Partly realised — every fix is a commit deployed by the pipelines, while an emergency-change procedure and the follow-up record are planned
(follow-up).

### 10 — Manage Azure Policy as code

```text
CAF platform automation and DevOps — Automation, Platform automation design recommendation — recommendation 10
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/automation (retrieved 2026-10-15)
Summary (ours): Deploy and manage Azure Policy with infrastructure as code.
```

#### What 10 means here

The landing zone's policies are Bicep: `discovery/main.bicep` holds the three built-in definition ids, their parameters, and their
non-compliance messages, and assigns them through `infrastructure/modules/policy-assignment.bicep`
([ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3)). Whether they enforce is `policy_enforcement` in `azure.yml`, read by config address
([ADR-AZ-DATAMOD#11](../azure-data-model.md#rule-adr-az-datamod11)). Each definition id is registered in `guids.yml`, and changing one is a
single reviewed change ([ADR-AZ-CAFGOV#6](governance.md#rule-adr-az-cafgov6)).

##### 10 in `foundation`

Not applicable: it assigns no policy.

##### 10 in `discovery`

Assigns the three policies at subscription scope, deployed by the landing zone's pipeline stage like every other resource.

##### 10 in `expedition`

Not applicable: a workload assigns no policy ([ADR-AZ-LZ#4](../landing-zones.md#rule-adr-az-lz4)).

##### 10 status

Realised — every policy assignment is Bicep in `discovery`, with its definition pinned by id and its enforcement mode in config.

### 11 — Offer a way to request a policy exemption

```text
CAF platform automation and DevOps — Automation, Platform automation design recommendation — recommendation 11
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/automation (retrieved 2026-10-15)
Summary (ours): Give workload teams a process to request a policy exemption, so a policy does not leave them stuck.
```

#### What 11 means here

The landing zone carries no exemption and no exclusion ([ADR-AZ-CAFGOV#4](governance.md#rule-adr-az-cafgov4)), and a workload owns no policy
([ADR-AZ-LZ#4](../landing-zones.md#rule-adr-az-lz4)). The three policies are narrow — region, a cost tag, no public IP address on a network
interface — and a team that needs something they forbid proposes a change to `discovery` or its config through review, so the outcome is
versioned like everything else. Outside production the policies audit rather than deny, so a team is never blocked there. An exemption would
be a Bicep `Microsoft.Authorization/policyExemptions` resource in `discovery` when the need arises; a process around it belongs to the
operating organisation.

##### 11 in `foundation`

Not applicable: it assigns no policy.

##### 11 in `discovery`

Makes no exemption; it is where one would be declared, as code.

##### 11 in `expedition`

Not applicable: a workload that needs an exemption asks for it in the landing zone.

##### 11 status

Not adopted, because the landing zone makes no exemption; a change to a policy is a reviewed change to the landing zone.

### 12 — Block non-compliant deployments instead of fixing them

```text
CAF platform automation and DevOps — Automation, Platform automation design recommendation — recommendation 12
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/automation (retrieved 2026-10-15)
Summary (ours): Stop a non-compliant deployment with a deny policy rather than correcting it quietly at deploy time, so the code and what is
  deployed do not drift apart; the considerations name modify effects as the risk.
```

#### What 12 means here

The landing zone's policies use deny effects where they enforce and report where they audit
([ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3)); none uses a modify, append, or deploy-if-not-exists effect. The activity log's
diagnostic setting, which a deploy-if-not-exists policy could create, is a resource in the template instead, so it exists exactly when the
deploy succeeds. Tags are written by every template from its config rather than filled in by policy
([ADR-AZ-CAFGOV#1](governance.md#rule-adr-az-cafgov1)), so the code is always the full description of what is deployed.

##### 12 in `foundation`

Writes its CAF tags itself, so it passes the required-tag policy without a modify effect.

##### 12 in `discovery`

Assigns the three deny-effect policies, enforcing in `psub` and auditing in `nsub` by `policy_enforcement`.

##### 12 in `expedition`

Writes its CAF tags itself; a resource that broke a policy would fail its production deploy rather than be altered.

##### 12 status

Realised — deny effects block a non-compliant resource in production, and no policy changes a resource after it is deployed.

### 13 — Build on existing DevOps frameworks

```text
CAF platform automation and DevOps — DevOps considerations, DevOps recommendations: Define your DevOps framework — recommendation 13
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/devops-principles-and-practices (retrieved 2026-10-15)
Summary (ours): Start from available frameworks — the Microsoft DevOps Resource Center and the DevOps Dojo taxonomy — rather than inventing
  one.
```

#### What 13 means here

The repository's DevOps framework is its own flow model ([ADR-FLOW-CD](../../flow/cd-discipline-and-promotion-flow.md)), its process rules,
and the DORA research, which it cites through [the DORA reference](../../../references/dora/index.md). DORA is research rather than a
vendor's taxonomy, and the repository's rules are argued from it. Microsoft's material is reviewed item by item where it bears on Azure, as
in this ADR and the WAF reviews, not adopted as the framework.

##### 13 status

Not adopted, because the repository's framework is its own flow model grounded in DORA's research.

### 14 — Adopt the landing zone DevOps practices

```text
CAF platform automation and DevOps — DevOps considerations, DevOps recommendations: Define DevOps practices — recommendation 14
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/devops-principles-and-practices (retrieved 2026-10-15)
Summary (ours): For the landing zone's management, follow the pages on its development lifecycle and on DevOps security.
```

#### What 14 means here

The development lifecycle page is recommendations 18 to 35 of this ADR, each reviewed against the repository. The DevOps security page has
no recommendations section; its guidance on pipeline identities and secrets is weighed in
[30](#30--give-pipeline-connections-only-the-access-they-need) and [31](#31--take-pipeline-secrets-from-key-vault).

##### 14 status

Realised — both pages are reviewed here, the first as rules, the second as context for the pipeline identity rules.

### 15 — Plan the DevOps journey in steps

```text
CAF platform automation and DevOps — DevOps considerations, DevOps recommendations: Plan your DevOps implementation journey — recommendation 15
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/devops-principles-and-practices (retrieved 2026-10-15)
Summary (ours): Assess current practices, team structure, and operating model, define the target from the adoption plan, and get there by an
  incremental roadmap.
```

#### What 15 means here

The repository improves continuously and from evidence: gate results, flow measures, and incidents, read off the real system
([ADR-PROC-KAIZEN#2](../../process/inspect-and-adapt.md#rule-adr-proc-kaizen2)). Its plans are files under `out/` for a specific change, not
a maturity roadmap, and team structure and operating model belong to the organisation that runs the repository.

##### 15 status

Not adopted, because improvement here is continuous and evidence-led rather than an assessed, staged roadmap.

### 16 — Measure delivery with chosen metrics

```text
CAF platform automation and DevOps — DevOps considerations, DevOps recommendations: Implement desired DevOps metrics — recommendation 16
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/devops-principles-and-practices (retrieved 2026-10-15)
Summary (ours): Pick visible, outcome-oriented metrics for business outcomes, software delivery performance (the four DORA metrics), and
  quality.
```

#### What 16 means here

The delivery metrics are DORA's ([metrics](../../../references/dora/metrics.md)):
[change lead time](../../../references/dora/metrics.md#change-lead-time),
[deployment frequency](../../../references/dora/metrics.md#deployment-frequency),
[failed deployment recovery time](../../../references/dora/metrics.md#failed-deployment-recovery-time), and
[change fail rate](../../../references/dora/metrics.md#change-fail-rate). The pipelines carry what they need — each deploy tags its target
with the commit, the build, and the branch (`Set-BicepTrackingTagSet`) — but no function or pipeline collects and reports them. Business and
quality metrics belong to the operating organisation.

##### 16 status

Partly realised — the DORA metrics are the chosen measures, while collecting them from the pipelines is planned (follow-up).

### 17 — Choose the toolchain deliberately

```text
CAF platform automation and DevOps — DevOps considerations, DevOps recommendations: Define your DevOps technology ecosystem — recommendation 17
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/devops-principles-and-practices (retrieved 2026-10-15)
Summary (ours): Choose tools per DevOps activity, balancing team fit against standardisation; the toolchain shapes practices, security, and
  the landing zone lifecycle.
```

#### What 17 means here

The toolchain is one decision per tool, pinned to a version in `tools.yml` and installed by the same installer on a devbox and in a pipeline
([ADR-AUTO-DEPS#1](../../automation/controlling-systemwide-deps.md#rule-adr-auto-deps1)): Git, Bicep, the az CLI
([ADR-AZ-CLI](../prefer-az-cli.md)), PowerShell with Pester and PSScriptAnalyzer, Azure DevOps Pipelines for the infrastructure, and GitHub
Actions for the automation's own CI and release. The choices with lasting consequences are ADRs — the az CLI over Azure PowerShell, proper
package managers ([ADR-AUTO-PKGMGR](../../automation/use-proper-package-managers.md)) — so they are reviewed and versioned like the code.

##### 17 status

Realised — each tool is chosen once, pinned, and installed the same way everywhere.

### 18 — Use Git

```text
CAF platform automation and DevOps — Development lifecycle, Repository strategy: Design recommendations — recommendation 18
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/development-strategy-development-lifecycle (retrieved 2026-10-15)
Summary (ours): Use Git for version control.
```

#### What 18 means here

The repository is a Git repository, and its automation reads Git directly: a deployable-unit's change is computed from `git diff` at real
refs ([ADR-FLOW-CD-GLOBS#9](../../flow/durable-sha-globs.md#rule-adr-flow-cd-globs9)), and a globset selects from `git ls-files`
([ADR-FLOW-CD-GLOBS#4](../../flow/durable-sha-globs.md#rule-adr-flow-cd-globs4)).

##### 18 status

Realised — Git is the version control system, and the delivery automation depends on it.

### 19 — Keep landing zone code in private repositories

```text
CAF platform automation and DevOps — Development lifecycle, Repository strategy: Design recommendations — recommendation 19
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/development-strategy-development-lifecycle (retrieved 2026-10-15)
Summary (ours): Keep the code of Azure landing zones in private repositories.
```

#### What 19 means here

Whether a repository is private is a setting of its server remote, which the repository does not hold. What the repository does decide is
that nothing in it needs hiding for security: it holds no secret ([ADR-AZ-WAFSE#9](../waf/security.md#rule-adr-az-wafse9)), and the shipped
`azure.yml` carries placeholder subscription ids. A repository that fills in a real tenant's subscriptions, address plan, and customers
holds information an organisation would usually keep private, and its owner sets the remote accordingly.

##### 19 status

Not adopted, because repository visibility is a setting of the server remote, outside the repository.

### 20 — Share only nonconfidential material in public repositories

```text
CAF platform automation and DevOps — Development lifecycle, Repository strategy: Design recommendations — recommendation 20
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/development-strategy-development-lifecycle (retrieved 2026-10-15)
Summary (ours): Use public repositories only for material that is not confidential: samples, documentation, and openly licensed code.
```

#### What 20 means here

What the repository publishes is the catzc package, built by `Export-Catzc` and released by a manually started GitHub workflow
([ADR-GH-RELEASE#1](../../github/github-release.md#rule-adr-gh-release1)). It carries the built automation modules, not the
`infrastructure/` templates and the configuration tree that describe a tenant's subscriptions.

##### 20 status

Realised — the only material published outward is the built automation package, by a deliberate manual release.

### 21 — Deploy and govern through infrastructure as code

```text
CAF platform automation and DevOps — Development lifecycle, Repository strategy: Design recommendations — recommendation 21
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/development-strategy-development-lifecycle (retrieved 2026-10-15)
Summary (ours): Deploy, manage, and govern cloud resources through infrastructure as code.
```

#### What 21 means here

All Azure infrastructure is declarative Bicep: one parameterised template per rate of change, shared modules under
`infrastructure/modules/`, and one config per configuration slot ([ADR-AZ-WAFOE#5](../waf/operational-excellence.md#rule-adr-az-wafoe5),
[ADR-AZ-DATAMOD#2](../azure-data-model.md#rule-adr-az-datamod2)). `Build-Bicep` compiles the template and renders a parameters file per
slot, `Assert-BicepTemplate` validates the template and its configs, and `Deploy-Bicep` deploys the built artifact into an asserted
subscription. Governance is code too: policies (see [10](#10--manage-azure-policy-as-code)), budgets, and tags. The gaps ADR-AZ-WAFOE#5
records apply here: no scan of the compiled templates for misconfiguration, and a resource removed from a template stays in Azure, because
the deploys are incremental.

##### 21 in `foundation`

The workspace and the vault from two shared modules, with a short config per subscription.

##### 21 in `discovery`

The network, peerings, DNS zones, policy assignments, and budget from shared modules; ranges come from `network.yml` by config address.

##### 21 in `expedition`

Storage, SQL, and private endpoints from shared modules; what varies by environment class is config, and the secure defaults are module
defaults.

##### 21 status

Realised — every resource is declared in Bicep and deployed by `Deploy-Bicep` from a pipeline; a misconfiguration scan and the removal of
deleted resources are tracked under ADR-AZ-WAFOE#5.

### 22 — Develop on a single trunk

```text
CAF platform automation and DevOps — Development lifecycle, Branch strategy: Design recommendations — recommendation 22
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/development-strategy-development-lifecycle (retrieved 2026-10-15)
Summary (ours): Use trunk-based development: everyone integrates into one branch and resolves conflicts as they commit.
```

#### What 22 means here

Trunk-based development is a rule here, not a preference: work integrates continuously into `main`, branches are short-lived, and there is
no long-lived release or version branch ([ADR-PRIN-ONELIVE#4](../../principles/one-living-version.md#rule-adr-prin-onelive4),
[ADR-FLOW-CD#1](../../flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd1)). It is also the DORA capability
[trunk-based-development](../../research/trunk-based-development.md). Every pipeline triggers on `main` only.

##### 22 status

Realised — `main` is the one trunk, and every CI and CD pipeline runs on it.

### 23 — Name branches consistently

```text
CAF platform automation and DevOps — Development lifecycle, Branch strategy: Design recommendations — recommendation 23
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/development-strategy-development-lifecycle (retrieved 2026-10-15)
Summary (ours): Agree branch naming conventions that show what kind of work a branch holds.
```

#### What 23 means here

A branch here lives for one change and merges back quickly (see [22](#22--develop-on-a-single-trunk)); no automation reads its name, and the
pull request carries the description of the work. A convention would cost a check and add little while branches stay that short.

##### 23 status

Not adopted, because branches are short-lived and nothing reads their names.

### 24 — Control who can read and write each branch

```text
CAF platform automation and DevOps — Development lifecycle, Branch strategy: Design recommendations — recommendation 24
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/development-strategy-development-lifecycle (retrieved 2026-10-15)
Summary (ours): Set read and write permissions per branch for users and groups.
```

#### What 24 means here

Branch permissions are held by the server remote. The repository's model needs one of them: `main` is protected and reached only through a
pull request in the `main-via-pr` variant ([ADR-DSGN-REMOTE#4](../../design/server-remote-integration.md#rule-adr-dsgn-remote4)). Finer
permissions per user or group belong to whoever administers the Azure DevOps project.

##### 24 status

Not adopted, because branch permissions are a server setting; the repository relies on the protected `main` alone.

### 25 — Set branch policies on the main branch

```text
CAF platform automation and DevOps — Development lifecycle, Branch strategy: Design recommendations — recommendation 25
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/development-strategy-development-lifecycle (retrieved 2026-10-15)
Summary (ours): Protect main with branch policies: pull requests required, a minimum number of reviewers, approvals reset on new changes,
  reviewers added automatically, and comments resolved before merge.
```

#### What 25 means here

Of these, the repository configures one kind as code: blocking build validation, one per declared globset, in `build-validation.yml` (see
[4](#4--protect-important-branches-with-policies)). Minimum reviewers, vote reset, automatic reviewers, and comment resolution are branch
policies Azure DevOps supports that nothing in the repository declares, and the drift check `Test-AdoPipelineTriggerGlob` covers only
triggers. Declaring them in the same config, applied by the same function, would make them code as well
([ADR-AZ-WAFOE#3](../waf/operational-excellence.md#rule-adr-az-wafoe3) plans the reviewer policy).

##### 25 in `foundation`

Validated by the `infrastructure`, `shared`, and customer build validations.

##### 25 in `discovery`

As for `foundation`.

##### 25 in `expedition`

As for `foundation`.

##### 25 status

Partly realised — blocking build validation per globset is code, while reviewer, vote-reset, and comment policies are planned (follow-up).

### 26 — Merge pull requests by squashing

```text
CAF platform automation and DevOps — Development lifecycle, Branch strategy: Design recommendations — recommendation 26
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/development-strategy-development-lifecycle (retrieved 2026-10-15)
Summary (ours): Squash-merge pull requests so each lands on the default branch as one commit.
```

#### What 26 means here

The delivery design depends on it. `main` advances only by squash merge, so a merged commit's first parent is the prior mainline, and
`Get-GlobSetChangeRange` diffs `HEAD^1..HEAD` to find exactly what a merge changed
([ADR-FLOW-CD-GLOBS#9](../../flow/durable-sha-globs.md#rule-adr-flow-cd-globs9)); `Test-GlobSetAffected` fails open on doubt, so a different
merge type would start a pipeline rather than skip one. The merge type is a branch policy, though, and nothing in the repository sets it; it
belongs beside the build validations (see [25](#25--set-branch-policies-on-the-main-branch)).

##### 26 status

Partly realised — the delivery design assumes squash merges and its change detection is built on them, while a merge-type policy as code is
planned (follow-up).

### 27 — Build and test every commit

```text
CAF platform automation and DevOps — Development lifecycle, Automated builds: Design recommendations — recommendation 27
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/development-strategy-development-lifecycle (retrieved 2026-10-15)
Summary (ours): Use continuous integration so every commit is built and tested automatically.
```

#### What 27 means here

`ci-infrastructure.yaml` triggers on every change under `infrastructure/`, as a pull-request build validation and again on the merged
commit, and runs the CI engine for all three templates inside the integration budget
([ADR-FLOW-CD#2](../../flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd2)). Each CD pipeline runs the same engine before it deploys
([ADR-FLOW-CD#4](../../flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd4)). The triggers are generated from the globsets and kept
equal to them by `Test-AdoPipelineTriggerGlob` ([ADR-FLOW-CD-GLOBS#6](../../flow/durable-sha-globs.md#rule-adr-flow-cd-globs6)).

##### 27 in `foundation`

`Assert-BicepTemplate foundation` and `Build-Bicep foundation` on every change.

##### 27 in `discovery`

`Assert-BicepTemplate discovery` and `Build-Bicep discovery` on every change.

##### 27 in `expedition`

`Assert-BicepTemplate expedition` and `Build-Bicep expedition` on every change, then the infrastructure test suite.

##### 27 status

Realised — every infrastructure change is built and tested before and after it merges.

### 28 — Unit-test infrastructure code as well

```text
CAF platform automation and DevOps — Development lifecycle, Automated builds: Design recommendations — recommendation 28
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/development-strategy-development-lifecycle (retrieved 2026-10-15)
Summary (ours): Include unit tests for both infrastructure code and application code in the build.
```

#### What 28 means here

The infrastructure's build tests are tiered by [ADR-AUTO-TEST](../../automation/test-automation.md). `Assert-BicepTemplate` checks
`options.yml`, the classification of each config, its identity references, and its parameter alignment; `Build-Bicep` compiles the template,
renders every parameters file, and fails a config left `UNDEFINED`; and `Test-Automation -Suite infrastructure` runs the L2 test that checks
every rendered parameters file against the compiled parameter model ([ADR-AZ-DATAMOD#9](../azure-data-model.md#rule-adr-az-datamod9)). The
automation that builds and deploys is itself unit-tested at L0 and L1.

Two kinds of testing are missing ([ADR-AZ-WAFOE#4](../waf/operational-excellence.md#rule-adr-az-wafoe4),
[ADR-AZ-WAFOE#9](../waf/operational-excellence.md#rule-adr-az-wafoe9)). The Bicep linter runs at its default levels and a warning does not
fail the build. And no L3 system test deploys a template and checks the result
([ADR-AUTO-TEST#33](../../automation/test-automation.md#rule-adr-auto-test33)); CAF's test-driven development page suggests policy
compliance and resource queries as exactly those checks.

##### 28 in `foundation`

Built and checked against its parameter model; a system test would check the workspace and the vault with their tags.

##### 28 in `discovery`

Built and checked, and its network plan checked by `Test-AzureNetworkPlan`; a system test would check peerings, zone links, and policy
compliance.

##### 28 in `expedition`

Built and checked; the special slot `dev-blu` is the natural target of a system test.

##### 28 status

Partly realised — every template is validated, compiled, and checked in the build, while the linter as a quality gate and system tests are
planned (follow-up).

### 29 — Prefer Microsoft-hosted build agents

```text
CAF platform automation and DevOps — Development lifecycle, Automated builds: Design recommendations — recommendation 29
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/development-strategy-development-lifecycle (retrieved 2026-10-15)
Summary (ours): Prefer Microsoft-hosted agents over self-hosted ones, for an isolated, fresh machine on every run.
```

#### What 29 means here

Every job and deployment job of every pipeline uses `vmImage: ubuntu-latest`, a Microsoft-hosted agent. A fresh agent fits the repository's
own rule that a pipeline behaves like a devbox ([ADR-AUTO-PARITY](../../automation/devbox-pipeline-parity.md)): the runner imports the
module system on every run ([ADR-FLOW-CD-RUNNER#2](../../flow/pipeline-runner-pattern.md#rule-adr-flow-cd-runner2)), and the pinned tools
install the same way on a devbox and in a pipeline ([ADR-AUTO-DEPS#1](../../automation/controlling-systemwide-deps.md#rule-adr-auto-deps1)),
so nothing depends on a machine kept between runs. A self-hosted agent would become necessary once the deploy targets accept only private
network traffic.

##### 29 in `foundation`

Built and deployed on Microsoft-hosted agents.

##### 29 in `discovery`

As for `foundation`.

##### 29 in `expedition`

As for `foundation`.

##### 29 status

Realised — every job runs on a Microsoft-hosted agent.

### 30 — Give pipeline connections only the access they need

```text
CAF platform automation and DevOps — Development lifecycle, Automated builds: Design recommendations — recommendation 30
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/development-strategy-development-lifecycle (retrieved 2026-10-15)
Summary (ours): When pipelines connect to Azure through service connections or stored secrets, limit each connection to the resources it
  needs.
```

#### What 30 means here

Each deploy runs through the service connection of its own subscription: `sc-<owner>-nonprod` for the non-production subscription and
`sc-<owner>-prod` for production, per customer and for the shared platform. Every deploy pins the subscription with
`-SubscriptionIdAssertIs`, so a wrongly wired connection fails instead of deploying elsewhere
([ADR-AZ-SESSION#5](../az-session-verification.md#rule-adr-az-session5), [ADR-AZ-DATAMOD#7](../azure-data-model.md#rule-adr-az-datamod7)).
The CI build needs no Azure sign-in at all, because `az bicep build` is offline. Reaching another customer's subscription therefore needs
another connection, which the pipeline does not name.

The DevOps security page asks for more, and the repository does not show it. How a service connection signs in — workload identity
federation or a stored secret — is set where the connection is created, outside the repository, and nothing here records it. The identity is
one per subscription, shared by all three templates and every environment the subscription serves (`nsub`, `dev`, `test`), not one per
template and environment. There is no separate read-only identity for previews, because the pipelines run none (see
[34](#34--preview-each-deployment-before-it-runs)). And the rights each connection holds, and any approval on it, are granted outside the
repository.

##### 30 in `foundation`

Deployed by the subscription's connection, which needs rights to create its resource group, workspace, and vault.

##### 30 in `discovery`

Deployed at subscription scope, so its connection needs subscription-level rights, including policy assignment and peering.

##### 30 in `expedition`

Deployed by the same connection as `discovery`, although it needs far less: its own resource groups, plus what joining the spoke's subnet
and registering in the hub's DNS zones requires.

##### 30 status

Partly realised — one connection per subscription, asserted on every deploy, while federated sign-in, an identity per template and
environment, and a read-only preview identity are planned (follow-up).

### 31 — Take pipeline secrets from Key Vault

```text
CAF platform automation and DevOps — Development lifecycle, Automated builds: Design recommendations — recommendation 31
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/development-strategy-development-lifecycle (retrieved 2026-10-15)
Summary (ours): Pull credentials, certificates, and keys from Key Vault into pipeline variables instead of writing them into code.
```

#### What 31 means here

The pipelines hold no secret at all. The one secret a deploy needs, the break-glass SQL password, is a Key Vault reference in the
`expedition` config, which Azure Resource Manager resolves at deploy time from `foundation`'s vault
([ADR-AZ-LZ#6](../landing-zones.md#rule-adr-az-lz6), [ADR-AZ-WAFSE#9](../waf/security.md#rule-adr-az-wafse9)); it never passes through a
pipeline variable. A `secureString` parameter must be such a reference, never a literal, or the build fails
([ADR-AZ-DATAMOD#9](../azure-data-model.md#rule-adr-az-datamod9)). The Azure DevOps access token reaches a step only when its template asks
for it ([ADR-PIPE-AUTH#6](../../pipelines/dual-authentication.md#rule-adr-pipe-auth6)), and pipeline variables never carry script
configuration ([ADR-PIPE-TEMPLATE#6](../../pipelines/custom-template-discipline.md#rule-adr-pipe-template6)). What is missing is a secret
scan of every change, which [ADR-AZ-WAFOE#3](../waf/operational-excellence.md#rule-adr-az-wafoe3) plans.

##### 31 in `foundation`

Holds the vault the secret lives in; seeding the secret is a manual step (see [6](#6--automate-provisioning-and-management)).

##### 31 in `discovery`

Not applicable: it takes no secret.

##### 31 in `expedition`

Reads `exped-sql-admin-password` from the vault of its own subscription by reference, in every config that deploys a SQL server.

##### 31 status

Realised — no secret is in code or in a pipeline, and the one deploy-time secret comes from Key Vault; a secret scan is tracked under
ADR-AZ-WAFOE#3.

### 32 — Keep the code always deployable

```text
CAF platform automation and DevOps — Development lifecycle, Deployment strategy: Design recommendations — recommendation 32
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/development-strategy-development-lifecycle (retrieved 2026-10-15)
Summary (ours): Deliver continuously to production-like environments, so the code is always ready to deploy and defects show early.
```

#### What 32 means here

Every merge to `main` that touches a deployable-unit starts its CD pipeline, which deploys the build-once artifact to that unit's
non-production subscriptions on the same run ([ADR-FLOW-CD#3](../../flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd3)). The shared
non-production configs (`dev`, `test`) and a customer's `dev` are production-like in shape: the same template, the same modules, a different
environment class. The flow model asks for more before an artifact counts as integrated: a deploy to an on-demand environment with L3 system
tests, then the always-on non-production environment ([ADR-FLOW-CD#5](../../flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd5),
[ADR-FLOW-CD#8](../../flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd8)); the pipelines have no on-demand environment and no
system test.

##### 32 in `foundation`

Deployed to `nsub` on every relevant merge.

##### 32 in `discovery`

Deployed to the `nsub` hub or spoke on every relevant merge.

##### 32 in `expedition`

Deployed to `dev` and `test` for the shared platform, and to `dev` and `dev-blu` for `apex`, on every relevant merge.

##### 32 status

Partly realised — every merge deploys to non-production, while on-demand environments with system tests are planned (follow-up).

### 33 — Deploy through pipeline environments

```text
CAF platform automation and DevOps — Development lifecycle, Deployment strategy: Design recommendations — recommendation 33
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/development-strategy-development-lifecycle (retrieved 2026-10-15)
Summary (ours): Use pipeline environments for deployment history, traceability to commits and work items, resource health, and security.
```

#### What 33 means here

Every deploy is a deployment job that names an Azure DevOps environment after its target: `shared-nsub`, `shared-psub`, `shared-dev`, and
`shared-test` in `cd-shared.yaml`, and `<customer>-<env>` or `<customer>-<env>-<slot>` in `cd-customer.yaml`. Each environment therefore
holds the deployment history of its target. Deploys also tag their target with the commit, the build, and the branch, so the resource itself
traces back to its code ([ADR-AZ-WAFOE#3](../waf/operational-excellence.md#rule-adr-az-wafoe3)).

CAF's environments page asks for at least one test environment, separate identities for test and production, and automated checks before
each environment. The first two hold: every unit has non-production configs, and non-production and production use different service
connections. The third does not: no check or approval is declared on any environment, and the repository holds no description of them.
Production approvals are where DEPLOY or a CDe approval gate would sit (see [5](#5--test-and-deploy-through-pipelines)).

##### 33 in `foundation`

Deploys into `shared-nsub` and `shared-psub`, or `<customer>-nsub` and `<customer>-psub`, environments it shares with `discovery`.

##### 33 in `discovery`

As for `foundation`; one environment per subscription holds both templates' history.

##### 33 in `expedition`

One environment per configuration slot, for example `apex-dev-blu`.

##### 33 status

Partly realised — every deploy runs in a named environment with its history, while checks and approvals on the environments are planned
(follow-up).

### 34 — Preview each deployment before it runs

```text
CAF platform automation and DevOps — Development lifecycle, Deployment strategy: Design recommendations — recommendation 34
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/development-strategy-development-lifecycle (retrieved 2026-10-15)
Summary (ours): Before deploying infrastructure code, preview what it will create, change, and delete (what-if or plan).
```

#### What 34 means here

`Deploy-Bicep -DryRun` runs Azure's server-side what-if preview and stops before the deploy
([ADR-AUTO-DRYRUN](../../automation/dry-run.md)), so the preview exists and runs the same way on a devbox. The pipelines do not call it:
each deploy job runs `Deploy-Bicep` directly, a gap [ADR-AZ-WAFOE#11](../waf/operational-excellence.md#rule-adr-az-wafoe11) records. A
preview in the pipeline would run under its own read-only identity, as the DevOps security page suggests (see
[30](#30--give-pipeline-connections-only-the-access-they-need)).

##### 34 in `foundation`

Previewable with `-DryRun`; previewed by no pipeline.

##### 34 in `discovery`

The template where a preview matters most: a change to peering, routing, or a policy reaches every workload of a subscription.

##### 34 in `expedition`

Previewable per configuration slot; previewed by no pipeline.

##### 34 status

Partly realised — the what-if preview is one switch on `Deploy-Bicep`, while running it before every pipeline deploy is planned (follow-up).

### 35 — Roll back with Git

```text
CAF platform automation and DevOps — Development lifecycle, Rollback strategy: Design recommendations — recommendation 35
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/development-strategy-development-lifecycle (retrieved 2026-10-15)
Summary (ours): Roll back by Git's undo operations: revert, discard, or reset.
```

#### What 35 means here

On the shared trunk the undo is a revert: a new commit that the same CI and CD pipelines build and deploy, so a rollback is tested like any
change. Resetting `main` is not used, because history lives in Git and the trunk is never rewritten
([ADR-PRIN-ONELIVE#5](../../principles/one-living-version.md#rule-adr-prin-onelive5)). The flow model's faster path is to deploy the
artifact of the commit before ([ADR-FLOW-CD-TYPE#10](../../flow/pipeline-types.md#rule-adr-flow-cd-type10)), which needs the DEPLOY pipeline
the repository does not have. And a revert that removes a resource from a template leaves it in Azure, because deploys are incremental
([ADR-AZ-WAFOE#5](../waf/operational-excellence.md#rule-adr-az-wafoe5)).

##### 35 in `foundation`

A revert redeploys the previous template and configs; its resources are rarely removed.

##### 35 in `discovery`

A revert of a policy or peering change is undone on the next deploy; a removed subnet or zone link stays until deleted.

##### 35 in `expedition`

A revert redeploys each slot; a resource dropped from the template stays in the resource group.

##### 35 status

Partly realised — a rollback is a revert deployed by the pipelines, while redeploying an earlier artifact and removing what a template no
longer declares are planned (follow-up).

### 36 — An all Azure DevOps toolchain

```text
CAF platform automation and DevOps — DevOps toolchain, DevOps toolchain recommendations for Azure Landing Zones — recommendation 36
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/devops-toolchain (retrieved 2026-10-15)
Summary (ours): A toolchain covers planning, CI and CD with infrastructure as code, operations, and collaboration; the first option is Azure
  DevOps for all of it, for organisations deep in Microsoft's ecosystem.
```

#### What 36 means here

The infrastructure's pipelines are Azure DevOps Pipelines, and the repository automates Azure DevOps through its own modules
(`Catzc.Azure.DevOps`, `Catzc.Azure.DevOps.BuildValidation`). Planning, boards, and collaboration tools are the operating organisation's
choice; nothing in the repository depends on one.

##### 36 status

Partly realised — CI and CD run on Azure DevOps, while planning and collaboration tools are left to the organisation.

### 37 — A combined Azure DevOps and GitHub toolchain

```text
CAF platform automation and DevOps — DevOps toolchain, DevOps toolchain recommendations for Azure Landing Zones — recommendation 37
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/devops-toolchain (retrieved 2026-10-15)
Summary (ours): The second option combines Azure DevOps and GitHub, to use the strengths of each.
```

#### What 37 means here

The repository uses both: Azure DevOps Pipelines deploy the infrastructure, and GitHub Actions run the catzc automation's CI
(`.github/workflows/ci-automation.yml`) and its manual release ([ADR-GH-RELEASE](../../github/github-release.md)). The globsets project to
both vendors' trigger dialects from one registry ([ADR-FLOW-CD-GLOBS#6](../../flow/durable-sha-globs.md#rule-adr-flow-cd-globs6)), so a unit
can move between them without its trigger being written again.

##### 37 status

Realised — Azure DevOps carries the infrastructure delivery and GitHub the automation's CI and release.

## Decision

The repository answers each of Microsoft's platform automation and DevOps recommendations with what it does, what it plans, or why it does
not adopt it. Most of the area is machinery the repository defines for its own reasons — everything as code, one trunk, the CI discipline,
build-once CD triggered by globsets, the runner, and the test tiers — so a CAF item adds no second mechanism; it names the gap between the
recommendation and that machinery. The gaps cluster in three places: production reached in the same stage as non-production rather than by
promotion, Azure DevOps state (service connections, environments, reviewer policies) kept outside the repository, and the outer loop of
testing and preview (system tests, what-if, a secret scan). Items that assume a tenant-level platform (accelerators, subscription creation)
or that belong to the operating organisation (frameworks, roadmaps, branch permissions, planning tools) are not adopted, and the rule says
why.

### How this is enforced

Checks that exist:

- `ci-infrastructure.yaml` runs `Assert-BicepTemplate` and `Build-Bicep` for every template on every change under `infrastructure/`, as a
  pull-request check and on the merged commit, then `Test-Automation -Suite infrastructure`, whose L2 test checks every rendered parameters
  file against the compiled parameter model ([ADR-AZ-DATAMOD#9](../azure-data-model.md#rule-adr-az-datamod9)); a `secureString` parameter
  that is not a Key Vault reference fails it.
- `build-validation.yml`, applied by `Sync-AdoBuildValidations`, binds each declared globset to its pipeline as a blocking build validation
  on `main`; `Test-AdoPipelineTriggerGlob` keeps each pipeline's trigger equal to its globset's projection
  ([ADR-FLOW-CD-GLOBS#6](../../flow/durable-sha-globs.md#rule-adr-flow-cd-globs6)).
- `Test-Pipelines` holds the pipeline naming and placement ([ADR-PIPE-NAME](../../pipelines/pipeline-naming-and-placement.md)).
- `Deploy-Bicep` asserts the target subscription with `-SubscriptionIdAssertIs` and tags every deployed resource group or subscription with
  its commit, build, and branch (`Set-BicepTrackingTagSet`).
- `Test-ManagedGuids` fails an unregistered GUID, so a policy definition id enters `discovery/main.bicep` only with its `guids.yml` entry
  ([ADR-AUTO-GUIDS](../../automation/managed-guids.md)).
- The CD pipelines' stage dependencies deploy `foundation`, then `discovery`, then `expedition`, and only on `main`.

Planned (follow-up), none of which exists:

- Production reached by promotion — a DEPLOY pipeline or a CDe with an internal approval — instead of the same stage as non-production
  (ADR-AZ-CAFDEVOPS#5, shared with ADR-AZ-WAFOE#6 and ADR-AZ-WAFOE#11).
- A what-if preview before every pipeline deploy, under a read-only identity (ADR-AZ-CAFDEVOPS#34, ADR-AZ-CAFDEVOPS#30).
- Reviewer, vote-reset, comment, and merge-type policies declared beside the build validations (ADR-AZ-CAFDEVOPS#25, ADR-AZ-CAFDEVOPS#26).
- Service connections and Azure DevOps environments, with their checks, declared as code (ADR-AZ-CAFDEVOPS#1, ADR-AZ-CAFDEVOPS#33).
- The Bicep linter as a quality gate and L3 system tests of deployed templates (ADR-AZ-CAFDEVOPS#28).
- A secret scan of every change (ADR-AZ-CAFDEVOPS#31, tracked under ADR-AZ-WAFOE#3).
- Collecting the DORA metrics from the pipelines (ADR-AZ-CAFDEVOPS#16).

## Consequences

- Every recommendation of the area has a status a reader can check against the files it names, and the follow-up is the list of rules that
  are not realised.
- The repository adds no CAF-specific mechanism: a gap is closed in the pipeline, config, or check that owns the concern, and most gaps are
  shared with the Operational Excellence review.
- Azure DevOps state that lives outside the repository — service connections, environments, branch protection — cannot be shown to be met
  from the repository until it is declared as code.
- The repository never creates subscriptions or management groups, so it stays deployable by an identity with subscription rights only, at
  the cost of leaving subscription vending to the tenant.
