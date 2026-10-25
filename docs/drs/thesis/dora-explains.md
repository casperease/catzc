# DORA explanations — thesis

The `Dora explains` rationale for the decision records in the `thesis/` folder, consolidated in one place. Each entry names its TDR and rule
code, then reproduces that TDR's tie to [DORA](../../references/dora/index.md) research and the relevant capability links. The decisions
live in the decision records themselves; this file carries only their DORA rationale.

## One source of truth

[TDR-ONETRUTH](one-source-of-truth.md)

> DORA identifies comprehensive version control and trunk-based development as predictors of delivery performance, and finds that
> heavyweight change approval slows delivery without making it safer. One source of truth, changed through one process, puts every artifact
> under version control, keeps one mainline, and lets change approval follow the delivery mechanism instead of a separate model of it.

- [Version control](../../references/dora/capabilities.md#version-control) — the repository as the one record of everything delivery
  touches.
- [Trunk-based development](../../references/dora/capabilities.md#trunk-based-development) — one mainline where everything is at HEAD.
- [Streamlining change approval](../../references/dora/capabilities.md#streamlining-change-approval) — approvals and audit act through the
  one change process.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Truth stores

[TDR-STORES](truth-stores.md)

> DORA finds that teams perform better when their data is accessible, trustworthy, and connected across the systems that hold it, and when
> monitoring and change approval rest on evidence rather than on parallel records. Classifying every truth store, reading fact sources
> instead of copying them, and synchronising into verifiable, actionable facts gives each team one connected view of delivery without a
> second record to keep in parity.

- [Healthy data ecosystems](../../references/dora/capabilities.md#healthy-data-ecosystems) — facts read from many stores, each traceable to
  its origin.
- [Monitoring and observability](../../references/dora/capabilities.md#monitoring-and-observability) — fact sources read at their live URL
  to know the state of delivery now.
- [Streamlining change approval](../../references/dora/capabilities.md#streamlining-change-approval) — state machines met at junctions, with
  facts reported to them instead of a separate model kept for them.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Eac normal form

[TDR-NORMALFORM](eac-normal-form.md)

> DORA finds that comprehensive version control, test automation, and code maintainability predict delivery performance, and that they pay
> off only when everything needed to reproduce a system is checked the same way. One eac normal form, verified within the repository's own
> enabling constraints and uncontested by its formatters, tests, and asserts, gives every piece of code, imported fragments included, one
> repeatable test of whether it belongs to the record and what that record consists of.

- [Version control](../../references/dora/capabilities.md#version-control) — any code, whatever its origin, is brought under the one record.
- [Test automation](../../references/dora/capabilities.md#test-automation) — the repository's own checks decide the form, not judgement.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — one target shape any team member can read and verify.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Closed loop

[TDR-CLOSEDLOOP](closed-loop.md)

> DORA finds that teams which experiment, deliver continuously, and work in small batches perform better, and its AI Capabilities Model
> finds that AI amplifies delivery only when strong internal platforms and clear policies surround it. A closed loop, where every change by
> a person or an agent is a committed experiment verified by the same deterministic quality gates, lets AI add speed without adding
> instability.

- [Team experimentation](../../references/dora/capabilities.md#team-experimentation) — every change is a committed hypothesis with a
  declared expectation.
- [Continuous delivery](../../references/dora/capabilities.md#continuous-delivery) — three phases carry one identical artifact to
  production.
- [Working in small batches](../../references/dora/capabilities.md#working-in-small-batches) — small changes keep each agent verdict cheap
  to verify.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.
