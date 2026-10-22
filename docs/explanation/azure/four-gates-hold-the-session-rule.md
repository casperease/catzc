# Four gates hold the session rule; the customer and the name hold by construction

```text
Four throwing gates hold ADR-AZ-DATAMOD-JOINSINPOWERSHELL; rules #4, #5 and ADR-AZ-NAMING-SUBSCRIPTIONNOTCOMPONENT hold by construction, with no gate.

1  assert given in a pipeline  #7: Deploy-Bicep throws in a pipeline without -SubscriptionIdAssertIs
2  subscription declared       #7: Get-AzCliSessionSubscription throws on an id azure.yml does not declare
3  session matches the assert  #7: Get-BicepDeploymentContext throws when the session differs from the pin
4  customer from the session   #4: the customer is read off the session; Deploy-Bicep has no -Customer
5  serves the env              #7: Get-AzureEnvironment throws when the subscription does not serve the env
6  RG name derived             #5 and NAMING#8: Get-BicepResourceGroupName builds the name; no subscription in it
7  throw                       every gate ends here; nothing retargets or falls back

Supports ADR-AZ-DATAMOD-CUSTOMERAXIS, ADR-AZ-DATAMOD-DERIVEDRESOURCEGROUPNAME and ADR-AZ-DATAMOD-JOINSINPOWERSHELL, and ADR-AZ-NAMING-SUBSCRIPTIONNOTCOMPONENT (governance lens).
```

The rule that the az session is the deploy target has four parts, and cats holds each one behind a check that throws: a pipeline must give
the pin, the session must be declared, the session must match the pin, and the session's subscription must serve the environment. Two
neighbouring rules need no check at all. The customer comes from the session because the deploy has no way to say otherwise, and the
resource-group name is built by one function that never sees a subscription. No message or help text contradicts these rules; one help text
misstates a config path.

