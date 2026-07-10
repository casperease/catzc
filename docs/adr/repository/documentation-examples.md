# ADR: Documentation examples — the discovery theme

## Rules: ADR-REPO-EXAMPLE

### Rule ADR-REPO-EXAMPLE:1

Worked examples in documentation — example infrastructure template names, sample commands, getting-started tutorials — use the **discovery**
theme: the reader is a CLI user _discovering_ what the system can do, so example names are drawn from exploration vocabulary. The canonical
example template is `discovery`; an illustration that needs a second or third template uses sibling exploration names — `expedition` for a
slotted, per-customer template and `survey` for a lightweight variant.

- [The discovery theme](#the-discovery-theme)

### Rule ADR-REPO-EXAMPLE:2

Examples never carry a real, customer, or internal-project name. Every placeholder is obviously fictional and theme-consistent: fictional
companies use Microsoft's canonical Contoso and Globex; example infrastructure templates use the discovery theme (ADR-REPO-EXAMPLE:1). A
real name in an example is a defect — it leaks context into a public repository and ties the docs to a moment in time.

- [Why fictional, themed names](#why-fictional-themed-names)

## Context

Documentation carries examples: a template a tutorial builds step by step, a `Build-Bicep <name>` line in comment-based help, the deploy
stages a reference pipeline illustrates. Those names are read far more often than any real deployment, so they set the tone of the docs and
are the first thing a newcomer copies.

### The discovery theme

An example name should tell the reader it is an example and should feel like part of one coherent story rather than a scatter of unrelated
tokens. The framing is that the person at the CLI is exploring — discovering the templates, the build, the deploy flow — so the example
infrastructure templates are named for exploration:

- `discovery` — the flagship example template (a data core: storage and a SQL server). Used wherever a single example template is enough.
- `expedition` — a slotted, per-customer example template, for illustrations that need per-customer slots on top of the core.
- `survey` — a lightweight example template (a smaller shape), for showing the minimal case, e.g. in the add-a-template tutorial.

Each derives a distinct `short_name` (`disco`, `exped`, `surve`), so multi-template illustrations read cleanly and never collide.

### Why fictional, themed names

A real or client-derived name in an example is a liability: in a repository that may be published it leaks who the work was for, and it
dates the material as products and customers change. Obviously-fictional names avoid both. Keeping them on a single theme also makes them
recognisable _as_ placeholders — a reader who sees `discovery` / `expedition` knows immediately these are illustrative, not a real
deployment. Fictional companies reuse Microsoft's canonical Contoso and Globex for the same reason.

## Decision

Documentation examples use fictional, theme-consistent names: the discovery family for example infrastructure templates, Contoso and Globex
for fictional companies. Real, customer, and internal-project names never appear in examples. Test fixtures are free to use their own
neutral fixture names (for example `sample-customer`); this ADR governs prose, tutorials, and comment-based-help examples under `docs/` and
in function help.

## Consequences

- Examples read as one coherent story and are instantly recognisable as illustrative, not real.
- Publishing the repository leaks no customer or project identity through example material.
- A new example reaches for the discovery family first; adding a fourth example name extends the same exploration vocabulary rather than
  inventing an unrelated token.
