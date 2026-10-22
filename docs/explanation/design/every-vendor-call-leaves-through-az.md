---
catzc:
  edges:
    cites:
      - ADR-AZ-CLI-AZBYDEFAULT
      - ADR-AZ-CLI-ASSERTAZ
      - ADR-AZ-CLI-NOAZMODULEIMPORT
      - DDR-THINPLAT-THINPLATFORM
      - DDR-THINPLAT-DELEGATENOTREIMPLEMENT
      - DDR-THINPLAT-PLATFORMASCLI
---

# Every vendor call leaves cats through the az CLI

```text
Every vendor call leaves cats through the az CLI, the one exit to Azure.

1  Catzc.Azure.Templates    the module behind the deploy commands; never calls the vendor itself
2  azure.yml, options.yml   the configuration both Azure modules read
3  Catzc.Azure.Cli          the module that owns the az session and the az wrapper
4  Catzc.Tooling.Core       the tooling contract: checks the installed az against its pin
5  az CLI                   the vendor's control-plane tool, and the one exit to Azure
6  Bicep                    the vendor's templating language, compiled by az
7  Azure                    the vendor substrate, today the only one
8  the single exit          the only edge that reaches Azure leaves from az

Supports DDR-THINPLAT-THINPLATFORM, DDR-THINPLAT-DELEGATENOTREIMPLEMENT and DDR-THINPLAT-PLATFORMASCLI, and ADR-AZ-CLI-AZBYDEFAULT, ADR-AZ-CLI-ASSERTAZ and ADR-AZ-CLI-NOAZMODULEIMPORT (architecture lens).
```

Cats is a thin platform over Azure: it standardizes how the vendor is used and leaves the work to the vendor's own tools. On the Bicep
deploy path, two Azure modules do the platform's part. One composes and deploys templates, the other owns the az session and the az wrapper,
and everything that reaches Azure, compiling a template included, goes out through the az CLI.

