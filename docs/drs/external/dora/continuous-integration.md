# EDR: DORA — Continuous integration

## Rules: EDR-DORA-CI

### Rule EDR-DORA-CI-EVERYCOMMITBUILDS

Every commit to the mainline triggers an automated build and an automated test suite, and both report back within minutes — the developer
who made the change learns the outcome before moving on to something else, not hours or a day later.

Source: [DORA, Continuous integration](../../../references/dora/capabilities.md#continuous-integration)

Binds to [FDR-CD-DISCIPLINEBEFOREPIPELINE](../../flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-disciplinebeforepipeline).

### Rule EDR-DORA-CI-DAILYINTEGRATION

Developers integrate their work into the mainline at least daily, in small increments. A large, infrequent merge is not continuous
integration behind a slow gate; it is batching, and the gate is not the part to fix.

Source: [DORA, Continuous integration](../../../references/dora/capabilities.md#continuous-integration)

Binds to [FDR-CD-SHORTINTEGRATIONCYCLE](../../flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-shortintegrationcycle).

### Rule EDR-DORA-CI-FIXBROKENBUILDFIRST

A broken build is fixed before other work continues. Treat a red mainline as the team's top priority, not a queued item, because every
commit layered on a broken build compounds on unverified ground.

Source: [DORA, Continuous integration](../../../references/dora/capabilities.md#continuous-integration)

Binds to [WDR-ANDON-NOBROKENBASELINE](../../process/holding-the-line.md#rule-wdr-andon-nobrokenbaseline).

### Rule EDR-DORA-CI-BUILDISSCRIPT

The automated build is itself a script, checked into version control and repeatable on demand — never a manual, undocumented sequence of
steps that a person remembers to run in a particular order.

Source: [DORA, Continuous integration](../../../references/dora/capabilities.md#continuous-integration)

Binds to [FDR-RUNNER-DEVELOPERREPRODUCIBLE](../../flow/pipeline-runner-pattern.md#rule-fdr-runner-developerreproducible).

### Rule EDR-DORA-CI-FASTGATE

Keep the per-commit gate fast: the build-and-test cycle that runs on every check-in stays inside a small number of minutes. Slower
verification — exhaustive suites, system-level checks — runs somewhere else, never inside that gate.

Source: [DORA, Continuous integration](../../../references/dora/capabilities.md#continuous-integration)

Binds to [FDR-TYPE-PRECOMMITBUDGET](../../flow/pipeline-types.md#rule-fdr-type-precommitbudget) and
[ADR-AUTO-TEST-BUILDVERIFICATIONTEST](../../automation/test-automation.md#rule-adr-auto-test-buildverificationtest).

## Context

Continuous integration builds directly on version control: it is the practice of integrating versioned changes continuously, so it
presupposes a mainline every developer can merge into and a history every change can be attributed to. DORA defines it as developers
integrating "all their work into the main version of the code base (known as trunk, main, or mainline) on a regular basis," with each commit
triggering an automated build and a test suite that reports feedback in minutes.[^1]

It is also the capability continuous delivery, deployment automation, and trunk-based development build on next: CD runs the same build step
and then keeps going; trunk-based development is the branching discipline that makes daily integration possible; deployment automation
carries the artifact CI produces. CI is the fast, per-commit core the rest of the delivery pipeline assumes is already solid.

## Summary

The capability is developers merging their work into a shared mainline frequently — daily or more — with every commit automatically built
and tested, and the result reported back in minutes. DORA frames the underlying principle plainly: "if something takes a lot of time and
energy, you should do it more often, forcing you to make it less painful."

Implementing it requires three things working together: an automated build process (a script that produces deployable packages, numbered and
repeatable, exercised at least daily), an automated test suite (starting from unit and acceptance tests that cover the system's high-value
functionality, kept reliable and fast), and a CI system that runs the build and the tests on every check-in and makes the result visible to
the team. Trunk-based development with small batches, prioritizing a broken build over other work, and test-driven development are the
practices that keep this loop healthy rather than merely present.

## Why it matters

DORA's research associates CI with higher deployment frequency, more stable systems, and higher-quality software. The mechanism is the
feedback loop: a build and test result that returns in minutes, on every commit, turns integration from a rare, risky event into a routine
one, and it forces the small-batch habit that makes each change easy to reason about and safe to revert. DORA's own framing of the objection
makes the mechanism explicit — "CI requires your developers to break up large features and other changes into smaller incremental steps" —
which is not a cost of the practice but its point: small, frequent integrations are what the fast feedback loop requires, and what makes it
fast.

Without daily integration, changes accumulate outside the mainline, and the diff a merge finally faces grows large enough that resolving it
— and finding what broke — becomes its own project. Fast, automated feedback on every commit is what keeps that from happening.

## Common pitfalls

- **Leaving something out of the repository.** A build that depends on a file, script, or configuration value that is not in version control
  is not reproducible from the mainline alone.

- **Not automating the build.** A manual build process is undocumented by construction — the steps live in someone's memory instead of in a
  script anyone (or any pipeline) can run the same way every time.

- **Not triggering quick tests on every change.** A build that compiles but is not paired with fast automated tests on the same commit gives
  no real feedback about whether the change works.

- **Not fixing a broken build right away.** Letting a red build sit while other work continues means the next several commits integrate
  against ground nobody has verified.

- **Tests that take too long to run.** A suite that does not return in a few minutes stops functioning as continuous feedback and starts
  functioning as a queue, and teams route around it.

- **Not merging into trunk often enough.** Long-lived branches and infrequent merges recreate the large, risky integration event CI exists
  to eliminate, no matter how fast the build itself runs.

## References

[^1]:
    DORA, _Continuous integration_ capability, <https://dora.dev/capabilities/continuous-integration/>. Part of the DORA Core Model of
    capabilities that predict software delivery performance.

## Dora explains

Continuous integration is a Core Model capability in the fast-feedback group. DORA's research ties it to higher deployment frequency, more
stable systems, and higher-quality software, and finds that merging to trunk at least daily and fixing a broken build before other work both
predict delivery performance. The Quick Check names it one of three capabilities worth assessing first.

- **Catalogue entry:** [Continuous integration](../../../references/dora/capabilities.md#continuous-integration)
- **Category:** [Fast feedback](../../../references/dora/capabilities.md#fast-feedback) — Core Model v2.1.0:
  [fast feedback](../../../references/dora/core-model.md#fast-feedback).
- **Evidence:**
  - [2014 State of DevOps Report](../../../references/dora/publications.md#2014-state-of-devops-report) — CI and automated testing are key
    practices behind high IT performance.
  - [2015 State of DevOps Report](../../../references/dora/publications.md#2015-state-of-devops-report) — the capability page cites it for
    merging to trunk at least daily.
  - [2016 State of DevOps Report](../../../references/dora/publications.md#2016-state-of-devops-report) — cited on the capability page.
  - [2017 State of DevOps Report](../../../references/dora/publications.md#2017-state-of-devops-report) — CI is one of the practices
    essential to continuous delivery, which lowers deployment pain.
  - [2022 Accelerate State of DevOps Report](../../../references/dora/publications.md#2022-accelerate-state-of-devops-report) — software
    supply-chain security controls improve delivery performance only where CI is established, and CD, loosely coupled teams, version
    control, and CI together add up to more than the sum of their parts.
  - [2023 Accelerate State of DevOps Report](../../../references/dora/publications.md#2023-accelerate-state-of-devops-report) — CI, loosely
    coupled teams, and fast code reviews significantly improve delivery and operational performance.
  - [2025 Impact of Generative AI](../../../references/dora/publications.md#2025-impact-of-generative-ai-in-software-development) — CI
    catches AI-introduced errors; fast, high-quality feedback loops are the counterweight to AI-generated volume.
- **Predicts:** higher [deployment frequency](../../../references/dora/metrics.md#deployment-frequency) and more stable systems (the
  [instability](../../../references/dora/metrics.md#instability) family), plus higher-quality software. As a Core Model capability it sits
  in the column that predicts [software delivery performance](../../../references/dora/core-model.md#software-delivery-performance) and
  [reliability](../../../references/dora/core-model.md#reliability), which in turn predict
  [organizational performance](../../../references/dora/core-model.md#organizational-performance) and
  [well-being](../../../references/dora/core-model.md#well-being).
- **Related capabilities:**
  - [Version control](../../../references/dora/capabilities.md#version-control) — the recoverable, attributable history CI integrates
    changes into; CI is not possible without it.
  - [Trunk-based development](../../../references/dora/capabilities.md#trunk-based-development) — the branching discipline that keeps daily
    integration into the mainline practical; the CI page calls it predictive of delivery performance.
  - [Continuous delivery](../../../references/dora/capabilities.md#continuous-delivery) — CI is one of the capabilities that drive it; CD
    runs the same build-and-verify step and carries the result further, toward a release-ready state.
- [DORA research program](../../../references/dora/index.md) — the overview these findings sit within.
