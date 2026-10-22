---
catzc:
  edges:
    cites:
      - ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES
---

# Catzc.Azure

The Azure identity module. It owns the _model_ behind every Azure deployment — the tenants, customers, environments, and subscriptions the
platform deploys into, and the network plan that overlays them — and the resolution logic that turns a name into the full identity the rest
of the Azure stack needs. It holds the source-of-truth configuration; the templating module
([Catzc.Azure.Templates](catzc-azure-templates.md)) consumes it.

## Responsibilities

| Responsibility   | Area         | Name                                                                         |
| ---------------- | ------------ | ---------------------------------------------------------------------------- |
| responsibility:1 | model        | [Identity and topology model](#responsibility1--identity-and-topology-model) |
| responsibility:2 | subscription | [Subscription resolution](#responsibility2--subscription-resolution)         |
| responsibility:3 | environment  | [Environment resolution](#responsibility3--environment-resolution)           |
| responsibility:4 | catalog      | [Global catalog accessors](#responsibility4--global-catalog-accessors)       |

### responsibility:1 — Identity and topology model

The declared shape of the Azure estate: the tenants, the customers (each with a readable key and a short code), the environments (each with
a region, region code, and short code), and the subscriptions (each bound to a tenant, optionally to a customer, and serving a set of
environments). Overlaid on this is the IP plan: a range per environment, and a hub-and-spoke network per subscription — a hub in each shared
subscription, a spoke in each customer subscription, with no two networks overlapping. This is data, not behaviour — it lives in three
configuration assets, `azure.yml`, `customer.yml` (the customers) and `network.yml`, and is the single source of truth the whole Azure stack
resolves against; a quality gate keeps the IP plan in step with the environments and subscriptions. The live identities these files carry
are declared in `identity-tokens.yml`, so a hermetic logic test that names one is found
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)). See
[data-model](../../drs/azure/azure-data-model.md) and [network-model](../../drs/azure/azure-network-model.md).

### responsibility:2 — Subscription resolution

Turning a subscription name into its full identity: its id and tenant, the customer it belongs to (if any), and its per-subscription
identity environment. A subscription is the deployment target, and this responsibility is where "which subscription, and what does that
imply" is answered.

### responsibility:3 — Environment resolution

Turning an environment name into its full identity in the context of a serving subscription: its region and region code, its short code, and
the resolved subscription that serves it. This is the join between the environment dimension and the subscription dimension.

### responsibility:4 — Global catalog accessors

Whole-estate lookups that aren't tied to one subscription or environment: the list of customers, one customer resolved from either its key
or its short code, and the minimum Bicep CLI version the estate requires. These are thin readers over the identity model for callers that
need a catalog rather than a single resolved identity.

## What the module does

This module is pure resolution over a declared model. It performs no Azure API calls and changes no state — it reads `azure.yml` and
`network.yml`, validates each through its config type on load, checks with a quality gate that the network plan stays in sync with the
environments and subscriptions, and answers questions about identity. The governing principle is "optimise for ease of configuration and
codebase-as-source-of-truth": the configuration is shaped for a human to read and edit, and the non-trivial joins between its dimensions
live here, in code, rather than being denormalised into the config.

The model has two independent dimensions — subscriptions and environments — that meet at deployment time. Responsibility 2 resolves the
subscription dimension, responsibility 3 resolves the environment dimension _in the context of_ a subscription, and the catalog accessors in
responsibility 4 expose the whole sets when a caller needs to enumerate rather than resolve. The customer is never a dimension a caller
selects directly; it is derived from the resolved subscription, which is why "which customer" is answered through subscription resolution
rather than as its own input.

Everything downstream — resource naming, build, deploy — phrases its questions in terms this module answers, so the identity model has
exactly one home. Adding a tenant, customer, environment, or subscription is an edit to `azure.yml` (and a matching `network.yml` entry for
a standard environment or a subscription: a hub for a shared one, a spoke for a customer's); the validation on load and the quality gate are
what stop the two assets from drifting apart.

The diagram below draws identity resolution from the source. Every Azure identity resolves from `azure.yml` and `customer.yml` through the
configuration loader, each into its own registered type. The live az session is matched back to the declared subscriptions and must match
exactly one.

```yml drawio
description:
  Azure identities resolve only from the typed azure.yml and customer.yml; the az session subscription is looked up in the azure config and
  must match exactly one declared subscription before it reaches the subscription resolver.
about:
  adrs: [ADR-AZ-SESSION, ADR-AZ-DATAMOD, ADR-AZ-CUSTOMER]
  lens: source
content:
  title: Azure identities resolve from config; session must match one
  kind: reference
  flow: left-to-right
  relation: feeds
  theme: dark
  bands:
    - { id: band-session, label: SESSION }
    - { id: band-config, label: CONFIG }
  groups:
    - { id: grp-cli, label: Catzc.Azure.Cli, in: band-session }
    - { id: grp-base-config, label: Catzc.Base.Config, in: band-config }
    - { id: grp-resolvers, label: resolvers, in: band-config }
  glyphs:
    - { id: g-current-sub, kind: code, label: Get-CurrentAzSubscription, in: grp-cli }
    - { id: g-session-sub, kind: gate, label: Get-AzCliSessionSubscription, in: grp-cli }
    - { id: g-azure-yml, kind: file, label: azure.yml, in: band-config }
    - { id: g-customer-yml, kind: file, label: customer.yml, in: band-config }
    - { id: g-get-config, kind: code, label: Get-Config, in: grp-base-config }
    - { id: g-azure-config, kind: type, label: AzureConfig, in: band-config }
    - { id: g-customer-config, kind: type, label: CustomerConfig, in: band-config }
    - { id: g-azure-customer, kind: code, label: Get-AzureCustomer, in: band-config }
    - { id: g-azure-sub, kind: code, label: Get-AzureSubscription, in: grp-resolvers }
    - { id: g-azure-env, kind: code, label: Get-AzureEnvironment, in: grp-resolvers }
  edges:
    - { from: g-azure-yml, to: g-get-config, kind: flow, label: "" }
    - { from: g-customer-yml, to: g-get-config, kind: flow, label: "" }
    - { from: g-get-config, to: g-azure-config, kind: flow, label: "" }
    - { from: g-get-config, to: g-customer-config, kind: flow, label: "" }
    - { from: g-azure-config, to: g-azure-sub, kind: flow, label: "" }
    - { from: g-azure-config, to: g-session-sub, kind: flow, label: "" }
    - { from: g-customer-config, to: g-azure-customer, kind: flow, label: "" }
    - { from: g-azure-customer, to: g-azure-sub, kind: flow, label: "" }
    - { from: g-current-sub, to: g-session-sub, kind: flow, label: "" }
    - { from: g-session-sub, to: g-azure-sub, kind: flow, label: "" }
    - { from: g-azure-sub, to: g-azure-env, kind: flow, label: "" }
  markers:
    - { at: g-azure-yml, number: 1 }
    - { at: g-customer-yml, number: 2 }
    - { at: g-get-config, number: 3 }
    - { at: g-azure-config, number: 4 }
    - { at: g-customer-config, number: 5 }
    - { at: g-azure-customer, number: 6 }
    - { at: g-azure-sub, number: 7 }
    - { at: g-azure-env, number: 8 }
    - { at: g-current-sub, number: 9 }
    - { at: g-session-sub, number: 10 }
  chips:
    - { at: g-session-sub, kind: count, text: "1" }
  legend: auto
  minimaps:
    code-locations:
      - cell: ado-pipelines/pipelines/.
        by: [.ado/pipelines/cd-shared.yaml, .ado/pipelines/ci-infrastructure.yaml, ADR-AZ-DATAMOD]
      - cell: ado-pipelines/pipelines/extends
        by: [.ado/pipelines/extends/cd-customer.yaml, ADR-AZ-DATAMOD]
      - cell: docs/-/.
        by:
          - docs/drs/azure/az-session-verification.md
          - docs/drs/azure/azure-customer-model.md
          - docs/drs/azure/azure-data-model.md
          - docs/drs/azure/dora-explains.md
          - docs/drs/glossary.md
          - docs/drs/index.md
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
          - docs/references/pwsh/catzc-azure-dev-ops-build-validation/types/BuildValidationEntry.cs.md
          - docs/references/pwsh/catzc-azure-templates/Assert-BicepTemplate.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Build-Bicep.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Deploy-Bicep.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Get-AzureBicepEnvironmentKinds.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Get-BicepDeploymentContext.ps1.md
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
          - docs/references/pwsh/catzc-azure-templates/types/BicepParamWriter.cs.md
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
          - docs/references/pwsh/catzc-base-docs/types/GlossaryConcept.cs.md
          - docs/references/pwsh/catzc-base-docs/types/GlossaryConfig.cs.md
          - docs/references/pwsh/catzc-base-drs/types/DrsConfig.cs.md
          - docs/references/pwsh/catzc-base-quality-gates/configs/analyzer-drs-map.yml.md
          - docs/references/pwsh/catzc-base-quality-gates/private/Get-MarkdownHeadingFinding.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/types/AnalyzerDrsMapConfig.cs.md
          - docs/references/pwsh/catzc-base-variants/configs/variants.yml.md
          - ADR-AZ-CUSTOMER
          - ADR-AZ-DATAMOD
          - ADR-AZ-SESSION
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
        by: [pwsh/Catzc.Azure/configs/azure.yml, pwsh/Catzc.Azure/configs/customer.yml, ADR-AZ-CUSTOMER, ADR-AZ-DATAMOD]
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
          - ADR-AZ-CUSTOMER
          - ADR-AZ-DATAMOD
      - cell: pwsh/Catzc.Azure.Cli/.
        by:
          - pwsh/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1
          - pwsh/Catzc.Azure.Cli/Assert-AzCliIsConnected.ps1
          - pwsh/Catzc.Azure.Cli/Get-AzCliSessionSubscription.ps1
          - pwsh/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1
          - ADR-AZ-DATAMOD
          - ADR-AZ-SESSION
      - cell: pwsh/Catzc.Azure.DevOps.BuildValidation/configs
        by: [pwsh/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml, ADR-AZ-CUSTOMER]
      - cell: pwsh/Catzc.Azure.DevOps.BuildValidation/tests/types
        by: [pwsh/Catzc.Azure.DevOps.BuildValidation/tests/types/BuildValidationConfig.Tests.ps1, ADR-AZ-CUSTOMER]
      - cell: pwsh/Catzc.Azure.DevOps.BuildValidation/types
        by: [pwsh/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationEntry.cs, ADR-AZ-CUSTOMER]
      - cell: pwsh/Catzc.Azure.Templates/.
        by:
          - pwsh/Catzc.Azure.Templates/Assert-BicepTemplate.ps1
          - pwsh/Catzc.Azure.Templates/Build-Bicep.ps1
          - pwsh/Catzc.Azure.Templates/ConvertTo-BicepParam.ps1
          - pwsh/Catzc.Azure.Templates/Deploy-Bicep.ps1
          - pwsh/Catzc.Azure.Templates/Get-AzureBicepEnvironmentKinds.ps1
          - pwsh/Catzc.Azure.Templates/Get-BicepDeploymentContext.ps1
          - pwsh/Catzc.Azure.Templates/Get-BicepTemplateConfiguration.ps1
          - pwsh/Catzc.Azure.Templates/Get-BicepTemplates.ps1
          - pwsh/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1
          - ADR-AZ-CUSTOMER
          - ADR-AZ-DATAMOD
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
      - cell: pwsh/Catzc.Azure.Templates/tests
        by:
          - pwsh/Catzc.Azure.Templates/tests/Assert-BicepTemplate.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Get-BicepTemplates.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1
          - ADR-AZ-DATAMOD
      - cell: pwsh/Catzc.Azure.Templates/types
        by:
          - pwsh/Catzc.Azure.Templates/types/BicepParamWriter.cs
          - pwsh/Catzc.Azure.Templates/types/BicepSlot.cs
          - pwsh/Catzc.Azure.Templates/types/BicepTemplate.cs
          - ADR-AZ-CUSTOMER
          - ADR-AZ-DATAMOD
      - cell: pwsh/Catzc.Base.Docs/types
        by: [pwsh/Catzc.Base.Docs/types/GlossaryConcept.cs, pwsh/Catzc.Base.Docs/types/GlossaryConfig.cs, ADR-AZ-CUSTOMER]
      - cell: pwsh/Catzc.Base.Drs/configs
        by:
          - pwsh/Catzc.Base.Drs/configs/drs-index.yml
          - pwsh/Catzc.Base.Drs/configs/drs.yml
          - ADR-AZ-CUSTOMER
          - ADR-AZ-DATAMOD
          - ADR-AZ-SESSION
      - cell: pwsh/Catzc.Base.Drs/types
        by: [pwsh/Catzc.Base.Drs/types/DrsConfig.cs, ADR-AZ-CUSTOMER]
      - cell: pwsh/Catzc.Base.QualityGates/configs
        by: [pwsh/Catzc.Base.QualityGates/configs/analyzer-drs-map.yml, ADR-AZ-CUSTOMER]
      - cell: pwsh/Catzc.Base.QualityGates/private
        by: [pwsh/Catzc.Base.QualityGates/private/Get-MarkdownHeadingFinding.ps1, ADR-AZ-DATAMOD]
      - cell: pwsh/Catzc.Base.QualityGates/types
        by: [pwsh/Catzc.Base.QualityGates/types/AnalyzerDrsMapConfig.cs, ADR-AZ-CUSTOMER]
      - cell: pwsh/Catzc.Base.RootConfig/assets/root
        by: [pwsh/Catzc.Base.RootConfig/assets/root/cspell.yml, ADR-AZ-DATAMOD]
      - cell: pwsh/Catzc.Base.Variants/configs
        by: [pwsh/Catzc.Base.Variants/configs/variants.yml, ADR-AZ-CUSTOMER]
    module-neighbourhood:
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
          - ADR-AZ-CUSTOMER
          - ADR-AZ-DATAMOD
      - cell: subject/Catzc.Azure.Cli
        by:
          - pwsh/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1
          - pwsh/Catzc.Azure.Cli/Assert-AzCliIsConnected.ps1
          - pwsh/Catzc.Azure.Cli/Get-AzCliSessionSubscription.ps1
          - pwsh/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1
          - ADR-AZ-DATAMOD
          - ADR-AZ-SESSION
      - cell: subject/Catzc.Azure.DevOps.BuildValidation
        by:
          - pwsh/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml
          - pwsh/Catzc.Azure.DevOps.BuildValidation/tests/types/BuildValidationConfig.Tests.ps1
          - pwsh/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationEntry.cs
          - ADR-AZ-CUSTOMER
      - cell: subject/Catzc.Azure.Templates
        by:
          - pwsh/Catzc.Azure.Templates/Assert-BicepTemplate.ps1
          - pwsh/Catzc.Azure.Templates/Build-Bicep.ps1
          - pwsh/Catzc.Azure.Templates/ConvertTo-BicepParam.ps1
          - pwsh/Catzc.Azure.Templates/Deploy-Bicep.ps1
          - pwsh/Catzc.Azure.Templates/Get-AzureBicepEnvironmentKinds.ps1
          - pwsh/Catzc.Azure.Templates/Get-BicepDeploymentContext.ps1
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
          - pwsh/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Get-BicepTemplates.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1
          - pwsh/Catzc.Azure.Templates/types/BicepParamWriter.cs
          - pwsh/Catzc.Azure.Templates/types/BicepSlot.cs
          - pwsh/Catzc.Azure.Templates/types/BicepTemplate.cs
          - ADR-AZ-CUSTOMER
          - ADR-AZ-DATAMOD
      - cell: subject/Catzc.Base.Docs
        by: [pwsh/Catzc.Base.Docs/types/GlossaryConcept.cs, pwsh/Catzc.Base.Docs/types/GlossaryConfig.cs, ADR-AZ-CUSTOMER]
      - cell: subject/Catzc.Base.Drs
        by:
          - pwsh/Catzc.Base.Drs/configs/drs-index.yml
          - pwsh/Catzc.Base.Drs/configs/drs.yml
          - pwsh/Catzc.Base.Drs/types/DrsConfig.cs
          - ADR-AZ-CUSTOMER
          - ADR-AZ-DATAMOD
          - ADR-AZ-SESSION
      - cell: subject/Catzc.Base.QualityGates
        by:
          - pwsh/Catzc.Base.QualityGates/configs/analyzer-drs-map.yml
          - pwsh/Catzc.Base.QualityGates/private/Get-MarkdownHeadingFinding.ps1
          - pwsh/Catzc.Base.QualityGates/types/AnalyzerDrsMapConfig.cs
          - ADR-AZ-CUSTOMER
          - ADR-AZ-DATAMOD
      - cell: subject/Catzc.Base.RootConfig
        by: [pwsh/Catzc.Base.RootConfig/assets/root/cspell.yml, ADR-AZ-DATAMOD]
      - cell: subject/Catzc.Base.Variants
        by: [pwsh/Catzc.Base.Variants/configs/variants.yml, ADR-AZ-CUSTOMER]
      - cell: subject/discovery
        by: [infrastructure/templates/discovery/options.yml, ADR-AZ-DATAMOD]
      - cell: subject/expedition
        by: [infrastructure/templates/expedition/options.yml, ADR-AZ-DATAMOD]
      - cell: subject/foundation
        by: [infrastructure/templates/foundation/options.yml, ADR-AZ-DATAMOD]
      - cell: subject/pipelines
        by: [.ado/pipelines/cd-shared.yaml, .ado/pipelines/ci-infrastructure.yaml, .ado/pipelines/extends/cd-customer.yaml, ADR-AZ-DATAMOD]
    axis:
      - cell: CLOUD/deploy
        by: [ADR-AZ-CUSTOMER, ADR-AZ-DATAMOD]
      - cell: CLOUD/access
        by: [ADR-AZ-DATAMOD, ADR-AZ-SESSION]
layout:
  band-session: { x: 400, y: 84, w: 880, h: 190 }
  band-config: { x: 20, y: 292, w: 1260, h: 220 }
  grp-cli: { x: 604, y: 98, w: 292, h: 170 }
  g-current-sub: { x: 645, y: 132, w: 210, h: 40 }
  g-session-sub: { x: 622, y: 186, w: 256, h: 76 }
  g-azure-yml: { x: 40, y: 322, w: 110, h: 46 }
  g-customer-yml: { x: 40, y: 432, w: 110, h: 46 }
  grp-base-config: { x: 190, y: 356, w: 180, h: 92 }
  g-get-config: { x: 210, y: 396, w: 140, h: 40 }
  g-azure-config: { x: 410, y: 326, w: 130, h: 40 }
  g-customer-config: { x: 410, y: 436, w: 130, h: 40 }
  g-azure-customer: { x: 650, y: 436, w: 200, h: 40 }
  grp-resolvers: { x: 634, y: 302, w: 532, h: 96 }
  g-azure-sub: { x: 650, y: 346, w: 200, h: 40 }
  g-azure-env: { x: 950, y: 346, w: 200, h: 40 }
```

![Azure identities resolve from config; session must match one](.assets/azure-identity-resolves-from-config.drawio.png)

## Division

The module's public functions and configuration, sorted into the responsibilities above.

| Responsibility                                 | Function                           |
| ---------------------------------------------- | ---------------------------------- |
| responsibility:1 — Identity and topology model | `Test-AzureNetworkPlan`            |
| config                                         | `azure.yml`                        |
|                                                | `customer.yml`                     |
|                                                | `network.yml`                      |
|                                                | `identity-tokens.yml`              |
| responsibility:2 — Subscription resolution     | `Get-AzureSubscription`            |
|                                                | `Get-AzureSubscriptionCustomer`    |
|                                                | `Get-AzureSubscriptionEnvironment` |
| responsibility:3 — Environment resolution      | `Get-AzureEnvironment`             |
| responsibility:4 — Global catalog accessors    | `Get-AzureCustomers`               |
|                                                | `Get-AzureCustomer`                |
|                                                | `Get-AzureBicepMinVersion`         |