```yml drawio
description:
  Four throwing gates hold the rule that the az session is the deploy target; the customer and the resource-group name hold by construction,
  with no gate, and every gate ends in a throw.
about:
  adrs:
    - ADR-AZ-DATAMOD-CUSTOMERAXIS
    - ADR-AZ-DATAMOD-DERIVEDRESOURCEGROUPNAME
    - ADR-AZ-DATAMOD-JOINSINPOWERSHELL
    - ADR-AZ-NAMING-SUBSCRIPTIONNOTCOMPONENT
  lens: governance
content:
  title: Four gates hold the session rule; the customer and the name hold by construction
  kind: explanation
  flow: left-to-right
  relation: runs next
  theme: dark
  bands:
    - { id: band-target, label: TARGET }
    - { id: band-config, label: CONFIG + NAMES }
    - { id: band-outcome, label: OUTCOME }
  glyphs:
    - { id: g-pipeline-assert, kind: gate, label: assert given in a pipeline, in: band-target }
    - { id: g-declared, kind: gate, label: subscription declared, in: band-target }
    - { id: g-matches, kind: gate, label: session matches the assert, in: band-target }
    - { id: g-customer, kind: code, label: customer from the session, in: band-config }
    - { id: g-serves, kind: gate, label: serves the env, in: band-config }
    - { id: g-group, kind: code, label: RG name derived, in: band-config }
    - { id: f-throw, kind: failure, label: throw, in: band-outcome }
  edges:
    - { from: g-pipeline-assert, to: g-declared, kind: flow, label: "" }
    - { from: g-declared, to: g-matches, kind: flow, label: "" }
    - { from: g-matches, to: g-customer, kind: flow, label: "" }
    - { from: g-customer, to: g-serves, kind: flow, label: "" }
    - { from: g-serves, to: g-group, kind: flow, label: "" }
    - { from: g-pipeline-assert, to: f-throw, kind: fail, label: "" }
    - { from: g-declared, to: f-throw, kind: fail, label: "" }
    - { from: g-matches, to: f-throw, kind: fail, label: "" }
    - { from: g-serves, to: f-throw, kind: fail, label: "" }
  markers:
    - { at: g-pipeline-assert, number: 1 }
    - { at: g-declared, number: 2 }
    - { at: g-matches, number: 3 }
    - { at: g-customer, number: 4 }
    - { at: g-serves, number: 5 }
    - { at: g-group, number: 6 }
    - { at: f-throw, number: 7 }
  chips:
    - { at: g-pipeline-assert, kind: rule, rule: ADR-AZ-DATAMOD-JOINSINPOWERSHELL }
    - { at: g-declared, kind: rule, rule: ADR-AZ-DATAMOD-JOINSINPOWERSHELL }
    - { at: g-matches, kind: rule, rule: ADR-AZ-DATAMOD-JOINSINPOWERSHELL }
    - { at: g-serves, kind: rule, rule: ADR-AZ-DATAMOD-JOINSINPOWERSHELL }
    - { at: band-config, kind: rule, rule: ADR-AZ-DATAMOD-CUSTOMERAXIS, gated: false }
    - { at: band-config, kind: rule, rule: ADR-AZ-DATAMOD-DERIVEDRESOURCEGROUPNAME, gated: false }
    - { at: band-config, kind: rule, rule: ADR-AZ-NAMING-SUBSCRIPTIONNOTCOMPONENT, gated: false }
  legend: auto
  minimaps:
    code-locations:
      - cell: ado-pipelines/pipelines/.
        by:
          - .ado/pipelines/cd-shared.yaml
          - ADR-AZ-DATAMOD-CUSTOMERAXIS
          - ADR-AZ-DATAMOD-DERIVEDRESOURCEGROUPNAME
          - ADR-AZ-DATAMOD-JOINSINPOWERSHELL
      - cell: ado-pipelines/pipelines/extends
        by:
          - .ado/pipelines/extends/cd-customer.yaml
          - ADR-AZ-DATAMOD-CUSTOMERAXIS
          - ADR-AZ-DATAMOD-DERIVEDRESOURCEGROUPNAME
          - ADR-AZ-DATAMOD-JOINSINPOWERSHELL
      - cell: docs/-/.
        by:
          - docs/drs/azure/azure-data-model.md
          - docs/drs/azure/azure-naming-standard.md
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
          - docs/references/pwsh/catzc-azure-templates/Deploy-Bicep.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Get-AzureBicepEnvironmentKinds.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Get-AzureResourceName.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Get-AzureResourceTypeSet.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Get-BicepDeploymentContext.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Get-BicepResourceName.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Get-BicepTemplateConfiguration.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Get-BicepTemplates.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Set-BicepTemplateConfiguration.ps1.md
          - docs/references/pwsh/catzc-azure-templates/private/Get-BicepConfigSubscriptionCandidates.ps1.md
          - docs/references/pwsh/catzc-azure-templates/private/Get-BicepParametersFileName.ps1.md
          - docs/references/pwsh/catzc-azure-templates/types/BicepShortName.cs.md
          - docs/references/pwsh/catzc-azure/Get-AzureEnvironment.ps1.md
          - docs/references/pwsh/catzc-azure/Get-AzureSubscription.ps1.md
          - docs/references/pwsh/catzc-azure/Get-AzureSubscriptionEnvironment.ps1.md
          - docs/references/pwsh/catzc-azure/configs/azure.yml.md
          - docs/references/pwsh/catzc-azure/configs/customer.yml.md
          - docs/references/pwsh/catzc-azure/tests/types/AzureConfig.Tests.ps1.md
          - docs/references/pwsh/catzc-azure/types/AzureConfig.cs.md
          - docs/references/pwsh/catzc-azure/types/AzureEnvironmentRecord.cs.md
          - docs/references/pwsh/catzc-azure/types/AzureSubscriptionRecord.cs.md
          - docs/references/pwsh/catzc-azure/types/AzureTenantRecord.cs.md
          - docs/references/pwsh/catzc-base-maps/Get-TrackPlacementMinimapData.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/private/Get-MarkdownHeadingFinding.ps1.md
          - docs/references/pwsh/catzc-base-variants/configs/variants.yml.md
          - ADR-AZ-DATAMOD-CUSTOMERAXIS
          - ADR-AZ-DATAMOD-DERIVEDRESOURCEGROUPNAME
          - ADR-AZ-DATAMOD-JOINSINPOWERSHELL
          - ADR-AZ-NAMING-SUBSCRIPTIONNOTCOMPONENT
      - cell: infrastructure/discovery/.
        by:
          - infrastructure/templates/discovery/options.yml
          - ADR-AZ-DATAMOD-CUSTOMERAXIS
          - ADR-AZ-DATAMOD-DERIVEDRESOURCEGROUPNAME
          - ADR-AZ-DATAMOD-JOINSINPOWERSHELL
      - cell: infrastructure/expedition/.
        by:
          - infrastructure/templates/expedition/options.yml
          - ADR-AZ-DATAMOD-CUSTOMERAXIS
          - ADR-AZ-DATAMOD-DERIVEDRESOURCEGROUPNAME
          - ADR-AZ-DATAMOD-JOINSINPOWERSHELL
      - cell: infrastructure/foundation/.
        by:
          - infrastructure/templates/foundation/options.yml
          - ADR-AZ-DATAMOD-CUSTOMERAXIS
          - ADR-AZ-DATAMOD-DERIVEDRESOURCEGROUPNAME
          - ADR-AZ-DATAMOD-JOINSINPOWERSHELL
      - cell: pwsh/Catzc.Azure/.
        by:
          - pwsh/Catzc.Azure/Get-AzureEnvironment.ps1
          - pwsh/Catzc.Azure/Get-AzureSubscription.ps1
          - pwsh/Catzc.Azure/Get-AzureSubscriptionEnvironment.ps1
          - ADR-AZ-DATAMOD-CUSTOMERAXIS
          - ADR-AZ-DATAMOD-DERIVEDRESOURCEGROUPNAME
          - ADR-AZ-DATAMOD-JOINSINPOWERSHELL
      - cell: pwsh/Catzc.Azure/configs
        by:
          - pwsh/Catzc.Azure/configs/azure.yml
          - pwsh/Catzc.Azure/configs/customer.yml
          - ADR-AZ-DATAMOD-CUSTOMERAXIS
          - ADR-AZ-DATAMOD-DERIVEDRESOURCEGROUPNAME
          - ADR-AZ-DATAMOD-JOINSINPOWERSHELL
          - ADR-AZ-NAMING-SUBSCRIPTIONNOTCOMPONENT
      - cell: pwsh/Catzc.Azure/tests/types
        by:
          - pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1
          - ADR-AZ-DATAMOD-CUSTOMERAXIS
          - ADR-AZ-DATAMOD-DERIVEDRESOURCEGROUPNAME
          - ADR-AZ-DATAMOD-JOINSINPOWERSHELL
      - cell: pwsh/Catzc.Azure/types
        by:
          - pwsh/Catzc.Azure/types/AzureConfig.cs
          - pwsh/Catzc.Azure/types/AzureEnvironmentRecord.cs
          - pwsh/Catzc.Azure/types/AzureSubscriptionRecord.cs
          - pwsh/Catzc.Azure/types/AzureTenantRecord.cs
          - ADR-AZ-DATAMOD-CUSTOMERAXIS
          - ADR-AZ-DATAMOD-DERIVEDRESOURCEGROUPNAME
          - ADR-AZ-DATAMOD-JOINSINPOWERSHELL
          - ADR-AZ-NAMING-SUBSCRIPTIONNOTCOMPONENT
      - cell: pwsh/Catzc.Azure.Cli/.
        by:
          - pwsh/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1
          - pwsh/Catzc.Azure.Cli/Assert-AzCliIsConnected.ps1
          - pwsh/Catzc.Azure.Cli/Get-AzCliSessionSubscription.ps1
          - pwsh/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1
          - ADR-AZ-DATAMOD-CUSTOMERAXIS
          - ADR-AZ-DATAMOD-DERIVEDRESOURCEGROUPNAME
          - ADR-AZ-DATAMOD-JOINSINPOWERSHELL
          - ADR-AZ-NAMING-SUBSCRIPTIONNOTCOMPONENT
      - cell: pwsh/Catzc.Azure.Templates/.
        by:
          - pwsh/Catzc.Azure.Templates/Deploy-Bicep.ps1
          - pwsh/Catzc.Azure.Templates/Get-AzureBicepEnvironmentKinds.ps1
          - pwsh/Catzc.Azure.Templates/Get-AzureResourceName.ps1
          - pwsh/Catzc.Azure.Templates/Get-AzureResourceTypeSet.ps1
          - pwsh/Catzc.Azure.Templates/Get-BicepDeploymentContext.ps1
          - pwsh/Catzc.Azure.Templates/Get-BicepResourceName.ps1
          - pwsh/Catzc.Azure.Templates/Get-BicepTemplateConfiguration.ps1
          - pwsh/Catzc.Azure.Templates/Get-BicepTemplates.ps1
          - pwsh/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1
          - ADR-AZ-DATAMOD-CUSTOMERAXIS
          - ADR-AZ-DATAMOD-DERIVEDRESOURCEGROUPNAME
          - ADR-AZ-DATAMOD-JOINSINPOWERSHELL
          - ADR-AZ-NAMING-SUBSCRIPTIONNOTCOMPONENT
      - cell: pwsh/Catzc.Azure.Templates/private
        by:
          - pwsh/Catzc.Azure.Templates/private/Get-BicepConfigSubscriptionCandidates.ps1
          - pwsh/Catzc.Azure.Templates/private/Get-BicepParametersFileName.ps1
          - ADR-AZ-DATAMOD-CUSTOMERAXIS
          - ADR-AZ-DATAMOD-DERIVEDRESOURCEGROUPNAME
          - ADR-AZ-DATAMOD-JOINSINPOWERSHELL
      - cell: pwsh/Catzc.Azure.Templates/types
        by: [pwsh/Catzc.Azure.Templates/types/BicepShortName.cs, ADR-AZ-NAMING-SUBSCRIPTIONNOTCOMPONENT]
      - cell: pwsh/Catzc.Base.Drs/configs
        by:
          - pwsh/Catzc.Base.Drs/configs/drs.yml
          - ADR-AZ-DATAMOD-CUSTOMERAXIS
          - ADR-AZ-DATAMOD-DERIVEDRESOURCEGROUPNAME
          - ADR-AZ-DATAMOD-JOINSINPOWERSHELL
          - ADR-AZ-NAMING-SUBSCRIPTIONNOTCOMPONENT
      - cell: pwsh/Catzc.Base.Maps/.
        by: [pwsh/Catzc.Base.Maps/Get-TrackPlacementMinimapData.ps1, ADR-AZ-NAMING-SUBSCRIPTIONNOTCOMPONENT]
      - cell: pwsh/Catzc.Base.QualityGates/private
        by:
          - pwsh/Catzc.Base.QualityGates/private/Get-MarkdownHeadingFinding.ps1
          - ADR-AZ-DATAMOD-CUSTOMERAXIS
          - ADR-AZ-DATAMOD-DERIVEDRESOURCEGROUPNAME
          - ADR-AZ-DATAMOD-JOINSINPOWERSHELL
      - cell: pwsh/Catzc.Base.Variants/configs
        by: [pwsh/Catzc.Base.Variants/configs/variants.yml, ADR-AZ-NAMING-SUBSCRIPTIONNOTCOMPONENT]
    module-neighbourhood:
      - cell: subject/Catzc.Azure
        by:
          - pwsh/Catzc.Azure/Get-AzureEnvironment.ps1
          - pwsh/Catzc.Azure/Get-AzureSubscription.ps1
          - pwsh/Catzc.Azure/Get-AzureSubscriptionEnvironment.ps1
          - pwsh/Catzc.Azure/configs/azure.yml
          - pwsh/Catzc.Azure/configs/customer.yml
          - pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1
          - pwsh/Catzc.Azure/types/AzureConfig.cs
          - pwsh/Catzc.Azure/types/AzureEnvironmentRecord.cs
          - pwsh/Catzc.Azure/types/AzureSubscriptionRecord.cs
          - pwsh/Catzc.Azure/types/AzureTenantRecord.cs
          - ADR-AZ-DATAMOD-CUSTOMERAXIS
          - ADR-AZ-DATAMOD-DERIVEDRESOURCEGROUPNAME
          - ADR-AZ-DATAMOD-JOINSINPOWERSHELL
          - ADR-AZ-NAMING-SUBSCRIPTIONNOTCOMPONENT
      - cell: subject/Catzc.Azure.Cli
        by:
          - pwsh/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1
          - pwsh/Catzc.Azure.Cli/Assert-AzCliIsConnected.ps1
          - pwsh/Catzc.Azure.Cli/Get-AzCliSessionSubscription.ps1
          - pwsh/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1
          - ADR-AZ-DATAMOD-CUSTOMERAXIS
          - ADR-AZ-DATAMOD-DERIVEDRESOURCEGROUPNAME
          - ADR-AZ-DATAMOD-JOINSINPOWERSHELL
          - ADR-AZ-NAMING-SUBSCRIPTIONNOTCOMPONENT
      - cell: subject/Catzc.Azure.Templates
        by:
          - pwsh/Catzc.Azure.Templates/Deploy-Bicep.ps1
          - pwsh/Catzc.Azure.Templates/Get-AzureBicepEnvironmentKinds.ps1
          - pwsh/Catzc.Azure.Templates/Get-AzureResourceName.ps1
          - pwsh/Catzc.Azure.Templates/Get-AzureResourceTypeSet.ps1
          - pwsh/Catzc.Azure.Templates/Get-BicepDeploymentContext.ps1
          - pwsh/Catzc.Azure.Templates/Get-BicepResourceName.ps1
          - pwsh/Catzc.Azure.Templates/Get-BicepTemplateConfiguration.ps1
          - pwsh/Catzc.Azure.Templates/Get-BicepTemplates.ps1
          - pwsh/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1
          - pwsh/Catzc.Azure.Templates/private/Get-BicepConfigSubscriptionCandidates.ps1
          - pwsh/Catzc.Azure.Templates/private/Get-BicepParametersFileName.ps1
          - pwsh/Catzc.Azure.Templates/types/BicepShortName.cs
          - ADR-AZ-DATAMOD-CUSTOMERAXIS
          - ADR-AZ-DATAMOD-DERIVEDRESOURCEGROUPNAME
          - ADR-AZ-DATAMOD-JOINSINPOWERSHELL
          - ADR-AZ-NAMING-SUBSCRIPTIONNOTCOMPONENT
      - cell: subject/Catzc.Base.Drs
        by:
          - pwsh/Catzc.Base.Drs/configs/drs.yml
          - ADR-AZ-DATAMOD-CUSTOMERAXIS
          - ADR-AZ-DATAMOD-DERIVEDRESOURCEGROUPNAME
          - ADR-AZ-DATAMOD-JOINSINPOWERSHELL
          - ADR-AZ-NAMING-SUBSCRIPTIONNOTCOMPONENT
      - cell: subject/Catzc.Base.Maps
        by: [pwsh/Catzc.Base.Maps/Get-TrackPlacementMinimapData.ps1, ADR-AZ-NAMING-SUBSCRIPTIONNOTCOMPONENT]
      - cell: subject/Catzc.Base.QualityGates
        by:
          - pwsh/Catzc.Base.QualityGates/private/Get-MarkdownHeadingFinding.ps1
          - ADR-AZ-DATAMOD-CUSTOMERAXIS
          - ADR-AZ-DATAMOD-DERIVEDRESOURCEGROUPNAME
          - ADR-AZ-DATAMOD-JOINSINPOWERSHELL
      - cell: subject/Catzc.Base.Variants
        by: [pwsh/Catzc.Base.Variants/configs/variants.yml, ADR-AZ-NAMING-SUBSCRIPTIONNOTCOMPONENT]
      - cell: subject/discovery
        by:
          - infrastructure/templates/discovery/options.yml
          - ADR-AZ-DATAMOD-CUSTOMERAXIS
          - ADR-AZ-DATAMOD-DERIVEDRESOURCEGROUPNAME
          - ADR-AZ-DATAMOD-JOINSINPOWERSHELL
      - cell: subject/expedition
        by:
          - infrastructure/templates/expedition/options.yml
          - ADR-AZ-DATAMOD-CUSTOMERAXIS
          - ADR-AZ-DATAMOD-DERIVEDRESOURCEGROUPNAME
          - ADR-AZ-DATAMOD-JOINSINPOWERSHELL
      - cell: subject/foundation
        by:
          - infrastructure/templates/foundation/options.yml
          - ADR-AZ-DATAMOD-CUSTOMERAXIS
          - ADR-AZ-DATAMOD-DERIVEDRESOURCEGROUPNAME
          - ADR-AZ-DATAMOD-JOINSINPOWERSHELL
      - cell: subject/pipelines
        by:
          - .ado/pipelines/cd-shared.yaml
          - .ado/pipelines/extends/cd-customer.yaml
          - ADR-AZ-DATAMOD-CUSTOMERAXIS
          - ADR-AZ-DATAMOD-DERIVEDRESOURCEGROUPNAME
          - ADR-AZ-DATAMOD-JOINSINPOWERSHELL
    axis:
      - cell: CLOUD/deploy
        by:
          - ADR-AZ-DATAMOD-CUSTOMERAXIS
          - ADR-AZ-DATAMOD-DERIVEDRESOURCEGROUPNAME
          - ADR-AZ-DATAMOD-JOINSINPOWERSHELL
          - ADR-AZ-NAMING-SUBSCRIPTIONNOTCOMPONENT
      - cell: CLOUD/access
        by: [ADR-AZ-DATAMOD-CUSTOMERAXIS, ADR-AZ-DATAMOD-DERIVEDRESOURCEGROUPNAME, ADR-AZ-DATAMOD-JOINSINPOWERSHELL]
layout:
  band-target: { x: 20, y: 84, w: 700, h: 180 }
  band-config: { x: 740, y: 84, w: 540, h: 180 }
  band-outcome: { x: 20, y: 300, w: 1260, h: 110 }
  g-pipeline-assert: { x: 40, y: 140, w: 200, h: 68 }
  g-declared: { x: 260, y: 140, w: 200, h: 68 }
  g-matches: { x: 480, y: 140, w: 220, h: 68 }
  g-customer: { x: 760, y: 152, w: 150, h: 44 }
  g-serves: { x: 940, y: 140, w: 160, h: 68 }
  g-group: { x: 1130, y: 152, w: 130, h: 44 }
  f-throw: { x: 540, y: 346, w: 200, h: 44 }
```

