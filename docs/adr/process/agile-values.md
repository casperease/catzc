# ADR: Agile values — the four preferences of the manifesto

## Rules: ADR-VALUES

### Rule ADR-VALUES:1

Value individuals and interactions over processes and tools — the people doing the work and how they communicate matter more than the
machinery around them; a process serves the people, never the reverse.

- [The four values](#the-four-values)

### Rule ADR-VALUES:2

Value working software over comprehensive documentation — running, usable software is the primary evidence of progress; documentation is
kept to what genuinely serves that end.

- [The four values](#the-four-values)

### Rule ADR-VALUES:3

Value customer collaboration over contract negotiation — a continuing working relationship with the customer adapts to what is learned,
where a fixed contract fixes the wrong answer early.

- [The four values](#the-four-values)

### Rule ADR-VALUES:4

Value responding to change over following a plan — a plan is a starting hypothesis; when reality diverges from it, the response to reality
wins over adherence to the plan.

- [The four values](#the-four-values)

## Context

The Agile Manifesto ([ADR-AGILE](agile.md)) opens with four value statements, each of the form "_A_ over _B_". They are the top of the
definition of agile: the twelve principles ([ADR-PRINCIPLES](agile-principles.md)) elaborate them, and every agile framework claims to serve
them. A recurring misreading treats each value as "_A_, not _B_" — as a licence to abandon documentation, plans, or contracts — which
inverts the manifesto's own words.

## The four values

The manifesto's authors "came to value" [^1]:

- **Individuals and interactions over processes and tools.** Capable people communicating well will overcome a weak process; a strong
  process cannot rescue a team that cannot talk to each other. Tools and processes exist to support the people, and are shaped to them.
- **Working software over comprehensive documentation.** Software that runs and does something useful is the honest measure of where a
  project stands. Documentation has real value, but a pile of documents is not progress; documentation is produced where it earns its keep,
  not by default.
- **Customer collaboration over contract negotiation.** Requirements are discovered, not known up front. A living relationship with the
  customer lets the product follow that discovery, where an up-front contract locks in the least-informed decisions and turns change into a
  dispute.
- **Responding to change over following a plan.** Planning is essential; a plan is not. The plan captures the best current understanding,
  and is expected to be revised as the team and customer learn — the ability to revise it cheaply is the whole point
  ([ADR-AGILE](agile.md)).

## Comparative, not absolute

Every value is a preference between two things that both have worth — the manifesto states plainly that "while there is value in the items
on the right, we value the items on the left more" [^1]. The right-hand items — processes, documentation, contracts, plans — are not
discarded. The value ranks them: when the two pull against each other, the left-hand item governs the decision.

Reading a value as an absolute ("no documentation", "no plan") is the most common way agile is misapplied. The correct reading is a
tie-break rule: default to the left, keep as much of the right as genuinely serves the outcome, and drop the rest as waste
([ADR-NOWASTE](../principles/reduce-waste.md)).

## How to apply

When two courses of action conflict, name which side of which value each serves and prefer the left. Reach for more documentation, more
up-front planning, or a firmer contract only when it demonstrably serves working software and responsiveness — not out of habit or process
compliance. If a practice can be justified by none of the four values, it is ceremony and can be removed.

## References

[^1]:
    Kent Beck et al., _Manifesto for Agile Software Development_ (2001), <https://agilemanifesto.org>. The four value statements and the
    closing clause — "That is, while there is value in the items on the right, we value the items on the left more" — are quoted from the
    manifesto text.

## Dora explains

DORA's research consistently finds that team capability and culture, not tooling or documentation weight, predict delivery performance — the
same ordering the four values assert.

- [Teams empowered to choose tools](https://dora.dev/capabilities/teams-empowered-to-choose-tools/) — putting people ahead of imposed
  tooling reflects individuals and interactions over processes and tools.
- [Working in small batches](https://dora.dev/capabilities/working-in-small-batches/) — small batches are what make responding to change
  over following a plan affordable.
- [Learning culture](https://dora.dev/capabilities/learning-culture/) — customer collaboration and change response both depend on a team
  that treats a plan as a hypothesis to revise.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
