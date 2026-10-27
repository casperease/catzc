# Three gates guard the CLI and az, but nothing checks that cats stays thin

```text
Three gates guard the CLI and az, but nothing checks that cats stays thin.

1  NoAzModuleNaming      gate: no function named like an Az PowerShell cmdlet
2  Verb-Noun functions   the CLI surface consumers bind to
3  config validation     gate: the configuration is checked before the functions act
4  everything is code    DRS-only: one living version in the repository
5  Assert-Tool 'az_cli'  gate: the installed az matches its pin
6  no reimplementation   DRS-only: call the vendor's tools, never rebuild them
7  az CLI                the default for every Azure operation
8  swappable substrate   DRS-only: the vendor could change behind the CLI

Supports DDR-THINPLAT-THINPLATFORM, DDR-THINPLAT-DELEGATENOTREIMPLEMENT, DDR-THINPLAT-PLATFORMASCLI, DDR-THINPLAT-REPRESENTEDASCODE
and DDR-THINPLAT-SWAPPABLESUBSTRATE, and ADR-AZ-CLI-AZBYDEFAULT, ADR-AZ-CLI-ASSERTAZ and ADR-AZ-CLI-NOAZMODULEIMPORT (governance lens).
```

Each rule that shapes cats as a thin platform constrains either the CLI surface or the vendor call behind it. Three of those rules have a
gate that stops the flow when they break: the function naming, the configuration, and the az version pin. The rules that make the platform
thin in the first place (no reimplementation, everything as code, a swappable substrate) have no code behind them and are held by review
alone.

```yml drawio
description:
  "Which rules that keep the platform thin have a gate: the function naming rule, the configuration check and the az version pin do, while
  no reimplementation, everything as code and the swappable substrate are held by review alone."
about:
  adrs:
    - DDR-THINPLAT-THINPLATFORM
    - DDR-THINPLAT-DELEGATENOTREIMPLEMENT
    - DDR-THINPLAT-PLATFORMASCLI
    - DDR-THINPLAT-REPRESENTEDASCODE
    - DDR-THINPLAT-SWAPPABLESUBSTRATE
    - ADR-AZ-CLI-AZBYDEFAULT
    - ADR-AZ-CLI-ASSERTAZ
    - ADR-AZ-CLI-NOAZMODULEIMPORT
  lens: governance
content:
  title: Three gates guard the CLI and az, but nothing checks that the platform stays thin
  kind: explanation
  flow: left-to-right
  theme: dark
  bands:
    - { id: band-surface, label: CLI SURFACE }
    - { id: band-catzc, label: CATZC }
    - { id: band-delegated, label: DELEGATED }
    - { id: band-substrate, label: VENDOR SUBSTRATE }
  glyphs:
    - { id: g-naming, kind: gate, label: NoAzModuleNaming, in: band-surface }
    - { id: g-functions, kind: code, label: Verb-Noun functions, in: band-surface }
    - { id: g-config, kind: gate, label: config validation, in: band-surface }
    - { id: g-everything-code, kind: drsonly, label: everything is code, in: band-catzc }
    - { id: g-assert-tool, kind: gate, label: Assert-Tool 'az_cli', in: band-catzc }
    - { id: g-no-reimplementation, kind: drsonly, label: no reimplementation, in: band-delegated }
    - { id: g-az-cli, kind: external, label: az CLI, in: band-delegated }
    - { id: g-substrate, kind: drsonly, label: swappable substrate, in: band-substrate }
  edges:
    - { from: g-naming, to: g-functions, kind: flow, label: calls }
    - { from: g-config, to: g-functions, kind: flow, label: calls }
    - { from: g-everything-code, to: g-functions, kind: adr, label: "" }
    - { from: g-assert-tool, to: g-az-cli, kind: flow, label: "" }
    - { from: g-no-reimplementation, to: g-az-cli, kind: adr, label: "" }
    - { from: g-substrate, to: g-az-cli, kind: adr, label: "" }
  markers:
    - { at: g-naming, number: 1 }
    - { at: g-functions, number: 2 }
    - { at: g-config, number: 3 }
    - { at: g-everything-code, number: 4 }
    - { at: g-assert-tool, number: 5 }
    - { at: g-no-reimplementation, number: 6 }
    - { at: g-az-cli, number: 7 }
    - { at: g-substrate, number: 8 }
  chips:
    - { at: g-naming, kind: rule, rule: ADR-AZ-CLI-NOAZMODULEIMPORT }
    - { at: g-functions, kind: rule, rule: DDR-THINPLAT-PLATFORMASCLI, gated: false }
    - { at: g-config, kind: rule, rule: DDR-THINPLAT-THINPLATFORM }
    - { at: g-everything-code, kind: rule, rule: DDR-THINPLAT-REPRESENTEDASCODE, gated: false }
    - { at: g-assert-tool, kind: rule, rule: ADR-AZ-CLI-ASSERTAZ }
    - { at: g-no-reimplementation, kind: rule, rule: DDR-THINPLAT-DELEGATENOTREIMPLEMENT, gated: false }
    - { at: g-az-cli, kind: rule, rule: ADR-AZ-CLI-AZBYDEFAULT, gated: false }
    - { at: g-substrate, kind: rule, rule: DDR-THINPLAT-SWAPPABLESUBSTRATE, gated: false }
  legend: auto
  minimaps: [code-locations, module-neighbourhood, axis]
layout:
  band-surface: { x: 20, y: 104, w: 1260, h: 130 }
  band-catzc: { x: 20, y: 254, w: 1260, h: 130 }
  band-delegated: { x: 20, y: 404, w: 1260, h: 130 }
  band-substrate: { x: 20, y: 554, w: 1260, h: 130 }
  g-naming: { x: 140, y: 140, w: 220, h: 84 }
  g-functions: { x: 440, y: 168, w: 400, h: 44 }
  g-config: { x: 920, y: 140, w: 220, h: 84 }
  g-everything-code: { x: 410, y: 300, w: 220, h: 52 }
  g-assert-tool: { x: 680, y: 280, w: 240, h: 90 }
  g-no-reimplementation: { x: 140, y: 450, w: 220, h: 52 }
  g-az-cli: { x: 440, y: 450, w: 400, h: 44 }
  g-substrate: { x: 530, y: 600, w: 220, h: 52 }
```

