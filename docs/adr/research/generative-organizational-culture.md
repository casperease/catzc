# ADR: DORA — Generative organizational culture

## Rules: ADR-DORA-CULTURE

### Rule ADR-DORA-CULTURE:1

Organizational culture is classified by how information flows through it, using Ron Westrum's typology of pathological (power-oriented),
bureaucratic (rule-oriented), and generative (performance-oriented) cultures — not by any other axis of team behavior.

- [Summary](#summary)

### Rule ADR-DORA-CULTURE:2

A generative culture is defined by six concrete traits, not a slogan: high cooperation, trained messengers, shared risk, encouraged bridging
across roles, failure met with inquiry, and novelty implemented rather than resisted. Treat all six as the working definition.

- [Summary](#summary)

### Rule ADR-DORA-CULTURE:3

Change behavior first and let belief follow. Culture shifts by changing what people do — how a postmortem runs, who owns a system in
production, how an idea gets tried — not by first trying to change how people think.

- [How to apply](#how-to-apply)

### Rule ADR-DORA-CULTURE:4

Treat a failure as information about the system, never as a reason to find someone to blame. Punishing the messenger, or the person nearest
the incident, teaches people to hide problems instead of surfacing them.

- [Common pitfalls](#common-pitfalls)

### Rule ADR-DORA-CULTURE:5

Measure culture as a perception, not an artifact count. Westrum's six survey items, scored on a Likert scale and averaged into one score,
are the validated instrument for this capability — not a proxy derived from delivery metrics.

- [Why it matters](#why-it-matters)

## Context

Generative organizational culture is one of DORA's cultural capabilities, alongside job satisfaction, learning culture, team
experimentation, transformational leadership, and well-being. Where the technical capabilities describe what a team builds and how it ships,
this capability describes how the organization around the team behaves under stress — whether information travels honestly or gets filtered,
blamed, or buried before it reaches the people who need it.

The capability rests on sociologist Ron Westrum's research on system safety: organizations that handle information well recover from failure
better than organizations that handle information badly, independent of how skilled their individual engineers are. Westrum's typology sorts
organizational cultures into three kinds along that single axis — how information flows — rather than by org chart, size, or industry.

## Summary

DORA describes organizational culture as high-trust and focused on information flow, and finds it predictive of both software delivery
performance and organizational performance in technology.[^1] The concept comes from Westrum's typology, which contrasts three culture types
across six dimensions: cooperation, treatment of messengers, scope of responsibility, encouragement of bridging across roles, response to
failure, and adoption of novelty.

A pathological culture is power-oriented: cooperation is low, messengers are shot, responsibility is shirked, bridging is discouraged,
failure means finding someone to blame, and novelty is crushed. A bureaucratic culture is rule-oriented: cooperation is modest, messengers
are neglected, responsibility is narrow, bridging is tolerated, failure means applying the rule book, and novelty creates problems. A
generative culture is performance-oriented: cooperation is high, messengers are trained, risks are shared, bridging is encouraged, failure
leads to inquiry, and novelty is implemented. Good information, in Westrum's framing, answers the receiver's actual question, arrives in
time to act on, and is presented so the receiver can use it effectively.

## Why it matters

A large two-year study at Google found that high-performing teams need a culture of trust and psychological safety, meaningful work, and
clarity. DORA's 2019 State of DevOps Report found that a culture of psychological safety is predictive of software delivery performance,
organizational performance, and productivity.

Because culture is a perception rather than an artifact, DORA measures it with survey methods rather than repository or pipeline metrics.
Six Westrum items, each scored on a 7-point Likert scale from strongly disagree to strongly agree, form a single latent construct: whether
information is actively sought, whether messengers go unpunished for bad news, whether responsibility is shared, whether cross-functional
collaboration is encouraged and rewarded, whether failure is treated primarily as an opportunity to improve the system, and whether new
ideas are welcomed. Averaging the six gives a team a single Westrum culture score to track over time.

## How to apply

DORA's implementation guidance is behavioral: change how people behave first, and belief follows, rather than trying to change minds before
changing practice. This platform's failure response already works that way. Holding the line
([ADR-PROC-ANDON](../process/holding-the-line.md)) treats a stopped line as the system working, not as a fault to find someone responsible
for — punishing whoever pulled the cord teaches people to route around it, the same messenger-punishing pattern a generative culture avoids.
Inspect-and-adapt ([ADR-PROC-KAIZEN](../process/inspect-and-adapt.md)) responds to a failure with a root-cause countermeasure drawn from
evidence, not with blame, which is Westrum's "failure leads to inquiry" applied to the platform's own gates. Building quality in
([ADR-PROC-BUILTIN](../process/build-quality-in.md)) removes the separate inspection phase and makes quality everyone's job rather than one
team's, which is the shared-risk trait a generative culture requires.

Beyond what these ADRs already encode, apply the capability directly: run blameless postmortems that ask what happened rather than who did
it, give developers ownership of their code once it runs in production, break down silos through shared planning and informal
cross-functional conversation, and protect real time for people to try an idea rather than only tolerating the idea in theory.

## Common pitfalls

- **Treating culture as secondary.** Culture work loses to technical and process work when it competes for the same attention — treating it
  as an afterthought misses that it predicts delivery performance in its own right.
- **Local optimization.** Fixing one team's culture without looking at the organization it sits inside — a generative team surrounded by a
  pathological organization still inherits the organization's response to failure.
- **No leadership backing.** Culture transformation with no support from managers and leadership does not take, because the behaviors it
  asks for — sharing risk, admitting failure, bridging across teams — need cover from above to be safe to practice.
- **Punishing bad news.** Ignoring or punishing whoever reports a failure teaches everyone to stop reporting, which is the opposite of what
  a generative culture needs.
- **Discouraging experimentation.** "We've always done it this way" forecloses the novelty a generative culture is supposed to implement,
  not merely tolerate.

## References

[^1]:
    DORA, _Generative organizational culture_ capability, <https://dora.dev/capabilities/generative-organizational-culture/>. Based on Ron
    Westrum's typology of organizational cultures.

## Dora explains

Generative organizational culture is one of DORA's cultural capabilities: predictors of delivery and organizational performance that sit
alongside, and reinforce, the technical and process capabilities. A team can run excellent technical practices and still underperform if its
culture punishes the reporting of bad news or blocks the sharing of risk.

- [Learning culture](https://dora.dev/capabilities/learning-culture/) — a generative response to failure, inquiry rather than blame, is what
  makes a learning culture possible.
- [Team experimentation](https://dora.dev/capabilities/team-experimentation/) — implementing novelty rather than merely tolerating it is
  what lets a team run and learn from experiments.
- [Job satisfaction](https://dora.dev/capabilities/job-satisfaction/) — high cooperation and shared risk are part of what makes work
  sustainable and satisfying.
- [Transformational leadership](https://dora.dev/capabilities/transformational-leadership/) — leadership support is what makes a generative
  culture's behaviors safe to practice.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
