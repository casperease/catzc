# Landing zones: Operations, authentication and enforcement

Part of the decision of [ADR-AZ-LZ](../landing-zones.md), which holds the rules these sections justify.

## Operations as code

The repository's standard practices are its domain rules: the decision records under `docs/drs/`, each rule cited by code and enforced,
where a machine can enforce it, by a quality gate
([ADR-AUTO-TEST-QUALITYGATE](../../automation/test-automation.md#rule-adr-auto-test-qualitygate)). Compliance built in as guardrails is the
landing zone's policy assignments, in force in production and auditing outside it. A learning, blameless culture is the DORA capability
[generative organizational culture](../../external/dora/generative-organizational-culture.md). The CAF tags on every resource include
`owner`, `criticality`, and `data-classification` ([ADR-AZ-LZ-CAFTAGS](../landing-zones.md#rule-adr-az-lz-caftags)).

Routine operations are automation, not documents: building, deploying, and validating a template are the `Build-Bicep`, `Deploy-Bicep`, and
`Assert-BicepTemplate` functions, run the same way on a devbox and in a pipeline. A scheduled routine is a CRON pipeline invoking an
idempotent function ([FDR-TYPE-CRONISSCHEDULER](../../flow/pipeline-types.md#rule-fdr-type-cronisscheduler)). Operational state and runbooks
never live outside version control ([PDR-EAC-NOUNVERSIONEDSTATE](../../principles/everything-as-code.md#rule-pdr-eac-nounversionedstate)),
and the task guides under `docs/how-to/` (adding a deployable unit, adding an infrastructure template) are the written procedures for the
changes that recur. Two operations stay manual: putting the break-glass SQL password (`exped-sql-admin-password`) into `foundation`'s vault
before the first `expedition` deploy, and the three-step rollout of a new spoke
([ADR-AZ-LZ-LINKSNEEDBOTHNETWORKS](../landing-zones.md#rule-adr-az-lz-linksneedbothnetworks)), which `cd-shared.yaml` and the customer CD
pipelines leave to a person; there is no emergency-change procedure.

The branching strategy is trunk-based development on `main` ([trunk-based-development](../../external/dora/trunk-based-development.md)). A
pull request is the authenticated ingress to the server remote
([DDR-REMOTE-PULLREQUESTISINGRESS](../../design/server-remote-integration.md#rule-ddr-remote-pullrequestisingress)), and the
build-validation policies in `build-validation.yml` bind each deployable unit's and each track's globset to its pipeline as a blocking check
on `main`. The CI engine builds and verifies inside the integration budget
([FDR-CD-SHORTINTEGRATIONCYCLE](../../flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-shortintegrationcycle)), and static analysis is a
set of quality gates (`Test-ScriptAnalyzer`, `Test-Markdownlint`, `Test-Spelling`, `Test-Formatting`). Every change under `infrastructure/`
runs `ci-infrastructure.yaml` as a pull-request check and again on the merged commit. Traceability is built into the deploy: after a
successful deploy, `Deploy-Bicep` runs `Set-BicepTrackingTagSet`, which tags the target resource group (`foundation`, and `expedition` per
slot) or the subscription (`discovery`) with the commit, the build id, and the branch. No secret scan of changes and no required-reviewer
policy are configured; `build-validation.yml` holds build validations only.

Tools are standard and pinned: the Bicep CLI, the az CLI ([ADR-AZ-CLI-AZBYDEFAULT](../prefer-az-cli.md#rule-adr-az-cli-azbydefault)),
Pester, PSScriptAnalyzer, markdownlint, and Prettier, each locked to a version in `tools.yml` and installed by the same installer on a
devbox and in a pipeline
([ADR-AUTO-DEPS-LOCKEDTOOLVERSIONS](../../automation/controlling-systemwide-deps.md#rule-adr-auto-deps-lockedtoolversions)). Formatting is
one standard per file language, configured in `languages.yml` and applied by `Format-Code`, Bicep by `bicep format`. Every Azure name
follows one deterministic naming standard
([ADR-AZ-NAMING-DETERMINISTICNAMES](../azure-naming-standard.md#rule-adr-az-naming-deterministicnames); `nsub-weu-zct-fnd-log` for
`foundation`'s workspace, and a storage account, whose type allows no hyphen, takes the concatenated form), every resource carries the CAF
tags, and every decision is an ADR. The delivery metrics are DORA's ([metrics](../../../references/dora/metrics.md)). The Bicep linter is a
quality gate: `Test-BicepLint` lints every template and module at the rule levels of `infrastructure/bicepconfig.json`, and a linter warning
fails the build.

Everything the infrastructure needs lives in version control
([PDR-EAC-EVERYTHINGCOMMITTED](../../principles/everything-as-code.md#rule-pdr-eac-everythingcommitted)): declarative Bicep under
`infrastructure/`, shared modules under `infrastructure/modules/`, and one config per slot under each template's `configuration/`
([ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION](../azure-data-model.md#rule-adr-az-datamod-onefileonesubscription)). One template serves every
environment; only its config varies, and a value that another config owns is read by config address, never copied
([ADR-AZ-DATAMOD-VALUEBYADDRESS](../azure-data-model.md#rule-adr-az-datamod-valuebyaddress)). The three templates are the split by rate of
change: `foundation` changes least, `discovery` rarely, `expedition` with its workload. A secure parameter takes a Key Vault reference, so
no secret sits in a config; the vault is RBAC-authorised with no access policies to drift. `discovery` reads the network's kind, address
space, and subnets from `network.yml` and the policy enforcement mode from `azure.yml` by config address, so its config holds names, never
ranges. The secure defaults (public access off, TLS 1.2, managed identities) are module defaults, and what varies by environment class (SKU,
zone redundancy, backup redundancy and retention, the serverless pause) is config. Every template deploys in `Incremental` mode (the default
of `deployment_mode`), so a resource removed from a template stays in Azure until someone deletes it, and no check scans the compiled
templates for misconfiguration.

The delivery flow is the supply chain. Each deployable unit, the shared platform and each customer, has a globset in `globs.yml` that
triggers its CD pipeline through the globset's native path filter
([FDR-GLOBS-NATIVEPATHFILTER](../../flow/durable-sha-globs.md#rule-fdr-globs-nativepathfilter)). The CD pipeline runs the same CI engine as
`ci-infrastructure.yaml` ([FDR-TYPE-ONECIENGINE](../../flow/pipeline-types.md#rule-fdr-type-oneciengine)), publishes one artifact per
template, and its deploy stages consume those artifacts unchanged, build once and deploy many
([FDR-CD-SEPARATEPIPELINEKINDS](../../flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-separatepipelinekinds)), and configuration
reaches the cloud only through version control
([FDR-TYPE-CONFIGENTERSTHROUGHINPUT](../../flow/pipeline-types.md#rule-fdr-type-configentersthroughinput)). The stages run `foundation`,
then `discovery`, then `expedition` (one deployment job per slot; a customer with no `expedition` config gets no stage), and each deploy
asserts the subscription its service connection logs into (`-SubscriptionIdAssertIs`). Hubs deploy from `cd-shared.yaml` and spokes from
the customer pipelines, so the spoke rollout order spans two pipelines. The shipped CD pipelines deploy non-production and production in the
same stage, on `main` only, with no bake time and no what-if preview, and `.ado/pipelines/` holds no DEPLOY pipeline: they fall short of
the flow model's promotion
([FDR-CD-CDSTAYSINNONPROD](../../flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-cdstaysinnonprod),
[FDR-CD-PRODPROGRESSIONISDEPLOY](../../flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-prodprogressionisdeploy),
[FDR-CD-TWORELEASEGATES](../../flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-tworeleasegates),
[FDR-CD-TWOENVIRONMENTACTIVATION](../../flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-twoenvironmentactivation),
[FDR-TYPE-DEPLOYISPINNED](../../flow/pipeline-types.md#rule-fdr-type-deployispinned)). Read-only standing access to the subscriptions is a
tenant setting. `discovery` is the riskiest template, since a change to peering, routing, or a policy assignment reaches every workload of
the subscription; a slot is a deployment of its own, so a special slot can take a change before the base slot.

Monitoring is part of the infrastructure, deployed by the same templates
([monitoring-and-observability](../../external/dora/monitoring-and-observability.md)). `foundation` gives every subscription one Log
Analytics workspace (`PerGB2018`, the module's 30-day retention in every config), so telemetry is central per subscription and separate
between non-production and production. Each template sends the diagnostics of the resources it deploys to that workspace through the
`diagnostic-setting.bicep` module, and the subscription's activity log through `subscription-diagnostic-setting.bicep`
([ADR-AZ-LZ-CAFMANAGEMENT](../landing-zones.md#rule-adr-az-lz-cafmanagement)). A diagnostic setting in the template exists when the deploy
succeeds, which a deploy-if-not-exists policy cannot promise. `expedition` deploys no compute, so it has no application telemetry to trace.
There is no health model, alert rule, or dashboard, and the only alerts are the landing zone's budget thresholds, sent to the subscription's
`Owner` role.

The architecture carries the containment and recovery side of an incident. Workloads sit behind private endpoints with public access off,
each subnet that carries workloads has a network security group that denies inbound traffic from the internet, a spoke has a route table on
every subnet, the hub reserves `AzureFirewallSubnet`, and a SQL server keeps a break-glass login beside its Entra ID administrator group
([ADR-AZ-LZ-SQLENTRAADMINS](../landing-zones.md#rule-adr-az-lz-sqlentraadmins)). The activity log of every subscription is the audit trail,
and the provenance tags name the commit behind any deployed resource, so a bad change is found and redeployed from the commit before it. No
alert routes an incident to anyone, and no response plan, escalation path, or drill exists as a version-controlled procedure; a blameless
review that changes a rule, a gate, or an ADR is how the repository learns.

Infrastructure is tested in tiers by `Test-Automation` ([ADR-AUTO-TEST](../../automation/test-automation.md)), each test tagged with its
tier and category and kept in the module it tests. For infrastructure, `ci-infrastructure.yaml` runs `Assert-BicepTemplate` and
`Build-Bicep` for every template and then `Test-Automation -Suite infrastructure`, whose L2 test builds every shipped template and checks
each rendered parameters file against the compiled parameter model
([ADR-AZ-DATAMOD-PARAMETERCONTRACT](../azure-data-model.md#rule-adr-az-datamod-parametercontract)); a build that leaves the literal
`UNDEFINED` in a config fails, and `Test-AzureNetworkPlan` checks the network plan. No L3 system test deploys a template to an on-demand
environment ([FDR-CD-INNERANDOUTERLOOP](../../flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-innerandouterloop),
[ADR-AUTO-TEST-SYSTEMTESTSATLTHREE](../../automation/test-automation.md#rule-adr-auto-test-systemtestsatlthree)), and no L4 test observes a
deployed landing zone or workload
([ADR-AUTO-TEST-TESTINGINPRODUCTION](../../automation/test-automation.md#rule-adr-auto-test-testinginproduction)); an ephemeral slot
(`dev-blu`, [ADR-AZ-DATAMOD-EPHEMERALSLOT](../azure-data-model.md#rule-adr-az-datamod-ephemeralslot)) is a purpose-built second deployment
beside a base slot, from the base slot's own config.

The automation is the catzc module system itself: every operation is a function in a module under `pwsh/`, tested by
[ADR-AUTO-TEST](../../automation/test-automation.md), idempotent ([ADR-AUTO-IDEM](../../automation/idempotent-state-functions.md)),
previewable with `-DryRun` ([ADR-AUTO-DRYRUN](../../automation/dry-run.md)), and bounded in time
([ADR-AUTO-FAILFAST-BOUNDEVERYWAIT](../../automation/fail-fast-with-asserts.md#rule-adr-auto-failfast-boundeverywait)). Pipelines call it
through one runner and keep their YAML declarative
([FDR-TYPE-ALLTHROUGHRUNNER](../../flow/pipeline-types.md#rule-fdr-type-allthroughrunner)), so the same function runs on a devbox and in a
pipeline ([ADR-AUTO-PARITY](../../automation/devbox-pipeline-parity.md)). It drives Azure through the az CLI. Desired state in Azure is held
by the landing zone's policy assignments, which deny a resource that breaks them in production and audit it elsewhere. `foundation` needs no
bootstrap beyond the resource group `Deploy-Bicep` creates; `expedition`'s storage account and SQL server each take a system-assigned
managed identity, and its database's serverless pause outside production is platform automation set by config. Monitoring-driven
self-healing is not used: the templates deploy platform services (storage, SQL Database, networking) whose recovery Azure performs.

## SQL authentication

An Entra ID group as the server's administrator ties database access to the directory: joining or leaving the group grants or revokes it,
and no password is shared. A break-glass SQL login stays beside it, so the server stays reachable when the directory or the group is
unavailable. Its password is a Key Vault reference to `foundation`'s vault, resolved by Azure Resource Manager at deploy time, so the
repository never holds it ([data-model](../azure-data-model.md)).

## Adding a spoke

A peering points at a remote virtual network, and a DNS zone link names one, so both networks must exist before either is created. The hub
lists its spokes, so the order is fixed by ADR-AZ-LZ-LINKSNEEDBOTHNETWORKS: the hub first without the new spoke, then the spoke, which peers
to the existing hub, then the hub again with the spoke listed. A hub deploy that lists a spoke whose network does not exist fails, naming
the missing network; once the spoke is deployed, the next hub deploy completes it.

## How this is enforced

- `ci-infrastructure.yaml` runs `Assert-BicepTemplate` and `Build-Bicep` for `discovery` and `expedition` on every change under
  `infrastructure/`, so a template or config that does not compile, or a config address that does not resolve, fails the build.
- The parameter-model test binds every template `Get-BicepTemplates` finds and checks each rendered parameters file against the compiled
  parameter model ([ADR-AZ-DATAMOD-PARAMETERCONTRACT](../azure-data-model.md#rule-adr-az-datamod-parametercontract)).
- `NetworkConfig` and `Test-AzureNetworkPlan` hold the network plan: the kind of each subscription's network, its subnets, and no overlap
  ([network-model](../azure-network-model.md)).
- `AzureConfig` declares the default of `policy_enforcement` and rejects an unknown key or mode, and `discovery`'s `@allowed` decorator on
  `policyEnforcementMode` rejects any other value at build time.
- `Test-ManagedGuids` fails an unregistered GUID in tracked text, so a built-in definition id enters `discovery/main.bicep` only with its
  `guids.yml` entry ([ADR-AUTO-GUIDS](../../automation/managed-guids.md)).
- `globs.yml` declares `template-azure-subscription-discovery` and `template-azure-workload-expedition` as base deployable units, composed
  by the customer and shared-platform units, so a change to either template triggers every CD pipeline that deploys it
  ([durable-sha-globs](../../flow/durable-sha-globs.md)); the customer CD pipeline deploys `foundation`, then `discovery`, then
  `expedition`.
