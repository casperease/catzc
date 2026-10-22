# A config file's path is a coordinate that resolves to one subscription and one resource group

```text
A config file's path is a coordinate that resolves to one subscription and one resource group.

1  root config               a config at the configuration root: a deployment of the shared platform
2  customer config           a config under configuration/<customer>/: a deployment of that customer
3  exactly one subscription  the check that the coordinate is served by exactly one subscription
4  subscription              the one subscription the coordinate resolves to, never spelled into the path
5  resource group            the one resource group the config deploys, its name derived from the coordinate

Supports ADR-AZ-DATAMOD-TWOCONFIGLAYERS, ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION and ADR-AZ-DATAMOD-NAMEKEYEDMAPS, and ADR-AZ-CUSTOMER-KEYISSUBFOLDER (meta lens).
```

A Bicep template in cats keeps one config file per deployment under its `configuration/` folder, and where that file sits is its whole
address. The file's folder says whose deployment it is, and its name says which environment and which slot. Nothing in the file, and nothing
in any pipeline, names the subscription: cats resolves it from the path, and it insists that exactly one subscription fits. Because the
resolution is one-to-one all the way through, listing the `configuration/` tree is the inventory of a template's resource groups.

```yml drawio
description:
  "A config file's place under a template's configuration tree is its coordinate: a root config or a customer config, checked against
  exactly one subscription, resolves to that subscription and to one resource group."
about:
  adrs:
    - ADR-AZ-DATAMOD-TWOCONFIGLAYERS
    - ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION
    - ADR-AZ-DATAMOD-NAMEKEYEDMAPS
    - ADR-AZ-CUSTOMER-KEYISSUBFOLDER
  lens: meta
content:
  title: A config file's path is a coordinate that resolves to one subscription and one resource group
  kind: explanation
  flow: left-to-right
  relation: resolves to
  theme: dark
  bands:
    - { id: band-tree, label: CONFIGURATION TREE }
    - { id: band-resolved, label: RESOLVED }
  glyphs:
    - { id: g-root, kind: file, label: root config, in: band-tree }
    - { id: g-customer, kind: file, label: customer config, in: band-tree }
    - { id: g-one, kind: gate, label: exactly one subscription, in: band-resolved }
    - { id: e-subscription, kind: env, label: subscription, in: band-resolved }
    - { id: e-group, kind: env, label: resource group, in: band-resolved }
  edges:
    - { from: g-root, to: g-one, kind: flow, label: "" }
    - { from: g-customer, to: g-one, kind: flow, label: "" }
    - { from: g-one, to: e-subscription, kind: flow, label: "" }
    - { from: e-subscription, to: e-group, kind: flow, label: "" }
  markers:
    - { at: g-root, number: 1 }
    - { at: g-customer, number: 2 }
    - { at: g-one, number: 3 }
    - { at: e-subscription, number: 4 }
    - { at: e-group, number: 5 }
  legend: auto
  minimaps:
    code-locations:
      - cell: ado-pipelines/pipelines/.
        by:
          - .ado/pipelines/cd-shared.yaml
          - ADR-AZ-DATAMOD-NAMEKEYEDMAPS
          - ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION
          - ADR-AZ-DATAMOD-TWOCONFIGLAYERS
      - cell: ado-pipelines/pipelines/extends
        by:
          - .ado/pipelines/extends/cd-customer.yaml
          - ADR-AZ-DATAMOD-NAMEKEYEDMAPS
          - ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION
          - ADR-AZ-DATAMOD-TWOCONFIGLAYERS
      - cell: docs/-/.
        by:
          - docs/drs/azure/azure-customer-model.md
          - docs/drs/azure/azure-data-model.md
          - docs/drs/azure/dora-explains.md
          - docs/drs/glossary.md
          - docs/drs/index.md
          - docs/references/ado/pipelines/cd-shared.yaml.md
          - docs/references/ado/pipelines/extends/cd-customer.yaml.md
          - docs/references/infrastructure/templates/discovery/options.yml.md
          - docs/references/infrastructure/templates/expedition/options.yml.md
          - docs/references/infrastructure/templates/foundation/options.yml.md
          - docs/references/pwsh/catzc-azure-cli/Assert-AzCliCanAccess.ps1.md
          - docs/references/pwsh/catzc-azure-cli/Assert-AzCliIsConnected.ps1.md
          - docs/references/pwsh/catzc-azure-cli/Test-AzCliCanAccess.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Deploy-Bicep.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Get-AzureBicepEnvironmentKinds.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Get-BicepDeploymentContext.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Get-BicepTemplateConfiguration.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Get-BicepTemplates.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Set-BicepTemplateConfiguration.ps1.md
          - docs/references/pwsh/catzc-azure-templates/private/Get-BicepConfigName.ps1.md
          - docs/references/pwsh/catzc-azure-templates/private/Get-BicepConfigSubscriptionCandidates.ps1.md
          - docs/references/pwsh/catzc-azure-templates/private/Get-BicepCustomerClassViolations.ps1.md
          - docs/references/pwsh/catzc-azure-templates/private/Get-BicepParametersFileName.ps1.md
          - docs/references/pwsh/catzc-azure-templates/private/Resolve-BicepConfigName.ps1.md
          - docs/references/pwsh/catzc-azure-templates/types/BicepTemplate.cs.md
          - docs/references/pwsh/catzc-azure/Get-AzureCustomers.ps1.md
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
          - docs/references/pwsh/catzc-base-quality-gates/private/Get-MarkdownHeadingFinding.ps1.md
          - docs/references/pwsh/catzc-base-variants/configs/variants.yml.md
          - ADR-AZ-CUSTOMER-KEYISSUBFOLDER
          - ADR-AZ-DATAMOD-NAMEKEYEDMAPS
          - ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION
          - ADR-AZ-DATAMOD-TWOCONFIGLAYERS
      - cell: infrastructure/discovery/.
        by:
          - infrastructure/templates/discovery/options.yml
          - ADR-AZ-DATAMOD-NAMEKEYEDMAPS
          - ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION
          - ADR-AZ-DATAMOD-TWOCONFIGLAYERS
      - cell: infrastructure/expedition/.
        by:
          - infrastructure/templates/expedition/options.yml
          - ADR-AZ-DATAMOD-NAMEKEYEDMAPS
          - ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION
          - ADR-AZ-DATAMOD-TWOCONFIGLAYERS
      - cell: infrastructure/foundation/.
        by:
          - infrastructure/templates/foundation/options.yml
          - ADR-AZ-DATAMOD-NAMEKEYEDMAPS
          - ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION
          - ADR-AZ-DATAMOD-TWOCONFIGLAYERS
      - cell: pwsh/Catzc.Azure/.
        by:
          - pwsh/Catzc.Azure/Get-AzureCustomers.ps1
          - pwsh/Catzc.Azure/Get-AzureSubscription.ps1
          - pwsh/Catzc.Azure/Get-AzureSubscriptionEnvironment.ps1
          - ADR-AZ-CUSTOMER-KEYISSUBFOLDER
          - ADR-AZ-DATAMOD-NAMEKEYEDMAPS
          - ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION
          - ADR-AZ-DATAMOD-TWOCONFIGLAYERS
      - cell: pwsh/Catzc.Azure/configs
        by:
          - pwsh/Catzc.Azure/configs/azure.yml
          - pwsh/Catzc.Azure/configs/customer.yml
          - ADR-AZ-CUSTOMER-KEYISSUBFOLDER
          - ADR-AZ-DATAMOD-NAMEKEYEDMAPS
          - ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION
          - ADR-AZ-DATAMOD-TWOCONFIGLAYERS
      - cell: pwsh/Catzc.Azure/tests/types
        by:
          - pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1
          - ADR-AZ-CUSTOMER-KEYISSUBFOLDER
          - ADR-AZ-DATAMOD-NAMEKEYEDMAPS
          - ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION
          - ADR-AZ-DATAMOD-TWOCONFIGLAYERS
      - cell: pwsh/Catzc.Azure/types
        by:
          - pwsh/Catzc.Azure/types/AzureConfig.cs
          - pwsh/Catzc.Azure/types/AzureCustomer.cs
          - pwsh/Catzc.Azure/types/AzureEnvironmentRecord.cs
          - pwsh/Catzc.Azure/types/AzureSubscriptionRecord.cs
          - pwsh/Catzc.Azure/types/AzureTenantRecord.cs
          - pwsh/Catzc.Azure/types/CustomerConfig.cs
          - ADR-AZ-CUSTOMER-KEYISSUBFOLDER
          - ADR-AZ-DATAMOD-NAMEKEYEDMAPS
          - ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION
          - ADR-AZ-DATAMOD-TWOCONFIGLAYERS
      - cell: pwsh/Catzc.Azure.Cli/.
        by:
          - pwsh/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1
          - pwsh/Catzc.Azure.Cli/Assert-AzCliIsConnected.ps1
          - pwsh/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1
          - ADR-AZ-DATAMOD-NAMEKEYEDMAPS
          - ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION
          - ADR-AZ-DATAMOD-TWOCONFIGLAYERS
      - cell: pwsh/Catzc.Azure.Templates/.
        by:
          - pwsh/Catzc.Azure.Templates/Deploy-Bicep.ps1
          - pwsh/Catzc.Azure.Templates/Get-AzureBicepEnvironmentKinds.ps1
          - pwsh/Catzc.Azure.Templates/Get-BicepDeploymentContext.ps1
          - pwsh/Catzc.Azure.Templates/Get-BicepTemplateConfiguration.ps1
          - pwsh/Catzc.Azure.Templates/Get-BicepTemplates.ps1
          - pwsh/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1
          - ADR-AZ-CUSTOMER-KEYISSUBFOLDER
          - ADR-AZ-DATAMOD-NAMEKEYEDMAPS
          - ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION
          - ADR-AZ-DATAMOD-TWOCONFIGLAYERS
      - cell: pwsh/Catzc.Azure.Templates/configs
        by: [pwsh/Catzc.Azure.Templates/configs/glossary.yml, ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION]
      - cell: pwsh/Catzc.Azure.Templates/private
        by:
          - pwsh/Catzc.Azure.Templates/private/Get-BicepConfigName.ps1
          - pwsh/Catzc.Azure.Templates/private/Get-BicepConfigSubscriptionCandidates.ps1
          - pwsh/Catzc.Azure.Templates/private/Get-BicepCustomerClassViolations.ps1
          - pwsh/Catzc.Azure.Templates/private/Get-BicepParametersFileName.ps1
          - pwsh/Catzc.Azure.Templates/private/Resolve-BicepConfigName.ps1
          - ADR-AZ-CUSTOMER-KEYISSUBFOLDER
          - ADR-AZ-DATAMOD-NAMEKEYEDMAPS
          - ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION
          - ADR-AZ-DATAMOD-TWOCONFIGLAYERS
      - cell: pwsh/Catzc.Azure.Templates/types
        by: [pwsh/Catzc.Azure.Templates/types/BicepTemplate.cs, ADR-AZ-CUSTOMER-KEYISSUBFOLDER]
      - cell: pwsh/Catzc.Base.Drs/configs
        by:
          - pwsh/Catzc.Base.Drs/configs/drs-index.yml
          - pwsh/Catzc.Base.Drs/configs/drs.yml
          - ADR-AZ-CUSTOMER-KEYISSUBFOLDER
          - ADR-AZ-DATAMOD-NAMEKEYEDMAPS
          - ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION
          - ADR-AZ-DATAMOD-TWOCONFIGLAYERS
      - cell: pwsh/Catzc.Base.QualityGates/private
        by:
          - pwsh/Catzc.Base.QualityGates/private/Get-MarkdownHeadingFinding.ps1
          - ADR-AZ-DATAMOD-NAMEKEYEDMAPS
          - ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION
          - ADR-AZ-DATAMOD-TWOCONFIGLAYERS
      - cell: pwsh/Catzc.Base.Variants/configs
        by: [pwsh/Catzc.Base.Variants/configs/variants.yml, ADR-AZ-CUSTOMER-KEYISSUBFOLDER]
    module-neighbourhood:
      - cell: subject/Catzc.Azure
        by:
          - pwsh/Catzc.Azure/Get-AzureCustomers.ps1
          - pwsh/Catzc.Azure/Get-AzureSubscription.ps1
          - pwsh/Catzc.Azure/Get-AzureSubscriptionEnvironment.ps1
          - pwsh/Catzc.Azure/configs/azure.yml
          - pwsh/Catzc.Azure/configs/customer.yml
          - pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1
          - pwsh/Catzc.Azure/types/AzureConfig.cs
          - pwsh/Catzc.Azure/types/AzureCustomer.cs
          - pwsh/Catzc.Azure/types/AzureEnvironmentRecord.cs
          - pwsh/Catzc.Azure/types/AzureSubscriptionRecord.cs
          - pwsh/Catzc.Azure/types/AzureTenantRecord.cs
          - pwsh/Catzc.Azure/types/CustomerConfig.cs
          - ADR-AZ-CUSTOMER-KEYISSUBFOLDER
          - ADR-AZ-DATAMOD-NAMEKEYEDMAPS
          - ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION
          - ADR-AZ-DATAMOD-TWOCONFIGLAYERS
      - cell: subject/Catzc.Azure.Cli
        by:
          - pwsh/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1
          - pwsh/Catzc.Azure.Cli/Assert-AzCliIsConnected.ps1
          - pwsh/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1
          - ADR-AZ-DATAMOD-NAMEKEYEDMAPS
          - ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION
          - ADR-AZ-DATAMOD-TWOCONFIGLAYERS
      - cell: subject/Catzc.Azure.Templates
        by:
          - pwsh/Catzc.Azure.Templates/Deploy-Bicep.ps1
          - pwsh/Catzc.Azure.Templates/Get-AzureBicepEnvironmentKinds.ps1
          - pwsh/Catzc.Azure.Templates/Get-BicepDeploymentContext.ps1
          - pwsh/Catzc.Azure.Templates/Get-BicepTemplateConfiguration.ps1
          - pwsh/Catzc.Azure.Templates/Get-BicepTemplates.ps1
          - pwsh/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1
          - pwsh/Catzc.Azure.Templates/configs/glossary.yml
          - pwsh/Catzc.Azure.Templates/private/Get-BicepConfigName.ps1
          - pwsh/Catzc.Azure.Templates/private/Get-BicepConfigSubscriptionCandidates.ps1
          - pwsh/Catzc.Azure.Templates/private/Get-BicepCustomerClassViolations.ps1
          - pwsh/Catzc.Azure.Templates/private/Get-BicepParametersFileName.ps1
          - pwsh/Catzc.Azure.Templates/private/Resolve-BicepConfigName.ps1
          - pwsh/Catzc.Azure.Templates/types/BicepTemplate.cs
          - ADR-AZ-CUSTOMER-KEYISSUBFOLDER
          - ADR-AZ-DATAMOD-NAMEKEYEDMAPS
          - ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION
          - ADR-AZ-DATAMOD-TWOCONFIGLAYERS
      - cell: subject/Catzc.Base.Drs
        by:
          - pwsh/Catzc.Base.Drs/configs/drs-index.yml
          - pwsh/Catzc.Base.Drs/configs/drs.yml
          - ADR-AZ-CUSTOMER-KEYISSUBFOLDER
          - ADR-AZ-DATAMOD-NAMEKEYEDMAPS
          - ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION
          - ADR-AZ-DATAMOD-TWOCONFIGLAYERS
      - cell: subject/Catzc.Base.QualityGates
        by:
          - pwsh/Catzc.Base.QualityGates/private/Get-MarkdownHeadingFinding.ps1
          - ADR-AZ-DATAMOD-NAMEKEYEDMAPS
          - ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION
          - ADR-AZ-DATAMOD-TWOCONFIGLAYERS
      - cell: subject/Catzc.Base.Variants
        by: [pwsh/Catzc.Base.Variants/configs/variants.yml, ADR-AZ-CUSTOMER-KEYISSUBFOLDER]
      - cell: subject/discovery
        by:
          - infrastructure/templates/discovery/options.yml
          - ADR-AZ-DATAMOD-NAMEKEYEDMAPS
          - ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION
          - ADR-AZ-DATAMOD-TWOCONFIGLAYERS
      - cell: subject/expedition
        by:
          - infrastructure/templates/expedition/options.yml
          - ADR-AZ-DATAMOD-NAMEKEYEDMAPS
          - ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION
          - ADR-AZ-DATAMOD-TWOCONFIGLAYERS
      - cell: subject/foundation
        by:
          - infrastructure/templates/foundation/options.yml
          - ADR-AZ-DATAMOD-NAMEKEYEDMAPS
          - ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION
          - ADR-AZ-DATAMOD-TWOCONFIGLAYERS
      - cell: subject/pipelines
        by:
          - .ado/pipelines/cd-shared.yaml
          - .ado/pipelines/extends/cd-customer.yaml
          - ADR-AZ-DATAMOD-NAMEKEYEDMAPS
          - ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION
          - ADR-AZ-DATAMOD-TWOCONFIGLAYERS
    axis:
      - cell: CLOUD/deploy
        by:
          - ADR-AZ-CUSTOMER-KEYISSUBFOLDER
          - ADR-AZ-DATAMOD-NAMEKEYEDMAPS
          - ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION
          - ADR-AZ-DATAMOD-TWOCONFIGLAYERS
      - cell: CLOUD/access
        by: [ADR-AZ-DATAMOD-NAMEKEYEDMAPS, ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION, ADR-AZ-DATAMOD-TWOCONFIGLAYERS]
layout:
  band-tree: { x: 20, y: 84, w: 420, h: 280 }
  band-resolved: { x: 460, y: 84, w: 820, h: 280 }
  g-root: { x: 70, y: 144, w: 170, h: 52 }
  g-customer: { x: 70, y: 266, w: 170, h: 52 }
  g-one: { x: 520, y: 190, w: 210, h: 68 }
  e-subscription: { x: 800, y: 198, w: 180, h: 52 }
  e-group: { x: 1050, y: 198, w: 180, h: 52 }
```

