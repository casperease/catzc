# ADR: DORA — Streamlining change approval

## Rules: ADR-DORASCA

### Rule ADR-DORASCA:1

Approve changes through peer review captured in the development platform during development, not through a centralized Change Approval Board
(CAB) that reviews after the fact. The review and its approval live where the change was made, as part of making it, not as a separate
downstream ceremony.

- [Summary](#summary)

### Rule ADR-DORASCA:2

Automation — continuous testing, continuous integration, and comprehensive monitoring — is the mechanism that catches a bad change early;
approval is not the last line of defense against defects. A gate a human reads late is a weaker check than one a pipeline runs continuously
from the first commit.

- [How to apply](#how-to-apply)

### Rule ADR-DORASCA:3

Approval weight scales with a change's risk profile; low-risk changes carry lightweight, mostly automated approval, and only genuinely
high-risk changes draw heavier scrutiny. Treating every change as equally risky wastes review capacity on the changes that need it least.

- [Common pitfalls](#common-pitfalls)

### Rule ADR-DORASCA:4

A centralized review body's role is cross-team coordination, process improvement, and business-level trade-off decisions — never detailed
code-level gatekeeping. A distant reviewer without the change's context is a poor substitute for the peer who wrote and reviewed it.

- [How to apply](#how-to-apply)

### Rule ADR-DORASCA:5

Regular change management is made fast and reliable enough to also serve emergency changes, rather than keeping a separate, less-controlled
fast path that bypasses approval under pressure. One well-built path beats two paths of different quality.

- [Summary](#summary)

## Context

Streamlining change approval sits alongside continuous integration, continuous delivery, and deployment automation in DORA's Core Model —
capabilities that together determine how safely and how fast a change reaches production. Change approval is the process that governs the
lifecycle of an IT service change: who decides a change is safe to ship, and when. The traditional shape of that process is a Change
Approval Board (CAB) or an external reviewer authorizing changes before deployment, sitting apart from the team that made the change.

DORA's 2019 State of DevOps Report examined this traditional shape directly and found it wanting: heavyweight external approval does not buy
the stability it is meant to protect, and it costs delivery speed getting there.[^1] The capability is DORA's answer — shift approval into
the development process itself, as peer review, backed by automation that finds problems before a human ever needs to look.

## Summary

Change approval is a process for managing the lifecycle of IT service changes. The traditional approach relies on a CAB or an external
reviewer to authorize a change before it deploys. DORA research recommends a different shape: peer review during development, captured in
the development platform, supplemented by automation that detects and prevents problematic changes early. Regular change management, built
well, is fast and reliable enough to also carry emergency changes — there is no need for a separate, weaker path for urgent work.

## Why it matters

DORA's 2019 State of DevOps Report found that heavyweight external approval processes measurably hurt software delivery performance.
Organizations that lean on a traditional CAB see slower delivery cycles, which pushes them toward larger, less frequent releases; those
larger releases carry higher change fail rates, because more changes land in production at once with more surface area for something to go
wrong. The research finds no evidence that the extra formal process improves outcomes — the CAB does not buy the stability it is meant to
provide.

The organizations that do improve their change approval process share one trait: their teams have a clear understanding of the change
approval process itself. Confidence in how a change gets approved, and how long it takes, correlates with better delivery performance — the
clarity matters as much as the mechanism.

## How to apply

Peer review, done during development and captured in the development platform, replaces the external CAB as the approval record; it
satisfies segregation-of-duties requirements without adding a separate downstream step. Automation — continuous testing, continuous
integration, and comprehensive monitoring — detects and prevents bad changes early, so approval is not the only, or the last, safeguard.
Development platforms are themselves treated as products, giving fast feedback on security, performance, stability, and defects to the
people making the change. A centralized review body, where one still exists, is redesigned toward cross-team coordination, process
improvement, and business-level trade-off decisions rather than line-by-line code review. Regular change management, built to this standard,
is fast and reliable enough to also serve emergency changes.

On this platform, the pull request is exactly this shift made concrete: it is the authenticated ingress that captures peer review as a merge
precondition ([ADR-REMOTE](../design/server-remote-integration.md)), not a separate external gate a change waits behind. Self-service
delivery ([ADR-SELFSERV](../design/self-service.md)) rests on that same PR as its change-approval control — reviewable, reproducible, and
audited by construction, with no ticket to a central gatekeeper. Where a human certification gate does exist, it sits at the release
boundary — RC and RBC ([ADR-FLOW](../design/ci-discipline-and-promotion-flow.md)) — scoped to the business decision of certifying a release
candidate, not to re-reviewing code the PR already gated.

## Common pitfalls

- **Over-reliance on centralized CABs for error detection.** A reviewer distant from the change lacks the context to catch what the change
  actually implies; the check is theater more than it is a safeguard.
- **Treating all changes uniformly.** Applying the same heavyweight approval to every change regardless of risk wastes review capacity on
  low-risk changes and dilutes the attention high-risk changes deserve.
- **Neglecting continuous improvement of change metrics.** Not tracking or improving lead time and change fail rate leaves the approval
  process's actual effect on delivery invisible.
- **Adding process layers in response to production problems.** Reacting to an incident with a new approval step increases lead time and
  batch size, which worsens stability rather than improving it — a vicious cycle that heavyweight approval was supposed to prevent.

## References

[^1]:
    DORA, _Streamlining change approval_ capability, <https://dora.dev/capabilities/streamlining-change-approval/>. Part of the DORA Core
    Model of capabilities that predict software delivery performance.

## Dora explains

Streamlining change approval is DORA's answer to how a team keeps changes safe without slowing delivery: peer review built into the
development platform, backed by automation, in place of a heavyweight external board.

- [Continuous integration](https://dora.dev/capabilities/continuous-integration/) — the automated checks that catch problems before a human
  approval step ever needs to.
- [Version control](https://dora.dev/capabilities/version-control/) — the platform where peer review and approval are captured as part of
  the change itself.
- [Trunk-based development](https://dora.dev/capabilities/trunk-based-development/) — small, frequent changes are what make lightweight,
  risk-scaled approval practical.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — automates the path from an approved change to production,
  keeping the approved path the only path.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
