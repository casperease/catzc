# EDR: DORA — Generative organizational culture

## Rules: EDR-DORA-CULTURE

### Rule EDR-DORA-CULTURE-INFORMATIONFLOW

Organizational culture is classified by how information flows through it, using Ron Westrum's typology of pathological (power-oriented),
bureaucratic (rule-oriented), and generative (performance-oriented) cultures — not by any other axis of team behavior.

Source: [DORA, Generative organizational culture](../../../references/dora/capabilities.md#generative-organizational-culture)

### Rule EDR-DORA-CULTURE-SIXTRAITS

A generative culture is defined by six concrete traits, not a slogan: high cooperation, trained messengers, shared risk, encouraged bridging
across roles, failure met with inquiry, and novelty implemented rather than resisted. Treat all six as the working definition.

Source: [DORA, Generative organizational culture](../../../references/dora/capabilities.md#generative-organizational-culture)

Binds to [WDR-BUILTIN-QUALITYBUILTIN](../../process/build-quality-in.md#rule-wdr-builtin-qualitybuiltin).

### Rule EDR-DORA-CULTURE-BEHAVIOURFIRST

Change behavior first and let belief follow. Culture shifts by changing what people do — how a postmortem runs, who owns a system in
production, how an idea gets tried — not by first trying to change how people think.

Source: [DORA, Generative organizational culture](../../../references/dora/capabilities.md#generative-organizational-culture)

### Rule EDR-DORA-CULTURE-FAILUREISINFORMATION

Treat a failure as information about the system, never as a reason to find someone to blame. Punishing the messenger, or the person nearest
the incident, teaches people to hide problems instead of surfacing them.

Source: [DORA, Generative organizational culture](../../../references/dora/capabilities.md#generative-organizational-culture)

Binds to [WDR-ANDON-STOPPINGISCHEAP](../../process/holding-the-line.md#rule-wdr-andon-stoppingischeap) and
[WDR-KAIZEN-ADAPTFROMEVIDENCE](../../process/inspect-and-adapt.md#rule-wdr-kaizen-adaptfromevidence).

### Rule EDR-DORA-CULTURE-MEASUREPERCEPTION

Measure culture as a perception, not an artifact count. Westrum's six survey items, scored on a Likert scale and averaged into one score,
are the validated instrument for this capability — not a proxy derived from delivery metrics.

Source: [DORA, Generative organizational culture](../../../references/dora/capabilities.md#generative-organizational-culture)

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
changing practice.

Run blameless postmortems that ask what happened rather than who did it, give developers ownership of their code once it runs in production,
break down silos through shared planning and informal cross-functional conversation, and protect real time for people to try an idea rather
than only tolerating the idea in theory.

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

Generative organizational culture carries DORA evidence from 2014 through 2023 and is a member of the Core Model's climate-for-learning
group, where the diagram labels it "Generative culture". It predicts software delivery performance, organizational performance, and lower
burnout, alongside and reinforcing the technical capabilities: a team can run excellent technical practices and still underperform if its
culture punishes the reporting of bad news or blocks the sharing of risk.

- **Catalogue entry:** [Generative organizational culture](../../../references/dora/capabilities.md#generative-organizational-culture)
- **Category:** [Climate for learning](../../../references/dora/capabilities.md#climate-for-learning) — Core Model v2.1.0:
  [climate for learning](../../../references/dora/core-model.md#climate-for-learning). The Quick Check names it one of three capabilities
  worth assessing first.
- **Evidence:**
  - [2014 State of DevOps Report](../../../references/dora/publications.md#2014-state-of-devops-report) — organizational culture strongly
    predicts IT and organizational performance.
  - [2018 Accelerate State of DevOps Report](../../../references/dora/publications.md#2018-accelerate-state-of-devops-report) — generative
    culture, and autonomy grounded in trust in leaders, drive performance.
  - [2019 Accelerate State of DevOps Report](../../../references/dora/publications.md#2019-accelerate-state-of-devops-report) —
    psychological safety predicts software delivery performance, organizational performance, and productivity.
  - [2021 Accelerate State of DevOps Report](../../../references/dora/publications.md#2021-accelerate-state-of-devops-report) — inclusive,
    generative team cultures had less burnout during the COVID-19 pandemic.
  - [2022 Accelerate State of DevOps Report](../../../references/dora/publications.md#2022-accelerate-state-of-devops-report) — high-trust,
    low-blame cultures go with higher organizational performance, and culture is the biggest predictor of security practices.
  - [2023 Accelerate State of DevOps Report](../../../references/dora/publications.md#2023-accelerate-state-of-devops-report) — generative
    cultures go with 30% higher organizational performance.
- **Predicts:** [software delivery performance](../../../references/dora/core-model.md#software-delivery-performance),
  [organizational performance](../../../references/dora/core-model.md#organizational-performance), and lower burnout, part of
  [well-being](../../../references/dora/core-model.md#well-being).
- **Related capabilities:**
  - [Learning culture](../../../references/dora/capabilities.md#learning-culture) — a generative response to failure, inquiry rather than
    blame, is what makes a learning culture possible.
  - [Team experimentation](../../../references/dora/capabilities.md#team-experimentation) — implementing novelty rather than merely
    tolerating it is what lets a team run and learn from experiments.
  - [Job satisfaction](../../../references/dora/capabilities.md#job-satisfaction) — high cooperation and shared risk are part of what makes
    work sustainable and satisfying.
  - [Transformational leadership](../../../references/dora/capabilities.md#transformational-leadership) — leadership support is what makes a
    generative culture's behaviors safe to practice.
- [DORA research reference](../../../references/dora/index.md) — the overview these findings sit within.
