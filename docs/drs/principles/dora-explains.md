# DORA explanations — principles

The `Dora explains` rationale for the ADRs in the `principles/` domain, consolidated in one place. Each entry names its ADR and rule code,
then reproduces that ADR's tie to [DORA](../../references/dora/index.md) research and the domain-relevant capability links. The decisions
live in the ADRs themselves; this file carries only their DORA rationale.

## Everything as code

[PDR-EAC](everything-as-code.md)

> DORA identifies comprehensive version control as a predictor of continuous delivery. Everything-as-code ensures reproducibility,
> traceability, and version alignment by storing all artifacts in a single source of truth.

- [Version control](../../references/dora/capabilities.md#version-control) — comprehensive coverage of all artifacts enables reproducibility
  and traceability.
- [Trunk-based development](../../references/dora/capabilities.md#trunk-based-development) — requires all artifacts in version control for
  safe, rapid integration.
- [Working in small batches](../../references/dora/capabilities.md#working-in-small-batches) — version control enables short-lived branches
  and frequent commits.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Configure, don't program

[PDR-CONFIG](configure-not-program.md)

> DORA links code maintainability and small, safe changes to delivery performance. Configuring instances through one mechanism keeps the
> code small and uniform, and turns supporting a new case into a reviewable change of a few configuration lines.

- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — one mechanism per kind replaces many drifting
  per-instance copies.
- [Working in small batches](../../references/dora/capabilities.md#working-in-small-batches) — a new instance is a small config change, not
  new code to test.
- [Platform engineering](../../references/dora/capabilities.md#platform-engineering) — the platform's behaviour is declared in its
  registries, so its users configure it instead of extending it.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Reduce variability

[PDR-REDUCEVAR](reduce-variability.md)

> DORA's research links reduced variability to faster, more reliable delivery outcomes. Standardizing processes, tooling, and artifact
> structure makes deviations visible, enabling early detection of defects and predictable performance across environments.

- [Version control](../../references/dora/capabilities.md#version-control) — standardized artifacts in version control establish a
  consistent baseline.
- [Trunk-based development](../../references/dora/capabilities.md#trunk-based-development) — enforces a uniform process and prevents
  long-lived variant branches.
- [Working in small batches](../../references/dora/capabilities.md#working-in-small-batches) — consistent process and tooling enable
  frequent, predictable integration.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Reduce waste

[PDR-NOWASTE](reduce-waste.md)

> DORA's research links small batch sizes and streamlined approvals to faster deployment frequency and lower change failure rates. Reducing
> waste eliminates handoffs, delays, and rework, accelerating the flow from development to production.

- [Working in small batches](../../references/dora/capabilities.md#working-in-small-batches) — small batches reduce delays, task switching,
  and feedback loops.
- [Streamlining change approval](../../references/dora/capabilities.md#streamlining-change-approval) — automated quality gates and
  self-service reduce approval delays and handoffs.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Poka-yoke

`Poka-yoke — make mistakes impossible`

[PDR-POKAYOKE](poka-yoke.md)

> DORA's research identifies code maintainability and platform engineering as drivers of team efficacy and delivery performance. Poka-yoke
> prevents defects at their origin through structural prevention and immediate detection, reducing the cost and friction of change.

- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — structural enforcement of conventions scales beyond
  documentation and code review.
- [Platform engineering](../../references/dora/capabilities.md#platform-engineering) — zero-ceremony platforms eliminate prerequisites and
  follow-up steps, reducing defect introduction.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## One living version

`One living version — no legacy, no back-compat, history in git`

[PDR-ONELIVE](one-living-version.md)

> DORA identifies version control and trunk-based development as predictors of delivery performance. One living version enforces a single
> source of truth, eliminating the cognitive load and defects that parallel paths create, enabling fast, atomic change propagation across
> the entire codebase.

- [Version control](../../references/dora/capabilities.md#version-control) — git preserves complete history, making retention of legacy code
  unnecessary.
- [Trunk-based development](../../references/dora/capabilities.md#trunk-based-development) — short-lived branches and atomic merges keep
  trunk as the sole living version.
- [Working in small batches](../../references/dora/capabilities.md#working-in-small-batches) — atomic contract changes across all callers
  enable rapid, coherent integration.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## cats and catzc

`cats and catzc — two names, two audiences, used across each other on purpose`

[PDR-CATS](cats-and-catzc.md)

> DORA ties code maintainability and documentation quality to how easily a reader finds and understands what a name means. One name per
> audience, each with a home and a rule for where they meet, removes a source of variability in how the system is spoken of and written, so
> code, docs and conversation stay legible to the reader each is for.

- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — one reserved token in every namespace, prefix and
  path means a search for catzc finds the system and nothing else.
- [Documentation quality](../../references/dora/capabilities.md#documentation-quality) — docs and conversation say cats, so the product
  reads as a product, and a code token never leaks into a sentence meant for a person.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.
