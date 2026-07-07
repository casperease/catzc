# ADR: Time bindings — fixed values stitched into immutable artifacts at build-time

## Rules: ADR-TIMEBIND

### Rule ADR-TIMEBIND:1

A **time binding** is a fixed value pinned at **build-time** and stitched into an artifact, to be consumed unchanged later — at
**runtime** ("runtime for live") or **test-time** ("runtime for test"). The binding names the two times it connects: the value is _bound at_
build-time and _used at_ runtime/test-time. Binding early is the point: a value resolved at build-time and woven into the artifact cannot
drift, so what runs is exactly what was built.

### Rule ADR-TIMEBIND:2

The bound artifacts are the repository's **immutable** outputs — the CI/CD areas-of-control (sha-markers, `ADR-GLOBS`), the compiled types,
the rendered deployment packages: everything CI + automation stitch and freeze. Each is immutable by construction (its identity is its
content), and each ships in exactly two package **types** — **live** and **test** (`ADR-ASPECT`, the runtime and test-time surfaces). A time
binding therefore always produces a _pair_: the same value stitched into the live artifact and into the test artifact, each frozen.

### Rule ADR-TIMEBIND:3

**Bind early to erase runtime deviation.** The whole reason live and test can be "the same runtime" (`ADR-TIMEBIND`, `ADR-TEST:6`) is that
their differences are resolved at build-time and stitched into two immutable artifacts, not branched at runtime. A value _decided at
runtime_ is a deviation — a place live and test can diverge unobserved; the same value _stitched at build-time_ into a live artifact and a
test artifact is a binding — two frozen results with no runtime branch. Prefer the binding; a runtime branch is allowed only at a genuine
seam (`ADR-TEST:4`).

### Rule ADR-TIMEBIND:4

Downstream consumes a bound artifact by its **type and properties**, never by re-deriving the bound value: a consumer reads the live package
at runtime and the test package at test-time, and trusts what was frozen. The current time is read through the one sanctioned detector,
`Get-TimeBinding` (`build-time` | `runtime` | `test-time`, over `Test-IsTestTime` / `Test-IsBuildTime`); raw sniffing of the underlying
signals is forbidden and analyzer-flagged, so _how_ a time is detected stays behind the detector (mirroring `ADR-PIPEDET:1`).

## Context

The live/test shard (`ADR-ASPECT`) splits a unit's files; time bindings say _why the split is immutable and paired_. A deployment carries
values that must be fixed — a subscription id, a rendered parameter, a durable SHA — and the safe moment to fix them is build-time, where the
result is frozen into the artifact. If instead the value is chosen at runtime, the live path and the test path can silently diverge; if it is
bound at build-time, both paths carry a frozen value and there is nothing left to diverge. So a time binding is the mechanism that turns "the
same runtime for live and test" from an aspiration into a build-time fact: one value, two frozen artifacts.

## Decision

Resolve variability at build-time and stitch it into immutable, typed artifacts. Every binding yields a live artifact and a test artifact,
each frozen and consumed by type — runtime reads the live one, test-time the test one, neither re-deriving the value. `Get-TimeBinding` is the
single reader of the current time (so a build step knows to stitch, a consumer knows which package to read); it is read only at the stitch
seam, never sprinkled through logic. The seams that legitimately branch (`Get-Config`, `Get-BicepTemplates`, output roots, pipeline
detection) key their caches on the resolved path/root (`ADR-TEST:4`) — that branch IS the whole deviation, and it is auditable because the
detector is one function guarded by one analyzer rule.

## Consequences

- **What runs is what was built.** A bound value cannot drift between build and run — the artifact is immutable and the value is inside it.
- **Live and test can't silently diverge.** Their difference is a build-time stitch into two frozen artifacts, not a runtime branch.
- **Downstream is dumb and safe.** Consumers pick the package by type and trust the frozen value; they never re-derive it.
- **Deviation is enumerable.** One detector + one analyzer rule means every runtime branch between live and test is a seam you can list.

## Related

- [module-aspects](../design/module-aspects.md) — the `live`/`test` immutable package types a binding pairs (`ADR-ASPECT`)
- [durable-sha-globs](../pipelines/durable-sha-globs.md) — the immutable, content-addressed artifacts bindings freeze (`ADR-GLOBS`)
- [pipeline-detection](../pipelines/pipeline-detection.md) — the one-detector idiom the time detector mirrors (`ADR-PIPEDET`)
- [test-automation](test-automation.md) — the seams that are the only sanctioned runtime deviation (`ADR-TEST`)
