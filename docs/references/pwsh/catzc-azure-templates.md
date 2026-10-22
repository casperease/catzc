---
catzc:
  edges:
    cites:
      - ADR-AZ-DATAMOD-CUSTOMERAXIS
      - ADR-AZ-DATAMOD-VALUEBYADDRESS
      - ADR-PWSH-DRYRUN-SUPPRESSSHOULDPROCESS
---

# Catzc.Azure.Templates

The Bicep templating module. It is the top of the Azure stack: it discovers the deployable templates in the repository, derives the names
their resources must carry, builds them into deployable artifacts, and deploys them. It consumes the identity model from
[Catzc.Azure](catzc-azure.md) and the session checks from [Catzc.Azure.Cli](catzc-azure-cli.md), and is the implementation of the
[data-model](../../drs/azure/azure-data-model.md) and [naming-standard](../../drs/azure/azure-naming-standard.md) decisions.

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
resource group, so this responsibility _is_ the resource-group inventory. See [data-model](../../drs/azure/azure-data-model.md).

### responsibility:2 — Deterministic resource naming

Assembling an Azure resource name from its canonical components — environment, slot, region, organization, template short name, optional
customer and role, and resource type — in the active component order, rendered to each resource type's length and character budget. Names
are deterministic, with no random suffixes, and an over-budget name fails rather than being silently truncated. This responsibility owns the
name builder and the registries of orders, render patterns, and resource types. See
[naming-standard](../../drs/azure/azure-naming-standard.md).

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
state-changing responsibility, and it verifies the session targets the configured subscription before it acts.

### responsibility:6 — Template integrity validation

