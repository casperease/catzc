# Design: Self-service — safe by construction in controlled settings

## Rules: DDR-SELFSERV

### Rule DDR-SELFSERV-CONSUMERSPROVISION

Self-service is the platform's mode of use: a consumer provisions and changes managed infrastructure themselves, through the CLI
(`DDR-THINPLAT`), without filing a ticket to a central gatekeeper. This is only defensible because every self-service action is a
**reviewable, reproducible change to a single source of truth** — never a live, unrecorded mutation. The guardrails in the rules below are
what make self-service safe in tightly controlled and managed settings, rather than a way to route around control.

- [Self-service, not free-for-all](#self-service-not-free-for-all)

### Rule DDR-SELFSERV-IMMUTABLEARTIFACT

What ships is an **immutable, content-addressed artifact** built **reproducibly** from a source commit that is known and carrying
**provenance** from source to deployed state. The globset durable-SHA identities content-address each shippable unit; a build is a
verifiable path from that commit to its output, not a one-off act that cannot be repeated. This is what makes self-service _auditable_:
every deployed thing traces to one exact, reviewed commit, and anyone can independently rebuild it and confirm the match. (Primary sources:
the Reproducible Builds project on the source-to-binary verification path, and SLSA on build provenance and attestation.)

- [Immutable artifacts and provenance](#immutable-artifacts-and-provenance)

### Rule DDR-SELFSERV-REGULATEDREPRODUCIBLE

In tightly managed settings — regulated, compliance-bound, provenance-critical — self-service is acceptable **only when reproducibility,
provenance, and an audit trail are intrinsic to the mechanism**, not bolted on as process. Here they are structural: the git history _is_
the audit log, the build's `build.json` and the commit it names _are_ the provenance record, and code review _is_ the change-approval
control. Self-service and compliance auditability are therefore not in tension — the same trunk-based, everything-as-code pipeline that lets
a consumer move quickly is also the one that produces a complete, tamper-evident record of who changed what, when, and why.

- [Safe where control matters](#safe-where-control-matters)

## Context

Self-service is the whole point of a platform: if every change still routes through a central team's queue, the platform has not removed the
bottleneck it exists to remove. But naive self-service — handing people console access to a controlled environment — trades the bottleneck
for chaos: undocumented changes, un-reproducible state, and no audit trail. In a regulated or otherwise tightly managed setting that trade
is simply not allowed. The thin platform lets consumers edit configuration and compose functions without a ticket, the freedom DORA names as
needing no outside permission.

The resolution is to make self-service _safe by construction_. catzc rests on four properties that, together, make "anyone can change it
themselves" and "every change is controlled, reproducible, and auditable" the same statement rather than opposing ones: a **single source of
truth** (`PDR-EAC`), **immutable and reproducibly-built artifacts** with provenance, **trunk-based development** with automated guardrails
(`PDR-ONELIVE`), and the **thin CLI** as the only way to act (`DDR-THINPLAT`). Each one is load-bearing; remove any and self-service stops
being safe.

### Self-service, not free-for-all

Self-service is the freedom to act _within_ the platform's grain, not around it. A consumer edits configuration, adds a template, or writes
a test and runs the CLI; the platform does the provisioning. What a consumer cannot do is the thing that breaks control: reach past the CLI
to mutate live state directly. The CLI is the only actuator, which is precisely what lets the platform guarantee that every action is
recorded, reproducible, and reviewable. Freedom and control coexist because the freedom is expressed through a controlled channel.

### One source of truth, or none

The repository is the single source of truth for everything the platform manages — automation, configuration, infrastructure, and pinned
tooling — all represented as code ([PDR-EAC-EVERYTHINGCOMMITTED](../principles/everything-as-code.md#rule-pdr-eac-everythingcommitted), the
mechanics of the one source of truth). For self-service that means editing that source and letting the platform apply it, never clicking a
portal or running an out-of-band command. State that diverges from the repository is **drift**, and drift is reconciled _to_ the repository,
never blessed after the fact: you cannot audit, reproduce, or review what is not written down. The moment a second source exists (a console
tweak, a hand-run command that leaves no record), the guarantees collapse: the audit log is incomplete, the rebuild does not match, and
review covered only half the change.

### Immutable artifacts and provenance

A shippable unit is identified by its content, not by a mutable tag: the globset durable-SHA identities key each unit to the exact bytes it
comprises, so "which version is deployed" has a single, verifiable answer. Reproducibility makes that answer checkable by a third party —
the Reproducible Builds project defines a reproducible build as "an independently-verifiable path from source to binary code", which is
exactly the property an auditor needs. Provenance carries the chain the other direction: SLSA frames build provenance as verifiable evidence
of _how_ an artifact was produced. Together they mean a deployed artifact is not trusted on faith — it is trusted because it can be traced
back to a reviewed commit and rebuilt to match.

### Trunk-based development

`Trunk-based development is the guardrail`

Trunk-based development is what keeps the single source of truth actually single and actually current. trunkbaseddevelopment.com defines it
as "a source-control branching model where developers collaborate on code in a single branch called 'trunk' and resist any pressure to
create other long-lived development branches" ([PDR-ONELIVE-TRUNKBASED](../principles/one-living-version.md#rule-pdr-onelive-trunkbased)).
For self-service, work lands on trunk in small batches behind short-lived branches that must pass the CI gate and are deleted after merge,
and the guardrails — asserts, the quality gates, the generated-file drift checks, and code review — are automated and mandatory, so
self-service cannot merge a change that skips them. Speed and control are the same mechanism here, not a trade-off. The branching discipline
and the no-legacy rule (`PDR-ONELIVE`) are two faces of the same commitment: one living version, on trunk, always releasable.

### Safe where control matters

`Why this is safe where control matters most`

The domains where self-service seems most dangerous — regulated, audited, compliance-bound — are the ones this design serves best, because
it makes the compliance artifacts fall out of the normal workflow instead of being assembled after the fact. None of them is an extra step a
busy engineer might skip under deadline — they are the only path, so the record is always complete. That is what "safe by construction"
means: the fast path and the compliant path are the same path.

## Decision

Make self-service the platform's mode of use, and make it safe by construction: every self-service action is a change to the **single source
of truth** (PDR-EAC-EVERYTHINGCOMMITTED), applied only through the **thin CLI** (DDR-SELFSERV-CONSUMERSPROVISION), shipped as an
**immutable, reproducibly-built artifact with provenance** (DDR-SELFSERV-IMMUTABLEARTIFACT), landed via **trunk-based development behind
automated, mandatory guardrails** (PDR-ONELIVE-TRUNKBASED). In controlled settings this makes self-service and auditability the same
mechanism rather than competing ones (DDR-SELFSERV-REGULATEDREPRODUCIBLE).

### How this is enforced

- **Everything-as-code** (`PDR-EAC`) keeps the repository the sole authoritative source; there is no supported out-of-band channel.
- **The globset durable-SHA identities** content-address every shippable unit, giving each deployment a single verifiable identity.
- **One living version** (`PDR-ONELIVE`) forbids long-lived branches and legacy variants, keeping trunk the one source that is always
  releasable.
- **Fail-fast asserts and the quality gates** (the spelling, terminology, and generated-file drift quality gates) are the automated
  guardrails a self-service change must clear before it can merge.
- **The thin CLI** (`DDR-THINPLAT`) is the only actuator, so no self-service action can bypass the record.

## References

- The Reproducible Builds project — "an independently-verifiable path from source to binary code":
  [reproducible-builds.org](https://reproducible-builds.org/)
- SLSA (Supply-chain Levels for Software Artifacts) — build provenance and attestation: [slsa.dev](https://slsa.dev/)
- Paul Hammant et al., Trunk-Based Development — the branching model and its guardrails:
  [trunkbaseddevelopment.com](https://trunkbaseddevelopment.com/)
