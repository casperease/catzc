# ADR: Retry is a last resort — lowest level only, never in tests

## Rules: ADR-RETRY

### Rule ADR-RETRY:1

Never retry in a test. A flake must surface; make the dependency deterministic (mock it) or gate it behind an explicit tier (e.g.
`-Tag 'L3'`, skipped when unavailable). Non-L3 tests must not depend on external connectivity.

- [Decision](#decision)

### Rule ADR-RETRY:2

Treat retry as a last resort, not a first reflex. First remove the need: make the operation idempotent, wait on the right condition, or fix
the call. Retry only when the failure is provably transient and external with no deterministic fix.

- [Decision](#decision)

### Rule ADR-RETRY:3

Retry at the lowest level possible: wrap the single external operation that can transiently fail, never a whole function, workflow, or
pipeline step. Prefer a tool's own waiter (`az … --wait`) over a hand-rolled loop.

- [Decision](#decision)

### Rule ADR-RETRY:4

Only retry idempotent operations; the retried call must be safe to repeat. Never retry a non-idempotent mutation.

- [Decision](#decision)

### Rule ADR-RETRY:5

Keep retries bounded and visible: a small explicit attempt count, and log each retry as a warning so a degrading dependency leaves a
breadcrumb. Never silent or unbounded.

- [Decision](#decision)

### Rule ADR-RETRY:6

Isolate retry in a dedicated scriptblock-taking wrapper (an `Invoke-WithRetry`-style helper), never inlined into a function that also does
work.

- [Decision](#decision)

## Context

Automation calls flaky external systems — CLIs, networks, cloud control planes — and transient failures are real (a network blip,
eventually-consistent cloud state, a tool cold-start). The reflex is to wrap the failing thing in a retry. That reflex is wrong far more
often than it is right: a retry **masks real failures**, turns a fast failure into a slow one, and **hides a degrading system** until it
fails catastrophically. Reaching for retry is a strong claim — "I expect this to fail sometimes and I choose to paper over it" — that is
rarely justified.

The codebase leans the other way. [Fail fast with assertions](fail-fast-with-asserts.md) says assert and fail at the source.
[Error handling](powershell/error-handling.md) and [single-responsibility-functions](single-responsibility-functions.md) say functions
**throw** on failure and never catch-and-continue; whether to retry is the _caller's_ decision, isolated in a dedicated wrapper, never
tangled into business logic. This ADR sets the policy for when a retry is permitted at all.

## Decision

A retry is a **last-ditch** mechanism for a genuinely-transient external failure, applied at the **lowest possible level**, made
**visible**, on an **idempotent** operation — and **never** in a test.

## Consequences

- Failures are honest and fast by default; the test suite and the logs stay trustworthy.
- Tests never hide flakiness: a flaky or unavailable external dependency is handled by mocking or by an explicit, skippable tier (L3) — not
  by re-running until green.
- When a retry _is_ used it is surgical (lowest level), bounded, logged, and idempotent — easy to spot in review and to reason about, with a
  contained blast radius.
- A genuinely broken system fails immediately, with the real error, instead of after N slow, noisy attempts that bury the cause.

## Dora explains

Restricting retry to idempotent operations at the lowest level keeps test results trustworthy and failures visible. This discipline is
essential for reliable CI and for surfacing degrading systems before they cascade.

- [Test automation](https://dora.dev/capabilities/test-automation/) — tests never retry, so flakiness surfaces immediately and must be fixed
  or gated behind an explicit tier.
- [Continuous integration](https://dora.dev/capabilities/continuous-integration/) — honest, fast failures prevent masking real defects and
  keep merge gates reliable.
- [Monitoring and observability](https://dora.dev/capabilities/monitoring-and-observability/) — every retry is logged as a warning so
  degrading dependencies leave a visible breadcrumb.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