```yml drawio
description:
  Two Azure modules do the platform's part on the Bicep deploy path, and every vendor call, a template compile included, leaves through the
  az command-line tool, the one exit to Azure.
about:
  adrs:
    - DDR-THINPLAT-THINPLATFORM
    - DDR-THINPLAT-DELEGATENOTREIMPLEMENT
    - DDR-THINPLAT-PLATFORMASCLI
    - ADR-AZ-CLI-AZBYDEFAULT
    - ADR-AZ-CLI-ASSERTAZ
    - ADR-AZ-CLI-NOAZMODULEIMPORT
  lens: architecture
content:
  title: Every vendor call leaves cats through the az CLI
  kind: explanation
  flow: top-to-bottom
  relation: uses
  theme: dark
  bands:
    - { id: band-surface, label: CLI SURFACE }
    - { id: band-platform, label: CATZC }
    - { id: band-delegated, label: DELEGATED }
    - { id: band-vendor, label: VENDOR SUBSTRATE }
  glyphs:
    - { id: c-templates, kind: code, label: Catzc.Azure.Templates, in: band-surface }
    - { id: f-configuration, kind: file, label: azure.yml · options.yml, in: band-surface }
    - { id: c-azure-cli, kind: code, label: Catzc.Azure.Cli, in: band-platform }
    - { id: c-tooling, kind: code, label: Catzc.Tooling.Core, in: band-platform }
    - { id: x-command, kind: external, label: az CLI, in: band-delegated }
    - { id: x-bicep, kind: external, label: Bicep, in: band-delegated }
    - { id: e-azure, kind: env, label: Azure, in: band-vendor }
  edges:
    - { from: c-templates, to: f-configuration, kind: flow, label: "" }
    - { from: c-templates, to: c-azure-cli, kind: flow, label: "" }
    - { from: c-azure-cli, to: f-configuration, kind: flow, label: "" }
    - { from: c-azure-cli, to: c-tooling, kind: flow, label: "" }
    - { from: c-azure-cli, to: x-command, kind: flow, label: "" }
    - { from: x-command, to: x-bicep, kind: flow, label: "" }
    - { from: x-command, to: e-azure, kind: flow, label: the single exit }
  markers:
    - { at: c-templates, number: 1 }
    - { at: f-configuration, number: 2 }
    - { at: c-azure-cli, number: 3 }
    - { at: c-tooling, number: 4 }
    - { at: x-command, number: 5 }
    - { at: x-bicep, number: 6 }
    - { at: e-azure, number: 7 }
  legend: auto
  minimaps:
    code-locations:
      - cell: docs/-/.
        by:
          - docs/drs/azure/dora-explains.md
          - docs/drs/azure/prefer-az-cli.md
          - docs/drs/design/dora-explains.md
          - docs/drs/design/thin-platforms.md
          - docs/drs/index.md
          - docs/references/pwsh/catzc-azure-cli/Assert-AzCliBicep.ps1.md
          - docs/references/pwsh/catzc-azure-cli/Assert-AzCliCanAccess.ps1.md
          - docs/references/pwsh/catzc-azure-cli/Assert-AzCliSubscriptionAccessible.ps1.md
          - docs/references/pwsh/catzc-azure-cli/Get-AzCliSubscriptionAccessState.ps1.md
          - docs/references/pwsh/catzc-azure-cli/Install-AzCliBicep.ps1.md
          - docs/references/pwsh/catzc-azure-cli/Test-AzCliBicep.ps1.md
          - docs/references/pwsh/catzc-azure-cli/Test-AzCliCanAccess.ps1.md
          - docs/references/pwsh/catzc-azure-cli/Test-AzCliSubscriptionAccessible.ps1.md
          - ADR-AZ-CLI-ASSERTAZ
          - ADR-AZ-CLI-AZBYDEFAULT
          - ADR-AZ-CLI-NOAZMODULEIMPORT
          - DDR-THINPLAT-DELEGATENOTREIMPLEMENT
          - DDR-THINPLAT-PLATFORMASCLI
          - DDR-THINPLAT-THINPLATFORM
      - cell: pwsh/Catzc.Azure.Cli/.
        by:
          - pwsh/Catzc.Azure.Cli/Assert-AzCliBicep.ps1
          - pwsh/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1
          - pwsh/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1
          - pwsh/Catzc.Azure.Cli/Get-AzCliSubscriptionAccessState.ps1
          - pwsh/Catzc.Azure.Cli/Install-AzCliBicep.ps1
          - pwsh/Catzc.Azure.Cli/Test-AzCliBicep.ps1
          - pwsh/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1
          - pwsh/Catzc.Azure.Cli/Test-AzCliSubscriptionAccessible.ps1
          - ADR-AZ-CLI-AZBYDEFAULT
      - cell: pwsh/Catzc.Base.Drs/configs
        by:
          - pwsh/Catzc.Base.Drs/configs/drs.yml
          - ADR-AZ-CLI-ASSERTAZ
          - ADR-AZ-CLI-AZBYDEFAULT
          - ADR-AZ-CLI-NOAZMODULEIMPORT
          - DDR-THINPLAT-DELEGATENOTREIMPLEMENT
          - DDR-THINPLAT-PLATFORMASCLI
          - DDR-THINPLAT-THINPLATFORM
      - cell: pwsh/Catzc.Base.QualityGates/configs
        by: [pwsh/Catzc.Base.QualityGates/configs/terminology.yml, ADR-AZ-CLI-ASSERTAZ, ADR-AZ-CLI-AZBYDEFAULT, ADR-AZ-CLI-NOAZMODULEIMPORT]
    module-neighbourhood:
      - cell: subject/Catzc.Azure.Cli
        by:
          - pwsh/Catzc.Azure.Cli/Assert-AzCliBicep.ps1
          - pwsh/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1
          - pwsh/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1
          - pwsh/Catzc.Azure.Cli/Get-AzCliSubscriptionAccessState.ps1
          - pwsh/Catzc.Azure.Cli/Install-AzCliBicep.ps1
          - pwsh/Catzc.Azure.Cli/Test-AzCliBicep.ps1
          - pwsh/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1
          - pwsh/Catzc.Azure.Cli/Test-AzCliSubscriptionAccessible.ps1
          - ADR-AZ-CLI-AZBYDEFAULT
      - cell: subject/Catzc.Base.Drs
        by:
          - pwsh/Catzc.Base.Drs/configs/drs.yml
          - ADR-AZ-CLI-ASSERTAZ
          - ADR-AZ-CLI-AZBYDEFAULT
          - ADR-AZ-CLI-NOAZMODULEIMPORT
          - DDR-THINPLAT-DELEGATENOTREIMPLEMENT
          - DDR-THINPLAT-PLATFORMASCLI
          - DDR-THINPLAT-THINPLATFORM
      - cell: subject/Catzc.Base.QualityGates
        by: [pwsh/Catzc.Base.QualityGates/configs/terminology.yml, ADR-AZ-CLI-ASSERTAZ, ADR-AZ-CLI-AZBYDEFAULT, ADR-AZ-CLI-NOAZMODULEIMPORT]
    axis:
      - cell: DSGN/deploy
        by: [DDR-THINPLAT-DELEGATENOTREIMPLEMENT, DDR-THINPLAT-PLATFORMASCLI, DDR-THINPLAT-THINPLATFORM]
      - cell: CLOUD/deploy
        by: [ADR-AZ-CLI-ASSERTAZ, ADR-AZ-CLI-AZBYDEFAULT, ADR-AZ-CLI-NOAZMODULEIMPORT]
      - cell: CLOUD/access
        by: [ADR-AZ-CLI-ASSERTAZ, ADR-AZ-CLI-AZBYDEFAULT, ADR-AZ-CLI-NOAZMODULEIMPORT]
layout:
  band-surface: { x: 20, y: 84, w: 1260, h: 120 }
  band-platform: { x: 20, y: 224, w: 1260, h: 120 }
  band-delegated: { x: 20, y: 364, w: 1260, h: 120 }
  band-vendor: { x: 20, y: 504, w: 1260, h: 120 }
  c-templates: { x: 200, y: 125, w: 280, h: 44 }
  f-configuration: { x: 600, y: 125, w: 280, h: 44 }
  c-azure-cli: { x: 380, y: 265, w: 280, h: 44 }
  c-tooling: { x: 800, y: 265, w: 280, h: 44 }
  x-command: { x: 380, y: 405, w: 280, h: 44 }
  x-bicep: { x: 800, y: 405, w: 280, h: 44 }
  e-azure: { x: 380, y: 545, w: 280, h: 52 }
```

