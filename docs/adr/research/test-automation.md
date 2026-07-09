# ADR: DORA — Test automation

## Rules: ADR-DORATA

### Rule ADR-DORATA:1

Automated tests run continuously across the whole delivery lifecycle, not as a separate late-stage phase, and the suite returns a result in
minutes — the developer who made a change learns the outcome before moving on to something else, not hours or days later.

- [Summary](#summary)

### Rule ADR-DORATA:2

Developers write and own the automated suite — practicing test-driven development and authoring the acceptance tests that gate a change —
while testers shift their effort toward continuous exploratory and usability testing and toward curating the suite, not toward manually
re-verifying every change by hand.

- [Why it matters](#why-it-matters)

### Rule ADR-DORATA:3

Follow the test pyramid: most defects are caught by fast, isolated unit tests, and a pipeline runs them before the slower acceptance and
nonfunctional tests that follow. A suite inverted toward slow, broad tests catches the same defects later and at higher cost.

- [How to apply](#how-to-apply)

### Rule ADR-DORATA:4

Integrate the suite into the deployment pipeline so every change triggers a build, the unit tests, then acceptance and nonfunctional tests
against the running software — a change does not pass until all of them do, and the result is visible to the whole team.

- [How to apply](#how-to-apply)

### Rule ADR-DORATA:5

Treat a failing test as evidence of a real defect, never as noise. Eliminate flaky tests and keep the whole suite fast enough to run locally
and in CI — bloated, over-mocked, or slow suites get curated down, not tolerated, because a suite nobody trusts stops giving signal.

- [Common pitfalls](#common-pitfalls)

## Context

Test automation sits alongside continuous integration and continuous delivery in DORA's Core Model: it is what makes "every commit triggers
a build and a test suite" a meaningful gate rather than a formality. DORA frames the capability as obtaining rapid feedback about the impact
of a change throughout the software delivery lifecycle, replacing manual testing performed in separate phases with teams that "perform all
types of testing continuously throughout the software delivery lifecycle" and "create and curate fast, reliable suites of automated
tests."[^1]

It depends on continuous integration to run the suite on every commit and feeds continuous delivery the confidence that a build is
release-candidate quality. Without it, CI's fast build-and-test loop has nothing fast or trustworthy to run, and CD has no basis for
deciding a change is safe to release.

## Summary

The capability is continuous, automated testing across the delivery lifecycle rather than manual testing confined to a late phase. Teams
create and curate fast, reliable automated test suites, and developers practice test-driven development — writing unit tests before the code
they verify. The suite runs on every change and reports back in minutes, and DORA's guidance is to keep total suite execution under ten
minutes for local and CI feedback.

Two technical components anchor the practice: unit tests that verify individual methods and classes in isolation, and acceptance tests that
validate higher-level functionality and prevent regressions — a change is not accepted until both classes of test pass. The pipeline runs
them in order: a build produces a software package, then unit tests run against it, then acceptance and nonfunctional tests run against the
deployed, running software.

## Why it matters

DORA's research ties test automation to improved software stability, reduced team burnout, and lower deployment pain. The mechanism is speed
and trust in feedback: eliminating manual regression testing removes the bottleneck that prevents frequent releases, and automated,
repeatable verification is more reliable than a human re-running the same checks by hand. A developer who receives feedback within minutes —
rather than days or weeks — can still recall the change and fix it cheaply; a developer told about a regression a week later has to
reconstruct context before they can even start.

The practice also changes how code gets written. Developers who own the automated suite and practice test-driven development learn, as a
byproduct, how to write quality, testable code — the suite's existence bends the design toward smaller units with clear boundaries, because
those are the units that are cheap to test.

## How to apply

This platform separates every test into a **logic** test (isolated from shipped configuration through mockable seams, hermetic and fast) or
an **integrity** test (bound deliberately to the real, shipped files) — never both at once — and tags every test with one of four
integration tiers, `L0`–`L3`, so a suite runs unit-speed by default and only reaches a real CLI tool or the cloud when a test opts in
([ADR-TEST](../automation/test-automation.md#rule-adr-test1), tiers at [ADR-TEST:8](../automation/test-automation.md#rule-adr-test8)). Slow,
duplicated integration coverage is pushed left into fast L0 logic tests, leaving only a thin walking skeleton at the integration tier — one
test per distinct integration concern, never one per input case ([ADR-TEST:22](../automation/test-automation.md#rule-adr-test22)). The
aggregate Build Verification Test is the one pass/fail verdict a commit must clear before it reaches master
([ADR-TEST:24](../automation/test-automation.md#rule-adr-test24)), the pipeline-level version of "a change does not pass until its tests
do."

The concrete authoring idioms — mocking at module boundaries, isolating through seams rather than editing production data, and the
per-function test-file convention — are the Pester-specific layer under that doctrine
([ADR-PESTER](../automation/powershell/pester-testing.md#rule-adr-pester1)).

## Common pitfalls

- **Developers avoid test ownership.** When developers treat the suite as someone else's problem, it breaks frequently and the production
  code drifts toward being hard to test in the first place. Developers maintain the automation; testers spend their time on exploratory and
  usability testing and on curating the suite, not on manually re-verifying what automation already covers.

- **The suite is left to degrade.** An automated suite is not self-maintaining — over-mocking, bloat, and UI tests that are not decoupled
  with page objects accumulate unless the suite is continuously reviewed and the software's architecture is kept testable.

- **Wrong test proportions.** A suite weighted toward slow, broad tests instead of the test pyramid catches the same defects later and at
  higher cost; most errors are meant to be caught by fast unit tests, with slower acceptance tests running after them, not instead of them.

- **Unreliable, flaky tests.** A test suite that fails for reasons unrelated to a real defect trains people to ignore red results. Failures
  must always indicate a genuine defect, or the suite stops functioning as a feedback signal at all.

## References

[^1]:
    DORA, _Test automation_ capability, <https://dora.dev/capabilities/test-automation/>. Part of the DORA Core Model of capabilities that
    predict software delivery performance.

## Dora explains

DORA's research ties test automation to improved software stability, reduced team burnout, and lower deployment pain — the fast, trustworthy
feedback loop it produces is what lets the rest of the delivery pipeline move quickly without moving recklessly.

- [Continuous integration](https://dora.dev/capabilities/continuous-integration/) — runs the automated suite on every commit; the gate is
  only meaningful because the suite it runs is fast and trustworthy.
- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — depends on the automated suite to certify that a build is
  release-candidate quality without manual re-verification.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — testable, well-factored code and a healthy automated suite
  reinforce each other.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
