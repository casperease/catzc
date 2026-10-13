# docs/adr/azure/azure-network-model.md

`ADR: Network model (network.yml)`

This ADR covers the cross-cutting IP plan, which the data model deliberately leaves out of its two layers.

Pairs with [`data-model`](azure-data-model.md) (identity + templating) and [`naming-standard`](azure-naming-standard.md).

## Rules: ADR-AZ-NETWORK

### Rule ADR-AZ-NETWORK:1

The IP plan lives only in `network.yml` — never duplicate vnet/subnet ranges into a template's per-slot config. A template that needs ranges
reads them from `Get-Config -Config network` in its prepare hook and merges them into the parameter set.

> **Status.** The asset, its config type, and the prepare-hook range-merge mechanism are built and exercised by a fixture test (the
> `sample-with-prepost` template merges `vnet_address_space` / `default_subnet` into its parameter set). The shipped production templates do
> not create a vnet, so none of them consumes `network.yml` ranges; a production template that needs a vnet uses the same mechanism.

- [The asset](#the-asset)

### Rule ADR-AZ-NETWORK:2

Key the plan by environment name, matching `azure.yml`; the two assets stay in sync via the config type's load-time check, not by convention
alone.

- [Validation (`NetworkConfig`)](#validation)

### Rule ADR-AZ-NETWORK:3

One address space per environment — multi-region-per-environment is out of scope (each environment maps to one region).

- [The asset](#the-asset)

### Rule ADR-AZ-NETWORK:4

Per-subscription envs (`nsub`/`psub`) need no network entry — they carry no vnet, so the standard-env requirement skips them (a
`nsub`/`psub` entry is not forbidden, just pointless).

- [Validation (`NetworkConfig`)](#validation)

## Context

A template that creates a virtual network needs an address space and subnet ranges. Those ranges are **global, cross-cutting state**: every
environment must get a non-overlapping block, and the same block must be referenced identically by every template that touches that
environment's network. If the ranges lived in each template's per-slot `configuration/[<customer>/]<env>.yml`, the plan would be duplicated
across templates and drift — the exact failure [the data model](azure-data-model.md) avoids by giving every fact one source of truth.

So the IP plan is a **single source of truth** sitting beside `azure.yml`: `automation/Catzc.Azure/configs/network.yml`. A template merges
the right ranges in at build time through its PrePost prepare hook (see
[`prepost-extension-modules`](../automation/powershell/prepost-extension-modules.md)), so the central plan is read, never copied.

This is a third global asset, distinct from the two layers in [`data-model`](azure-data-model.md): it is not identity
(tenant/customer/environment/subscription) and not templating (template/options/slot). It is pure topology — the network plan keyed by
environment.

## Decision

### The asset

`configs/network.yml` declares one entity — a per-environment IP plan — keyed by environment **name** (the same keys as `azure.yml`'s
`environments`). It is loaded by `Get-Config -Config network`, which constructs its C# config type, `NetworkConfig` (every shipped config
has one, [ADR-CONF-LOADING#4](../configuration/module-config-loading.md#rule-adr-conf-loading4)), so a bad file throws at read time.

```mermaid
erDiagram
    NETWORK_CONFIG ||--o{ NETWORK_ENVIRONMENT : has
    NETWORK_ENVIRONMENT {
        string name              PK "map key; must be a defined azure.yml environment"
        string vnet_address_space "IPv4 CIDR, e.g. 10.10.0.0/16"
        string default_subnet     "IPv4 CIDR, e.g. 10.10.0.0/24"
    }
```

```yaml
# configs/network.yml
environments:
  dev:
    vnet_address_space: 10.10.0.0/16
    default_subnet: 10.10.0.0/24
  test:
    vnet_address_space: 10.20.0.0/16
    default_subnet: 10.20.0.0/24
  # … one entry per standard environment
```

### Validation

`NetworkConfig`

- **Required shape.** Top-level `environments` map; each entry has `vnet_address_space` and `default_subnet`.
- **Format.** Each environment name is a valid lower-snake_case identifier (`^[a-z][a-z0-9_]*$`); each range is an IPv4 CIDR (`a.b.c.d/n`,
  `0 ≤ n ≤ 32`), validated with `[System.Net.IPAddress]`.
- **Cross-asset integrity with `azure.yml`** (the join):
  - every network environment is a **defined `azure.yml` environment** (no ghost entries);
  - every **standard** `azure.yml` environment has a network entry;
  - **per-subscription** environments (`per_subscription: true` — `nsub`/`psub`) are **exempt**: they identify a subscription's foundation
    (Log Analytics + Key Vault) and carry no vnet, so they need no IP plan.
- All violations are collected and thrown together (fail with the full list, not the first error).

### How this is enforced

- `Get-Config -Config network` loads and validates the file through its registered config type, `NetworkConfig`.
- `NetworkConfig` (with `NetworkEnvironment` for each entry) performs the shape, format, and cross-asset checks above; the cross-asset join
  reads `azure.yml` through `Get-Config`.
- The shipped `network.yml` is exercised by the same integrity discipline as `azure.yml` (see
  [`test-automation`](../automation/test-automation.md)).

## Consequences

- The IP plan has one home; templates reference it, so ranges cannot drift across templates.
- Adding an environment to `azure.yml` forces a matching `network.yml` entry (or the standard-env rule fails) — the two assets cannot
  silently diverge.
- Per-subscription identity environments stay network-free by design.
- The network plan is a separate, self-contained asset — extending it (new env, new range) is a one-file change, validated on load.