![A config file's path is a coordinate that resolves to one subscription and one resource group](.assets/config-path-is-a-coordinate.drawio.png)

## Walkthrough

1. **Root config.** A file at the configuration root, `configuration/<env>[-<slot>].yml`, is a deployment of the shared platform. Its
   coordinate has no customer, so only the non-customer subscriptions can serve it.
2. **Customer config.** A file under a subfolder, `configuration/<customer>/<env>[-<slot>].yml`, is that customer's deployment. The
   subfolder is always a customer key from the customer catalogue, so a subfolder that names no customer is a discovery error.
3. **Exactly one subscription.** The coordinate (customer?, env) is matched against the subscriptions of `azure.yml`: those serving the
   environment, filtered to the non-customer ones for a root config or to the customer's own for a customer config. Exactly one must remain.
   Zero or several stop discovery, which is how the shared platform stays one platform and a customer's environments stay disjoint. The slot
   plays no part in this choice.
4. **Subscription.** The one match is the subscription the config deploys into. It is a resolved value, never an argument and never a path
   segment, so no subscription name appears anywhere in the templating layer.
5. **Resource group.** Each config is one slot and one resource group. The group's name is derived from the coordinate by the namer, never
   typed into a config, so the file, the subscription and the group stay one-to-one.

## Why it holds

- A config at the configuration root is the shared platform's and a config under a customer subfolder is that customer's; the subscription
  is always resolved from that coordinate and never spelled into a path (ADR-AZ-DATAMOD-TWOCONFIGLAYERS).
- One config file is one (customer?, env, slot), one subscription and one Azure resource group, at
  `configuration/[<customer>/]<env>[-<slot>].yml`, so listing the tree is the resource-group inventory
  (ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION).
- A configuration subfolder is always a customer key, and every coordinate must resolve to exactly one subscription: a root config's
  environment to one non-customer subscription, a customer config's environment to one of that customer's, asserted per file at discovery
  and by integrity tests (ADR-AZ-DATAMOD-NAMEKEYEDMAPS).
- The customer key is the subfolder name, one spelling on disk; the shortcode never names a folder (ADR-AZ-CUSTOMER-KEYISSUBFOLDER).

## See also

- [Templating data model](../../drs/azure/azure-data-model.md) — the decision this article explains, with the
  [customer model](../../drs/azure/azure-customer-model.md) it pairs with.
- The other lenses on the same coordinate: [architecture](two-layers-join-through-one-resolver.md),
  [implementation](coordinate-resolved-file-by-file-at-discovery.md), [operations](a-bad-coordinate-stops-discovery.md) and
  [governance](coordinate-rules-and-their-gates.md).
- [The Azure explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
