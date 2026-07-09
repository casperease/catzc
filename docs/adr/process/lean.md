# ADR: Lean — the Toyota Production System, mapped to software by the Poppendiecks

## Rules: ADR-LEAN

### Rule ADR-LEAN:1

Lean is here the Toyota Production System applied to software delivery: its two pillars are just-in-time flow (make value move without
waiting) and jidoka (build quality in, stop the line on a defect). Its goal is the fastest _sustainable_ flow from concept to cash with
quality built in, never inspected in.

- [Decision](#decision)

### Rule ADR-LEAN:2

The seven Poppendieck principles are authoritative here — eliminate waste, build quality in, create knowledge, defer commitment, deliver
fast, respect people, and optimise the whole — and each is realised by concrete rules elsewhere in this repository rather than left as
slogans.

- [The seven principles](#the-seven-principles)

### Rule ADR-LEAN:3

Lean is quantitative, not merely cultural: Little's Law makes flow time a function of work-in-progress and throughput, and cost of delay
makes queue time money. The platform manages batch size and work-in-progress on that basis, not by intuition
([ADR-QUEUECOST](queues-cost-money.md)).

- [The two laws](#the-two-laws)

### Rule ADR-LEAN:4

Machine time is cheap and falls on a Moore's-law cadence while human attention is the scarce constraint, so the platform spends compute
freely — parallel gates, eager caches, ephemeral environments — to drain the human queue. A minute of CPU is cheaper than a minute of a
person blocked ([ADR-QUEUECOST](queues-cost-money.md)).

- [The two laws](#the-two-laws)

### Rule ADR-LEAN:5

Lean and agile ([ADR-AGILE](agile.md)) describe the same responsiveness from two directions — flow of value and response to change — and
reinforce rather than compete; where a lean rule and an agile principle meet, they say the same thing in different words.

- [Why](#why)

## Context

Agile ([ADR-AGILE](agile.md)) fixes _what responsiveness is_ and measures it by the cost of change. Lean supplies the other half: a
mechanical account of _how work flows_ and _where it stalls_. The two grew up together — the Agile Manifesto's authors drew directly on lean
manufacturing — but they answer different questions, and this repository needs both. Where the agile articles define the values and
principles, the lean articles define the flow discipline the pipeline and promotion rules specialise. Both draw on one shared vocabulary —
constraint, throughput, lead time, work-in-progress — fixed once in [ADR-LEANTERMS](process-terms.md).

"Lean" is as overloaded as "agile": it names Toyota's production system, a startup methodology, a family of consultancies, and a
cost-cutting euphemism. This article fixes the one meaning that grounds decisions here — Taiichi Ohno's Toyota Production System [^1] as
mapped to software by Mary and Tom Poppendieck [^2] — so that a claim of "this is leaner" can be checked against flow, waste, and queues
rather than asserted.

## Decision

Adopt lean as defined by the Toyota Production System's two pillars and the Poppendiecks' translation of them to software:

- **Just-in-time flow.** Value moves through the system pulled by downstream demand, in the smallest batches that make sense, with the
  shortest possible wait between steps. The enemy is not slow work but idle work — items sitting in queues.
- **Jidoka — "automation with a human touch".** The moment a defect appears, the line stops, the defect is fixed at its source, and only
  then does production resume. Quality is a property of the process, not a phase bolted on at the end.

These two pillars specialise, for CI/CD, into the six companion articles below. Everything lean-flavoured in this repository is one of them,
and each is anchored to concrete rules — the seven wastes ([ADR-NOWASTE](../principles/reduce-waste.md)), fail-fast jidoka
([ADR-POKAYOKE](../principles/poka-yoke.md)), the promotion flow ([ADR-FLOW](../design/ci-discipline-and-promotion-flow.md)) — so lean here
is enacted, not merely admired.

## The seven principles

The Poppendiecks map the Toyota Production System to software as seven principles [^2]. Each is authoritative here, and each has a home in
this repository's rules:

1. **Eliminate waste.** Remove any work that does not contribute to the outcome — the seven wastes
   ([ADR-NOWASTE](../principles/reduce-waste.md)).
2. **Build quality in.** Make each step produce already-correct output; do not inspect quality in afterwards
   ([ADR-BUILTIN](build-quality-in.md)).
3. **Create knowledge.** Development is a knowledge-creating process; capture what is learned so it is not relearned
   ([ADR-KAIZEN](inspect-and-adapt.md)).
4. **Defer commitment.** Decide at the last responsible moment, when the most is known ([ADR-PULLWORK](pull-work.md)).
5. **Deliver fast.** Short lead time is a competitive advantage and a prerequisite for deferring commitment; speed comes from draining
   queues ([ADR-QUEUECOST](queues-cost-money.md)).
6. **Respect people.** The people doing the work design the work; the system supports them ([ADR-VALUES](agile-values.md),
   [ADR-PRINCIPLES](agile-principles.md)).
7. **Optimise the whole.** Improve the end-to-end value stream, not a local step; a local optimum that starves the whole is a loss
   ([ADR-OBSERVEWIP](observe-work.md)).

## The two laws

Lean's flow claims are not metaphors; two laws make them quantitative, and both are used directly in [ADR-QUEUECOST](queues-cost-money.md):

- **Little's Law** [^3]. For any stable system, average flow time equals average work-in-progress divided by average throughput
  (`flow time = WIP ÷ throughput`). Throughput is near-fixed in the short run, so the practical lever on lead time is work-in-progress: cut
  the queue and lead time falls, arithmetically, with no one working faster. This is why the platform limits work-in-progress and shrinks
  batch size rather than exhorting people to hurry.
- **Moore's Law** [^4]. Compute capacity per unit cost roughly doubles on a regular cadence, so machine time trends towards free while human
  attention stays the scarce, expensive constraint. The lean move is therefore to spend the cheap resource to save the dear one: run gates
  in parallel, cache aggressively ([ADR-CACHE](../automation/caching.md)), stand up ephemeral environments, rebuild rather than wait. Buying
  down a human queue with machine time is almost always the right trade.

## Why

**Agile says why; lean says how work flows.** "Respond to change cheaply" ([ADR-AGILE](agile.md)) is the goal; lean's flow, waste, and queue
discipline is the mechanism that makes change cheap. Holding both keeps the repository's process rules anchored to a purpose _and_ a
mechanism.

**A mechanical model beats intuition.** Little's Law and cost of delay turn "we feel slow" into "our work-in-progress is too high and our
queues are expensive" — a checkable claim with a known remedy. Decisions about batch size, parallelism, and gating rest on the model, not on
taste.

**The lineage keeps the rules honest.** Anchoring to Ohno and the Poppendiecks means an adaptation can be tested against the source rather
than against whatever "lean" has come to mean in a given team. When a practice cannot be traced to eliminating waste, building quality in,
or shortening flow, it is ceremony ([ADR-NOWASTE](../principles/reduce-waste.md)).

## How to apply

Treat this article as the umbrella and the six companions as the detail. When a flow or process decision is in question, name which lean
principle it serves and which companion article governs it: is this holding the line ([ADR-ANDON](holding-the-line.md)), building quality in
([ADR-BUILTIN](build-quality-in.md)), observing the work ([ADR-OBSERVEWIP](observe-work.md)), pulling work ([ADR-PULLWORK](pull-work.md)),
draining a queue ([ADR-QUEUECOST](queues-cost-money.md)), or inspecting and adapting ([ADR-KAIZEN](inspect-and-adapt.md))? A change that
serves none of the seven principles is waste. When a repository rule specialises a lean principle, cite it so the lineage stays visible.

## References

[^1]:
    Taiichi Ohno, _Toyota Production System: Beyond Large-Scale Production_ (1988). The origin of just-in-time and jidoka — the two pillars
    — and of the seven wastes (muda). Ohno's insight is that visible waste hides in the waiting between steps, not in the steps themselves.

[^2]:
    Mary and Tom Poppendieck, _Lean Software Development: An Agile Toolkit_ (2003) and _Implementing Lean Software Development: From Concept
    to Cash_ (2006). The canonical mapping of the Toyota Production System to software, including the seven principles and the seven wastes
    used throughout these ADRs.

[^3]:
    John D. C. Little, "A Proof for the Queuing Formula: L = λW", _Operations Research_ 9 (1961). The relationship holds for any stable
    system regardless of arrival or service distribution, which is what makes it a dependable lever on lead time.

[^4]:
    Gordon E. Moore, "Cramming More Components onto Integrated Circuits", _Electronics_ (1965). Used here for its economic consequence —
    compute grows cheap relative to human time — rather than as a claim about transistor counts.

## Dora explains

DORA's research frames elite delivery as fast, stable flow — short lead times and small batches with quality held constant — which is lean
flow discipline measured. The lean principles here are the practices those metrics reward.

- [Working in small batches](https://dora.dev/capabilities/working-in-small-batches/) — small batches are the core lean flow move and the
  strongest predictor of short lead time.
- [Work in process limits](https://dora.dev/capabilities/wip-limits/) — limiting work-in-progress is Little's Law applied: it lowers lead
  time directly.
- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — delivering fast and building quality in are the two pillars
  made continuous.
- [Learning culture](https://dora.dev/capabilities/learning-culture/) — creating knowledge and optimising the whole depend on a team that
  learns from the flow it can see.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
