---
catzc:
  immutable:
    with_body_sha: c62eb7ef9ecb
    path: docs/references/automation/catzc-azure-templates.md
    folder: docs/references/automation
    name: catzc-azure-templates
    filetype: md
    kind: reference
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/.assets/references/automation/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.md
      - docs/.assets/references/automation/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.png
      - docs/.assets/references/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.md
      - docs/.assets/references/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.png
      - docs/adr/azure/azure-data-model.md
      - docs/adr/azure/azure-data-model.md#rule-adr-az-datamod10
      - docs/adr/azure/azure-data-model.md#rule-adr-az-datamod9
      - docs/adr/azure/azure-naming-standard.md
      - docs/adr/configuration/config-value-addressing.md
      - docs/adr/pwsh/prepost-extension-modules.md
      - docs/references/automation/catzc-azure-cli.md
      - docs/references/automation/catzc-azure.md
---

# Catzc.Azure.Templates

The Bicep templating module. It is the top of the Azure stack: it discovers the deployable templates in the repository, derives the names
their resources must carry, builds them into deployable artifacts, and deploys them. It consumes the identity model from
[Catzc.Azure](catzc-azure.md) and the session checks from [Catzc.Azure.Cli](catzc-azure-cli.md), and is the implementation of the
[data-model](../../adr/azure/azure-data-model.md) and [naming-standard](../../adr/azure/azure-naming-standard.md) decisions.

## Responsibilities

