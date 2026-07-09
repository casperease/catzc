# ADR: Holding the line — a failing gate stops the flow until it is green

## Rules: ADR-ANDON

### Rule ADR-ANDON:1

A failing gate stops the line: the failing change goes no further, and restoring green takes priority over starting new work. This is the
andon cord — anyone, or any gate, can and must halt the flow the moment a defect appears (jidoka).

- [Decision](#decision)

### Rule ADR-ANDON:2

Never build on a known-broken baseline. A red mainline is fixed or reverted before new work integrates on top of it; stacking work on a
defect multiplies its blast radius and hides which change was at fault ([ADR-LIFE](../design/commit-lifecycle.md)).

- [Decision](#decision)

### Rule ADR-ANDON:3

Stopping the line is cheap and expected, not a failure event. The best stop is the earliest and smallest — a gate on the devbox
([ADR-PARITY](../automation/devbox-pipeline-parity.md)); the worst is a stop discovered in production. Optimise for stopping furthest left,
not for never stopping.

- [Why](#why)

### Rule ADR-ANDON:4

The stop is automatic and unambiguous: the gate throws ([ADR-ERROR](../automation/powershell/error-handling.md)), the commit is coloured red
([ADR-VISUAL](../design/visual-design.md)), and there is no "warn and continue" path. A warning that does not stop the line is not holding
the line.

- [How to apply](#how-to-apply)

## Context

The Toyota Production System ([ADR-LEAN](lean.md)) gives every worker an andon cord: pull it and the line stops. This sounds expensive — a
whole line idled by one station — but it is the cheapest policy Toyota found, because a defect allowed to travel down the line is multiplied
by every station it passes before someone notices. Stopping at the source turns a potential recall into a one-station fix [^1].

Software delivery has the same physics ([ADR-NOWASTE](../principles/reduce-waste.md), waste seven: defects grow with distance travelled). A
broken build that is allowed to stand while work piles on top of it does not stay one defect; it becomes a tangle in which every new change
is suspect and the original fault is buried. The question this article settles is what happens the instant a gate goes red.

## Decision

When a gate fails, the line stops. Concretely:

- The failing change does not advance. A red commit cannot be promoted or consumed downstream ([ADR-LIFE](../design/commit-lifecycle.md),
  the hard-stop rule) — it stays where it died, in history, coloured red ([ADR-VISUAL](../design/visual-design.md)).
- Restoring green is the team's first priority over starting new work. A broken mainline is a shared emergency, not one person's chore.
- No new work builds on the broken baseline. The fix goes in — or the offending change is reverted — before anything integrates on top.

The mechanism is the same fail-fast jidoka the platform uses everywhere ([ADR-POKAYOKE](../principles/poka-yoke.md), rule 3): stop the
moment a defect is detected, fix it at the source, then resume. "Holding the line" is that principle applied to the mainline and the
promotion flow ([ADR-FLOW](../design/ci-discipline-and-promotion-flow.md)) rather than to a single function call [^2].

## Why

**A defect's cost is its distance travelled.** The andon cord is cheap precisely because it caps that distance at zero stations. A gate that
lets a red build stand trades a small, certain stop for a large, uncertain untangling later.

**Green is the shared baseline everything depends on.** Integration, promotion, and consumption all assume the mainline works
([ADR-LIFE](../design/commit-lifecycle.md), the stable sync point). The moment that assumption is false and unenforced, every downstream
actor inherits the break.

**Stopping early is a feature, not a fault.** A team that stops the line often on the devbox and rarely in the pipeline is winning
([ADR-PARITY](../automation/devbox-pipeline-parity.md)) — the stops are landing where they are cheapest. Punishing stops teaches people to
route around the cord, which is how defects reach production.

## How to apply

Make the stop automatic and total. A gate that detects a problem throws ([ADR-ERROR](../automation/powershell/error-handling.md)) — it does
not `Write-Warning` and carry on, because a warning that does not stop is a defect waved through. When the mainline is red, treat restoring
it as the top priority and do not integrate new work onto it. When you hit a red gate on your own machine, that is the system working: fix
it there, where it is a one-line change, rather than pushing and letting the pipeline catch it.

## References

[^1]:
    Taiichi Ohno, _Toyota Production System: Beyond Large-Scale Production_ (1988). Jidoka and the andon cord — stop the line at the first
    defect and fix it at the source — are the origin of this rule.

[^2]:
    Mary and Tom Poppendieck, _Lean Software Development: An Agile Toolkit_ (2003). "Stop the line" mapped to software: a failing build is a
    pulled andon cord, and the team swarms to restore flow before doing anything else.

## Dora explains

DORA finds that keeping the mainline releasable — fixing a broken build as the top priority — is a defining practice of high-performing
teams, and that trunk-based development depends on it.

- [Continuous integration](https://dora.dev/capabilities/continuous-integration/) — a failing build stops the line and is fixed within
  minutes; that discipline is what CI measures.
- [Trunk-based development](https://dora.dev/capabilities/trunk-based-development/) — building only on a green mainline is what makes a
  shared trunk safe.
- [Test automation](https://dora.dev/capabilities/test-automation/) — automated gates are the cords that can stop the line the instant a
  defect appears.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