![Four gates hold the session rule; the customer and the name hold by construction](.assets/four-gates-hold-the-session-rule.drawio.png)

## Walkthrough

1. **Assert given in a pipeline.** `Deploy-Bicep` checks, before resolving anything, that a pipeline run carries `-SubscriptionIdAssertIs`,
   and throws at the call site when it does not. On a devbox the check does not apply, so the pin stays optional there. The gate holds the
   "mandatory in a pipeline" half of ADR-AZ-DATAMOD-JOINSINPOWERSHELL.
2. **Subscription declared.** `Get-AzCliSessionSubscription` matches the session's subscription id against the subscriptions `azure.yml`
   declares and throws when none, or more than one, carries it. Config defines what is correct: an undeclared session is an error, never a
   fallback.
3. **Session matches the assert.** `Get-BicepDeploymentContext` compares the resolved session's id with the pin and throws on a mismatch,
   naming both subscriptions and the mis-wired service connection. The pin never changes the target; the gate only confirms it.
4. **Customer from the session.** The context reads the customer off the resolved session subscription. No gate checks that the customer was
   not passed in, because it cannot be: `Deploy-Bicep` and `Get-BicepDeploymentContext` have no `-Customer` parameter.
   ADR-AZ-DATAMOD-CUSTOMERAXIS holds by construction.
