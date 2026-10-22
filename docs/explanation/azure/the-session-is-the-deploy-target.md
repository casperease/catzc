# The az session is the deploy target, and the guard only checks it

```text
The deploy target is the az session's subscription; the guard checks it and never selects it.

1  az session            the az CLI's active subscription: what the service connection logged into
2  subscription guard    the pin of the expected subscription id; mandatory in a pipeline
3  deploy target         the confirmed subscription, whose customer picks the config and the names
4  mis-wired connection  the throw when the session and the pin disagree

Supports ADR-AZ-DATAMOD-JOINSINPOWERSHELL (meta lens).
```

Cats deploys a Bicep template into whatever subscription the az session is signed in to. No deploy call, pipeline step or config path names
the subscription: in a pipeline it is exactly what the service connection logged into, and on a devbox it is what `az account set` chose. A
guard can state which subscription the session is expected to target, and in a pipeline it must, but the guard only confirms the target. It
never picks one.

```yml drawio
description:
  The deploy target is the subscription the az session is signed in to; the guard states which subscription the session is expected to
  target and only confirms it, stopping a mis-wired connection, and never selects one.
about:
  adrs: [ADR-AZ-DATAMOD-JOINSINPOWERSHELL]
  lens: meta
content:
  title: The az session is the deploy target, and the guard only checks it
  kind: explanation
  flow: left-to-right
  relation: decides the next step
  theme: dark
  bands:
    - { id: band-session, label: SESSION }
    - { id: band-guard, label: GUARD }
  glyphs:
    - { id: x-session, kind: external, label: az session, in: band-session }
    - { id: g-guard, kind: gate, label: subscription guard, in: band-guard }
    - { id: r-target, kind: result, label: deploy target, in: band-guard }
    - { id: f-mis-wired, kind: failure, label: mis-wired connection, in: band-guard }
  edges:
    - { from: x-session, to: g-guard, kind: flow, label: "" }
    - { from: g-guard, to: r-target, kind: flow, label: "" }
    - { from: g-guard, to: f-mis-wired, kind: fail, label: "" }
  markers:
    - { at: x-session, number: 1 }
    - { at: g-guard, number: 2 }
    - { at: r-target, number: 3 }
    - { at: f-mis-wired, number: 4 }
  legend: auto
  minimaps:
    code-locations:
      - cell: ado-pipelines/pipelines/.
        by: [.ado/pipelines/cd-shared.yaml, ADR-AZ-DATAMOD-JOINSINPOWERSHELL]
      - cell: ado-pipelines/pipelines/extends
        by: [.ado/pipelines/extends/cd-customer.yaml, ADR-AZ-DATAMOD-JOINSINPOWERSHELL]
      - cell: docs/-/.
        by:
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
          - docs/references/pwsh/catzc-azure-templates/Deploy-Bicep.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Get-AzureBicepEnvironmentKinds.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Get-BicepDeploymentContext.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Get-BicepTemplateConfiguration.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Get-BicepTemplates.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Set-BicepTemplateConfiguration.ps1.md
          - docs/references/pwsh/catzc-azure-templates/private/Get-BicepConfigSubscriptionCandidates.ps1.md
          - docs/references/pwsh/catzc-azure-templates/private/Get-BicepParametersFileName.ps1.md
          - docs/references/pwsh/catzc-azure/Get-AzureSubscriptionEnvironment.ps1.md
          - docs/references/pwsh/catzc-azure/configs/azure.yml.md
          - docs/references/pwsh/catzc-azure/tests/types/AzureConfig.Tests.ps1.md
          - docs/references/pwsh/catzc-azure/types/AzureConfig.cs.md
          - docs/references/pwsh/catzc-azure/types/AzureEnvironmentRecord.cs.md
          - docs/references/pwsh/catzc-azure/types/AzureSubscriptionRecord.cs.md
          - docs/references/pwsh/catzc-azure/types/AzureTenantRecord.cs.md
          - docs/references/pwsh/catzc-base-quality-gates/private/Get-MarkdownHeadingFinding.ps1.md
          - ADR-AZ-DATAMOD-JOINSINPOWERSHELL
      - cell: infrastructure/discovery/.
        by: [infrastructure/templates/discovery/options.yml, ADR-AZ-DATAMOD-JOINSINPOWERSHELL]
      - cell: infrastructure/expedition/.
        by: [infrastructure/templates/expedition/options.yml, ADR-AZ-DATAMOD-JOINSINPOWERSHELL]
      - cell: infrastructure/foundation/.
        by: [infrastructure/templates/foundation/options.yml, ADR-AZ-DATAMOD-JOINSINPOWERSHELL]
      - cell: pwsh/Catzc.Azure/.
        by: [pwsh/Catzc.Azure/Get-AzureSubscriptionEnvironment.ps1, ADR-AZ-DATAMOD-JOINSINPOWERSHELL]
      - cell: pwsh/Catzc.Azure/configs
        by: [pwsh/Catzc.Azure/configs/azure.yml, ADR-AZ-DATAMOD-JOINSINPOWERSHELL]
      - cell: pwsh/Catzc.Azure/tests/types
        by: [pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1, ADR-AZ-DATAMOD-JOINSINPOWERSHELL]
      - cell: pwsh/Catzc.Azure/types
        by:
          - pwsh/Catzc.Azure/types/AzureConfig.cs
          - pwsh/Catzc.Azure/types/AzureEnvironmentRecord.cs
          - pwsh/Catzc.Azure/types/AzureSubscriptionRecord.cs
          - pwsh/Catzc.Azure/types/AzureTenantRecord.cs
          - ADR-AZ-DATAMOD-JOINSINPOWERSHELL
      - cell: pwsh/Catzc.Azure.Cli/.
        by:
          - pwsh/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1
          - pwsh/Catzc.Azure.Cli/Assert-AzCliIsConnected.ps1
          - pwsh/Catzc.Azure.Cli/Get-AzCliSessionSubscription.ps1
          - pwsh/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1
          - ADR-AZ-DATAMOD-JOINSINPOWERSHELL
      - cell: pwsh/Catzc.Azure.Templates/.
        by:
          - pwsh/Catzc.Azure.Templates/Deploy-Bicep.ps1
          - pwsh/Catzc.Azure.Templates/Get-AzureBicepEnvironmentKinds.ps1
          - pwsh/Catzc.Azure.Templates/Get-BicepDeploymentContext.ps1
          - pwsh/Catzc.Azure.Templates/Get-BicepTemplateConfiguration.ps1
          - pwsh/Catzc.Azure.Templates/Get-BicepTemplates.ps1
          - pwsh/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1
          - ADR-AZ-DATAMOD-JOINSINPOWERSHELL
      - cell: pwsh/Catzc.Azure.Templates/private
        by:
          - pwsh/Catzc.Azure.Templates/private/Get-BicepConfigSubscriptionCandidates.ps1
          - pwsh/Catzc.Azure.Templates/private/Get-BicepParametersFileName.ps1
          - ADR-AZ-DATAMOD-JOINSINPOWERSHELL
      - cell: pwsh/Catzc.Base.Drs/configs
        by: [pwsh/Catzc.Base.Drs/configs/drs.yml, ADR-AZ-DATAMOD-JOINSINPOWERSHELL]
      - cell: pwsh/Catzc.Base.QualityGates/private
        by: [pwsh/Catzc.Base.QualityGates/private/Get-MarkdownHeadingFinding.ps1, ADR-AZ-DATAMOD-JOINSINPOWERSHELL]
    module-neighbourhood:
      - cell: subject/Catzc.Azure
        by:
          - pwsh/Catzc.Azure/Get-AzureSubscriptionEnvironment.ps1
          - pwsh/Catzc.Azure/configs/azure.yml
          - pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1
          - pwsh/Catzc.Azure/types/AzureConfig.cs
          - pwsh/Catzc.Azure/types/AzureEnvironmentRecord.cs
          - pwsh/Catzc.Azure/types/AzureSubscriptionRecord.cs
          - pwsh/Catzc.Azure/types/AzureTenantRecord.cs
          - ADR-AZ-DATAMOD-JOINSINPOWERSHELL
      - cell: subject/Catzc.Azure.Cli
        by:
          - pwsh/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1
          - pwsh/Catzc.Azure.Cli/Assert-AzCliIsConnected.ps1
          - pwsh/Catzc.Azure.Cli/Get-AzCliSessionSubscription.ps1
          - pwsh/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1
          - ADR-AZ-DATAMOD-JOINSINPOWERSHELL
      - cell: subject/Catzc.Azure.Templates
        by:
          - pwsh/Catzc.Azure.Templates/Deploy-Bicep.ps1
          - pwsh/Catzc.Azure.Templates/Get-AzureBicepEnvironmentKinds.ps1
          - pwsh/Catzc.Azure.Templates/Get-BicepDeploymentContext.ps1
          - pwsh/Catzc.Azure.Templates/Get-BicepTemplateConfiguration.ps1
          - pwsh/Catzc.Azure.Templates/Get-BicepTemplates.ps1
          - pwsh/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1
          - pwsh/Catzc.Azure.Templates/private/Get-BicepConfigSubscriptionCandidates.ps1
          - pwsh/Catzc.Azure.Templates/private/Get-BicepParametersFileName.ps1
          - ADR-AZ-DATAMOD-JOINSINPOWERSHELL
      - cell: subject/Catzc.Base.Drs
        by: [pwsh/Catzc.Base.Drs/configs/drs.yml, ADR-AZ-DATAMOD-JOINSINPOWERSHELL]
      - cell: subject/Catzc.Base.QualityGates
        by: [pwsh/Catzc.Base.QualityGates/private/Get-MarkdownHeadingFinding.ps1, ADR-AZ-DATAMOD-JOINSINPOWERSHELL]
      - cell: subject/discovery
        by: [infrastructure/templates/discovery/options.yml, ADR-AZ-DATAMOD-JOINSINPOWERSHELL]
      - cell: subject/expedition
        by: [infrastructure/templates/expedition/options.yml, ADR-AZ-DATAMOD-JOINSINPOWERSHELL]
      - cell: subject/foundation
        by: [infrastructure/templates/foundation/options.yml, ADR-AZ-DATAMOD-JOINSINPOWERSHELL]
      - cell: subject/pipelines
        by: [.ado/pipelines/cd-shared.yaml, .ado/pipelines/extends/cd-customer.yaml, ADR-AZ-DATAMOD-JOINSINPOWERSHELL]
    axis:
      - cell: CLOUD/deploy
        by: [ADR-AZ-DATAMOD-JOINSINPOWERSHELL]
      - cell: CLOUD/access
        by: [ADR-AZ-DATAMOD-JOINSINPOWERSHELL]
layout:
  band-session: { x: 20, y: 84, w: 560, h: 250 }
  band-guard: { x: 600, y: 84, w: 680, h: 250 }
  x-session: { x: 200, y: 156, w: 200, h: 52 }
  g-guard: { x: 700, y: 148, w: 200, h: 68 }
  r-target: { x: 1040, y: 160, w: 200, h: 44 }
  f-mis-wired: { x: 700, y: 268, w: 200, h: 44 }
```

