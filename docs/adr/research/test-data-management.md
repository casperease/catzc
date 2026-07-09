# ADR: DORA — Test data management

## Rules: ADR-DORATDM

### Rule ADR-DORATDM:1

Every automated test owns the data it exercises — a fixture the test (or its harness) creates and controls, never a shared or external data
set whose shape the test cannot pin down.

- [Summary](#summary)

### Rule ADR-DORATDM:2

Minimize test data before managing it. A test that needs no external data — an in-memory value, a generated input, a synthetic record —
beats one that acquires, wires, and maintains a data set, because the acquired set is the ongoing cost.

- [Why it matters](#why-it-matters)

### Rule ADR-DORATDM:3

Test data is isolated per test (or per run): no test's data is read, written, or reset by another test, another process, or a shared
environment. Isolation is a property the test setup guarantees, not a habit of carefulness.

- [Common pitfalls](#common-pitfalls)

### Rule ADR-DORATDM:4

Database-stored or externally-hosted test data is a last resort, chosen only when the thing under test genuinely is the database. An
in-memory or file-based fixture is preferred by default, because a shared datastore blocks parallel test runs and invites ordering-dependent
flakiness.

- [How to apply](#how-to-apply)

### Rule ADR-DORATDM:5

Production data never reaches a test fixture verbatim. Data derived from production is masked, hashed, or replaced with synthetic values
before a test touches it, and a fixture's identity is always distinct from any real environment, customer, or record.

- [Common pitfalls](#common-pitfalls)

## Context

Test data management sits alongside test automation in DORA's technical capabilities: automated tests only deliver fast, reliable feedback
when the data they run against is itself fast and reliable to obtain. DORA states the capability through three principles that describe a
successful team: "Adequate test data is available to run full automated test suites," "Test data for automated test suites can be acquired
on demand," and "Test data does not limit or constrain the automated tests that teams can run."[^1]

The capability is not about any one tool or data format. It is about whether a team's test data is a renewable, controllable input to
testing or a scarce, fragile dependency that testing has to work around.

## Summary

Good test data lets teams validate user journeys, exercise edge cases, reproduce reported defects, and simulate error conditions. DORA's
guidance names five practices that keep test data serving that purpose: favor unit tests that need no external data at all; minimize how
much test data any suite relies on; isolate the test data that does exist so tests do not interfere with each other; minimize
database-stored test data in favor of faster, more isolable alternatives; and make the test data that remains readily available by
identifying the relevant subset of a data source, exporting it regularly, and exposing it to tests on demand.[^1]

The throughline across all five is the same as the three principles above: test data should be abundant, on-demand, and never the limiting
factor on what a team can test.

## Why it matters

Mismanaged test data undermines the tests it feeds. Depending on external data makes tests brittle — a test can fail because the data
changed, not because the code under test regressed. Acquiring or refreshing that data introduces delay into the loop testing is supposed to
keep fast. Large or externally-hosted data sets impact test performance directly. And copying real data — production databases especially —
for use in tests poses a security risk whenever that data contains anything sensitive.[^1]

Each of these costs compounds: a test suite that depends on scarce, slow, or risky data gets run less often, trusted less, and eventually
worked around rather than fixed — the opposite of what automated testing is meant to buy a team.

## How to apply

This platform's split between logic tests and integrity tests ([test-automation](../automation/test-automation.md), `ADR-TEST`) is this
capability applied directly: a logic test owns its own fixture data under `tests/assets/` with deliberately distinct identities (envs
`alpha`/`beta`, customers `acme`/`globex`, org `tst`) so it can never collide with, or depend on, production
([ADR-TEST:3](../automation/test-automation.md#rule-adr-test3)). Isolation comes from mockable seams — `Get-BicepTemplatesRoot`,
`Resolve-ConfigEntry` — that redirect discovery to a fixture tree rather than from editing or borrowing real data
([ADR-TEST:6](../automation/test-automation.md#rule-adr-test6)). No tier below L3 depends on live connectivity
([ADR-TEST:9](../automation/test-automation.md#rule-adr-test9)), so the data a test needs is exactly the data it carries with it.

The [conventional-folders](../repository/conventional-folders.md) layout (`ADR-FOLDERS`) makes this the only place fixture data can go:
`tests/assets/` is packaged with the tests that consume it, distinct from the module's own shipped `assets/`, so a reviewer sees at a glance
that a test's data is scoped to that test and not a runtime asset masquerading as one.

## Common pitfalls

- **Over-reliance on external data.** Building tests around a shared or externally-owned data source instead of a fixture the test controls
  makes the test brittle and slows it down.

- **Full production copies instead of relevant subsets.** Copying an entire production database into a test environment, rather than
  exporting the specific sections a suite actually needs, is slower, harder to isolate, and carries more sensitive data than the tests
  require.

- **Failing to mask or hash sensitive data.** Test data derived from production that is not masked or hashed before use carries real
  security risk into an environment built for experimentation, not protection.

- **Relying on outdated or irrelevant data.** Test data that is not refreshed or curated drifts away from what the system under test
  actually looks like, so passing tests stop being evidence of anything.

## References

[^1]:
    DORA, _Test data management_ capability, <https://dora.dev/capabilities/test-data-management/>. Part of the DORA Core Model of
    capabilities that predict software delivery performance.

## Dora explains

Test data management is a precondition for the other technical capabilities to pay off: fast, frequent, automated testing only produces
fast, frequent, trustworthy feedback when the data behind it is abundant, on-demand, and safe to use.

- [Test automation](https://dora.dev/capabilities/test-automation/) — the capability this one exists to serve; automated suites are only as
  fast and reliable as the data they run against.
- [Database change management](https://dora.dev/capabilities/database-change-management/) — shares the concern of keeping database state
  safe, versioned, and low-risk to change.
- [Pervasive security](https://dora.dev/capabilities/pervasive-security/) — masking or hashing sensitive data before it reaches a test
  fixture is a security control, not just a testing convenience.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
