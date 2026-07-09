# ADR: DORA — Version control

## Rules: ADR-DORAVC

### Rule ADR-DORAVC:1

Everything required to reproduce a build, deployment, or environment lives in version control — application code, scripts, configuration,
infrastructure definitions, and pipeline definitions — not only the application source.

- [Summary](#summary)

### Rule ADR-DORAVC:2

Version control exists to serve two properties: reproducibility (any past state can be rebuilt from the recorded history) and traceability
(every change is attributable to an author, a time, and a reason).

- [Why it matters](#why-it-matters)

### Rule ADR-DORAVC:3

Comprehensive versioning is the scope, not partial versioning — a system whose code is tracked but whose configuration or infrastructure is
not is only partly under version control, and the untracked part is where irreproducible drift accumulates.

- [Common pitfalls](#common-pitfalls)

### Rule ADR-DORAVC:4

Inner-loop discipline is part of the capability — frequent, small commits with clear messages are what make the history a usable safety net;
large, infrequent commits and unmanaged merge conflicts erode it.

- [Common pitfalls](#common-pitfalls)

## Context

Version control is the most foundational of DORA's technical capabilities: continuous integration, continuous delivery, deployment
automation, and trunk-based development all assume it. DORA defines it as the systems — "Git, Subversion, and Mercurial" — that "provide a
logical means to organize files and coordinate their creation, controlled access, updating, and deletion across teams and
organizations".[^1]

It sits in the DORA Core Model as a predictor of software delivery performance: teams that comprehensively version their artifacts recover
faster, audit more easily, and change more safely. In the AI era DORA frames it further as a safety net — frequent commits bound the blast
radius of fast, machine-assisted change, and prompts and model configuration become artifacts worth versioning like any other.

## Summary

The capability is comprehensive version control: keeping in a version control system every artifact needed to build, test, deploy, and
operate the system. DORA highlights five benefits — disaster recovery, auditability, quality improvement, capacity management, and faster
defect response — all of which flow from a single, recoverable, attributable history of every change.

The requirement is not merely "use Git" but versioning the full set of artifacts: source, build and deployment scripts, application and
system configuration, container definitions, infrastructure-as-code, and (increasingly) AI prompts and configuration.

## Why it matters

DORA's research associates comprehensive version control with higher software delivery performance and faster recovery. The mechanism is
reproducibility and traceability: when any state can be rebuilt and every change is attributable, disaster recovery becomes a checkout,
auditing becomes reading history, and diagnosing a defect becomes bisecting a known sequence of changes rather than reconstructing what
happened. Without it, each of those becomes archaeology.

## How to apply

This platform realizes the capability by keeping every operational artifact in the repository
([ADR-ASCODE](../principles/everything-as-code.md)) and carrying exactly one living version of each
([ADR-ONELIVE](../principles/one-living-version.md)) with all history in git rather than in retained files. Trunk-based development and
short-lived branches ([ADR-FLOW](../design/ci-discipline-and-promotion-flow.md)) keep the inner-loop discipline this capability depends on,
and the audited server remote ([ADR-REMOTE](../design/server-remote-integration.md)) is the single source of truth for what is on main.

## Common pitfalls

- **Limited scope.** Versioning application code while leaving configuration, infrastructure, or pipeline definitions outside version
  control — the untracked artifacts are exactly where irreproducible drift hides.
- **Neglecting inner-loop discipline.** Large, infrequent commits with vague messages turn the history into a liability rather than a safety
  net; the value is in small, frequent, well-described changes.
- **Unmanaged merge conflicts.** Long-lived branches that defer integration produce painful conflicts, discouraging the frequent commits the
  capability relies on.

## References

[^1]:
    DORA, _Version control_ capability, <https://dora.dev/capabilities/version-control/>. Part of the DORA Core Model of capabilities that
    predict software delivery performance.

## Dora explains

Version control is the base on which DORA's delivery metrics rest: without a recoverable, attributable history there is no reliable way to
deploy frequently, keep change lead time short, or restore service quickly after a failure.

- [Continuous integration](https://dora.dev/capabilities/continuous-integration/) — integrates versioned changes continuously; impossible
  without version control.
- [Trunk-based development](https://dora.dev/capabilities/trunk-based-development/) — the branching discipline that keeps the history a
  usable safety net.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — automates deployment from versioned definitions.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
