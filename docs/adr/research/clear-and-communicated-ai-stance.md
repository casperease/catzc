# ADR: DORA — Clear and communicated AI stance

## Rules: ADR-DORAAIS

### Rule ADR-DORAAIS:1

An AI stance is a living, actionable framework, not a static legal document — it tells developers how the organization expects them to use
AI, which tools are sanctioned, and how the organization supports that use.

- [Summary](#summary)

### Rule ADR-DORAAIS:2

A stance only works when a developer can answer four questions from it: whether AI use is expected, whether experimentation is supported,
which tools are permitted, and how the policy applies to their own role — ambiguity in any one of these pushes developers toward hiding
their AI use or avoiding it altogether.

- [Why it matters](#why-it-matters)

### Rule ADR-DORAAIS:3

Classify every tool and use case into one of three buckets — prohibited, permitted with guardrails, or allowed — and publish that
classification as a living document with a working feedback loop, not a policy issued once and left to go stale.

- [How to apply](#how-to-apply)

### Rule ADR-DORAAIS:4

Revise the stance on a cadence that matches how fast AI tooling actually changes; treating it as fixed lets it fall behind, but revising it
faster than developers can absorb produces policy whiplash that is just as damaging.

- [Common pitfalls](#common-pitfalls)

### Rule ADR-DORAAIS:5

Draft and own the stance with a cross-functional group — engineering, legal, security, IT, and product — so the result is practical for the
engineering work it governs, rather than a single department's policy applied to engineering from outside.

- [Common pitfalls](#common-pitfalls)

## Context

A clear and communicated AI stance is DORA's capability for how an organization tells its developers what is expected of them around AI:
which tools they may use, what guardrails apply, and what support exists when they try. DORA frames it as a "comprehensible, widely
socialized framework that tells developers: 'Here is how we expect you to use AI, here are the tools you can use, and here is how we support
you.'"

It sits among DORA's newer, AI-specific capabilities, alongside AI-accessible internal data and healthy data ecosystems: capabilities that
condition how much benefit an organization actually captures from AI adoption, as distinct from the core capabilities that predict delivery
performance generally. Without a clear stance, the same AI tooling produces inconsistent, anxious, or hidden usage instead of a consistent
lift in effectiveness.

## Summary

A clear and communicated AI stance moves an organization's AI policy out of static legal documents and into an actionable guide embedded in
day-to-day culture. It succeeds when a developer perceives four things from it: that AI use is **expected**, that the organization
**supports** experimentation, that **permitted** tools are clearly identified, and that the policy's **applicability** to their own role is
plain.

DORA's implementation guidance names five steps: secure executive sponsorship for the AI mission and adoption plan; form a cross-functional
working group spanning engineering, legal, security, IT, and product; adopt a three-bucket framework that sorts tools and use cases into
prohibited, permitted with guardrails, or allowed; publish the result as a living document in a searchable developer hub with an evolving
FAQ; and socialize it through launches such as town halls while keeping a feedback loop open so the policy can evolve.

## Why it matters

DORA research finds, with a high degree of certainty, that a clear and communicated AI stance amplifies AI's positive influence on both
individual effectiveness and organizational performance. A stance that meets the four perception criteria above turns AI from a source of
anxiety into a tool for reducing friction.

The failure mode it prevents is ambiguity: when developers cannot tell what is expected, permitted, or supported, they respond by hiding
their AI use — shadow AI — or by avoiding the tools entirely, forfeiting the benefit an organization intended to capture by adopting AI in
the first place.

## How to apply

Applying this capability means treating the AI stance itself as a product with an owner, not a one-off memo: executive sponsorship gives it
a mandate, a cross-functional working group keeps it grounded in what is actually practical for engineering work, the three-bucket framework
gives developers an unambiguous answer for any given tool, and a living document with an open feedback channel lets the policy keep pace
with how the tools and the organization's experience with them change.

## Common pitfalls

- **Treating the stance as a "one-time" policy.** AI tooling and practice change on a monthly cadence; a stance published once and left
  untouched drifts out of date and stops answering the questions developers actually have.

- **The "whiplash" effect.** Revising the policy so often, or so abruptly, that developers cannot keep up erodes the same trust that a clear
  stance is meant to build — change needs room to be absorbed, not just announced.

- **Myopic authorship.** A stance drafted by a single department — legal or security alone, for instance — in isolation from engineering
  tends to ignore practical engineering realities, producing rules developers cannot actually follow.

## References

[^1]:
    DORA, _Clear and communicated AI stance_ capability, <https://dora.dev/capabilities/clear-and-communicated-ai-stance/>. Part of DORA's
    AI-capabilities research on how organizations shape the effect of AI adoption on delivery performance.

## Dora explains

This capability sits at the front of DORA's AI-capabilities research: without a clear stance on expected, permitted, and supported AI use,
the same tooling produces inconsistent adoption and hidden usage instead of a measurable lift in individual and organizational performance.

- [AI-accessible internal data](https://dora.dev/capabilities/ai-accessible-internal-data/) — a companion AI capability; a clear stance on
  how AI may use internal data is part of what the policy must communicate.
- [Healthy data ecosystems](https://dora.dev/capabilities/healthy-data-ecosystems/) — the data-quality foundation an AI stance assumes when
  it tells developers which AI-assisted uses are safe to rely on.
- [Generative organizational culture](https://dora.dev/capabilities/generative-organizational-culture/) — the culture of trust and
  information flow that determines whether a published stance is actually believed and followed.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
