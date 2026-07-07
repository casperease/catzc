# ADR: Self-service — safe by construction in controlled domains

## Rules: ADR-SELFSERV

### Rule ADR-SELFSERV:1

Self-service is the platform's mode of use: a consumer provisions and changes managed infrastructure themselves, through the CLI
(`ADR-THINPLAT`), without filing a ticket to a central gatekeeper. This is only defensible because every self-service action is a
**reviewable, reproducible change to a single source of truth** — never a live, unrecorded mutation. The guardrails in the rules below are
what make self-service safe in tightly controlled and managed domains, rather than a way to route around control.

- [Self-service, not free-for-all](#self-service-not-free-for-all)

### Rule ADR-SELFSERV:2

The repository is the **single source of truth** for everything the platform manages — automation, configuration, infrastructure, and pinned
tooling — all represented as code (`ADR-ASCODE`). Self-service means editing that source and letting the platform apply it; it never means
clicking a portal or running an out-of-band command. State that diverges from the repository is **drift**, and drift is reconciled _to_ the
repository, never blessed after the fact. One authoritative source is the precondition for every downstream guarantee: you cannot audit,
reproduce, or review what is not written down.

- [One source of truth, or none](#one-source-of-truth-or-none)

### Rule ADR-SELFSERV:3

What ships is an **immutable, content-addressed artifact** built **reproducibly** from a known source commit and carrying **provenance**
from source to deployed state. The durable-SHA markers (`ADR-GLOBS`) content-address each shippable unit; a build is a verifiable path from
that commit to its output, not a one-off act that cannot be repeated. This is what makes self-service _auditable_: every deployed thing
traces to one exact, reviewed commit, and anyone can independently rebuild it and confirm the match. (Primary sources: the Reproducible
Builds project on the source-to-binary verification path, and SLSA on build provenance and attestation.)

- [Immutable artifacts and provenance](#immutable-artifacts-and-provenance)

### Rule ADR-SELFSERV:4

Changes reach production through **trunk-based development with automated guardrails**. Work lands on trunk in small batches behind
short-lived branches that are gated by CI and deleted after merge; there are no long-lived divergent branches and no legacy variants of our
own code (`ADR-ONELIVE`). The guardrails — asserts (`ADR-FAILFAST`), the quality gates, the freshness/marker checks, and code review — are
**automated and mandatory**, so self-service cannot merge a change that skips them. Speed and control are the same mechanism here, not a
trade-off. (Primary source: trunkbaseddevelopment.com, Paul Hammant.)

- [Trunk-based development is the guardrail](#trunk-based-development-is-the-guardrail)

### Rule ADR-SELFSERV:5

In tightly managed domains — regulated, compliance-bound, provenance-critical — self-service is acceptable **only when reproducibility,
provenance, and an audit trail are intrinsic to the mechanism**, not bolted on as process. Here they are structural: the git history _is_
the audit log, the markers _are_ the provenance record, and code review _is_ the change-approval control. Self-service and compliance
auditability are therefore not in tension — the same trunk-based, everything-as-code pipeline that lets a consumer move quickly is also the
one that produces a complete, tamper-evident record of who changed what, when, and why.

- [Why this is safe where control matters most](#why-this-is-safe-where-control-matters-most)

## Context

Self-service is the whole point of a platform: if every change still routes through a central team's queue, the platform has not removed the
bottleneck it exists to remove. But naive self-service — handing people console access to a controlled environment — trades the bottleneck
for chaos: undocumented changes, un-reproducible state, and no audit trail. In a regulated or otherwise tightly managed domain that trade is
simply not allowed.

The resolution is to make self-service _safe by construction_. catzc rests on four properties that, together, make "anyone can change it
themselves" and "every change is controlled, reproducible, and auditable" the same statement rather than opposing ones: a **single source of
truth** (`ADR-ASCODE`), **immutable and reproducibly-built artifacts** with provenance, **trunk-based development** with automated
guardrails (`ADR-ONELIVE`), and the **thin CLI** as the only way to act (`ADR-THINPLAT`). Each one is load-bearing; remove any and
self-service stops being safe.

### Self-service, not free-for-all

Self-service is the freedom to act _within_ the platform's grain, not around it. A consumer edits configuration, adds a template, or writes
a test and runs the CLI; the platform does the provisioning. What a consumer cannot do is the thing that breaks control: reach past the CLI
to mutate live state directly. The CLI is the only actuator, which is precisely what lets the platform guarantee that every action is
recorded, reproducible, and reviewable. Freedom and control coexist because the freedom is expressed through a controlled channel.

### One source of truth, or none

Every guarantee downstream — audit, reproducibility, review, rollback — assumes there is exactly one authoritative description of the
managed world. The moment a second source exists (a console tweak, a hand-run command that leaves no record), the guarantees collapse: the
audit log is incomplete, the rebuild does not match, and review covered only half the change. So the repository is not _a_ source of truth,
it is _the_ source, and anything not in it does not exist as far as the platform is concerned. Drift detection exists to find the gap and
close it toward the repository — never to promote an out-of-band change into the record.

### Immutable artifacts and provenance

A shippable unit is identified by its content, not by a mutable tag: the durable-SHA markers key each unit to the exact bytes it comprises
(`ADR-GLOBS`), so "which version is deployed" has a single, verifiable answer. Reproducibility makes that answer checkable by a third party
— the Reproducible Builds project defines a reproducible build as "an independently-verifiable path from source to binary code", which is
exactly the property an auditor needs. Provenance carries the chain the other direction: SLSA frames build provenance as verifiable evidence
of _how_ an artifact was produced. Together they mean a deployed artifact is not trusted on faith — it is trusted because it can be traced
back to a reviewed commit and rebuilt to match.

### Trunk-based development is the guardrail

Trunk-based development is what keeps the single source of truth actually single and actually current. trunkbaseddevelopment.com defines it
as "a source-control branching model where developers collaborate on code in a single branch called 'trunk' and resist any pressure to
create other long-lived development branches". The practices that matter here are its guardrails: small, frequent commits to trunk;
short-lived branches used only for review and CI, then deleted; and a mandatory build/gate that a commit must pass. Because those gates are
automated and stand between every change and trunk, self-service cannot merge something that skips review, fails an assert, or leaves a
stale marker. The branching discipline and the no-legacy rule (`ADR-ONELIVE`) are two faces of the same commitment: one living version, on
trunk, always releasable.

### Why this is safe where control matters most

The domains where self-service seems most dangerous — regulated, audited, compliance-bound — are the ones this design serves best, because
it makes the compliance artifacts fall out of the normal workflow instead of being assembled after the fact. The audit trail is `git log`:
every change is attributed, timestamped, and justified in its commit and review. The provenance record is the marker set: every deployed
unit names its exact content. The change-approval control is the pull request: no change reaches trunk unreviewed. None of these is an extra
step a busy engineer might skip under deadline — they are the only path, so the record is always complete. That is what "safe by
construction" means: the fast path and the compliant path are the same path.

## Decision

Make self-service the platform's mode of use, and make it safe by construction: every self-service action is a change to the **single source
of truth** (ADR-SELFSERV:2), applied only through the **thin CLI** (ADR-SELFSERV:1), shipped as an **immutable, reproducibly-built artifact
with provenance** (ADR-SELFSERV:3), landed via **trunk-based development behind automated, mandatory guardrails** (ADR-SELFSERV:4). In
controlled domains this makes self-service and auditability the same mechanism rather than competing ones (ADR-SELFSERV:5).

### How this is enforced

- **Everything-as-code** (`ADR-ASCODE`) keeps the repository the sole authoritative source; there is no supported out-of-band channel.
- **The durable-SHA markers** (`ADR-GLOBS`) content-address every shippable unit, giving each deployment a single verifiable identity.
- **One living version** (`ADR-ONELIVE`) forbids long-lived branches and legacy variants, keeping trunk the one always-releasable source.
- **Fail-fast asserts and the quality gates** (`ADR-FAILFAST`, the spell/terminology/freshness gates) are the automated guardrails a
  self-service change must clear before it can merge.
- **The thin CLI** (`ADR-THINPLAT`) is the only actuator, so no self-service action can bypass the record.

## References

- The Reproducible Builds project — "an independently-verifiable path from source to binary code":
  [reproducible-builds.org](https://reproducible-builds.org/)
- SLSA (Supply-chain Levels for Software Artifacts) — build provenance and attestation: [slsa.dev](https://slsa.dev/)
- Paul Hammant et al., Trunk-Based Development — the branching model and its guardrails:
  [trunkbaseddevelopment.com](https://trunkbaseddevelopment.com/)

## Dora explains

DORA's research consistently ties elite delivery performance to exactly the practices this ADR makes structural — version control as the
single source of truth, trunk-based development, and automated deployment — and to lightweight, built-in change approval over heavyweight
external review. Relevant DORA capabilities:

- [Version control](https://dora.dev/capabilities/version-control/) — the single source of truth for all production artifacts.
- [Trunk-based development](https://dora.dev/capabilities/trunk-based-development/) — small batches on trunk, short-lived branches.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — self-service delivery without manual gatekeeping.
- [Streamlining change approval](https://dora.dev/capabilities/streamlining-change-approval/) — peer review over external change-advisory
  boards.
- [Working in small batches](https://dora.dev/capabilities/working-in-small-batches/) — the batch size that keeps self-service safe.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
