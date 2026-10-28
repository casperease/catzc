# Azure DevOps: Environment approvals — the promotion ladder's gates and records in Azure DevOps

The flow states the gates and records of the promotion ladder for any execution engine
([cd-discipline-and-promotion-flow](../flow/cd-discipline-and-promotion-flow.md), `FDR-CD`). This record binds them to Azure DevOps: which ADO
construct carries each kind, how a rung is named as an ADO environment, how the approval checks are applied from configuration, and where
the certifying record is read.

## Rules: ADR-ADO-APPROVAL

### Rule ADR-ADO-APPROVAL-PIPELINEPERKIND

**Each pipeline kind is its own ADO pipeline.** CI, CD, CDe and DEPLOY each get their own ADO pipeline definition, with its own trigger,
permissions and run history; they join through the tagged artifact and the run id of the CI run that built it
([FDR-CD-SEPARATEPIPELINEKINDS](../flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-separatepipelinekinds)).

- [One pipeline per kind](#one-pipeline-per-kind)

### Rule ADR-ADO-APPROVAL-ENVIRONMENTPERRUNG

**A unit's ADO environment for a rung is `<unit>-<rung>`, read from the rungs registry.** The registry is `rungs.yml` in `Catzc.Base.Flow`,
with its ladder declared on `RungsConfig`; an environment name, approval check or deploy list that refers to a rung reads it from there
([FDR-CD-RUNGSREGISTRY](../flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-rungsregistry)). The prod-tier environments are the
exception: they are named by their deploy target, a subscription or a configuration slot, and listed in `environment-approvals.yml`.

- [Environments named from the registry](#environments-named-from-the-registry)

### Rule ADR-ADO-APPROVAL-CHECKSFROMCONFIG

**Every approval gate is an ADO Approval check applied from `environment-approvals.yml`, never set in the portal.** The file (in
`Catzc.Azure.DevOps`) names the approver group and its members, the timeout a pending approval waits, the units whose release-gate rungs
carry the RC and RBC checks, and the prod-tier environments; its config type declares the defaults once (`Prod Approvers`, 24 hours). One
apply, `Sync-AdoEnvironmentApprovals`, makes the organization match the file in a fixed order: the group, then exactly its configured
members, then one check per environment. The RC and RBC checks land on each unit's `<unit>-release-uat` and `<unit>-pre-prod` environments
([FDR-CD-TWORELEASEGATES](../flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-tworeleasegates),
[FDR-CD-PRODAPPROVALGATE](../flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-prodapprovalgate)).

- [Approval checks from configuration](#approval-checks-from-configuration)

### Rule ADR-ADO-APPROVAL-DEPLOYMENTHISTORY

**The certifying record is the `<unit>-pre-prod` environment's ADO deployment history, checked by `Assert-AdoDeploymentHistory` in every
deploy job of the prod target.** A DEPLOY pipeline names the pre-prod environment as its prod stage's `CertifiedBy`; each deploy job of that
stage runs the assert before it downloads the artifact, and the assert throws when the history holds no successful deployment of the commit
the run ships ([FDR-CD-CERTIFYINGRECORD](../flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-certifyingrecord)).

- [The deployment history](#the-deployment-history)

## Context

The flow decides that the pipeline kinds are separate, that a rung is named once, that a gate waits for a person on the next environment,
and that the engine's own history certifies a rung. Each of those needs an ADO construct to stand on, and an ADO construct set by hand in
the portal drifts: nobody can review it, rebuild it or see who may approve. So each one is named here and driven from the repository.

## Decision

### One pipeline per kind

An ADO pipeline is the unit of trigger, permission and run history, so one pipeline per kind keeps each kind's governance apart. A DEPLOY
run is started by hand with the run id of the CI run whose artifact it ships, and never rebuilds it.

### Environments named from the registry

The rung names travel into ADO environment names, approval checks, deploy lists and the lifecycle diagrams. The approval apply builds
`<unit>-<rung>` for the rungs behind RC and RBC from the registry, so remapping a rung to another environment is one edit in `rungs.yml`.
The prod tier is named by its deploy target, not by the rung, so `environment-approvals.yml` lists it.

### Approval checks from configuration

ADO holds a stop before an environment as an Approval check on that environment. `Sync-AdoEnvironmentApprovals` applies the file in its
fixed order and reports each step, so a second run changes nothing. The procedure is the how-to "Apply the prod-tier approvals"
(`docs/how-to/automation/apply-environment-approvals.md`).

### The deployment history

ADO writes an environment's deployment history as a side effect of every deploy job, so no pipeline can forge it, and it names the run
behind each deployment, from which the commit follows. The assert resolves the commit of the CI run the DEPLOY run names and looks for a
successful pre-prod deployment of that commit; a deployment made by a DEPLOY run counts for the commit of the CI run that run named. A unit
whose DEPLOY has no prod target has nothing to certify, and takes the check when it gains one.

## How this is enforced

- `EnvironmentApprovalsConfig` validates `environment-approvals.yml` when it loads, an integrity test loads the shipped file, and
  `Sync-AdoEnvironmentApprovals` applies it; review checks that a pipeline deploying a new prod-tier environment lists it there
  (ADR-ADO-APPROVAL-CHECKSFROMCONFIG).
- Each deploy job of a prod stage first runs `Assert-AdoDeploymentHistory`; an L0 test stops a commit absent from the history
  (ADR-ADO-APPROVAL-DEPLOYMENTHISTORY).

## Consequences

- The gates, environments and records of the ladder are reviewable files and commands, rebuilt by one apply.
- The flow record stays engine-neutral; a second engine binds the same rules in its own record.
