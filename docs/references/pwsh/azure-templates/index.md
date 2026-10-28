# Catzc.Azure.Templates

The Bicep templating module. It is the top of the Azure stack: it discovers the deployable templates in the repository, derives the names
their resources must carry, builds them into deployable artifacts, and deploys them. It consumes the identity model from
[Catzc.Azure](../azure/index.md) and the session checks from [Catzc.Azure.Cli](../azure-cli/index.md), and is the implementation of the
[data-model](../../../drs/azure/azure-data-model.md) and [naming-standard](../../../drs/azure/azure-naming-standard.md) decisions. The
identity model is not its own; the configuration it owns is that of its compliance checks, its cost estimate and its orphan removal.

## Responsibilities

| Responsibility   | Area      | Name                                                                                               |
| ---------------- | --------- | -------------------------------------------------------------------------------------------------- |
| responsibility:1 | discovery | [Template discovery and the configuration model][r1]                                               |
| responsibility:2 | naming    | [Deterministic resource naming](#responsibility2--deterministic-resource-naming)                   |
| responsibility:3 | classify  | [Deployment classification](#responsibility3--deployment-classification)                           |
| responsibility:4 | build     | [Build](#responsibility4--build)                                                                   |
| responsibility:5 | deploy    | [Deploy and resource-group provisioning](#responsibility5--deploy-and-resource-group-provisioning) |
| responsibility:6 | integrity | [Template integrity validation](#responsibility6--template-integrity-validation)                   |

[r1]: #responsibility1--template-discovery-and-the-configuration-model

### responsibility:1 — Template discovery and the configuration model

Finding the deployable templates on disk and reading their structure: the per-template options, and the per-resource-group configuration
files that map a subscription, environment, and slot to one set of parameters. This responsibility also exposes the distinct customers,
subscriptions, and slots a template targets, and writing a configuration back; from those slots it derives the service connections a project
needs, one per deployment identity in each subscription where a slot of its templates lives. One configuration file corresponds to exactly
one Azure resource group, so this responsibility _is_ the resource-group inventory. See
[data-model](../../../drs/azure/azure-data-model.md).

### responsibility:2 — Deterministic resource naming

Assembling an Azure resource name from its canonical components — environment, slot, region, organization, template short name, optional
customer and role, and resource type — in the active component order, rendered to each resource type's length and character budget. Names
are deterministic, with no random suffixes, and an over-budget name fails rather than being silently truncated. This responsibility owns the
name builder and the registries of orders, render patterns, and resource types. See
[naming-standard](../../../drs/azure/azure-naming-standard.md).

### responsibility:3 — Deployment classification

The small, closed vocabularies a template and a deployment are classified by: the environment kinds a template can declare, and the
deployment modes and targets a deploy can use. These are the allowed-value sets the options and the deploy validate against.

### responsibility:4 — Build

Turning a template plus a chosen environment and slot into a deployable artifact: resolving the build context, resolving every
config-addressed parameter into the value its config address names, running the template's build-time preparation hook, rendering the
per-slot parameter file, and compiling the Bicep into the output directory, which sits under the one output root every template's build
output resolves to. Build is mode-agnostic — it produces artifacts, it does not touch Azure. The deployment's identifying name is derived
here too.

### responsibility:5 — Deploy and resource-group provisioning

Taking a built template to Azure: ensuring the target resource group exists, running the pre-deploy hook, executing the deployment
(honouring a dry-run preview), applying the tracking tags that scope the deployment, and running the post-deploy hook. This is the only
state-changing responsibility, and it verifies the session targets the configured subscription before it acts. It also rotates the
break-glass SQL password of the deployed expedition slots, server first and vault second (run monthly by the CRON pipeline
cron-break-glass-rotation), and seeds the anomaly alert's recipients into the foundation vault before each discovery deploy.

### responsibility:6 — Template integrity validation

Checking that a template is internally consistent and conforms to the model — that its configuration sits under defined subscriptions
serving the right environments, that its class and slots are valid, that its name renders within budget, and that every parameters file it
renders satisfies the parameter model of its compiled `main.json` (see
[data-model](../../../drs/azure/azure-data-model.md#rule-adr-az-datamod-parametercontract)). This is the guard the integrity tests run
across every shipped template. Three quality gates hold the compiled templates and the configuration tree to the landing-zone rules: the
compliance quality gate (CAF tags, a diagnostic setting per data kind, public access off, TLS 1.2, availability zone redundancy in
production, against a ratchet of known findings), the names quality gate (a slot never writes a name its template derives from the namer),
and the orphans quality gate (a resource group no config derives).

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
engine (see [prepost-extension-modules](../../../drs/automation/pwsh/prepost-extension-modules.md)). A value that belongs to the repository
rather than to one template, such as the policy enforcement mode, needs no hook: a template's configuration names it by its config address,
and build renders the addressed value into the parameter file (see
[data-model](../../../drs/azure/azure-data-model.md#rule-adr-az-datamod-valuebyaddress) and
[config-value-addressing](../../../drs/configuration/config-value-addressing.md)). Deploy leans on the session-verification checks before it
acts, so a deployment can never run against the wrong subscription.

The classification vocabularies (responsibility 3) are the small enumerations that keep options and deploys honest, and integrity validation
(responsibility 6) is the safety net: it binds to the _set_ of shipped templates and asserts the invariants that must hold for every one of
them, so a misnamed config folder or an undefined environment fails the tests rather than a deployment. Throughout, identity comes from the
[Catzc.Azure](../azure/index.md) model: the module reads `azure.yml` and `network.yml` through that module, and owns only the configuration
of its own checks and estimates, the template-compliance rules, the cost model's meters and the resources the orphan removal leaves to
Azure.

The first diagram below draws template discovery and the build from the source. A template is a folder, and its `options.yml` may override
only five derived defaults, under a strict schema. The build writes one parameters file per slot and then compiles the template once. The
second diagram draws a deployment. It works on one immutable context (the plan, the artifacts and the environment), resolved from the live
az session against `azure.yml`. A dry run stops at the what-if; otherwise the deployment is created.

![A template is a folder; options.yml overrides five defaults](../.assets/bicep-template-is-a-folder.drawio.png)

![One immutable context, resolved from the az session](../.assets/bicep-deploy-one-immutable-context.drawio.png)

## Division

The module's public functions and its config files, sorted into the responsibilities above; it consumes `azure.yml` and `network.yml` (owned
by [Catzc.Azure](../azure/index.md)).

| Responsibility                                                    | Function                          |
| ----------------------------------------------------------------- | --------------------------------- |
| responsibility:1 — Template discovery and the configuration model | `Get-BicepTemplates`              |
|                                                                   | `Get-BicepTemplate`               |
|                                                                   | `Get-BicepTemplateNames`          |
|                                                                   | `Get-BicepTemplateConfiguration`  |
|                                                                   | `Set-BicepTemplateConfiguration`  |
|                                                                   | `Get-BicepTemplateCustomers`      |
|                                                                   | `Get-BicepTemplateSlots`          |
|                                                                   | `Get-BicepServiceConnections`     |
|                                                                   | `Get-BicepServiceConnectionName`  |
| config                                                            | `service-connections.yml`         |
| responsibility:2 — Deterministic resource naming                  | `Get-AzureResourceName`           |
|                                                                   | `Get-BicepResourceName`           |
|                                                                   | `Get-AzureNameOrderSet`           |
|                                                                   | `Get-AzureNamePatternSet`         |
|                                                                   | `Get-AzureResourceTypeSet`        |
| responsibility:3 — Deployment classification                      | `Get-AzureBicepEnvironmentKinds`  |
|                                                                   | `Get-AzureBicepDeploymentModes`   |
|                                                                   | `Get-AzureBicepDeploymentTargets` |
|                                                                   | `Get-BicepDeploymentName`         |
| responsibility:4 — Build                                          | `Build-Bicep`                     |
|                                                                   | `ConvertTo-BicepParam`            |
|                                                                   | `Get-BicepTemplatesOutputRoot`    |
|                                                                   | `Get-BicepCostEstimate`           |
|                                                                   | `Update-AzurePriceTable`          |
| config                                                            | `cost-model.yml`                  |
| responsibility:5 — Deploy and resource-group provisioning         | `Deploy-Bicep`                    |
|                                                                   | `Get-BicepDeploymentContext`      |
|                                                                   | `Deploy-AzureResourceGroup`       |
|                                                                   | `Set-BicepTrackingTagSet`         |
|                                                                   | `Get-BicepTrackTagNameSet`        |
|                                                                   | `Invoke-BreakGlassRotation`       |
|                                                                   | `Set-AnomalyAlertRecipientSecret` |
|                                                                   | `Remove-BicepOrphanResources`     |
| config                                                            | `orphan-removal.yml`              |
| responsibility:6 — Template integrity validation                  | `Assert-BicepTemplate`            |
|                                                                   | `Get-BicepParameterModel`         |
|                                                                   | `Test-BicepTemplateCompliance`    |
|                                                                   | `Test-BicepResourceNames`         |
|                                                                   | `Test-BicepOrphans`               |
| config                                                            | `template-compliance.yml`         |
