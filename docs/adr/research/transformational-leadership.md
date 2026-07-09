# ADR: DORA — Transformational leadership

## Rules: ADR-DORA-LEADERSHIP

### Rule ADR-DORA-LEADERSHIP:1

Transformational leadership is five distinct behaviors — vision, inspirational communication, intellectual stimulation, supportive
leadership, and personal recognition — not a single trait, a job title, or a slogan; treat all five as necessary, not a menu to pick one
from.

- [Summary](#summary)

### Rule ADR-DORA-LEADERSHIP:2

Treat leadership as an indirect lever on delivery performance: its effect runs through the technical and product-management practices it
enables a team to adopt, not through the leader producing outcomes directly.

- [Why it matters](#why-it-matters)

### Rule ADR-DORA-LEADERSHIP:3

Never treat strong leadership behaviors as sufficient on their own. Pair them with investment in the practices they are meant to unlock —
leadership quality alone predicts only part of the variation in delivery performance, and even highly transformational leaders see teams
with widely varying outcomes when the underlying practices are missing.

- [Common pitfalls](#common-pitfalls)

### Rule ADR-DORA-LEADERSHIP:4

Set clear, measurable delivery goals, use intellectual stimulation to help a team question its own assumptions, and recognize good work and
safe experimentation deliberately — including attempts that fail — and hold to that behavior consistently, especially under stress.

- [How to apply](#how-to-apply)

### Rule ADR-DORA-LEADERSHIP:5

Distribute leadership rather than concentrating it in one named role. Anyone in a position to set direction, challenge assumptions, or
recognize good work can and should practice these five behaviors, not only the person with the title.

- [How to apply](#how-to-apply)

## Context

Transformational leadership is one of the capabilities in DORA's Core Model, and it behaves differently from most of the others: it is not a
technical or process practice that a team adopts directly, it is a leadership style that predicts whether the team adopts the other
practices at all. DORA defines it across five measured dimensions — vision, inspirational communication, intellectual stimulation,
supportive leadership, and personal recognition — each drawn from validated leadership-behavior research and each assessed by asking team
members how their leader actually behaves.[^1]

The capability sits upstream of the rest of the Core Model rather than beside it: DORA's validated model shows transformational leaders
driving delivery performance by enabling adoption of technical and product-management capabilities, not by any direct action of the leader
on outcomes. A leader who scores well on all five dimensions but whose team never gets the technical practices in place does not, by this
model, produce a high-performing team.

## Summary

Transformational leadership comprises five dimensions. **Vision** is understanding clearly where the team and the organization are going,
and where the team should be in five years. **Inspirational communication** is saying positive things about the team, making employees proud
to belong to the organization, and framing changing conditions as opportunities rather than threats. **Intellectual stimulation** is
challenging team members to think about old problems in new ways and to rethink their basic assumptions about their work. **Supportive
leadership** is considering others' personal feelings before acting and behaving in a way that is thoughtful of others' personal needs.
**Personal recognition** is commending team members when they do a better-than-average job and acknowledging improvement in the quality of
their work.

All five are behaviors, not credentials: they are observed in what a leader does day to day, and DORA measures them by asking the people who
work for that leader, not by asking the leader to self-assess.

## Why it matters

DORA's research finds that teams with the least transformational leaders are half as likely to exhibit high software delivery performance.
The mechanism is indirect rather than direct: transformational leadership does not move delivery metrics by itself, it moves them by making
a team more likely to adopt the technical and product-management practices — continuous delivery, lean product management, a generative
culture — that do predict performance. A leader who sets a clear vision, invites the team to question its own assumptions, supports people
under pressure, and recognizes good work is a leader whose team can actually take up those practices; a leader who does none of this is an
obstacle to adopting them, regardless of how good the practices are on paper.

## How to apply

This platform cannot encode leadership behavior directly — it is a property of people, not of code — but two of its process decisions are
the concrete form two of the five dimensions take here. Holding the line ([ADR-PROC-ANDON](../process/holding-the-line.md)) states plainly
that stopping the line is cheap and expected, never a failure event, and that punishing a stop teaches people to route around the cord
instead — that is supportive leadership applied to a specific moment: whether a team member who halts the flow to report a defect is treated
with support or blame decides whether the andon cord gets pulled again. Inspect-and-adapt
([ADR-PROC-KAIZEN](../process/inspect-and-adapt.md)) builds continuous, evidence-driven reflection into the process itself — the discipline
of routinely questioning how the team works and why — which is intellectual stimulation made a standing habit rather than an occasional
leadership gesture.

Beyond what a platform can enforce, apply the capability by setting delivery goals that are specific enough to be measurably true or false,
by treating obstacles as questions to put to the team rather than answers to hand down, by rewarding deliberate experimentation even when an
attempt fails, and by keeping the same supportive, recognition-giving behavior under deadline pressure as when things are calm. Treat
leadership as something anyone in a position to influence a team can practice, not as a behavior reserved for a named role.

## Common pitfalls

- **Leadership as a substitute for practice investment.** Assuming that strong leadership behaviors alone will lift delivery performance —
  leaders cannot achieve higher performance on their own; the behaviors matter because of the practices they enable a team to adopt, and
  skipping investment in those practices leaves the leadership effort with nothing to act through.
- **Inconsistent behavior under pressure.** Vision, support, and recognition that hold up in calm periods and disappear under deadline
  stress are not transformational leadership, they are a fair-weather version of it — DORA's research treats consistency, especially under
  stress, as part of the behavior itself.
- **Leadership concentrated in one role.** Treating these five behaviors as the exclusive property of a person with a leadership title,
  rather than as behaviors anyone influencing the team can practice, narrows the effect to one person's bandwidth and one person's blind
  spots.

## References

[^1]:
    DORA, _Transformational leadership_ capability, <https://dora.dev/capabilities/transformational-leadership/>. Part of the DORA Core
    Model of capabilities that predict software delivery performance.

## Dora explains

Transformational leadership is the capability DORA's own model treats as indirect: it does not move delivery metrics on its own, it moves
them by making a team more likely to adopt the technical and cultural practices that do. It is the human precondition the rest of the Core
Model assumes.

- [Learning culture](https://dora.dev/capabilities/learning-culture/) — intellectual stimulation is what turns questioning old assumptions
  into a standing habit rather than a one-off leadership gesture.
- [Generative organizational culture](https://dora.dev/capabilities/generative-organizational-culture/) — supportive leadership and personal
  recognition are what make a blameless, trust-based culture possible in practice.
- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — one of the technical practices transformational leadership
  predicts adoption of, rather than a capability it produces directly.
- [Job satisfaction](https://dora.dev/capabilities/job-satisfaction/) — supportive leadership and personal recognition bear directly on
  whether people find the work sustaining rather than draining.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