![The az session is the deploy target, and the guard only checks it](.assets/the-session-is-the-deploy-target.drawio.png)

## Walkthrough

1. **Az session.** The az CLI's active subscription. In a pipeline it is the subscription the service connection logged into; on a devbox
   `az login` and `az account set` choose it. Cats reads the session and resolves its subscription id against `azure.yml`. A session that
   targets a subscription the file does not declare is an error, not a fallback.
2. **Subscription guard.** `-SubscriptionIdAssertIs` carries the subscription id the session is expected to target. It is mandatory in a
   pipeline, where `Deploy-Bicep` throws without it, and optional on a devbox. When it is set, the resolved session must carry the same id.
   The guard selects nothing: the session has already decided.
3. **Deploy target.** The session's subscription, confirmed. Its `customer` picks the template's configuration slot, the customer's
   subfolder or the configuration root, and renders into the resource-group name. The subscription itself never appears in a name.
4. **Mis-wired connection.** When the session's id and the guard's id differ, the deploy throws before anything is built or deployed. In a
   pipeline that means the service connection is wired to the wrong subscription, so a re-wired connection can never silently retarget an
   existing pipeline's deploy.

## Why it holds

- The deploy-time subscription is determined by the az session, reverse-resolved against `azure.yml`, and a pipeline deploy must still pin
  its target: `-SubscriptionIdAssertIs` is mandatory in a pipeline and optional on a devbox (ADR-AZ-DATAMOD-JOINSINPOWERSHELL).
- The assert is a guard, never a selector: a mismatch means a mis-wired service connection and fails loudly
  (ADR-AZ-DATAMOD-JOINSINPOWERSHELL).

## See also

- [Templating data model](../../drs/azure/azure-data-model.md) — the decision this article explains.
- The other lenses on the same deploy target: [architecture](one-reverse-lookup-feeds-every-module.md),
  [implementation](read-the-session-guard-then-pick-slot.md), [operations](pipeline-pins-devbox-picks-the-target.md) and
  [governance](four-gates-hold-the-session-rule.md).
- [The azure explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
