# ADR: DORA — Documentation quality

## Rules: ADR-DORADQ

### Rule ADR-DORADQ:1

Documentation is an active engineering deliverable, created and maintained deliberately alongside the systems it describes, not a byproduct
assembled once and left to age.

- [Summary](#summary)

### Rule ADR-DORADQ:2

Quality is judged along three dimensions — clarity, discoverability, and reliability — and a document that fails any one of them fails the
capability: accurate but unreadable, readable but undiscoverable, and discoverable but wrong are each as unhelpful as no documentation at
all.

- [Summary](#summary)

### Rule ADR-DORADQ:3

Documentation quality is treated as a multiplier that amplifies every other technical capability — trunk-based development, continuous
integration, continuous delivery, supply chain security, and SRE practices — rather than a standalone practice measured in isolation.

- [Why it matters](#why-it-matters)

### Rule ADR-DORADQ:4

Ownership of documentation currency is explicit — guidelines, training, style guides, or a documentation champion own keeping authored
material accurate — rather than leaving currency to whichever contributor happens to notice drift.

- [How to apply](#how-to-apply)

### Rule ADR-DORADQ:5

Stale or duplicated documentation is treated as an active defect, not a passive gap: two copies of the same material are a drift risk from
the moment they are created, whether or not either copy has yet gone wrong.

- [Common pitfalls](#common-pitfalls)

## Context

DORA frames internal documentation as "a fundamental part of software development," on par with the code, tests, and pipelines it
describes.[^1] The capability is not "documentation exists" but documentation quality: whether the material a team produces is clear enough
to read, findable enough to reach, and reliable enough to trust.

Documentation quality sits alongside DORA's other technical capabilities without being one of them in isolation — DORA's research finds it
interacts with, and amplifies, the practices this repository's other capability ADRs already cover (version control, trunk-based
development, continuous integration, continuous delivery). A team that adopts those practices without quality documentation realizes a
fraction of the available performance gain; a team that pairs them with quality documentation realizes far more.

## Summary

The capability is documentation that is clear, findable, and reliable — DORA's research uses eight metrics spanning those three dimensions
to assess it. The requirement is not a documentation policy or a single style guide but the outcome those instruments measure: a reader can
locate the material relevant to their task, understand it once found, and trust that what it says still matches the system it describes.

Documentation quality is not scoped to end-user or customer-facing material. It covers internal documentation — architecture records,
runbooks, comment-based help, contribution guides — every artifact a contributor or operator consults to understand or change the system.

## Why it matters

DORA's research finds that documentation quality drives the realized benefit of every other technical practice studied. Above-average
documentation multiplies the performance lift of trunk-based development (1525%, against 36% with below-average documentation), continuous
integration (750% against 34%), continuous delivery (656% against 63%), supply chain security practices (451% against 37%), and SRE
practices (343% against 79%). The mechanism is straightforward: a technical practice only pays off when the people executing it can find and
trust the documentation that tells them how, so poor documentation caps the return on every other capability regardless of how well that
capability is otherwise implemented.

## How to apply

This platform realizes clarity and findability by keeping documentation examples on one consistent, obviously-fictional theme
([ADR-EXAMPLE](../repository/documentation-examples.md)) so a reader recognizes illustrative material instantly and is never confused about
whether an example is live data. It realizes reliability by removing the chance of drift at the source: a generated `README.md` is a
filesystem link to its single authored source rather than a hand-kept copy, so the two can never diverge
([ADR-README](../repository/generated-readmes.md)). Both patterns follow DORA's broader guidance to invest in organizational guidelines,
training, style guides, and named documentation ownership rather than leaving currency to incidental effort.

## Common pitfalls

- **Documentation as an afterthought.** Writing it once at a milestone and never revisiting it as the system changes; documentation needs
  active, ongoing maintenance to stay reliable.
- **Duplicated sources.** Keeping the same material in two places — a README and its source article, a wiki page and a code comment —
  invites drift the moment either copy is edited without the other.
- **Poor findability.** Accurate documentation that a reader cannot locate from where they are working delivers none of the benefit; clarity
  without findability is wasted effort.
- **Treating it as an isolated practice.** Measuring documentation quality on its own rather than watching how it amplifies (or caps) the
  return on trunk-based development, continuous integration, continuous delivery, and other technical capabilities.

## References

[^1]:
    DORA, _Documentation quality_ capability, <https://dora.dev/capabilities/documentation-quality/>. Part of the DORA Core Model of
    capabilities that predict software delivery performance.

## Dora explains

Documentation quality is a force multiplier in DORA's model: it does not appear as an independent driver of delivery performance so much as
the factor that determines how much of the benefit from other capabilities a team actually realizes.

- [Trunk-based development](https://dora.dev/capabilities/trunk-based-development/) — shows the largest documented multiplier from
  above-average documentation quality.
- [Continuous integration](https://dora.dev/capabilities/continuous-integration/) — its performance lift is likewise amplified sharply by
  documentation quality.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — shares the same clarity and findability concerns, applied to
  code rather than prose.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