![Three gates guard the CLI and az; thinness has none](.assets/what-keeps-the-platform-thin.drawio.png)

## Walkthrough

1. **NoAzModuleNaming.** A custom PSScriptAnalyzer rule that flags any function named like an Az PowerShell cmdlet (`Verb-Az<Noun>`),
   allowing only the `Azure`, `AzCli` and `AzBicep` prefixes. It runs inside `Test-Automation` on every devbox run and in CI, and the
   analyzer map credits it to ADR-AZ-CLI-AZURENOUNPREFIX.
2. **Verb-Noun functions.** The CLI surface: the public functions are the only thing a consumer binds to. The code delivers that surface,
   but no gate checks that consumers bind to nothing else.
3. **Config validation.** The configuration the functions read is checked before they act. The `AzureConfig` type validates `azure.yml` when
   it loads, a template's `options.yml` throws on a bad key, and an az session whose subscription `azure.yml` does not declare throws before
   anything deploys.
4. **Everything is code.** The DDR requires the automation, configs, tool versions and vendor bindings to live as one living version in the
   repository. No dedicated check holds it, and the Thinnest Viable Platform test ("if a wiki page would do, we do not build a function") is
   a review question too.
5. **Assert-Tool 'az_cli'.** The tooling contract. `Invoke-AzCli` and `Connect-AzCli` assert the `az_cli` pin from `tools.yml` (held by
   `Catzc.Base.Execution`) at run time, and `Build-Bicep` asserts the `bicep` pin from the same file before it builds.
6. **No reimplementation.** The platform calls the vendor's own tools and never rebuilds them, for example through SDK assemblies. No gate
   checks it.
7. **az CLI.** The default for every Azure operation, wrapped by `Invoke-AzCli` over `Invoke-Executable`. The code does it, but no gate
   checks that a caller uses az rather than something else.
8. **Swappable substrate.** The vendor sits behind the CLI and could change without reshaping a consumer's API. Azure is the only substrate
   today, so nothing exercises the swap.

## Why it holds

- The conventions over Azure are owned by the platform and live in its configuration (DDR-THINPLAT-THINPLATFORM).
- Thin is delegation, not reimplementation (DDR-THINPLAT-DELEGATENOTREIMPLEMENT).
- The `Verb-Noun` functions and their configuration are the platform's API (DDR-THINPLAT-PLATFORMASCLI).
- Everything the platform covers is code, in one living version (DDR-THINPLAT-REPRESENTEDASCODE).
- The substrate is swappable, and the consequential choices stay in the consumer's configuration (DDR-THINPLAT-SWAPPABLESUBSTRATE).
- az is the default for Azure operations (ADR-AZ-CLI-AZBYDEFAULT), a function that calls az asserts `Assert-Tool 'az_cli'` first
  (ADR-AZ-CLI-ASSERTAZ), and automation code never imports `Az.*` (ADR-AZ-CLI-NOAZMODULEIMPORT).

## Where the code and the decision record differ

- The pipeline step template still offers `Mode: azps` (AzurePowerShell@5), and the CI pipeline exercises it, beside ADR-AZ-CLI's az-first
  rule.
- The DDR says consumers call `Get-Azure*` and `New-*` verbs; the only `New-*` function in the Azure modules is `New-AdoPullRequest`, and
  the deploy verbs are `Build-Bicep` and `Deploy-Bicep`.

## See also

- [Thin platforms](../../drs/design/thin-platforms.md) — the decision this article explains.
- [Prefer Az CLI over Az PowerShell modules](../../drs/azure/prefer-az-cli.md) — the az-first rules.
- The other lenses on the same platform: [meta](bind-to-one-cli-delegate-the-rest.md),
  [architecture](every-vendor-call-leaves-through-az.md), [implementation](deploy-bicep-delegates-to-az.md) and
  [operations](same-deploy-bicep-on-both-sides.md).
- [The design explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
