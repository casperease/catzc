# DORA explanations — principles

The `Dora explains` rationale for the ADRs in the `principles/` domain, consolidated in one place. Each entry
names its ADR and rule code, then reproduces that ADR's tie to [DORA](https://dora.dev/research/) research and
the domain-relevant capability links. The decisions live in the ADRs themselves; this file carries only their
DORA rationale.

## Everything as code (`ADR-PRIN-EAC`)

DORA identifies comprehensive version control as a predictor of continuous delivery. Everything-as-code ensures reproducibility,
traceability, and version alignment by storing all artifacts in a single source of truth.

- [Version control](https://dora.dev/capabilities/version-control/) — comprehensive coverage of all artifacts enables reproducibility and
  traceability.
- [Trunk-based development](https://dora.dev/capabilities/trunk-based-development/) — requires all artifacts in version control for safe,
  rapid integration.
- [Working in small batches](https://dora.dev/capabilities/working-in-small-batches/) — version control enables short-lived branches and
  frequent commits.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Reduce variability (`ADR-PRIN-REDUCEVAR`)

DORA's research links reduced variability to faster, more reliable delivery outcomes. Standardizing processes, tooling, and artifact
structure makes deviations visible, enabling early detection of defects and predictable performance across environments.

- [Version control](https://dora.dev/capabilities/version-control/) — standardized artifacts in version control establish a consistent
  baseline.
- [Trunk-based development](https://dora.dev/capabilities/trunk-based-development/) — enforces a uniform process and prevents long-lived
  variant branches.
- [Working in small batches](https://dora.dev/capabilities/working-in-small-batches/) — consistent process and tooling enable frequent,
  predictable integration.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Reduce waste (`ADR-PRIN-NOWASTE`)

DORA's research links small batch sizes and streamlined approvals to faster deployment frequency and lower change failure rates. Reducing
waste eliminates handoffs, delays, and rework, accelerating the flow from development to production.

- [Working in small batches](https://dora.dev/capabilities/working-in-small-batches/) — small batches reduce delays, task switching, and
  feedback loops.
- [Streamlining change approval](https://dora.dev/capabilities/streamlining-change-approval/) — automated gates and self-service reduce
  approval delays and handoffs.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Poka-yoke — make mistakes impossible (`ADR-PRIN-POKAYOKE`)

DORA's research identifies code maintainability and platform engineering as drivers of team efficacy and delivery performance. Poka-yoke
prevents defects at their origin through structural prevention and immediate detection, reducing the cost and friction of change.

- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — structural enforcement of conventions scales beyond
  documentation and code review.
- [Platform engineering](https://dora.dev/capabilities/platform-engineering/) — zero-ceremony platforms eliminate prerequisites and
  follow-up steps, reducing defect introduction.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## One living version — no legacy, no back-compat, history in git (`ADR-PRIN-ONELIVE`)

DORA identifies version control and trunk-based development as predictors of delivery performance. One living version enforces a single
source of truth, eliminating the cognitive load and defects that parallel paths create, enabling fast, atomic change propagation across the
entire codebase.

- [Version control](https://dora.dev/capabilities/version-control/) — git preserves complete history, making retention of legacy code
  unnecessary.
- [Trunk-based development](https://dora.dev/capabilities/trunk-based-development/) — short-lived branches and atomic merges keep trunk as
  the sole living version.
- [Working in small batches](https://dora.dev/capabilities/working-in-small-batches/) — atomic contract changes across all callers enable
  rapid, coherent integration.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
