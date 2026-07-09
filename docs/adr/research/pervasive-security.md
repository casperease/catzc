# ADR: DORA — Pervasive security

## Rules: ADR-DORAPS

### Rule ADR-DORAPS:1

Treat security as a property everyone building the system owns, not a gate a separate team enforces at the end — security quality is built
in throughout the lifecycle, the same way test quality is, not inspected in afterward.

- [Summary](#summary)

### Rule ADR-DORAPS:2

Shift security left: raise a security concern at design time, when it costs a conversation, rather than at release time, when it costs an
architectural change.

- [Why it matters](#why-it-matters)

### Rule ADR-DORAPS:3

Make the secure path the automated path — preapproved libraries and toolchains, and security tests embedded in continuous integration — so
verification scales without a manual review on every change.

- [How to apply](#how-to-apply)

### Rule ADR-DORAPS:4

Keep InfoSec engaged across the whole lifecycle — design, demos, code review, test, and release — not at a single checkpoint near delivery.

- [Common pitfalls](#common-pitfalls)

### Rule ADR-DORAPS:5

Measure security integration the same way delivery performance is measured — review coverage, lifecycle involvement, automated test
coverage, and approved-tool adoption — rather than treating a passed audit as proof the capability exists.

- [How to apply](#how-to-apply)

## Context

Pervasive security is one of DORA's technical capabilities in the Core Model that predict software delivery performance. DORA defines it as
the integration of information security objectives into daily development work throughout the software lifecycle, built on the principle
that "security is everyone's responsibility" and the practice of "shifting left" — addressing security concerns earlier in development
rather than at the end.[^1]

The capability draws on lean manufacturing: developers work alongside security and testing experts to design and deliver work in small
batches throughout the product lifecycle, building security quality in from the start rather than relying on end-stage inspection. It sits
alongside continuous integration and test automation as a capability that depends on fast feedback and small batches to be effective.

## Summary

The capability is embedding security into the daily work of building and shipping software, rather than treating it as a separate, end-stage
review. DORA finds high-performing teams spend 50 percent less time remediating security issues than low performers, a gap the research
attributes to catching problems while they are still cheap to fix.

The requirement is not merely having a security team but distributing security work across the lifecycle: InfoSec involved during design as
a gating review, preapproved libraries and toolchains that make the secure choice the default choice, and automated security tests running
in the same pipelines as functional tests — so vulnerability detection happens at scale without a manual review on every change.

## Why it matters

DORA's research ties pervasive security to delivery performance through the cost curve of when a defect is found. A security concern raised
at design time costs a conversation; the same concern found after release costs an architectural change, an emergency patch, and the trust
the incident spends. Embedding security into continuous integration and deployment pipelines lets teams discover and address defects
earlier, avoiding the expensive rework that surfaces only once a problem reaches production.

## How to apply

This platform realizes the capability where it has concrete surface. Authentication code proves every credential against the configured org
and tenant before it is used, rather than trusting a token that merely authenticates somewhere
([ADR-AUTH](../pipelines/dual-authentication.md)); session verification is layered so automation checks a session is pointed at the
config-declared target before any deployment proceeds ([ADR-AZSESS](../automation/az-session-verification.md)); and tool installation uses a
platform-native, hash-verified, reviewed package manager instead of a structurally weaker alternative
([ADR-PKGMGR](../automation/use-proper-package-managers.md)). Each of these treats a security property as a built-in, automatically checked
default rather than a manual review step bolted on afterward.

## Common pitfalls

- **Late engagement.** Involving security only near delivery, when a finding forces an architectural change instead of a design
  conversation.

- **Insufficient InfoSec collaboration.** Building without security partnership throughout design, development, and test, and requesting a
  review only at the end.

- **Understaffing that forces late engagement.** Industry ratios such as one InfoSec person per ten infrastructure people per hundred
  developers leave room only for a final gate; automated, preapproved paths are what make early involvement affordable at that ratio.

- **Knowledge gaps.** Developers unfamiliar with common threat classes such as the OWASP Top 10 push the entire security burden onto a
  separate team instead of sharing it.

## References

[^1]:
    DORA, _Pervasive security_ capability, <https://dora.dev/capabilities/pervasive-security/>. Part of the DORA Core Model of capabilities
    that predict software delivery performance.

## Dora explains

Pervasive security is one of the technical capabilities DORA's research links to software delivery performance: teams that build security in
throughout the lifecycle spend measurably less time remediating issues than teams that treat it as a late gate, the same pattern DORA finds
for quality practices generally.

- [Continuous integration](https://dora.dev/capabilities/continuous-integration/) — the pipeline where automated security tests run
  alongside functional tests.
- [Working in small batches](https://dora.dev/capabilities/working-in-small-batches/) — the batch size that makes early, cheap security
  review possible.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — automates the preapproved, security-reviewed path from
  commit to release.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