| Responsibility   | Area           | Name                                                                                                               |
| ---------------- | -------------- | ------------------------------------------------------------------------------------------------------------------ |
| responsibility:1 | discovery      | [Template discovery and the configuration model](#responsibility1--template-discovery-and-the-configuration-model) |
| responsibility:2 | naming         | [Deterministic resource naming](#responsibility2--deterministic-resource-naming)                                   |
| responsibility:3 | classification | [Deployment classification](#responsibility3--deployment-classification)                                           |
| responsibility:4 | build          | [Build](#responsibility4--build)                                                                                   |
| responsibility:5 | deploy         | [Deploy and resource-group provisioning](#responsibility5--deploy-and-resource-group-provisioning)                 |
| responsibility:6 | integrity      | [Template integrity validation](#responsibility6--template-integrity-validation)                                   |

### responsibility:1 — Template discovery and the configuration model

Finding the deployable templates on disk and reading their structure: the per-template options, and the per-resource-group configuration
files that map a subscription, environment, and slot to one set of parameters. This responsibility also exposes the distinct customers,
subscriptions, and slots a template targets, and writing a configuration back. One configuration file corresponds to exactly one Azure
resource group, so this responsibility _is_ the resource-group inventory. See [data-model](../../adr/azure/azure-data-model.md).

### responsibility:2 — Deterministic resource naming

Assembling an Azure resource name from its canonical components — environment, slot, region, organization, template short name, optional
customer and role, and resource type — in the active component order, rendered to each resource type's length and character budget. Names
are deterministic, with no random suffixes, and an over-budget name fails rather than being silently truncated. This responsibility owns the
name builder and the registries of orders, render patterns, and resource types. See
[naming-standard](../../adr/azure/azure-naming-standard.md).

### responsibility:3 — Deployment classification

The small, closed vocabularies a template and a deployment are classified by: the environment kinds a template can declare, and the
deployment modes and targets a deploy can use. These are the allowed-value sets the options and the deploy validate against.

### responsibility:4 — Build

Turning a template plus a chosen environment and slot into a deployable artifact: resolving the build context, resolving every
config-addressed parameter into the value its config address names, running the template's build-time preparation hook, rendering the
per-slot parameter file, and compiling the Bicep into the output directory. Build is mode-agnostic — it produces artifacts, it does not
touch Azure. The deployment's identifying name is derived here too.

### responsibility:5 — Deploy and resource-group provisioning

Taking a built template to Azure: ensuring the target resource group exists, running the pre-deploy hook, executing the deployment
(honouring a dry-run preview), applying the tracking tags that scope the deployment, and running the post-deploy hook. This is the only
state-changing responsibility, and it verifies the session targets the configured subscription before it acts.

### responsibility:6 — Template integrity validation

Checking that a template is internally consistent and conforms to the model — that its configuration sits under defined subscriptions
serving the right environments, that its class and slots are valid, that its name renders within budget, and that every parameters file it
renders satisfies the parameter model of its compiled `main.json` (see
[data-model](../../adr/azure/azure-data-model.md#rule-adr-az-datamod9)). This is the guard the integrity tests run across every shipped
template.

## What the module does

The module is a pipeline of concerns that takes a template from "a folder in the repository" to "resources in Azure". Discovery
(responsibility 1) reads the filesystem into a model: which templates exist, what each declares, and the one-to-one map between a
configuration file and a resource group. Naming (responsibility 2) is the deterministic function that turns the identity components into the
exact strings Azure will see — it is pure derivation, so the same inputs always produce the same names, and a name that cannot fit its
resource type's budget is an error to fix, not a string to trim.

Build (responsibility 4) and deploy (responsibility 5) are the two execution phases, and the split is deliberate: build produces an
immutable artifact and never touches the cloud, while deploy is the only place state changes. Both phases call the template's optional
extension hooks at the right moments — preparation merges global configuration into the parameter set at build time, and the pre/post-deploy
hooks bracket the deployment — which is how a template injects a secret reference or provisions a queue without that logic leaking into the
engine (see [prepost-extension-modules](../../adr/pwsh/prepost-extension-modules.md)). A value that belongs to the repository rather than to
one template, such as the policy enforcement mode, needs no hook: a template's configuration names it by its config address, and build
renders the addressed value into the parameter file (see [data-model](../../adr/azure/azure-data-model.md#rule-adr-az-datamod10) and
[config-value-addressing](../../adr/configuration/config-value-addressing.md)). Deploy leans on the session-verification checks before it
acts, so a deployment can never run against the wrong subscription.

The classification vocabularies (responsibility 3) are the small enumerations that keep options and deploys honest, and integrity validation
(responsibility 6) is the safety net: it binds to the _set_ of shipped templates and asserts the invariants that must hold for every one of
them, so a misnamed config folder or an undefined environment fails the tests rather than a deployment. Throughout, identity comes from the
[Catzc.Azure](catzc-azure.md) model — this module owns no configuration of its own; it reads `azure.yml` and `network.yml` through that
module.

The first diagram below draws template discovery and the build from the source. A template is a folder, and its `options.yml` may override
only five derived defaults, under a strict schema. The build writes one parameters file per slot and then compiles the template once. The
second diagram draws a deployment. It works on one immutable context (the plan, the artifacts and the environment), resolved from the live
az session against `azure.yml`. A dry run stops at the what-if; otherwise the deployment is created. Each slide has a description:
[template discovery](../../.assets/references/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.md) and
[deployment](../../.assets/references/automation/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.md).

![A template is a folder; options.yml overrides five defaults](../../.assets/references/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.png)

![One immutable context, resolved from the az session](../../.assets/references/automation/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.png)

## Division

The module's public functions, sorted into the responsibilities above. This module owns no config files of its own; it consumes `azure.yml`
and `network.yml` (owned by [Catzc.Azure](catzc-azure.md)).

| Responsibility                                                    | Function                          |
| ----------------------------------------------------------------- | --------------------------------- |
| responsibility:1 — Template discovery and the configuration model | `Get-BicepTemplates`              |
|                                                                   | `Get-BicepTemplate`               |
|                                                                   | `Get-BicepTemplateNames`          |
|                                                                   | `Get-BicepTemplateConfiguration`  |
|                                                                   | `Set-BicepTemplateConfiguration`  |
|                                                                   | `Get-BicepTemplateCustomers`      |
|                                                                   | `Get-BicepTemplateSlots`          |
| responsibility:2 — Deterministic resource naming                  | `Get-AzureResourceName`           |
|                                                                   | `Get-BicepResourceName`           |
|                                                                   | `Get-AzureNameOrder`              |
|                                                                   | `Get-AzureNameOrderSet`           |
|                                                                   | `Get-AzureNamePatternSet`         |
|                                                                   | `Get-AzureResourceTypeSet`        |
| responsibility:3 — Deployment classification                      | `Get-AzureBicepEnvironmentKinds`  |
|                                                                   | `Get-AzureBicepDeploymentModes`   |
|                                                                   | `Get-AzureBicepDeploymentTargets` |
|                                                                   | `Get-BicepDeploymentName`         |
| responsibility:4 — Build                                          | `Build-Bicep`                     |
| responsibility:5 — Deploy and resource-group provisioning         | `Deploy-Bicep`                    |
|                                                                   | `Get-BicepDeploymentContext`      |
|                                                                   | `Deploy-AzureResourceGroup`       |
|                                                                   | `Set-BicepTrackingTagSet`         |
|                                                                   | `Get-BicepTrackTagNameSet`        |
| responsibility:6 — Template integrity validation                  | `Assert-BicepTemplate`            |
|                                                                   | `Get-BicepParameterModel`         |