Checking that a template is internally consistent and conforms to the model — that its configuration sits under defined subscriptions
serving the right environments, that its class and slots are valid, that its name renders within budget, and that every parameters file it
renders satisfies the parameter model of its compiled `main.json` (see
[data-model](../../drs/azure/azure-data-model.md#rule-adr-az-datamod-parametercontract)). This is the guard the integrity tests run across
every shipped template.

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
engine (see [prepost-extension-modules](../../drs/automation/pwsh/prepost-extension-modules.md)). A value that belongs to the repository
rather than to one template, such as the policy enforcement mode, needs no hook: a template's configuration names it by its config address,
and build renders the addressed value into the parameter file (see
[data-model](../../drs/azure/azure-data-model.md#rule-adr-az-datamod-valuebyaddress) and
[config-value-addressing](../../drs/configuration/config-value-addressing.md)). Deploy leans on the session-verification checks before it
acts, so a deployment can never run against the wrong subscription.

The classification vocabularies (responsibility 3) are the small enumerations that keep options and deploys honest, and integrity validation
(responsibility 6) is the safety net: it binds to the _set_ of shipped templates and asserts the invariants that must hold for every one of
them, so a misnamed config folder or an undefined environment fails the tests rather than a deployment. Throughout, identity comes from the
[Catzc.Azure](catzc-azure.md) model — this module owns no configuration of its own; it reads `azure.yml` and `network.yml` through that
module.

The first diagram below draws template discovery and the build from the source. A template is a folder, and its `options.yml` may override
only five derived defaults, under a strict schema. The build writes one parameters file per slot and then compiles the template once. The
second diagram draws a deployment. It works on one immutable context (the plan, the artifacts and the environment), resolved from the live
az session against `azure.yml`. A dry run stops at the what-if; otherwise the deployment is created.

```yml drawio
description:
  Template discovery walks the template folders, lets an optional options.yml override five derived defaults, and resolves each template's
  short name and type; the build then resolves the parameter addresses per slot and compiles through the az runner.
about:
  adrs: [ADR-AZ-DATAMOD, ADR-AZ-NAMING, ADR-AZ-CUSTOMER, ADR-CONF-ADDRESSING, ADR-BCL-TYPES]
  lens: source
content:
  title: A template is a folder; options.yml overrides five defaults
  kind: reference
  flow: left-to-right
  relation: runs next (code order)
  theme: dark
  bands:
    - { id: band-entry, label: ENTRY }
    - { id: band-folder, label: EACH FOLDER }
    - { id: band-slot, label: EACH SLOT }
  groups:
    - { id: grp-cli, label: Catzc.Azure.Cli, in: band-slot }
  glyphs:
    - { id: g-build, kind: code, label: Build-Bicep, in: band-entry }
    - { id: g-templates, kind: code, label: Get-BicepTemplates, in: band-entry }
    - { id: g-options, kind: gate, label: Read-BicepTemplateOptions, in: band-folder }
    - { id: f-options-yml, kind: file, label: options.yml, in: band-folder }
    - { id: t-short-name, kind: type, label: BicepShortName, in: band-folder }
    - { id: t-template, kind: type, label: BicepTemplate, in: band-folder }
    - { id: g-addresses, kind: private, label: Resolve-BicepParameterAddresses, in: band-slot }
    - { id: f-parameters, kind: file, label: parameters.<config>.json, in: band-slot }
    - { id: g-invoke, kind: code, label: Invoke-AzCli, in: grp-cli }
  edges:
    - { from: g-build, to: g-templates, kind: flow, label: "" }
    - { from: g-templates, to: g-options, kind: flow, label: "" }
    - { from: g-options, to: t-short-name, kind: flow, label: "" }
    - { from: t-short-name, to: t-template, kind: flow, label: "" }
    - { from: t-template, to: g-addresses, kind: flow, label: "" }
    - { from: g-addresses, to: g-invoke, kind: flow, label: "" }
  markers:
    - { at: g-templates, number: 1 }
    - { at: g-options, number: 2 }
    - { at: t-short-name, number: 3 }
    - { at: t-template, number: 4 }
    - { at: g-addresses, number: 5 }
    - { at: f-parameters, number: 6 }
    - { at: g-invoke, number: 7 }
  legend: auto
  minimaps:
    code-locations:
      - cell: .claude/.claude/skills/catzc-module
        by: [.claude/skills/catzc-module/SKILL.md, ADR-BCL-TYPES]
      - cell: ado-pipelines/pipelines/.
        by: [.ado/pipelines/cd-shared.yaml, .ado/pipelines/ci-infrastructure.yaml, ADR-AZ-DATAMOD]
      - cell: ado-pipelines/pipelines/extends
        by: [.ado/pipelines/extends/cd-customer.yaml, ADR-AZ-DATAMOD]
      - cell: docs/-/.
        by:
          - docs/drs/automation/BCL/dora-explains.md
          - docs/drs/automation/BCL/native-csharp-types.md
          - docs/drs/azure/azure-customer-model.md
          - docs/drs/azure/azure-data-model.md
          - docs/drs/azure/azure-naming-standard.md
          - docs/drs/azure/dora-explains.md
          - docs/drs/configuration/config-value-addressing.md
          - docs/drs/configuration/dora-explains.md
          - docs/drs/glossary.md
          - docs/drs/index.md
          - docs/how-to/getting-started/BCL/add-a-dotnet-type.md
          - docs/how-to/pwsh/manual-test-plan/azure.md
          - docs/references/ado/pipelines/cd-shared.yaml.md
          - docs/references/ado/pipelines/ci-infrastructure.yaml.md
          - docs/references/ado/pipelines/extends/cd-customer.yaml.md
          - docs/references/infrastructure/templates/discovery/options.yml.md
          - docs/references/infrastructure/templates/expedition/options.yml.md
          - docs/references/infrastructure/templates/foundation/options.yml.md
          - docs/references/pwsh/catzc-azure-cli/Assert-AzCliCanAccess.ps1.md
          - docs/references/pwsh/catzc-azure-cli/Assert-AzCliIsConnected.ps1.md
          - docs/references/pwsh/catzc-azure-cli/Get-AzCliSessionSubscription.ps1.md
          - docs/references/pwsh/catzc-azure-cli/Test-AzCliCanAccess.ps1.md
          - docs/references/pwsh/catzc-azure-dev-ops-build-validation/configs/build-validation.yml.md
          - docs/references/pwsh/catzc-azure-dev-ops-build-validation/tests/types/BuildValidationConfig.Tests.ps1.md
          - docs/references/pwsh/catzc-azure-dev-ops-build-validation/types/BuildValidationConfig.cs.md
          - docs/references/pwsh/catzc-azure-dev-ops-build-validation/types/BuildValidationEntry.cs.md
          - docs/references/pwsh/catzc-azure-dev-ops/types/AdoConfig.cs.md
          - docs/references/pwsh/catzc-azure-templates/Assert-BicepTemplate.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Build-Bicep.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Deploy-Bicep.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Get-AzureBicepEnvironmentKinds.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Get-AzureResourceName.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Get-AzureResourceTypeSet.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Get-BicepDeploymentContext.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Get-BicepResourceName.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Get-BicepTemplateConfiguration.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Get-BicepTemplates.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Set-BicepTemplateConfiguration.ps1.md
          - docs/references/pwsh/catzc-azure-templates/private/Get-BicepConfigClassViolations.ps1.md
          - docs/references/pwsh/catzc-azure-templates/private/Get-BicepConfigName.ps1.md
          - docs/references/pwsh/catzc-azure-templates/private/Get-BicepConfigSubscriptionCandidates.ps1.md
          - docs/references/pwsh/catzc-azure-templates/private/Get-BicepCustomerClassViolations.ps1.md
          - docs/references/pwsh/catzc-azure-templates/private/Get-BicepParametersFileName.ps1.md
          - docs/references/pwsh/catzc-azure-templates/private/Get-BicepSubscriptionConfigViolations.ps1.md
          - docs/references/pwsh/catzc-azure-templates/private/Resolve-BicepConfigName.ps1.md
          - docs/references/pwsh/catzc-azure-templates/private/Resolve-BicepParameterAddresses.ps1.md
          - docs/references/pwsh/catzc-azure-templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1.md
          - docs/references/pwsh/catzc-azure-templates/tests/types/BicepShortName.Tests.ps1.md
          - docs/references/pwsh/catzc-azure-templates/types/BicepParamWriter.cs.md
          - docs/references/pwsh/catzc-azure-templates/types/BicepParameter.cs.md
          - docs/references/pwsh/catzc-azure-templates/types/BicepParameterModel.cs.md
          - docs/references/pwsh/catzc-azure-templates/types/BicepShortName.cs.md
          - docs/references/pwsh/catzc-azure-templates/types/BicepSlot.cs.md
          - docs/references/pwsh/catzc-azure-templates/types/BicepTemplate.cs.md
          - docs/references/pwsh/catzc-azure/Get-AzureCustomers.ps1.md
          - docs/references/pwsh/catzc-azure/Get-AzureEnvironment.ps1.md
          - docs/references/pwsh/catzc-azure/Get-AzureSubscription.ps1.md
          - docs/references/pwsh/catzc-azure/Get-AzureSubscriptionEnvironment.ps1.md
          - docs/references/pwsh/catzc-azure/configs/azure.yml.md
          - docs/references/pwsh/catzc-azure/configs/customer.yml.md
          - docs/references/pwsh/catzc-azure/tests/types/AzureConfig.Tests.ps1.md
          - docs/references/pwsh/catzc-azure/types/AzureConfig.cs.md
          - docs/references/pwsh/catzc-azure/types/AzureCustomer.cs.md
          - docs/references/pwsh/catzc-azure/types/AzureEnvironmentRecord.cs.md
          - docs/references/pwsh/catzc-azure/types/AzureSubscriptionRecord.cs.md
          - docs/references/pwsh/catzc-azure/types/AzureTenantRecord.cs.md
          - docs/references/pwsh/catzc-azure/types/CustomerConfig.cs.md
          - docs/references/pwsh/catzc-azure/types/NetworkConfig.cs.md
          - docs/references/pwsh/catzc-azure/types/NetworkEnvironment.cs.md
          - docs/references/pwsh/catzc-azure/types/NetworkSubscription.cs.md
          - docs/references/pwsh/catzc-base-code-meta/types/CommentPageMap.cs.md
          - docs/references/pwsh/catzc-base-config/Get-Config.ps1.md
          - docs/references/pwsh/catzc-base-config/Get-ConfigValue.ps1.md
          - docs/references/pwsh/catzc-base-config/private/Resolve-ConfigKeyPath.ps1.md
          - docs/references/pwsh/catzc-base-contracts/tests/types/ContractCheckResult.Tests.ps1.md
          - docs/references/pwsh/catzc-base-contracts/types/ContractAsset.cs.md
          - docs/references/pwsh/catzc-base-contracts/types/ContractCheckResult.cs.md
          - docs/references/pwsh/catzc-base-contracts/types/ContractManifest.cs.md
          - docs/references/pwsh/catzc-base-contracts/types/ContractsConfig.cs.md
          - docs/references/pwsh/catzc-base-docs/types/AgentEntry.cs.md
          - docs/references/pwsh/catzc-base-docs/types/AgentsConfig.cs.md
          - docs/references/pwsh/catzc-base-docs/types/GlossaryAvoid.cs.md
          - docs/references/pwsh/catzc-base-docs/types/GlossaryConcept.cs.md
          - docs/references/pwsh/catzc-base-docs/types/GlossaryConfig.cs.md
          - docs/references/pwsh/catzc-base-docs/types/GlossaryEntry.cs.md
          - docs/references/pwsh/catzc-base-docs/types/GlossaryOptions.cs.md
          - docs/references/pwsh/catzc-base-docs/types/GlossaryRealization.cs.md
          - docs/references/pwsh/catzc-base-drs/tests/types/DrsDomainEdge.Tests.ps1.md
          - docs/references/pwsh/catzc-base-drs/types/DrsCheck.cs.md
          - docs/references/pwsh/catzc-base-drs/types/DrsChecksConfig.cs.md
          - docs/references/pwsh/catzc-base-drs/types/DrsCitationChange.cs.md
          - docs/references/pwsh/catzc-base-drs/types/DrsCitationChangeKind.cs.md
          - docs/references/pwsh/catzc-base-drs/types/DrsCitationRewrite.cs.md
          - docs/references/pwsh/catzc-base-drs/types/DrsConfig.cs.md
          - docs/references/pwsh/catzc-base-drs/types/DrsDomain.cs.md
          - docs/references/pwsh/catzc-base-drs/types/DrsDomainEdge.cs.md
          - docs/references/pwsh/catzc-base-drs/types/DrsDoraCheck.cs.md
          - docs/references/pwsh/catzc-base-drs/types/DrsNeutralityCheck.cs.md
          - docs/references/pwsh/catzc-base-drs/types/DrsNeutralityToken.cs.md
          - docs/references/pwsh/catzc-base-drs/types/DrsRuleSet.cs.md
          - docs/references/pwsh/catzc-base-engines/types/ExecutionEngine.cs.md
          - docs/references/pwsh/catzc-base-exporter/types/ExporterBundle.cs.md
          - docs/references/pwsh/catzc-base-exporter/types/ExporterConfig.cs.md
          - docs/references/pwsh/catzc-base-exporter/types/ExporterPackage.cs.md
          - docs/references/pwsh/catzc-base-languages/New-GoWorkspace.ps1.md
          - docs/references/pwsh/catzc-base-languages/New-PythonProject.ps1.md
          - docs/references/pwsh/catzc-base-languages/types/BashConfig.cs.md
          - docs/references/pwsh/catzc-base-languages/types/BashTestResult.cs.md
          - docs/references/pwsh/catzc-base-languages/types/BclConfig.cs.md
          - docs/references/pwsh/catzc-base-languages/types/BclHostBinding.cs.md
          - docs/references/pwsh/catzc-base-languages/types/FileCarrier.cs.md
          - docs/references/pwsh/catzc-base-languages/types/FileLanguage.cs.md
          - docs/references/pwsh/catzc-base-languages/types/FormatterEngine.cs.md
          - docs/references/pwsh/catzc-base-languages/types/GoConfig.cs.md
          - docs/references/pwsh/catzc-base-languages/types/GoTestResult.cs.md
          - docs/references/pwsh/catzc-base-languages/types/GoWorkspaceFile.cs.md
          - docs/references/pwsh/catzc-base-languages/types/LanguagesConfig.cs.md
          - docs/references/pwsh/catzc-base-languages/types/PythonConfig.cs.md
          - docs/references/pwsh/catzc-base-languages/types/PythonTestResult.cs.md
          - docs/references/pwsh/catzc-base-languages/types/PythonWorkspaceFile.cs.md
          - docs/references/pwsh/catzc-base-maps/Get-TrackPlacementMinimapData.ps1.md
          - docs/references/pwsh/catzc-base-maps/types/CitationSite.cs.md
          - docs/references/pwsh/catzc-base-maps/types/HighlightReason.cs.md
          - docs/references/pwsh/catzc-base-maps/types/HighlightedCell.cs.md
          - docs/references/pwsh/catzc-base-maps/types/MapCell.cs.md
          - docs/references/pwsh/catzc-base-maps/types/MapPlacement.cs.md
          - docs/references/pwsh/catzc-base-maps/types/MapsConfig.cs.md
          - docs/references/pwsh/catzc-base-maps/types/MapsHighlight.cs.md
          - docs/references/pwsh/catzc-base-maps/types/MapsLabels.cs.md
          - docs/references/pwsh/catzc-base-maps/types/MapsLimits.cs.md
          - docs/references/pwsh/catzc-base-maps/types/MapsPalette.cs.md
          - docs/references/pwsh/catzc-base-maps/types/MapsPin.cs.md
          - docs/references/pwsh/catzc-base-maps/types/TreemapRect.cs.md
          - docs/references/pwsh/catzc-base-maps/types/ValueChainCell.cs.md
          - docs/references/pwsh/catzc-base-maps/types/ValueChainReason.cs.md
          - docs/references/pwsh/catzc-base-maps/types/WorldMapBuilder.cs.md
          - docs/references/pwsh/catzc-base-maps/types/WorldMapGridLayout.cs.md
          - docs/references/pwsh/catzc-base-module-system/Copy-CatzcModule.ps1.md
          - docs/references/pwsh/catzc-base-module-system/Sync-GeneratedFile.ps1.md
          - docs/references/pwsh/catzc-base-module-system/types/ArtifactsConfig.cs.md
          - docs/references/pwsh/catzc-base-module-system/types/ArtifactsTarget.cs.md
          - docs/references/pwsh/catzc-base-module-system/types/DependenciesConfig.cs.md
          - docs/references/pwsh/catzc-base-module-system/types/FilesConfig.cs.md
          - docs/references/pwsh/catzc-base-module-system/types/ModuleFiles.cs.md
          - docs/references/pwsh/catzc-base-module-system/types/ProfilesConfig.cs.md
          - docs/references/pwsh/catzc-base-objects/tests/types/ConsoleText.Tests.ps1.md
          - docs/references/pwsh/catzc-base-objects/types/TypeShape.cs.md
          - docs/references/pwsh/catzc-base-quality-gates/configs/analyzer-drs-map.yml.md
          - docs/references/pwsh/catzc-base-quality-gates/private/Get-MarkdownHeadingFinding.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/types/AnalyzerDrsMapConfig.cs.md
          - docs/references/pwsh/catzc-base-quality-gates/types/CommentFileResult.cs.md
          - docs/references/pwsh/catzc-base-quality-gates/types/CommentsConfig.cs.md
          - docs/references/pwsh/catzc-base-quality-gates/types/EngineSetCheck.cs.md
          - docs/references/pwsh/catzc-base-quality-gates/types/GuidsConfig.cs.md
          - docs/references/pwsh/catzc-base-quality-gates/types/LinksConfig.cs.md
          - docs/references/pwsh/catzc-base-quality-gates/types/ManagedGuidEntry.cs.md
          - docs/references/pwsh/catzc-base-quality-gates/types/ParameterConsistencyConfig.cs.md
          - docs/references/pwsh/catzc-base-quality-gates/types/SourceCheck.cs.md
          - docs/references/pwsh/catzc-base-quality-gates/types/SourceConventionsConfig.cs.md
          - docs/references/pwsh/catzc-base-quality-gates/types/SpellingOracle.cs.md
          - docs/references/pwsh/catzc-base-quality-gates/types/TestPolicyConfig.cs.md
          - docs/references/pwsh/catzc-base-reports/types/OutputFormat.cs.md
          - docs/references/pwsh/catzc-base-reports/types/OutputFormatsConfig.cs.md
          - docs/references/pwsh/catzc-base-reports/types/ReportsConfig.cs.md
          - docs/references/pwsh/catzc-base-repository/Get-SessionActor.ps1.md
          - docs/references/pwsh/catzc-base-timeouts/types/TimeoutExemptionsConfig.cs.md
          - docs/references/pwsh/catzc-base-timeouts/types/TimeoutsConfig.cs.md
          - docs/references/pwsh/catzc-base-types-system.md
          - docs/references/pwsh/catzc-base-types-system/Assert-LoadedTypesCurrent.ps1.md
          - docs/references/pwsh/catzc-base-types-system/Invoke-BuildForVsCode.ps1.md
          - docs/references/pwsh/catzc-base-types-system/Test-LoadedTypesCurrent.ps1.md
          - docs/references/pwsh/catzc-base-variants/configs/variants.yml.md
          - docs/references/pwsh/catzc-base-variants/types/VariantAspect.cs.md
          - docs/references/pwsh/catzc-base-variants/types/VariantTrack.cs.md
          - docs/references/pwsh/catzc-base-variants/types/VariantsConfig.cs.md
          - docs/references/pwsh/catzc-base-vendor/types/VendorConfig.cs.md
          - docs/references/pwsh/catzc-base-vs-code/types/VscodeExtensionsConfig.cs.md
          - docs/references/pwsh/catzc-base-vs-code/types/VscodeLaunchConfig.cs.md
          - docs/references/pwsh/catzc-base-vs-code/types/VscodeSettingsConfig.cs.md
          - docs/references/pwsh/catzc-tooling-environment/Write-EnvironmentSet.ps1.md
          - docs/references/pwsh/catzc-tooling-inspiration/types/InspirationConfig.cs.md
          - docs/references/pwsh/catzc-tooling-inspiration/types/InspirationEntry.cs.md
          - docs/references/pwsh/catzc-tooling-key-handler/types/KeyHandlerBinding.cs.md
          - docs/references/pwsh/catzc-tooling-key-handler/types/KeyHandlerSupportedConfig.cs.md
          - docs/references/pwsh/internal/Catzc.Internal.Bootstrap.psm1.md
          - docs/references/pwsh/internal/catzc-internal-importer.md
          - docs/references/pwsh/internal/tests/Get-LoadedTypeDrift.Tests.ps1.md
          - ADR-AZ-CUSTOMER
          - ADR-AZ-DATAMOD
          - ADR-AZ-NAMING
          - ADR-BCL-TYPES
          - ADR-CONF-ADDRESSING
      - cell: infrastructure/discovery/.
        by: [infrastructure/templates/discovery/options.yml, ADR-AZ-DATAMOD]
      - cell: infrastructure/expedition/.
        by: [infrastructure/templates/expedition/options.yml, ADR-AZ-DATAMOD]
      - cell: infrastructure/foundation/.
        by: [infrastructure/templates/foundation/options.yml, ADR-AZ-DATAMOD]
      - cell: pwsh/Catzc.Azure/.
        by:
          - pwsh/Catzc.Azure/Get-AzureCustomers.ps1
          - pwsh/Catzc.Azure/Get-AzureEnvironment.ps1
          - pwsh/Catzc.Azure/Get-AzureSubscription.ps1
          - pwsh/Catzc.Azure/Get-AzureSubscriptionEnvironment.ps1
          - ADR-AZ-CUSTOMER
          - ADR-AZ-DATAMOD
      - cell: pwsh/Catzc.Azure/configs
        by: [pwsh/Catzc.Azure/configs/azure.yml, pwsh/Catzc.Azure/configs/customer.yml, ADR-AZ-CUSTOMER, ADR-AZ-DATAMOD, ADR-AZ-NAMING]
      - cell: pwsh/Catzc.Azure/tests/types
        by:
          - pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1
          - pwsh/Catzc.Azure/tests/types/CustomerConfig.Tests.ps1
          - ADR-AZ-CUSTOMER
          - ADR-AZ-DATAMOD
      - cell: pwsh/Catzc.Azure/types
        by:
          - pwsh/Catzc.Azure/types/AzureConfig.cs
          - pwsh/Catzc.Azure/types/AzureCustomer.cs
          - pwsh/Catzc.Azure/types/AzureEnvironmentRecord.cs
          - pwsh/Catzc.Azure/types/AzureSubscriptionRecord.cs
          - pwsh/Catzc.Azure/types/AzureTenantRecord.cs
          - pwsh/Catzc.Azure/types/CustomerConfig.cs
          - pwsh/Catzc.Azure/types/NetworkConfig.cs
          - pwsh/Catzc.Azure/types/NetworkEnvironment.cs
          - pwsh/Catzc.Azure/types/NetworkSubscription.cs
          - ADR-AZ-CUSTOMER
          - ADR-AZ-DATAMOD
          - ADR-AZ-NAMING
          - ADR-BCL-TYPES
      - cell: pwsh/Catzc.Azure.Cli/.
        by:
          - pwsh/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1
          - pwsh/Catzc.Azure.Cli/Assert-AzCliIsConnected.ps1
          - pwsh/Catzc.Azure.Cli/Get-AzCliSessionSubscription.ps1
          - pwsh/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1
          - ADR-AZ-DATAMOD
          - ADR-AZ-NAMING
      - cell: pwsh/Catzc.Azure.DevOps/types
        by: [pwsh/Catzc.Azure.DevOps/types/AdoConfig.cs, ADR-BCL-TYPES]
      - cell: pwsh/Catzc.Azure.DevOps.BuildValidation/configs
        by: [pwsh/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml, ADR-AZ-CUSTOMER]
      - cell: pwsh/Catzc.Azure.DevOps.BuildValidation/tests/types
        by: [pwsh/Catzc.Azure.DevOps.BuildValidation/tests/types/BuildValidationConfig.Tests.ps1, ADR-AZ-CUSTOMER]
      - cell: pwsh/Catzc.Azure.DevOps.BuildValidation/types
        by:
          - pwsh/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationConfig.cs
          - pwsh/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationEntry.cs
          - ADR-AZ-CUSTOMER
          - ADR-BCL-TYPES
      - cell: pwsh/Catzc.Azure.Templates/.
        by:
          - pwsh/Catzc.Azure.Templates/Assert-BicepTemplate.ps1
          - pwsh/Catzc.Azure.Templates/Build-Bicep.ps1
          - pwsh/Catzc.Azure.Templates/ConvertTo-BicepParam.ps1
          - pwsh/Catzc.Azure.Templates/Deploy-Bicep.ps1
          - pwsh/Catzc.Azure.Templates/Get-AzureBicepEnvironmentKinds.ps1
          - pwsh/Catzc.Azure.Templates/Get-AzureResourceName.ps1
          - pwsh/Catzc.Azure.Templates/Get-AzureResourceTypeSet.ps1
          - pwsh/Catzc.Azure.Templates/Get-BicepDeploymentContext.ps1
          - pwsh/Catzc.Azure.Templates/Get-BicepResourceName.ps1
          - pwsh/Catzc.Azure.Templates/Get-BicepTemplateConfiguration.ps1
          - pwsh/Catzc.Azure.Templates/Get-BicepTemplates.ps1
          - pwsh/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1
          - ADR-AZ-CUSTOMER
          - ADR-AZ-DATAMOD
          - ADR-AZ-NAMING
      - cell: pwsh/Catzc.Azure.Templates/configs
        by: [pwsh/Catzc.Azure.Templates/configs/glossary.yml, ADR-AZ-DATAMOD]
      - cell: pwsh/Catzc.Azure.Templates/private
        by:
          - pwsh/Catzc.Azure.Templates/private/Get-BicepConfigClassViolations.ps1
          - pwsh/Catzc.Azure.Templates/private/Get-BicepConfigName.ps1
          - pwsh/Catzc.Azure.Templates/private/Get-BicepConfigSubscriptionCandidates.ps1
          - pwsh/Catzc.Azure.Templates/private/Get-BicepCustomerClassViolations.ps1
          - pwsh/Catzc.Azure.Templates/private/Get-BicepParametersFileName.ps1
          - pwsh/Catzc.Azure.Templates/private/Get-BicepSubscriptionConfigViolations.ps1
          - pwsh/Catzc.Azure.Templates/private/Resolve-BicepConfigName.ps1
          - pwsh/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1
          - ADR-AZ-CUSTOMER
          - ADR-AZ-DATAMOD
          - ADR-CONF-ADDRESSING
      - cell: pwsh/Catzc.Azure.Templates/tests
        by:
          - pwsh/Catzc.Azure.Templates/tests/Assert-BicepTemplate.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Get-BicepTemplates.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1
          - ADR-AZ-DATAMOD
          - ADR-AZ-NAMING
      - cell: pwsh/Catzc.Azure.Templates/tests/types
        by: [pwsh/Catzc.Azure.Templates/tests/types/BicepShortName.Tests.ps1, ADR-AZ-NAMING]
      - cell: pwsh/Catzc.Azure.Templates/types
        by:
          - pwsh/Catzc.Azure.Templates/types/BicepParamWriter.cs
          - pwsh/Catzc.Azure.Templates/types/BicepParameter.cs
          - pwsh/Catzc.Azure.Templates/types/BicepParameterModel.cs
          - pwsh/Catzc.Azure.Templates/types/BicepShortName.cs
          - pwsh/Catzc.Azure.Templates/types/BicepSlot.cs
          - pwsh/Catzc.Azure.Templates/types/BicepTemplate.cs
          - ADR-AZ-CUSTOMER
          - ADR-AZ-DATAMOD
          - ADR-AZ-NAMING
          - ADR-BCL-TYPES
      - cell: pwsh/Catzc.Base.CodeMeta/types
        by: [pwsh/Catzc.Base.CodeMeta/types/CommentPageMap.cs, ADR-BCL-TYPES]
      - cell: pwsh/Catzc.Base.Config/.
        by: [pwsh/Catzc.Base.Config/Get-Config.ps1, pwsh/Catzc.Base.Config/Get-ConfigValue.ps1, ADR-CONF-ADDRESSING]
      - cell: pwsh/Catzc.Base.Config/private
        by: [pwsh/Catzc.Base.Config/private/Resolve-ConfigKeyPath.ps1, ADR-CONF-ADDRESSING]
      - cell: pwsh/Catzc.Base.Config/tests
        by: [pwsh/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1, ADR-CONF-ADDRESSING]
      - cell: pwsh/Catzc.Base.Contracts/tests/types
        by: [pwsh/Catzc.Base.Contracts/tests/types/ContractCheckResult.Tests.ps1, ADR-BCL-TYPES]
      - cell: pwsh/Catzc.Base.Contracts/types
        by:
          - pwsh/Catzc.Base.Contracts/types/ContractAsset.cs
          - pwsh/Catzc.Base.Contracts/types/ContractCheckResult.cs
          - pwsh/Catzc.Base.Contracts/types/ContractCommand.cs
          - pwsh/Catzc.Base.Contracts/types/ContractManifest.cs
          - pwsh/Catzc.Base.Contracts/types/ContractsConfig.cs
          - ADR-BCL-TYPES
      - cell: pwsh/Catzc.Base.Docs/configs
        by: [pwsh/Catzc.Base.Docs/configs/capabilities.yml, ADR-BCL-TYPES]
      - cell: pwsh/Catzc.Base.Docs/types
        by:
          - pwsh/Catzc.Base.Docs/types/AgentEntry.cs
          - pwsh/Catzc.Base.Docs/types/AgentsConfig.cs
          - pwsh/Catzc.Base.Docs/types/CapabilitiesConfig.cs
          - pwsh/Catzc.Base.Docs/types/CapabilityEntry.cs
          - pwsh/Catzc.Base.Docs/types/GlossaryAvoid.cs
          - pwsh/Catzc.Base.Docs/types/GlossaryConcept.cs
          - pwsh/Catzc.Base.Docs/types/GlossaryConfig.cs
          - pwsh/Catzc.Base.Docs/types/GlossaryEntry.cs
          - pwsh/Catzc.Base.Docs/types/GlossaryOptions.cs
          - pwsh/Catzc.Base.Docs/types/GlossaryRealization.cs
          - ADR-AZ-CUSTOMER
          - ADR-BCL-TYPES
      - cell: pwsh/Catzc.Base.Drs/configs
        by:
          - pwsh/Catzc.Base.Drs/configs/drs-index.yml
          - pwsh/Catzc.Base.Drs/configs/drs.yml
          - ADR-AZ-CUSTOMER
          - ADR-AZ-DATAMOD
          - ADR-AZ-NAMING
          - ADR-BCL-TYPES
          - ADR-CONF-ADDRESSING
      - cell: pwsh/Catzc.Base.Drs/tests/types
        by:
          - pwsh/Catzc.Base.Drs/tests/types/DrsChecksConfig.Tests.ps1
          - pwsh/Catzc.Base.Drs/tests/types/DrsCodeForm.Tests.ps1
          - pwsh/Catzc.Base.Drs/tests/types/DrsConfig.Tests.ps1
          - pwsh/Catzc.Base.Drs/tests/types/DrsDomainEdge.Tests.ps1
          - ADR-BCL-TYPES
      - cell: pwsh/Catzc.Base.Drs/types
        by:
          - pwsh/Catzc.Base.Drs/types/DrsCheck.cs
          - pwsh/Catzc.Base.Drs/types/DrsChecksConfig.cs
          - pwsh/Catzc.Base.Drs/types/DrsCitationChange.cs
          - pwsh/Catzc.Base.Drs/types/DrsCitationChangeKind.cs
          - pwsh/Catzc.Base.Drs/types/DrsCitationRewrite.cs
          - pwsh/Catzc.Base.Drs/types/DrsConfig.cs
          - pwsh/Catzc.Base.Drs/types/DrsDomain.cs
          - pwsh/Catzc.Base.Drs/types/DrsDomainEdge.cs
          - pwsh/Catzc.Base.Drs/types/DrsDoraCheck.cs
          - pwsh/Catzc.Base.Drs/types/DrsNeutralityCheck.cs
          - pwsh/Catzc.Base.Drs/types/DrsNeutralityToken.cs
          - pwsh/Catzc.Base.Drs/types/DrsRuleSet.cs
          - ADR-AZ-CUSTOMER
          - ADR-BCL-TYPES
      - cell: pwsh/Catzc.Base.Engines/types
        by: [pwsh/Catzc.Base.Engines/types/ExecutionEngine.cs, ADR-BCL-TYPES]
      - cell: pwsh/Catzc.Base.Exporter/types
        by:
          - pwsh/Catzc.Base.Exporter/types/ExporterBundle.cs
          - pwsh/Catzc.Base.Exporter/types/ExporterConfig.cs
          - pwsh/Catzc.Base.Exporter/types/ExporterPackage.cs
          - ADR-BCL-TYPES
      - cell: pwsh/Catzc.Base.Folders/tests/types
        by: [pwsh/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1, ADR-CONF-ADDRESSING]
      - cell: pwsh/Catzc.Base.Languages/.
        by: [pwsh/Catzc.Base.Languages/New-GoWorkspace.ps1, pwsh/Catzc.Base.Languages/New-PythonProject.ps1, ADR-CONF-ADDRESSING]
      - cell: pwsh/Catzc.Base.Languages/tests/types
        by: [pwsh/Catzc.Base.Languages/tests/types/BclConfig.Tests.ps1, ADR-BCL-TYPES]
      - cell: pwsh/Catzc.Base.Languages/types
        by:
          - pwsh/Catzc.Base.Languages/types/BashConfig.cs
          - pwsh/Catzc.Base.Languages/types/BashTestResult.cs
          - pwsh/Catzc.Base.Languages/types/BclConfig.cs
          - pwsh/Catzc.Base.Languages/types/BclHostBinding.cs
          - pwsh/Catzc.Base.Languages/types/FileCarrier.cs
          - pwsh/Catzc.Base.Languages/types/FileLanguage.cs
          - pwsh/Catzc.Base.Languages/types/FormatterEngine.cs
          - pwsh/Catzc.Base.Languages/types/GoConfig.cs
          - pwsh/Catzc.Base.Languages/types/GoTestResult.cs
          - pwsh/Catzc.Base.Languages/types/GoWorkspaceFile.cs
          - pwsh/Catzc.Base.Languages/types/LanguagesConfig.cs
          - pwsh/Catzc.Base.Languages/types/LayoutRow.cs
          - pwsh/Catzc.Base.Languages/types/PythonConfig.cs
          - pwsh/Catzc.Base.Languages/types/PythonTestResult.cs
          - pwsh/Catzc.Base.Languages/types/PythonWorkspaceFile.cs
          - ADR-BCL-TYPES
      - cell: pwsh/Catzc.Base.Maps/.
        by: [pwsh/Catzc.Base.Maps/Get-TrackPlacementMinimapData.ps1, ADR-AZ-NAMING]
      - cell: pwsh/Catzc.Base.Maps/types
        by:
          - pwsh/Catzc.Base.Maps/types/CitationSite.cs
          - pwsh/Catzc.Base.Maps/types/HighlightReason.cs
          - pwsh/Catzc.Base.Maps/types/HighlightedCell.cs
          - pwsh/Catzc.Base.Maps/types/MapCell.cs
          - pwsh/Catzc.Base.Maps/types/MapPlacement.cs
          - pwsh/Catzc.Base.Maps/types/MapsConfig.cs
          - pwsh/Catzc.Base.Maps/types/MapsHighlight.cs
          - pwsh/Catzc.Base.Maps/types/MapsLabels.cs
          - pwsh/Catzc.Base.Maps/types/MapsLimits.cs
          - pwsh/Catzc.Base.Maps/types/MapsPalette.cs
          - pwsh/Catzc.Base.Maps/types/MapsPin.cs
          - pwsh/Catzc.Base.Maps/types/TreemapRect.cs
          - pwsh/Catzc.Base.Maps/types/ValueChainCell.cs
          - pwsh/Catzc.Base.Maps/types/ValueChainReason.cs
          - pwsh/Catzc.Base.Maps/types/WorldMapBuilder.cs
          - pwsh/Catzc.Base.Maps/types/WorldMapGridLayout.cs
          - ADR-BCL-TYPES
      - cell: pwsh/Catzc.Base.Modules/tests/types
        by: [pwsh/Catzc.Base.Modules/tests/types/Module.Tests.ps1, ADR-BCL-TYPES]
      - cell: pwsh/Catzc.Base.Modules/types
        by: [pwsh/Catzc.Base.Modules/types/Module.cs, ADR-BCL-TYPES]
      - cell: pwsh/Catzc.Base.ModuleSystem/.
        by: [pwsh/Catzc.Base.ModuleSystem/Copy-CatzcModule.ps1, pwsh/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1, ADR-BCL-TYPES]
      - cell: pwsh/Catzc.Base.ModuleSystem/tests
        by: [pwsh/Catzc.Base.ModuleSystem/tests/Sync-GeneratedFile.Tests.ps1, ADR-BCL-TYPES]
      - cell: pwsh/Catzc.Base.ModuleSystem/types
        by:
          - pwsh/Catzc.Base.ModuleSystem/types/ArtifactsConfig.cs
          - pwsh/Catzc.Base.ModuleSystem/types/ArtifactsTarget.cs
          - pwsh/Catzc.Base.ModuleSystem/types/DependenciesConfig.cs
          - pwsh/Catzc.Base.ModuleSystem/types/FilesConfig.cs
          - pwsh/Catzc.Base.ModuleSystem/types/ModuleFiles.cs
          - pwsh/Catzc.Base.ModuleSystem/types/ProfilesConfig.cs
          - ADR-BCL-TYPES
      - cell: pwsh/Catzc.Base.Objects/tests/types
        by:
          - pwsh/Catzc.Base.Objects/tests/types/ConsoleText.Tests.ps1
          - pwsh/Catzc.Base.Objects/tests/types/DictionaryRecord.Tests.ps1
          - ADR-BCL-TYPES
      - cell: pwsh/Catzc.Base.Objects/types
        by: [pwsh/Catzc.Base.Objects/types/TypeShape.cs, ADR-BCL-TYPES]
      - cell: pwsh/Catzc.Base.QualityGates/configs
        by: [pwsh/Catzc.Base.QualityGates/configs/analyzer-drs-map.yml, ADR-AZ-CUSTOMER]
      - cell: pwsh/Catzc.Base.QualityGates/private
        by: [pwsh/Catzc.Base.QualityGates/private/Get-MarkdownHeadingFinding.ps1, ADR-AZ-DATAMOD]
      - cell: pwsh/Catzc.Base.QualityGates/types
        by:
          - pwsh/Catzc.Base.QualityGates/types/AnalyzerDrsMapConfig.cs
          - pwsh/Catzc.Base.QualityGates/types/CommentBlock.cs
          - pwsh/Catzc.Base.QualityGates/types/CommentFileResult.cs
          - pwsh/Catzc.Base.QualityGates/types/CommentsConfig.cs
          - pwsh/Catzc.Base.QualityGates/types/EngineSetCheck.cs
          - pwsh/Catzc.Base.QualityGates/types/GuidsConfig.cs
          - pwsh/Catzc.Base.QualityGates/types/LinksConfig.cs
          - pwsh/Catzc.Base.QualityGates/types/ManagedGuidEntry.cs
          - pwsh/Catzc.Base.QualityGates/types/ParameterConsistencyConfig.cs
          - pwsh/Catzc.Base.QualityGates/types/SourceCheck.cs
          - pwsh/Catzc.Base.QualityGates/types/SourceConventionsConfig.cs
          - pwsh/Catzc.Base.QualityGates/types/SpellingOracle.cs
          - pwsh/Catzc.Base.QualityGates/types/TestPolicyConfig.cs
          - ADR-AZ-CUSTOMER
          - ADR-BCL-TYPES
      - cell: pwsh/Catzc.Base.Reports/tests/types
        by:
          - pwsh/Catzc.Base.Reports/tests/types/IsolationRunResult.Tests.ps1
          - pwsh/Catzc.Base.Reports/tests/types/QualityGateResult.Tests.ps1
          - pwsh/Catzc.Base.Reports/tests/types/TestRunResult.Tests.ps1
          - ADR-BCL-TYPES
      - cell: pwsh/Catzc.Base.Reports/types
        by:
          - pwsh/Catzc.Base.Reports/types/IsolationRunResult.cs
          - pwsh/Catzc.Base.Reports/types/OutputFormat.cs
          - pwsh/Catzc.Base.Reports/types/OutputFormatsConfig.cs
          - pwsh/Catzc.Base.Reports/types/OutputPattern.cs
          - pwsh/Catzc.Base.Reports/types/QualityGateResult.cs
          - pwsh/Catzc.Base.Reports/types/ReportsConfig.cs
          - pwsh/Catzc.Base.Reports/types/TestRunResult.cs
          - ADR-BCL-TYPES
      - cell: pwsh/Catzc.Base.Repository/.
        by: [pwsh/Catzc.Base.Repository/Get-SessionActor.ps1, ADR-BCL-TYPES]
      - cell: pwsh/Catzc.Base.Repository/tests
        by: [pwsh/Catzc.Base.Repository/tests/Get-SessionActor.Tests.ps1, ADR-BCL-TYPES]
      - cell: pwsh/Catzc.Base.RootConfig/assets/root
        by: [pwsh/Catzc.Base.RootConfig/assets/root/cspell.yml, ADR-AZ-DATAMOD]
      - cell: pwsh/Catzc.Base.Timeouts/types
        by: [pwsh/Catzc.Base.Timeouts/types/TimeoutExemptionsConfig.cs, pwsh/Catzc.Base.Timeouts/types/TimeoutsConfig.cs, ADR-BCL-TYPES]
      - cell: pwsh/Catzc.Base.TypesSystem/.
        by:
          - pwsh/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1
          - pwsh/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1
          - pwsh/Catzc.Base.TypesSystem/Test-LoadedTypesCurrent.ps1
          - ADR-BCL-TYPES
      - cell: pwsh/Catzc.Base.TypesSystem/tests
        by:
          - pwsh/Catzc.Base.TypesSystem/tests/Assert-LoadedTypesCurrent.Tests.ps1
          - pwsh/Catzc.Base.TypesSystem/tests/Test-LoadedTypesCurrent.Tests.ps1
          - ADR-BCL-TYPES
      - cell: pwsh/Catzc.Base.Variants/configs
        by: [pwsh/Catzc.Base.Variants/configs/variants.yml, ADR-AZ-CUSTOMER, ADR-AZ-NAMING]
      - cell: pwsh/Catzc.Base.Variants/types
        by:
          - pwsh/Catzc.Base.Variants/types/VariantAspect.cs
          - pwsh/Catzc.Base.Variants/types/VariantTrack.cs
          - pwsh/Catzc.Base.Variants/types/VariantsConfig.cs
          - ADR-BCL-TYPES
      - cell: pwsh/Catzc.Base.Vendor/types
        by: [pwsh/Catzc.Base.Vendor/types/VendorConfig.cs, ADR-BCL-TYPES]
      - cell: pwsh/Catzc.Base.VSCode/types
        by:
          - pwsh/Catzc.Base.VSCode/types/VscodeExtensionsConfig.cs
          - pwsh/Catzc.Base.VSCode/types/VscodeLaunchConfig.cs
          - pwsh/Catzc.Base.VSCode/types/VscodeOwnExtension.cs
          - pwsh/Catzc.Base.VSCode/types/VscodeSettingsConfig.cs
          - pwsh/Catzc.Base.VSCode/types/VscodeTasksConfig.cs
          - ADR-BCL-TYPES
      - cell: pwsh/Catzc.Internal.Tests/.
        by:
          - pwsh/.internal/tests/Enable-DeferredJanitors.Tests.ps1
          - pwsh/.internal/tests/Get-CombinedTypeHash.Tests.ps1
          - pwsh/.internal/tests/Get-LoadedTypeDrift.Tests.ps1
          - ADR-BCL-TYPES
      - cell: pwsh/Catzc.Tooling.Environment/.
        by: [pwsh/Catzc.Tooling.Environment/Write-EnvironmentSet.ps1, ADR-CONF-ADDRESSING]
      - cell: pwsh/Catzc.Tooling.Inspiration/types
        by:
          - pwsh/Catzc.Tooling.Inspiration/types/InspirationConfig.cs
          - pwsh/Catzc.Tooling.Inspiration/types/InspirationEntry.cs
          - ADR-BCL-TYPES
      - cell: pwsh/Catzc.Tooling.KeyHandler/types
        by:
          - pwsh/Catzc.Tooling.KeyHandler/types/KeyHandlerBinding.cs
          - pwsh/Catzc.Tooling.KeyHandler/types/KeyHandlerSupportedConfig.cs
          - ADR-BCL-TYPES
    module-neighbourhood:
      - cell: subject/.claude
        by: [.claude/skills/catzc-module/SKILL.md, ADR-BCL-TYPES]
      - cell: subject/Catzc.Azure
        by:
          - pwsh/Catzc.Azure/Get-AzureCustomers.ps1
          - pwsh/Catzc.Azure/Get-AzureEnvironment.ps1
          - pwsh/Catzc.Azure/Get-AzureSubscription.ps1
          - pwsh/Catzc.Azure/Get-AzureSubscriptionEnvironment.ps1
          - pwsh/Catzc.Azure/configs/azure.yml
          - pwsh/Catzc.Azure/configs/customer.yml
          - pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1
          - pwsh/Catzc.Azure/tests/types/CustomerConfig.Tests.ps1
          - pwsh/Catzc.Azure/types/AzureConfig.cs
          - pwsh/Catzc.Azure/types/AzureCustomer.cs
          - pwsh/Catzc.Azure/types/AzureEnvironmentRecord.cs
          - pwsh/Catzc.Azure/types/AzureSubscriptionRecord.cs
          - pwsh/Catzc.Azure/types/AzureTenantRecord.cs
          - pwsh/Catzc.Azure/types/CustomerConfig.cs
          - pwsh/Catzc.Azure/types/NetworkConfig.cs
          - pwsh/Catzc.Azure/types/NetworkEnvironment.cs
          - pwsh/Catzc.Azure/types/NetworkSubscription.cs
          - ADR-AZ-CUSTOMER
          - ADR-AZ-DATAMOD
          - ADR-AZ-NAMING
          - ADR-BCL-TYPES
      - cell: subject/Catzc.Azure.Cli
        by:
          - pwsh/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1
          - pwsh/Catzc.Azure.Cli/Assert-AzCliIsConnected.ps1
          - pwsh/Catzc.Azure.Cli/Get-AzCliSessionSubscription.ps1
          - pwsh/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1
          - ADR-AZ-DATAMOD
          - ADR-AZ-NAMING
      - cell: subject/Catzc.Azure.DevOps
        by: [pwsh/Catzc.Azure.DevOps/types/AdoConfig.cs, ADR-BCL-TYPES]
      - cell: subject/Catzc.Azure.DevOps.BuildValidation
        by:
          - pwsh/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml
          - pwsh/Catzc.Azure.DevOps.BuildValidation/tests/types/BuildValidationConfig.Tests.ps1
          - pwsh/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationConfig.cs
          - pwsh/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationEntry.cs
          - ADR-AZ-CUSTOMER
          - ADR-BCL-TYPES
      - cell: subject/Catzc.Azure.Templates
        by:
          - pwsh/Catzc.Azure.Templates/Assert-BicepTemplate.ps1
          - pwsh/Catzc.Azure.Templates/Build-Bicep.ps1
          - pwsh/Catzc.Azure.Templates/ConvertTo-BicepParam.ps1
          - pwsh/Catzc.Azure.Templates/Deploy-Bicep.ps1
          - pwsh/Catzc.Azure.Templates/Get-AzureBicepEnvironmentKinds.ps1
          - pwsh/Catzc.Azure.Templates/Get-AzureResourceName.ps1
          - pwsh/Catzc.Azure.Templates/Get-AzureResourceTypeSet.ps1
          - pwsh/Catzc.Azure.Templates/Get-BicepDeploymentContext.ps1
          - pwsh/Catzc.Azure.Templates/Get-BicepResourceName.ps1
          - pwsh/Catzc.Azure.Templates/Get-BicepTemplateConfiguration.ps1
          - pwsh/Catzc.Azure.Templates/Get-BicepTemplates.ps1
          - pwsh/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1
          - pwsh/Catzc.Azure.Templates/configs/glossary.yml
          - pwsh/Catzc.Azure.Templates/private/Get-BicepConfigClassViolations.ps1
          - pwsh/Catzc.Azure.Templates/private/Get-BicepConfigName.ps1
          - pwsh/Catzc.Azure.Templates/private/Get-BicepConfigSubscriptionCandidates.ps1
          - pwsh/Catzc.Azure.Templates/private/Get-BicepCustomerClassViolations.ps1
          - pwsh/Catzc.Azure.Templates/private/Get-BicepParametersFileName.ps1
          - pwsh/Catzc.Azure.Templates/private/Get-BicepSubscriptionConfigViolations.ps1
          - pwsh/Catzc.Azure.Templates/private/Resolve-BicepConfigName.ps1
          - pwsh/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1
          - pwsh/Catzc.Azure.Templates/tests/Assert-BicepTemplate.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Get-BicepTemplates.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/types/BicepShortName.Tests.ps1
          - pwsh/Catzc.Azure.Templates/types/BicepParamWriter.cs
          - pwsh/Catzc.Azure.Templates/types/BicepParameter.cs
          - pwsh/Catzc.Azure.Templates/types/BicepParameterModel.cs
          - pwsh/Catzc.Azure.Templates/types/BicepShortName.cs
          - pwsh/Catzc.Azure.Templates/types/BicepSlot.cs
          - pwsh/Catzc.Azure.Templates/types/BicepTemplate.cs
          - ADR-AZ-CUSTOMER
          - ADR-AZ-DATAMOD
          - ADR-AZ-NAMING
          - ADR-BCL-TYPES
          - ADR-CONF-ADDRESSING
      - cell: subject/Catzc.Base.CodeMeta
        by: [pwsh/Catzc.Base.CodeMeta/types/CommentPageMap.cs, ADR-BCL-TYPES]
      - cell: subject/Catzc.Base.Config
        by:
          - pwsh/Catzc.Base.Config/Get-Config.ps1
          - pwsh/Catzc.Base.Config/Get-ConfigValue.ps1
          - pwsh/Catzc.Base.Config/private/Resolve-ConfigKeyPath.ps1
          - pwsh/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1
          - ADR-CONF-ADDRESSING
      - cell: subject/Catzc.Base.Contracts
        by:
          - pwsh/Catzc.Base.Contracts/tests/types/ContractCheckResult.Tests.ps1
          - pwsh/Catzc.Base.Contracts/types/ContractAsset.cs
          - pwsh/Catzc.Base.Contracts/types/ContractCheckResult.cs
          - pwsh/Catzc.Base.Contracts/types/ContractCommand.cs
          - pwsh/Catzc.Base.Contracts/types/ContractManifest.cs
          - pwsh/Catzc.Base.Contracts/types/ContractsConfig.cs
          - ADR-BCL-TYPES
      - cell: subject/Catzc.Base.Docs
        by:
          - pwsh/Catzc.Base.Docs/configs/capabilities.yml
          - pwsh/Catzc.Base.Docs/types/AgentEntry.cs
          - pwsh/Catzc.Base.Docs/types/AgentsConfig.cs
          - pwsh/Catzc.Base.Docs/types/CapabilitiesConfig.cs
          - pwsh/Catzc.Base.Docs/types/CapabilityEntry.cs
          - pwsh/Catzc.Base.Docs/types/GlossaryAvoid.cs
          - pwsh/Catzc.Base.Docs/types/GlossaryConcept.cs
          - pwsh/Catzc.Base.Docs/types/GlossaryConfig.cs
          - pwsh/Catzc.Base.Docs/types/GlossaryEntry.cs
          - pwsh/Catzc.Base.Docs/types/GlossaryOptions.cs
          - pwsh/Catzc.Base.Docs/types/GlossaryRealization.cs
          - ADR-AZ-CUSTOMER
          - ADR-BCL-TYPES
      - cell: subject/Catzc.Base.Drs
        by:
          - pwsh/Catzc.Base.Drs/configs/drs-index.yml
          - pwsh/Catzc.Base.Drs/configs/drs.yml
          - pwsh/Catzc.Base.Drs/tests/types/DrsChecksConfig.Tests.ps1
          - pwsh/Catzc.Base.Drs/tests/types/DrsCodeForm.Tests.ps1
          - pwsh/Catzc.Base.Drs/tests/types/DrsConfig.Tests.ps1
          - pwsh/Catzc.Base.Drs/tests/types/DrsDomainEdge.Tests.ps1
          - pwsh/Catzc.Base.Drs/types/DrsCheck.cs
          - pwsh/Catzc.Base.Drs/types/DrsChecksConfig.cs
          - pwsh/Catzc.Base.Drs/types/DrsCitationChange.cs
          - pwsh/Catzc.Base.Drs/types/DrsCitationChangeKind.cs
          - pwsh/Catzc.Base.Drs/types/DrsCitationRewrite.cs
          - pwsh/Catzc.Base.Drs/types/DrsConfig.cs
          - pwsh/Catzc.Base.Drs/types/DrsDomain.cs
          - pwsh/Catzc.Base.Drs/types/DrsDomainEdge.cs
          - pwsh/Catzc.Base.Drs/types/DrsDoraCheck.cs
          - pwsh/Catzc.Base.Drs/types/DrsNeutralityCheck.cs
          - pwsh/Catzc.Base.Drs/types/DrsNeutralityToken.cs
          - pwsh/Catzc.Base.Drs/types/DrsRuleSet.cs
          - ADR-AZ-CUSTOMER
          - ADR-AZ-DATAMOD
          - ADR-AZ-NAMING
          - ADR-BCL-TYPES
          - ADR-CONF-ADDRESSING
      - cell: subject/Catzc.Base.Engines
        by: [pwsh/Catzc.Base.Engines/types/ExecutionEngine.cs, ADR-BCL-TYPES]
      - cell: subject/Catzc.Base.Exporter
        by:
          - pwsh/Catzc.Base.Exporter/types/ExporterBundle.cs
          - pwsh/Catzc.Base.Exporter/types/ExporterConfig.cs
          - pwsh/Catzc.Base.Exporter/types/ExporterPackage.cs
          - ADR-BCL-TYPES
      - cell: subject/Catzc.Base.Folders
        by: [pwsh/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1, ADR-CONF-ADDRESSING]
      - cell: subject/Catzc.Base.Languages
        by:
          - pwsh/Catzc.Base.Languages/New-GoWorkspace.ps1
          - pwsh/Catzc.Base.Languages/New-PythonProject.ps1
          - pwsh/Catzc.Base.Languages/tests/types/BclConfig.Tests.ps1
          - pwsh/Catzc.Base.Languages/types/BashConfig.cs
          - pwsh/Catzc.Base.Languages/types/BashTestResult.cs
          - pwsh/Catzc.Base.Languages/types/BclConfig.cs
          - pwsh/Catzc.Base.Languages/types/BclHostBinding.cs
          - pwsh/Catzc.Base.Languages/types/FileCarrier.cs
          - pwsh/Catzc.Base.Languages/types/FileLanguage.cs
          - pwsh/Catzc.Base.Languages/types/FormatterEngine.cs
          - pwsh/Catzc.Base.Languages/types/GoConfig.cs
          - pwsh/Catzc.Base.Languages/types/GoTestResult.cs
          - pwsh/Catzc.Base.Languages/types/GoWorkspaceFile.cs
          - pwsh/Catzc.Base.Languages/types/LanguagesConfig.cs
          - pwsh/Catzc.Base.Languages/types/LayoutRow.cs
          - pwsh/Catzc.Base.Languages/types/PythonConfig.cs
          - pwsh/Catzc.Base.Languages/types/PythonTestResult.cs
          - pwsh/Catzc.Base.Languages/types/PythonWorkspaceFile.cs
          - ADR-BCL-TYPES
          - ADR-CONF-ADDRESSING
      - cell: subject/Catzc.Base.Maps
        by:
          - pwsh/Catzc.Base.Maps/Get-TrackPlacementMinimapData.ps1
          - pwsh/Catzc.Base.Maps/types/CitationSite.cs
          - pwsh/Catzc.Base.Maps/types/HighlightReason.cs
          - pwsh/Catzc.Base.Maps/types/HighlightedCell.cs
          - pwsh/Catzc.Base.Maps/types/MapCell.cs
          - pwsh/Catzc.Base.Maps/types/MapPlacement.cs
          - pwsh/Catzc.Base.Maps/types/MapsConfig.cs
          - pwsh/Catzc.Base.Maps/types/MapsHighlight.cs
          - pwsh/Catzc.Base.Maps/types/MapsLabels.cs
          - pwsh/Catzc.Base.Maps/types/MapsLimits.cs
          - pwsh/Catzc.Base.Maps/types/MapsPalette.cs
          - pwsh/Catzc.Base.Maps/types/MapsPin.cs
          - pwsh/Catzc.Base.Maps/types/TreemapRect.cs
          - pwsh/Catzc.Base.Maps/types/ValueChainCell.cs
          - pwsh/Catzc.Base.Maps/types/ValueChainReason.cs
          - pwsh/Catzc.Base.Maps/types/WorldMapBuilder.cs
          - pwsh/Catzc.Base.Maps/types/WorldMapGridLayout.cs
          - ADR-AZ-NAMING
          - ADR-BCL-TYPES
      - cell: subject/Catzc.Base.ModuleSystem
        by:
          - pwsh/Catzc.Base.ModuleSystem/Copy-CatzcModule.ps1
          - pwsh/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1
          - pwsh/Catzc.Base.ModuleSystem/tests/Sync-GeneratedFile.Tests.ps1
          - pwsh/Catzc.Base.ModuleSystem/types/ArtifactsConfig.cs
          - pwsh/Catzc.Base.ModuleSystem/types/ArtifactsTarget.cs
          - pwsh/Catzc.Base.ModuleSystem/types/DependenciesConfig.cs
          - pwsh/Catzc.Base.ModuleSystem/types/FilesConfig.cs
          - pwsh/Catzc.Base.ModuleSystem/types/ModuleFiles.cs
          - pwsh/Catzc.Base.ModuleSystem/types/ProfilesConfig.cs
          - ADR-BCL-TYPES
      - cell: subject/Catzc.Base.Modules
        by: [pwsh/Catzc.Base.Modules/tests/types/Module.Tests.ps1, pwsh/Catzc.Base.Modules/types/Module.cs, ADR-BCL-TYPES]
      - cell: subject/Catzc.Base.Objects
        by:
          - pwsh/Catzc.Base.Objects/tests/types/ConsoleText.Tests.ps1
          - pwsh/Catzc.Base.Objects/tests/types/DictionaryRecord.Tests.ps1
          - pwsh/Catzc.Base.Objects/types/TypeShape.cs
          - ADR-BCL-TYPES
      - cell: subject/Catzc.Base.QualityGates
        by:
          - pwsh/Catzc.Base.QualityGates/configs/analyzer-drs-map.yml
          - pwsh/Catzc.Base.QualityGates/private/Get-MarkdownHeadingFinding.ps1
          - pwsh/Catzc.Base.QualityGates/types/AnalyzerDrsMapConfig.cs
          - pwsh/Catzc.Base.QualityGates/types/CommentBlock.cs
          - pwsh/Catzc.Base.QualityGates/types/CommentFileResult.cs
          - pwsh/Catzc.Base.QualityGates/types/CommentsConfig.cs
          - pwsh/Catzc.Base.QualityGates/types/EngineSetCheck.cs
          - pwsh/Catzc.Base.QualityGates/types/GuidsConfig.cs
          - pwsh/Catzc.Base.QualityGates/types/LinksConfig.cs
          - pwsh/Catzc.Base.QualityGates/types/ManagedGuidEntry.cs
          - pwsh/Catzc.Base.QualityGates/types/ParameterConsistencyConfig.cs
          - pwsh/Catzc.Base.QualityGates/types/SourceCheck.cs
          - pwsh/Catzc.Base.QualityGates/types/SourceConventionsConfig.cs
          - pwsh/Catzc.Base.QualityGates/types/SpellingOracle.cs
          - pwsh/Catzc.Base.QualityGates/types/TestPolicyConfig.cs
          - ADR-AZ-CUSTOMER
          - ADR-AZ-DATAMOD
          - ADR-BCL-TYPES
      - cell: subject/Catzc.Base.Reports
        by:
          - pwsh/Catzc.Base.Reports/tests/types/IsolationRunResult.Tests.ps1
          - pwsh/Catzc.Base.Reports/tests/types/QualityGateResult.Tests.ps1
          - pwsh/Catzc.Base.Reports/tests/types/TestRunResult.Tests.ps1
          - pwsh/Catzc.Base.Reports/types/IsolationRunResult.cs
          - pwsh/Catzc.Base.Reports/types/OutputFormat.cs
          - pwsh/Catzc.Base.Reports/types/OutputFormatsConfig.cs
          - pwsh/Catzc.Base.Reports/types/OutputPattern.cs
          - pwsh/Catzc.Base.Reports/types/QualityGateResult.cs
          - pwsh/Catzc.Base.Reports/types/ReportsConfig.cs
          - pwsh/Catzc.Base.Reports/types/TestRunResult.cs
          - ADR-BCL-TYPES
      - cell: subject/Catzc.Base.Repository
        by: [pwsh/Catzc.Base.Repository/Get-SessionActor.ps1, pwsh/Catzc.Base.Repository/tests/Get-SessionActor.Tests.ps1, ADR-BCL-TYPES]
      - cell: subject/Catzc.Base.RootConfig
        by: [pwsh/Catzc.Base.RootConfig/assets/root/cspell.yml, ADR-AZ-DATAMOD]
      - cell: subject/Catzc.Base.Timeouts
        by: [pwsh/Catzc.Base.Timeouts/types/TimeoutExemptionsConfig.cs, pwsh/Catzc.Base.Timeouts/types/TimeoutsConfig.cs, ADR-BCL-TYPES]
      - cell: subject/Catzc.Base.TypesSystem
        by:
          - pwsh/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1
          - pwsh/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1
          - pwsh/Catzc.Base.TypesSystem/Test-LoadedTypesCurrent.ps1
          - pwsh/Catzc.Base.TypesSystem/tests/Assert-LoadedTypesCurrent.Tests.ps1
          - pwsh/Catzc.Base.TypesSystem/tests/Test-LoadedTypesCurrent.Tests.ps1
          - ADR-BCL-TYPES
      - cell: subject/Catzc.Base.VSCode
        by:
          - pwsh/Catzc.Base.VSCode/types/VscodeExtensionsConfig.cs
          - pwsh/Catzc.Base.VSCode/types/VscodeLaunchConfig.cs
          - pwsh/Catzc.Base.VSCode/types/VscodeOwnExtension.cs
          - pwsh/Catzc.Base.VSCode/types/VscodeSettingsConfig.cs
          - pwsh/Catzc.Base.VSCode/types/VscodeTasksConfig.cs
          - ADR-BCL-TYPES
      - cell: subject/Catzc.Base.Variants
        by:
          - pwsh/Catzc.Base.Variants/configs/variants.yml
          - pwsh/Catzc.Base.Variants/types/VariantAspect.cs
          - pwsh/Catzc.Base.Variants/types/VariantTrack.cs
          - pwsh/Catzc.Base.Variants/types/VariantsConfig.cs
          - ADR-AZ-CUSTOMER
          - ADR-AZ-NAMING
          - ADR-BCL-TYPES
      - cell: subject/Catzc.Base.Vendor
        by: [pwsh/Catzc.Base.Vendor/types/VendorConfig.cs, ADR-BCL-TYPES]
      - cell: subject/Catzc.Internal.Tests
        by:
          - pwsh/.internal/tests/Enable-DeferredJanitors.Tests.ps1
          - pwsh/.internal/tests/Get-CombinedTypeHash.Tests.ps1
          - pwsh/.internal/tests/Get-LoadedTypeDrift.Tests.ps1
          - ADR-BCL-TYPES
      - cell: subject/Catzc.Tooling.Environment
        by: [pwsh/Catzc.Tooling.Environment/Write-EnvironmentSet.ps1, ADR-CONF-ADDRESSING]
      - cell: subject/Catzc.Tooling.Inspiration
        by:
          - pwsh/Catzc.Tooling.Inspiration/types/InspirationConfig.cs
          - pwsh/Catzc.Tooling.Inspiration/types/InspirationEntry.cs
          - ADR-BCL-TYPES
      - cell: subject/Catzc.Tooling.KeyHandler
        by:
          - pwsh/Catzc.Tooling.KeyHandler/types/KeyHandlerBinding.cs
          - pwsh/Catzc.Tooling.KeyHandler/types/KeyHandlerSupportedConfig.cs
          - ADR-BCL-TYPES
      - cell: subject/discovery
        by: [infrastructure/templates/discovery/options.yml, ADR-AZ-DATAMOD]
      - cell: subject/expedition
        by: [infrastructure/templates/expedition/options.yml, ADR-AZ-DATAMOD]
      - cell: subject/foundation
        by: [infrastructure/templates/foundation/options.yml, ADR-AZ-DATAMOD]
      - cell: subject/pipelines
        by: [.ado/pipelines/cd-shared.yaml, .ado/pipelines/ci-infrastructure.yaml, .ado/pipelines/extends/cd-customer.yaml, ADR-AZ-DATAMOD]
    axis:
      - cell: AUTO/build
        by: [ADR-BCL-TYPES]
      - cell: AUTO/*
        by: [ADR-CONF-ADDRESSING]
      - cell: CLOUD/deploy
        by: [ADR-AZ-CUSTOMER, ADR-AZ-DATAMOD, ADR-AZ-NAMING]
      - cell: CLOUD/access
        by: [ADR-AZ-DATAMOD]
layout:
  band-entry: { x: 20, y: 84, w: 190, h: 160 }
  band-folder: { x: 230, y: 84, w: 1050, h: 250 }
  band-slot: { x: 230, y: 354, w: 1050, h: 190 }
  g-build: { x: 40, y: 120, w: 150, h: 40 }
  g-templates: { x: 40, y: 182, w: 150, h: 40 }
  g-options: { x: 262, y: 162, w: 290, h: 80 }
  f-options-yml: { x: 365, y: 262, w: 110, h: 52 }
  t-short-name: { x: 640, y: 180, w: 150, h: 44 }
  t-template: { x: 900, y: 180, w: 150, h: 44 }
  g-addresses: { x: 290, y: 410, w: 240, h: 44 }
  f-parameters: { x: 560, y: 470, w: 210, h: 52 }
  grp-cli: { x: 980, y: 378, w: 280, h: 140 }
  g-invoke: { x: 1050, y: 430, w: 150, h: 44 }
```

![A template is a folder; options.yml overrides five defaults](.assets/bicep-template-is-a-folder.drawio.png)

```yml drawio
description:
  Deploy-Bicep resolves one immutable deployment context from the az session and the Azure config, then builds, deploys through the az
  runner and sets the tracking tags, all from that one context.
about:
  adrs:
    - ADR-AZ-DATAMOD-CUSTOMERAXIS
    - ADR-AZ-DATAMOD-VALUEBYADDRESS
    - ADR-AZ-SESSION
    - ADR-AUTO-DRYRUN
    - ADR-PWSH-DRYRUN-SUPPRESSSHOULDPROCESS
    - ADR-PWSH-PREPOST
  lens: source
content:
  title: One immutable context, resolved from the az session
  kind: reference
  flow: left-to-right
  relation: calls
  theme: dark
  bands:
    - { id: band-entry, label: ENTRY }
    - { id: band-resolve, label: RESOLVE }
    - { id: band-deploy, label: DEPLOY }
  groups:
    - { id: grp-types, label: context types, in: band-resolve }
    - { id: grp-cli, label: Catzc.Azure.Cli, in: band-resolve }
    - { id: grp-azure, label: Catzc.Azure, in: band-resolve }
  glyphs:
    - { id: g-deploy, kind: code, label: Deploy-Bicep, in: band-entry }
    - { id: g-context, kind: code, label: Get-BicepDeploymentContext, in: band-resolve }
    - { id: t-plan, kind: type, label: BicepDeploymentPlan, in: grp-types }
    - { id: t-artifacts, kind: type, label: BicepArtifacts, in: grp-types }
    - { id: t-context, kind: type, label: BicepDeploymentContext, in: grp-types }
    - { id: g-build, kind: code, label: Build-Bicep, in: band-resolve }
    - { id: g-session-sub, kind: code, label: Get-AzCliSessionSubscription, in: grp-cli }
    - { id: g-invoke, kind: code, label: Invoke-AzCli, in: grp-cli }
    - { id: g-environment, kind: code, label: Get-AzureEnvironment, in: grp-azure }
    - { id: g-tracking, kind: code, label: Set-BicepTrackingTagSet, in: band-deploy }
  edges:
    - { from: g-deploy, to: g-context, kind: flow, label: "" }
    - { from: g-context, to: grp-types, kind: flow, label: "" }
    - { from: g-context, to: g-build, kind: flow, label: "" }
    - { from: g-context, to: g-session-sub, kind: flow, label: "" }
    - { from: g-context, to: g-environment, kind: flow, label: "" }
    - { from: g-build, to: g-invoke, kind: flow, label: "" }
    - { from: g-deploy, to: g-invoke, kind: flow, label: "" }
    - { from: g-deploy, to: g-tracking, kind: flow, label: "" }
    - { from: g-tracking, to: g-invoke, kind: flow, label: "" }
    - { from: g-tracking, to: g-session-sub, kind: flow, label: "" }
    - { from: g-tracking, to: g-environment, kind: flow, label: "" }
  markers:
    - { at: g-deploy, number: 1 }
    - { at: g-context, number: 2 }
    - { at: g-session-sub, number: 3 }
    - { at: g-environment, number: 4 }
    - { at: g-build, number: 5 }
    - { at: t-context, number: 6 }
    - { at: g-invoke, number: 7 }
    - { at: g-tracking, number: 8 }
  legend: auto
  minimaps:
    code-locations:
      - cell: ado-pipelines/pipelines/.
        by: [.ado/pipelines/cd-shared.yaml, ADR-AZ-DATAMOD-CUSTOMERAXIS, ADR-AZ-DATAMOD-VALUEBYADDRESS]
      - cell: ado-pipelines/pipelines/extends
        by: [.ado/pipelines/extends/cd-customer.yaml, ADR-AZ-DATAMOD-CUSTOMERAXIS, ADR-AZ-DATAMOD-VALUEBYADDRESS]
      - cell: docs/-/.
        by:
          - docs/drs/automation/dora-explains.md
          - docs/drs/automation/dry-run.md
          - docs/drs/automation/pwsh/dora-explains.md
          - docs/drs/automation/pwsh/prefer-dryrun-over-shouldprocess.md
          - docs/drs/automation/pwsh/prepost-extension-modules.md
          - docs/drs/azure/az-session-verification.md
          - docs/drs/azure/azure-data-model.md
          - docs/drs/azure/dora-explains.md
          - docs/drs/index.md
          - docs/references/ado/pipelines/cd-shared.yaml.md
          - docs/references/ado/pipelines/extends/cd-customer.yaml.md
          - docs/references/infrastructure/templates/discovery/options.yml.md
          - docs/references/infrastructure/templates/expedition/options.yml.md
          - docs/references/infrastructure/templates/foundation/options.yml.md
          - docs/references/pwsh/catzc-azure-cli/Assert-AzCliCanAccess.ps1.md
          - docs/references/pwsh/catzc-azure-cli/Assert-AzCliIsConnected.ps1.md
          - docs/references/pwsh/catzc-azure-cli/Get-AzCliSessionSubscription.ps1.md
          - docs/references/pwsh/catzc-azure-cli/Test-AzCliCanAccess.ps1.md
          - docs/references/pwsh/catzc-azure-dev-ops-build-validation/tests/Register-AdoBuildValidation.Tests.ps1.md
          - docs/references/pwsh/catzc-azure-dev-ops-build-validation/tests/Unregister-AdoBuildValidation.Tests.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Build-Bicep.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Deploy-Bicep.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Get-AzureBicepEnvironmentKinds.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Get-BicepDeploymentContext.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Get-BicepTemplateConfiguration.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Get-BicepTemplates.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Set-BicepTemplateConfiguration.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Set-BicepTrackingTagSet.ps1.md
          - docs/references/pwsh/catzc-azure-templates/private/Get-BicepConfigSubscriptionCandidates.ps1.md
          - docs/references/pwsh/catzc-azure-templates/private/Get-BicepParametersFileName.ps1.md
          - docs/references/pwsh/catzc-azure-templates/private/Resolve-BicepParameterAddresses.ps1.md
          - docs/references/pwsh/catzc-azure/Get-AzureEnvironment.ps1.md
          - docs/references/pwsh/catzc-azure/Get-AzureSubscription.ps1.md
          - docs/references/pwsh/catzc-azure/Get-AzureSubscriptionEnvironment.ps1.md
          - docs/references/pwsh/catzc-azure/configs/azure.yml.md
          - docs/references/pwsh/catzc-azure/tests/types/AzureConfig.Tests.ps1.md
          - docs/references/pwsh/catzc-azure/types/AzureConfig.cs.md
          - docs/references/pwsh/catzc-azure/types/AzureEnvironmentRecord.cs.md
          - docs/references/pwsh/catzc-azure/types/AzureSubscriptionRecord.cs.md
          - docs/references/pwsh/catzc-azure/types/AzureTenantRecord.cs.md
          - docs/references/pwsh/catzc-base-docs/Build-GitKeep.ps1.md
          - docs/references/pwsh/catzc-base-docs/Build-Readme.ps1.md
          - docs/references/pwsh/catzc-base-drs/Build-DrsCodeDictionary.ps1.md
          - docs/references/pwsh/catzc-base-drs/Build-DrsIndex.ps1.md
          - docs/references/pwsh/catzc-base-drs/Update-DrsCitation.ps1.md
          - docs/references/pwsh/catzc-base-execution/Invoke-Executable.ps1.md
          - docs/references/pwsh/catzc-base-exporter/Build-Modules.ps1.md
          - docs/references/pwsh/catzc-base-exporter/Install-Catzc.ps1.md
          - docs/references/pwsh/catzc-base-files/Invoke-GitCommit.ps1.md
          - docs/references/pwsh/catzc-base-files/Write-FileIfChanged.ps1.md
          - docs/references/pwsh/catzc-base-git/Import-RepositoryWithHistory.ps1.md
          - docs/references/pwsh/catzc-base-git/Reset-GitCleanFxd.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Build-EnglishDictionary.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Build-TerminologyDictionary.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Export-SpellingTriage.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Format-FileMeta.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Format-MarkdownTitle.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Repair-IdiomaticNames.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/private/Get-MarkdownHeadingFinding.ps1.md
          - docs/references/pwsh/catzc-base-reports/Clear-Output.ps1.md
          - docs/references/pwsh/catzc-base-root-config/Build-RootConfig.ps1.md
          - docs/references/pwsh/catzc-tooling-provisioning/Clear-TempFolders.ps1.md
          - docs/references/pwsh/catzc-tooling-provisioning/Initialize-GitClone.ps1.md
          - ADR-AUTO-DRYRUN
          - ADR-AZ-DATAMOD-CUSTOMERAXIS
          - ADR-AZ-DATAMOD-VALUEBYADDRESS
          - ADR-AZ-SESSION
          - ADR-PWSH-DRYRUN-SUPPRESSSHOULDPROCESS
          - ADR-PWSH-PREPOST
      - cell: infrastructure/discovery/.
        by: [infrastructure/templates/discovery/options.yml, ADR-AZ-DATAMOD-CUSTOMERAXIS, ADR-AZ-DATAMOD-VALUEBYADDRESS]
      - cell: infrastructure/expedition/.
        by: [infrastructure/templates/expedition/options.yml, ADR-AZ-DATAMOD-CUSTOMERAXIS, ADR-AZ-DATAMOD-VALUEBYADDRESS]
      - cell: infrastructure/foundation/.
        by: [infrastructure/templates/foundation/options.yml, ADR-AZ-DATAMOD-CUSTOMERAXIS, ADR-AZ-DATAMOD-VALUEBYADDRESS]
      - cell: pwsh/Catzc.Azure/.
        by:
          - pwsh/Catzc.Azure/Get-AzureEnvironment.ps1
          - pwsh/Catzc.Azure/Get-AzureSubscription.ps1
          - pwsh/Catzc.Azure/Get-AzureSubscriptionEnvironment.ps1
          - ADR-AZ-DATAMOD-CUSTOMERAXIS
          - ADR-AZ-DATAMOD-VALUEBYADDRESS
      - cell: pwsh/Catzc.Azure/configs
        by: [pwsh/Catzc.Azure/configs/azure.yml, ADR-AZ-DATAMOD-CUSTOMERAXIS, ADR-AZ-DATAMOD-VALUEBYADDRESS]
      - cell: pwsh/Catzc.Azure/tests/types
        by: [pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1, ADR-AZ-DATAMOD-CUSTOMERAXIS, ADR-AZ-DATAMOD-VALUEBYADDRESS]
      - cell: pwsh/Catzc.Azure/types
        by:
          - pwsh/Catzc.Azure/types/AzureConfig.cs
          - pwsh/Catzc.Azure/types/AzureEnvironmentRecord.cs
          - pwsh/Catzc.Azure/types/AzureSubscriptionRecord.cs
          - pwsh/Catzc.Azure/types/AzureTenantRecord.cs
          - ADR-AZ-DATAMOD-CUSTOMERAXIS
          - ADR-AZ-DATAMOD-VALUEBYADDRESS
      - cell: pwsh/Catzc.Azure.Cli/.
        by:
          - pwsh/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1
          - pwsh/Catzc.Azure.Cli/Assert-AzCliIsConnected.ps1
          - pwsh/Catzc.Azure.Cli/Get-AzCliSessionSubscription.ps1
          - pwsh/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1
          - ADR-AZ-DATAMOD-CUSTOMERAXIS
          - ADR-AZ-DATAMOD-VALUEBYADDRESS
          - ADR-AZ-SESSION
      - cell: pwsh/Catzc.Azure.DevOps.BuildValidation/tests
        by:
          - pwsh/Catzc.Azure.DevOps.BuildValidation/tests/Register-AdoBuildValidation.Tests.ps1
          - pwsh/Catzc.Azure.DevOps.BuildValidation/tests/Unregister-AdoBuildValidation.Tests.ps1
          - ADR-AUTO-DRYRUN
      - cell: pwsh/Catzc.Azure.Templates/.
        by:
          - pwsh/Catzc.Azure.Templates/Build-Bicep.ps1
          - pwsh/Catzc.Azure.Templates/Deploy-Bicep.ps1
          - pwsh/Catzc.Azure.Templates/Get-AzureBicepEnvironmentKinds.ps1
          - pwsh/Catzc.Azure.Templates/Get-BicepDeploymentContext.ps1
          - pwsh/Catzc.Azure.Templates/Get-BicepTemplateConfiguration.ps1
          - pwsh/Catzc.Azure.Templates/Get-BicepTemplates.ps1
          - pwsh/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1
          - pwsh/Catzc.Azure.Templates/Set-BicepTrackingTagSet.ps1
          - ADR-AUTO-DRYRUN
          - ADR-AZ-DATAMOD-CUSTOMERAXIS
          - ADR-AZ-DATAMOD-VALUEBYADDRESS
          - ADR-PWSH-DRYRUN-SUPPRESSSHOULDPROCESS
          - ADR-PWSH-PREPOST
      - cell: pwsh/Catzc.Azure.Templates/private
        by:
          - pwsh/Catzc.Azure.Templates/private/Get-BicepConfigSubscriptionCandidates.ps1
          - pwsh/Catzc.Azure.Templates/private/Get-BicepParametersFileName.ps1
          - pwsh/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1
          - ADR-AZ-DATAMOD-CUSTOMERAXIS
          - ADR-AZ-DATAMOD-VALUEBYADDRESS
      - cell: pwsh/Catzc.Azure.Templates/tests
        by: [pwsh/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1, ADR-AZ-DATAMOD-VALUEBYADDRESS]
      - cell: pwsh/Catzc.Base.Docs/.
        by: [pwsh/Catzc.Base.Docs/Build-GitKeep.ps1, pwsh/Catzc.Base.Docs/Build-Readme.ps1, ADR-AUTO-DRYRUN]
      - cell: pwsh/Catzc.Base.Drs/.
        by:
          - pwsh/Catzc.Base.Drs/Build-DrsCodeDictionary.ps1
          - pwsh/Catzc.Base.Drs/Build-DrsIndex.ps1
          - pwsh/Catzc.Base.Drs/Update-DrsCitation.ps1
          - ADR-AUTO-DRYRUN
      - cell: pwsh/Catzc.Base.Drs/configs
        by:
          - pwsh/Catzc.Base.Drs/configs/drs.yml
          - ADR-AUTO-DRYRUN
          - ADR-AZ-DATAMOD-CUSTOMERAXIS
          - ADR-AZ-DATAMOD-VALUEBYADDRESS
          - ADR-AZ-SESSION
          - ADR-PWSH-DRYRUN-SUPPRESSSHOULDPROCESS
          - ADR-PWSH-PREPOST
      - cell: pwsh/Catzc.Base.Drs/tests
        by: [pwsh/Catzc.Base.Drs/tests/Update-DrsCitation.Tests.ps1, ADR-AUTO-DRYRUN]
      - cell: pwsh/Catzc.Base.Environment/.
        by: [pwsh/Catzc.Base.Environment/Remove-PermanentPath.ps1, ADR-PWSH-DRYRUN-SUPPRESSSHOULDPROCESS]
      - cell: pwsh/Catzc.Base.Execution/.
        by: [pwsh/Catzc.Base.Execution/Invoke-Executable.ps1, ADR-AUTO-DRYRUN]
      - cell: pwsh/Catzc.Base.Exporter/.
        by: [pwsh/Catzc.Base.Exporter/Build-Modules.ps1, pwsh/Catzc.Base.Exporter/Install-Catzc.ps1, ADR-AUTO-DRYRUN]
      - cell: pwsh/Catzc.Base.Files/.
        by: [pwsh/Catzc.Base.Files/Invoke-GitCommit.ps1, pwsh/Catzc.Base.Files/Write-FileIfChanged.ps1, ADR-AUTO-DRYRUN]
      - cell: pwsh/Catzc.Base.Git/.
        by: [pwsh/Catzc.Base.Git/Import-RepositoryWithHistory.ps1, pwsh/Catzc.Base.Git/Reset-GitCleanFxd.ps1, ADR-AUTO-DRYRUN]
      - cell: pwsh/Catzc.Base.ModuleSystem/tests
        by: [pwsh/Catzc.Base.ModuleSystem/tests/Set-ImportMix.Tests.ps1, ADR-AUTO-DRYRUN]
      - cell: pwsh/Catzc.Base.QualityGates/.
        by:
          - pwsh/Catzc.Base.QualityGates/Build-EnglishDictionary.ps1
          - pwsh/Catzc.Base.QualityGates/Build-TerminologyDictionary.ps1
          - pwsh/Catzc.Base.QualityGates/Export-SpellingTriage.ps1
          - pwsh/Catzc.Base.QualityGates/Format-FileMeta.ps1
          - pwsh/Catzc.Base.QualityGates/Format-MarkdownTitle.ps1
          - pwsh/Catzc.Base.QualityGates/Repair-IdiomaticNames.ps1
          - ADR-AUTO-DRYRUN
          - ADR-PWSH-DRYRUN-SUPPRESSSHOULDPROCESS
      - cell: pwsh/Catzc.Base.QualityGates/private
        by:
          - pwsh/Catzc.Base.QualityGates/private/Get-MarkdownHeadingFinding.ps1
          - ADR-AZ-DATAMOD-CUSTOMERAXIS
          - ADR-AZ-DATAMOD-VALUEBYADDRESS
      - cell: pwsh/Catzc.Base.QualityGates/tests
        by:
          - pwsh/Catzc.Base.QualityGates/tests/Export-Comments.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Move-FunctionHelp.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Sync-FileMeta.Tests.ps1
          - ADR-AUTO-DRYRUN
      - cell: pwsh/Catzc.Base.Reports/.
        by: [pwsh/Catzc.Base.Reports/Clear-Output.ps1, ADR-AUTO-DRYRUN]
      - cell: pwsh/Catzc.Base.RootConfig/.
        by: [pwsh/Catzc.Base.RootConfig/Build-RootConfig.ps1, ADR-AUTO-DRYRUN]
      - cell: pwsh/Catzc.Base.Slides/tests
        by: [pwsh/Catzc.Base.Slides/tests/Build-Diagrams.Tests.ps1, ADR-AUTO-DRYRUN]
      - cell: pwsh/Catzc.Tooling.Provisioning/.
        by:
          - pwsh/Catzc.Tooling.Provisioning/Clear-TempFolders.ps1
          - pwsh/Catzc.Tooling.Provisioning/Initialize-GitClone.ps1
          - ADR-AUTO-DRYRUN
      - cell: pwsh/Catzc.Tooling.Toolchain/private
        by: [pwsh/Catzc.Tooling.Toolchain/private/Stop-DotnetInstallHolder.ps1, ADR-PWSH-DRYRUN-SUPPRESSSHOULDPROCESS]
    module-neighbourhood:
      - cell: subject/Catzc.Azure
        by:
          - pwsh/Catzc.Azure/Get-AzureEnvironment.ps1
          - pwsh/Catzc.Azure/Get-AzureSubscription.ps1
          - pwsh/Catzc.Azure/Get-AzureSubscriptionEnvironment.ps1
          - pwsh/Catzc.Azure/configs/azure.yml
          - pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1
          - pwsh/Catzc.Azure/types/AzureConfig.cs
          - pwsh/Catzc.Azure/types/AzureEnvironmentRecord.cs
          - pwsh/Catzc.Azure/types/AzureSubscriptionRecord.cs
          - pwsh/Catzc.Azure/types/AzureTenantRecord.cs
          - ADR-AZ-DATAMOD-CUSTOMERAXIS
          - ADR-AZ-DATAMOD-VALUEBYADDRESS
      - cell: subject/Catzc.Azure.Cli
        by:
          - pwsh/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1
          - pwsh/Catzc.Azure.Cli/Assert-AzCliIsConnected.ps1
          - pwsh/Catzc.Azure.Cli/Get-AzCliSessionSubscription.ps1
          - pwsh/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1
          - ADR-AZ-DATAMOD-CUSTOMERAXIS
          - ADR-AZ-DATAMOD-VALUEBYADDRESS
          - ADR-AZ-SESSION
      - cell: subject/Catzc.Azure.DevOps.BuildValidation
        by:
          - pwsh/Catzc.Azure.DevOps.BuildValidation/tests/Register-AdoBuildValidation.Tests.ps1
          - pwsh/Catzc.Azure.DevOps.BuildValidation/tests/Unregister-AdoBuildValidation.Tests.ps1
          - ADR-AUTO-DRYRUN
      - cell: subject/Catzc.Azure.Templates
        by:
          - pwsh/Catzc.Azure.Templates/Build-Bicep.ps1
          - pwsh/Catzc.Azure.Templates/Deploy-Bicep.ps1
          - pwsh/Catzc.Azure.Templates/Get-AzureBicepEnvironmentKinds.ps1
          - pwsh/Catzc.Azure.Templates/Get-BicepDeploymentContext.ps1
          - pwsh/Catzc.Azure.Templates/Get-BicepTemplateConfiguration.ps1
          - pwsh/Catzc.Azure.Templates/Get-BicepTemplates.ps1
          - pwsh/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1
          - pwsh/Catzc.Azure.Templates/Set-BicepTrackingTagSet.ps1
          - pwsh/Catzc.Azure.Templates/private/Get-BicepConfigSubscriptionCandidates.ps1
          - pwsh/Catzc.Azure.Templates/private/Get-BicepParametersFileName.ps1
          - pwsh/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1
          - pwsh/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1
          - ADR-AUTO-DRYRUN
          - ADR-AZ-DATAMOD-CUSTOMERAXIS
          - ADR-AZ-DATAMOD-VALUEBYADDRESS
          - ADR-PWSH-DRYRUN-SUPPRESSSHOULDPROCESS
          - ADR-PWSH-PREPOST
      - cell: subject/Catzc.Base.Docs
        by: [pwsh/Catzc.Base.Docs/Build-GitKeep.ps1, pwsh/Catzc.Base.Docs/Build-Readme.ps1, ADR-AUTO-DRYRUN]
      - cell: subject/Catzc.Base.Drs
        by:
          - pwsh/Catzc.Base.Drs/Build-DrsCodeDictionary.ps1
          - pwsh/Catzc.Base.Drs/Build-DrsIndex.ps1
          - pwsh/Catzc.Base.Drs/Update-DrsCitation.ps1
          - pwsh/Catzc.Base.Drs/configs/drs.yml
          - pwsh/Catzc.Base.Drs/tests/Update-DrsCitation.Tests.ps1
          - ADR-AUTO-DRYRUN
          - ADR-AZ-DATAMOD-CUSTOMERAXIS
          - ADR-AZ-DATAMOD-VALUEBYADDRESS
          - ADR-AZ-SESSION
          - ADR-PWSH-DRYRUN-SUPPRESSSHOULDPROCESS
          - ADR-PWSH-PREPOST
      - cell: subject/Catzc.Base.Environment
        by: [pwsh/Catzc.Base.Environment/Remove-PermanentPath.ps1, ADR-PWSH-DRYRUN-SUPPRESSSHOULDPROCESS]
      - cell: subject/Catzc.Base.Execution
        by: [pwsh/Catzc.Base.Execution/Invoke-Executable.ps1, ADR-AUTO-DRYRUN]
      - cell: subject/Catzc.Base.Exporter
        by: [pwsh/Catzc.Base.Exporter/Build-Modules.ps1, pwsh/Catzc.Base.Exporter/Install-Catzc.ps1, ADR-AUTO-DRYRUN]
      - cell: subject/Catzc.Base.Files
        by: [pwsh/Catzc.Base.Files/Invoke-GitCommit.ps1, pwsh/Catzc.Base.Files/Write-FileIfChanged.ps1, ADR-AUTO-DRYRUN]
      - cell: subject/Catzc.Base.Git
        by: [pwsh/Catzc.Base.Git/Import-RepositoryWithHistory.ps1, pwsh/Catzc.Base.Git/Reset-GitCleanFxd.ps1, ADR-AUTO-DRYRUN]
      - cell: subject/Catzc.Base.ModuleSystem
        by: [pwsh/Catzc.Base.ModuleSystem/tests/Set-ImportMix.Tests.ps1, ADR-AUTO-DRYRUN]
      - cell: subject/Catzc.Base.QualityGates
        by:
          - pwsh/Catzc.Base.QualityGates/Build-EnglishDictionary.ps1
          - pwsh/Catzc.Base.QualityGates/Build-TerminologyDictionary.ps1
          - pwsh/Catzc.Base.QualityGates/Export-SpellingTriage.ps1
          - pwsh/Catzc.Base.QualityGates/Format-FileMeta.ps1
          - pwsh/Catzc.Base.QualityGates/Format-MarkdownTitle.ps1
          - pwsh/Catzc.Base.QualityGates/Repair-IdiomaticNames.ps1
          - pwsh/Catzc.Base.QualityGates/private/Get-MarkdownHeadingFinding.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Export-Comments.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Move-FunctionHelp.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Sync-FileMeta.Tests.ps1
          - ADR-AUTO-DRYRUN
          - ADR-AZ-DATAMOD-CUSTOMERAXIS
          - ADR-AZ-DATAMOD-VALUEBYADDRESS
          - ADR-PWSH-DRYRUN-SUPPRESSSHOULDPROCESS
      - cell: subject/Catzc.Base.Reports
        by: [pwsh/Catzc.Base.Reports/Clear-Output.ps1, ADR-AUTO-DRYRUN]
      - cell: subject/Catzc.Base.RootConfig
        by: [pwsh/Catzc.Base.RootConfig/Build-RootConfig.ps1, ADR-AUTO-DRYRUN]
      - cell: subject/Catzc.Base.Slides
        by: [pwsh/Catzc.Base.Slides/tests/Build-Diagrams.Tests.ps1, ADR-AUTO-DRYRUN]
      - cell: subject/Catzc.Tooling.Provisioning
        by:
          - pwsh/Catzc.Tooling.Provisioning/Clear-TempFolders.ps1
          - pwsh/Catzc.Tooling.Provisioning/Initialize-GitClone.ps1
          - ADR-AUTO-DRYRUN
      - cell: subject/Catzc.Tooling.Toolchain
        by: [pwsh/Catzc.Tooling.Toolchain/private/Stop-DotnetInstallHolder.ps1, ADR-PWSH-DRYRUN-SUPPRESSSHOULDPROCESS]
      - cell: subject/discovery
        by: [infrastructure/templates/discovery/options.yml, ADR-AZ-DATAMOD-CUSTOMERAXIS, ADR-AZ-DATAMOD-VALUEBYADDRESS]
      - cell: subject/expedition
        by: [infrastructure/templates/expedition/options.yml, ADR-AZ-DATAMOD-CUSTOMERAXIS, ADR-AZ-DATAMOD-VALUEBYADDRESS]
      - cell: subject/foundation
        by: [infrastructure/templates/foundation/options.yml, ADR-AZ-DATAMOD-CUSTOMERAXIS, ADR-AZ-DATAMOD-VALUEBYADDRESS]
      - cell: subject/pipelines
        by:
          - .ado/pipelines/cd-shared.yaml
          - .ado/pipelines/extends/cd-customer.yaml
          - ADR-AZ-DATAMOD-CUSTOMERAXIS
          - ADR-AZ-DATAMOD-VALUEBYADDRESS
    axis:
      - cell: AUTO/*
        by: [ADR-AUTO-DRYRUN, ADR-PWSH-DRYRUN-SUPPRESSSHOULDPROCESS, ADR-PWSH-PREPOST]
      - cell: CLOUD/deploy
        by: [ADR-AZ-DATAMOD-CUSTOMERAXIS, ADR-AZ-DATAMOD-VALUEBYADDRESS]
      - cell: CLOUD/access
        by: [ADR-AZ-DATAMOD-CUSTOMERAXIS, ADR-AZ-DATAMOD-VALUEBYADDRESS, ADR-AZ-SESSION]
layout:
  band-entry: { x: 20, y: 84, w: 190, h: 500 }
  band-resolve: { x: 220, y: 84, w: 1060, h: 290 }
  band-deploy: { x: 220, y: 394, w: 1060, h: 190 }
  g-deploy: { x: 40, y: 300, w: 150, h: 44 }
  g-context: { x: 250, y: 124, w: 220, h: 44 }
  grp-types: { x: 540, y: 104, w: 720, h: 84 }
  t-plan: { x: 560, y: 134, w: 200, h: 44 }
  t-artifacts: { x: 790, y: 134, w: 180, h: 44 }
  t-context: { x: 1000, y: 134, w: 240, h: 44 }
  g-build: { x: 260, y: 275, w: 200, h: 44 }
  grp-cli: { x: 520, y: 225, w: 290, h: 310 }
  g-session-sub: { x: 545, y: 275, w: 240, h: 44 }
  g-invoke: { x: 580, y: 465, w: 160, h: 44 }
  grp-azure: { x: 840, y: 225, w: 260, h: 120 }
  g-environment: { x: 860, y: 275, w: 220, h: 44 }
  g-tracking: { x: 880, y: 465, w: 230, h: 44 }
```

![One immutable context, resolved from the az session](.assets/bicep-deploy-one-immutable-context.drawio.png)

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
| responsibility:5 — Deploy and resource-group provisioning         | `Deploy-Bicep`                    |
|                                                                   | `Get-BicepDeploymentContext`      |
|                                                                   | `Deploy-AzureResourceGroup`       |
|                                                                   | `Set-BicepTrackingTagSet`         |
|                                                                   | `Get-BicepTrackTagNameSet`        |
| responsibility:6 — Template integrity validation                  | `Assert-BicepTemplate`            |
|                                                                   | `Get-BicepParameterModel`         |