5. **Serves the env.** `Get-AzureEnvironment`, called with the session's subscription, asserts that the subscription's `environments` list
   contains the requested environment and throws otherwise. This is the check that a session cannot deploy an environment its subscription
   does not serve.
6. **RG name derived.** `Get-BicepResourceGroupName` builds the resource-group name from the template, the environment, the slot and the
   session's customer, through `Get-BicepResourceName` and the namer. No gate asserts that nobody typed the name or that the subscription
   stayed out of it: the function is the only source of the name, and it takes no subscription. ADR-AZ-DATAMOD-DERIVEDRESOURCEGROUPNAME and
   ADR-AZ-NAMING-SUBSCRIPTIONNOTCOMPONENT hold by construction.
7. **Throw.** Every gate ends in a throw that stops the deploy before a build artifact is read or `az deployment` is called. Nothing is
   retargeted, defaulted or repaired along the way.

## Why it holds

- The customer is derived from the session subscription at deploy time, never a deploy argument (ADR-AZ-DATAMOD-CUSTOMERAXIS).
- The resource-group name is derived by `Get-BicepResourceGroupName`, never hand-typed (ADR-AZ-DATAMOD-DERIVEDRESOURCEGROUPNAME).
- The deploy-time subscription is the az session's, reverse-resolved against `azure.yml`; `-SubscriptionIdAssertIs` is mandatory in a
  pipeline and optional on a devbox, and it is a guard, never a selector (ADR-AZ-DATAMOD-JOINSINPOWERSHELL).
- The subscription is a resolution axis only and never a name component (ADR-AZ-NAMING-SUBSCRIPTIONNOTCOMPONENT).

## Where the code and the decision record differ

The ADR names `Deploy-Bicep` as the function that throws without the pin, and so does the code; `Get-BicepDeploymentContext` on its own
accepts a pipeline call without the pin, so the first gate guards the deploy surface, not the context function.

## See also

- [Templating data model](../../drs/azure/azure-data-model.md) — the decision this article explains.
- [Azure resource naming standard](../../drs/azure/azure-naming-standard.md) — why the subscription never enters a name.
- The other lenses on the same deploy target: [meta](the-session-is-the-deploy-target.md),
  [architecture](one-reverse-lookup-feeds-every-module.md), [implementation](read-the-session-guard-then-pick-slot.md) and
  [operations](pipeline-pins-devbox-picks-the-target.md).
- [The azure explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
