---
catzc:
  derived:
    path: docs/adr/thesis/dora-explains.md
    kind: adr
    body_sha: e9ca16ab63b7
    links:
      - docs/adr/thesis/one-source-of-truth.md
      - docs/references/dora/capabilities.md#streamlining-change-approval
      - docs/references/dora/capabilities.md#trunk-based-development
      - docs/references/dora/capabilities.md#version-control
      - docs/references/dora/index.md
---

# DORA explanations — thesis

The `Dora explains` rationale for the ADRs in the `thesis/` folder, consolidated in one place. Each entry names its ADR and rule code, then
reproduces that ADR's tie to [DORA](../../references/dora/index.md) research and the relevant capability links. The decisions live in the
ADRs themselves; this file carries only their DORA rationale.

## One source of truth

[ADR-THES-ONETRUTH](one-source-of-truth.md)

> DORA identifies comprehensive version control and trunk-based development as predictors of delivery performance, and finds that
> heavyweight change approval slows delivery without making it safer. One source of truth, changed through one process, puts every artifact
> under version control, keeps one mainline, and lets change approval follow the delivery mechanism instead of a separate model of it.

- [Version control](../../references/dora/capabilities.md#version-control) — the repository as the one record of everything delivery
  touches.
- [Trunk-based development](../../references/dora/capabilities.md#trunk-based-development) — one mainline where everything is at HEAD.
- [Streamlining change approval](../../references/dora/capabilities.md#streamlining-change-approval) — approvals and audit act through the
  one change process.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.