![Every vendor call leaves through the az CLI](.assets/every-vendor-call-leaves-through-az.drawio.png)

## Walkthrough

1. **Catzc.Azure.Templates.** The module behind the CLI surface for infrastructure: its public `Build-Bicep` and `Deploy-Bicep` are the
   commands a developer and a CD pipeline both type. It composes the Bicep templates under `infrastructure/templates/` and never calls the
   vendor itself; its declared Azure dependency is `Catzc.Azure.Cli`.
2. **azure.yml and options.yml.** The configuration that drives the commands. `azure.yml` holds the environments, subscriptions and regions,
   and each template can carry an `options.yml` of validated overrides beside it. Both modules read it.
3. **Catzc.Azure.Cli.** The module that owns the az session: the login, the session's subscription, and `Invoke-AzCli`, the wrapper every
   deploy-path call goes through.
4. **Catzc.Tooling.Core.** The tooling contract. It reads the `az_cli` pin from `tools.yml`, which `Catzc.Base.Execution` holds, and
   `Assert-Tool 'az_cli'` checks the installed az against it before the wrapper runs az.
5. **az CLI.** The vendor's control-plane tool, and the one exit to Azure. The resource-group check and create, the deployment and the
   tracking tags all go through it.
6. **Bicep.** The vendor's templating language. The platform does not generate ARM by hand: az compiles each template with `az bicep build`.
7. **Azure.** The vendor substrate, today the only one cats covers.
8. **The single exit.** Only one arrow reaches Azure, and it leaves from the az CLI. No automation code imports an Az PowerShell module.

## Why it holds

- Cats is a single CLI abstraction over the vendor that standardizes how Azure is used without reimplementing it
  (DDR-THINPLAT-THINPLATFORM).
- Thin comes from delegation: Bicep for templating and the az CLI for control-plane actions, never a clone of either
  (DDR-THINPLAT-DELEGATENOTREIMPLEMENT).
- The `Verb-Noun` functions and their configuration are the platform's API, so the modules behind them can be re-wired without touching a
  consumer (DDR-THINPLAT-PLATFORMASCLI).
- az is the default for every Azure operation, called through `Invoke-Executable` (ADR-AZ-CLI-AZBYDEFAULT); a function that calls az asserts
  it with `Assert-Tool 'az_cli'` first (ADR-AZ-CLI-ASSERTAZ); and automation code never imports `Az.*` (ADR-AZ-CLI-NOAZMODULEIMPORT).

## See also

- [Thin platforms](../../drs/design/thin-platforms.md) — the decision this article explains.
- [Prefer Az CLI over Az PowerShell modules](../../drs/azure/prefer-az-cli.md) — the az-first rules.
- The other lenses on the same platform: [meta](bind-to-one-cli-delegate-the-rest.md), [implementation](deploy-bicep-delegates-to-az.md),
  [operations](same-deploy-bicep-on-both-sides.md) and [governance](what-keeps-the-platform-thin.md).
- [The design explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
