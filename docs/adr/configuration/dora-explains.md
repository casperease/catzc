---
catzc:
  immutable:
    with_body_sha: da96fc3b252a
    path: docs/adr/configuration/dora-explains.md
    folder: docs/adr/configuration
    name: dora-explains
    filetype: md
    kind: adr
    language: markdown
    track: docs
  edges:
    links:
      - docs/adr/configuration/config-value-addressing.md
      - docs/adr/configuration/markdown-config-contributions.md
      - docs/adr/configuration/module-config-loading.md
      - docs/references/dora/capabilities.md#code-maintainability
      - docs/references/dora/capabilities.md#pervasive-security
      - docs/references/dora/capabilities.md#trunk-based-development
      - docs/references/dora/capabilities.md#version-control
      - docs/references/dora/index.md
---

# DORA explanations — configuration

The `Dora explains` rationale for the ADRs in the `configuration/` domain, consolidated in one place. Each entry names its ADR and rule
code, then reproduces that ADR's tie to [DORA](../../references/dora/index.md) research and the domain-relevant capability links. The
decisions live in the ADRs themselves; this file carries only their DORA rationale.

## Module config loading

`Module config loading — one reader (Get-Config), owner-scoped validation`

[ADR-CONF-LOADING](module-config-loading.md)

> A single config reader eliminates drift and ensures consistent validation, both core to reliable system behavior. This pattern reduces
> variability in configuration handling across modules, lowering defect rates and deployment risk.

- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — one reader eliminates boilerplate and drift across
  modules.
- [Version control](../../references/dora/capabilities.md#version-control) — configs flow through a single validation guard, making their
  state auditable and consistent.
- [Pervasive security](../../references/dora/capabilities.md#pervasive-security) — validation is owner-scoped and centralized, reducing the
  surface for misconfiguration.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Config value addressing

`Config value addressing — a by-reference handle into a named config`

[ADR-CONF-ADDRESSING](config-value-addressing.md)

> DORA's research links version-controlled configuration and single source of truth to reliable, maintainable delivery. Providing a uniform
> addressing grammar for config values ensures every reference points to a canonical, committed source and fails fast on mistakes.

- [Version control](../../references/dora/capabilities.md#version-control) — all addressable config lives in version-controlled files,
  making every reference traceable and auditable.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — a fixed address grammar and fail-fast validation make
  configuration handling clear and mistakes obvious.
- [Trunk-based development](../../references/dora/capabilities.md#trunk-based-development) — addressing enforces single source of truth for
  every config value, eliminating drift from copied literals.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Markdown config contributions

`Markdown config contributions — config values stated in a source-controlled Markdown file`

[ADR-CONF-MDCONTRIB](markdown-config-contributions.md)

> DORA's research links version-controlled configuration and a single source of truth to reliable delivery. A config value stated once,
> beside the thing it describes, and read through the one validated reader, removes a second copy that could drift.

- [Version control](../../references/dora/capabilities.md#version-control) — every contribution is a tracked file with a reviewed diff, in a
  fixed merge order.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — a registry that mirrors a set of files is replaced by
  one statement per file, so nothing needs to be kept in step.
- [Pervasive security](../../references/dora/capabilities.md#pervasive-security) — opt-in by glob and typed validation bound which files can
  change which config, and nothing a contribution states is secret.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.
