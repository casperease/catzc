# DORA explanations — configuration

The `Dora explains` rationale for the ADRs in the `configuration/` domain, consolidated in one place. Each entry
names its ADR and rule code, then reproduces that ADR's tie to [DORA](https://dora.dev/research/) research and
the domain-relevant capability links. The decisions live in the ADRs themselves; this file carries only their
DORA rationale.

## Module config loading — one reader (`Get-Config`), owner-scoped validation (`ADR-CONF-LOADING`)

A single config reader eliminates drift and ensures consistent validation, both core to reliable system behavior. This pattern reduces
variability in configuration handling across modules, lowering defect rates and deployment risk.

- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — one reader eliminates boilerplate and drift across modules.
- [Version control](https://dora.dev/capabilities/version-control/) — configs flow through a single validation gate, making their state
  auditable and consistent.
- [Pervasive security](https://dora.dev/capabilities/pervasive-security/) — validation is owner-scoped and centralized, reducing the surface
  for misconfiguration.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Config value addressing — a by-reference handle into a named config (`ADR-CONF-ADDRESSING`)

DORA's research links version-controlled configuration and single source of truth to reliable, maintainable delivery. Providing a uniform
addressing grammar for config values ensures every reference points to a canonical, committed source and fails fast on mistakes.

- [Version control](https://dora.dev/capabilities/version-control/) — all addressable config lives in version-controlled files, making every
  reference traceable and auditable.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — a fixed address grammar and fail-fast validation make
  configuration handling clear and mistakes obvious.
- [Trunk-based development](https://dora.dev/capabilities/trunk-based-development/) — addressing enforces single source of truth for every
  config value, eliminating drift from copied literals.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
