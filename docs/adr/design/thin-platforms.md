# ADR: Thin platforms — an API/CLI abstraction over a vendor layer

## Rules: ADR-THINPLAT

### Rule ADR-THINPLAT:1

catzc is a **thin platform**: a single, reusable API/CLI abstraction over a vendor substrate — today Azure (the ARM control plane via Bicep,
and the account/control-plane surface via a curated az CLI). It standardizes _how_ the organization uses the vendor; it does not reimplement
the vendor. This is exactly the **platform** of Team Topologies — an internal product other teams build on — deliberately held to the
**Thinnest Viable Platform** (TVP): the smallest set of APIs, tooling, and docs that measurably accelerates the teams delivering on it.

- [What "thin platform" means](#what-thin-platform-means)

### Rule ADR-THINPLAT:2

Thin is achieved by **delegation, not reimplementation**. The platform adds only what reduces a consumer's cognitive load, and delegates
everything else to the vendor's own primitives — Bicep for ARM templating, the az CLI for control-plane actions (`ADR-AZCLI`). It wraps to
_harmonize_ (one calling convention, one auth path, one set of defaults), never to hide the substrate or clone its behaviour. In Hohpe's
terms: build abstractions, not illusions — a thick wrapper that re-implements the cloud is a liability, not a platform.

- [Thin means delegation, not reimplementation](#thin-means-delegation-not-reimplementation)

### Rule ADR-THINPLAT:3

The consumable surface is a **CLI** — platform-as-a-CLI, offered X-as-a-Service. PowerShell `Verb-Noun` functions plus their configuration
_are_ the platform's API: a paved road with self-service defaults (`ADR-DEFAULT`). Consumers edit configuration and compose functions; they
never touch the vendor wiring. The CLI is the boundary that lets the platform team change the substrate underneath without breaking the
teams above.

- [The surface is a CLI](#the-surface-is-a-cli)

### Rule ADR-THINPLAT:4

Everything the platform covers is **represented as code** — the automation itself, the configs, the tooling versions, and the vendor
bindings (Bicep modules and az invocations) — in exactly one living version (`ADR-EAC`, `ADR-ONELIVE`). There is no console-clicked state,
no out-of-band tooling, and no drift between "what the docs say" and "what runs": the platform _is_ its repository. Full EaC representation
is what makes the thin abstraction reproducible and reviewable.

- [Everything the platform covers is code](#everything-the-platform-covers-is-code)

### Rule ADR-THINPLAT:5

The platform is a **product with a swappable substrate**, owned over its full lifecycle by the platform team whose job is to develop and
manage it (Team Topologies). It is reusable across consumers and CD pipelines, and the vendor layer sits _behind_ the CLI — Azure today,
another substrate later — without re-shaping the consumer's API. The abstraction stays honest: the decisions a consumer must own (cost,
region, scale, blast radius) are surfaced through configuration, not buried under a convenience default.

- [Owned as a product, over a swappable substrate](#owned-as-a-product-over-a-swappable-substrate)

## Context

An organization using a cloud vendor directly inherits the vendor's full surface: every team learns ARM's quirks, every pipeline re-derives
the same auth dance, and every deployment re-decides the same conventions. The opposite failure is just as expensive — a bespoke "cloud
framework" that wraps and re-implements the vendor, thick enough that it must be maintained in lock-step with a moving target it can never
fully cover.

The industry has a name for the middle path. Team Topologies frames the internal **platform** as a product built by a **platform team** that
treats other teams as customers and offers self-service capabilities to reduce their cognitive load — and prescribes keeping it to the
**Thinnest Viable Platform**, "the smallest set of APIs, documentation, and tools" that still accelerates delivery. Gregor Hohpe's _Platform
Strategy_ supplies the mechanism and its guardrail: platforms create leverage through **harmonization** and abstraction, but the abstraction
must expose the decisions that come back to bite (scale cost, regional latency) rather than paper over them — "build abstractions, not
illusions."

catzc is our implementation of that middle path: an **Everything-as-Code (EaC)** and **Continuous Delivery (CD)** platform, delivered as a
thin, reusable **platform-as-a-CLI**, currently covering Azure and Azure Resource Manager.

### What "thin platform" means

Thin is a measurement, not an aesthetic. The platform is thin when removing any part of it would slow a consumer down — and no thinner would
still leave them fighting the raw vendor. Concretely, catzc owns four things and nothing more: the **calling convention** (one CLI, one auth
model, one config-addressing scheme), the **conventions** over Azure (naming, layout, defaults), the **tooling contract** (pinned versions,
reproducible install), and the **vendor bindings** (which Bicep modules and which az commands, wired once). Everything a consumer wants to
_change_ is a config edit; everything they want to _add_ is a new template or test. The TVP test applies literally: if a wiki page would do,
we do not build a function.

### Thin means delegation, not reimplementation

The platform never re-implements what the vendor already does well. ARM templating is Bicep's job; the platform composes Bicep modules and
supplies their configuration, it does not generate ARM by hand. Control-plane and account actions are the az CLI's job; the platform curates
a pinned az surface and calls it (`ADR-AZCLI`), it does not reach for SDK assemblies to redo the same calls. What the platform _does_ own is
the harmonization layer on top: uniform invocation, a single authentication path (local token vs. pipeline identity resolved for you),
sensible zero-arg behaviour, and the guardrails that keep every call consistent. That is the line between a platform and a framework — a
platform makes the vendor easier to use correctly; a framework tries to replace it and inherits its entire maintenance surface.

### The surface is a CLI

The platform's API is its CLI: discoverable `Verb-Noun` functions, driven by declarative configuration. This is deliberate. A CLI is the
narrowest useful contract — it hides the substrate completely while staying scriptable, composable, and equally at home on a developer box
and in a pipeline (`ADR-PARITY`). Consumers get X-as-a-Service: they call `Get-Azure*`/`New-*` verbs and edit `azure.yml`/`options.yml`, and
the platform resolves, authenticates, and executes. Because the CLI is the only surface anyone binds to, the platform team is free to
re-wire what happens behind it — swap a Bicep module, change an az invocation, re-pin a tool — without touching a single consumer.

### Everything the platform covers is code

A thin abstraction is only trustworthy if it is fully materialized. Everything the platform touches is checked in and versioned as one
living source of truth (`ADR-EAC`, `ADR-ONELIVE`): the PowerShell/C# automation, the Bicep infrastructure, the per-target configuration, the
pinned tool versions, and the vendored dependencies. Nothing is configured by clicking a console, and nothing is a "we usually run this by
hand" step. This is what lets the thin layer stay thin without becoming lossy — the full representation is in the repo, so the abstraction
can be reproduced, reviewed, and diffed rather than trusted on faith.

### Owned as a product, over a swappable substrate

The platform is developed and managed as a product with a lifecycle, not a one-off scaffold — versioned, tested, and evolved on behalf of
its consumers by the platform team. Its value compounds because it is reusable: the same CLI backs every developer box and every CD
pipeline, and the same conventions apply to every Azure target. And because the vendor lives strictly behind the CLI, the substrate is
swappable in principle — Azure is the first covered vendor, not a hardwired assumption. The guardrail from Hohpe holds throughout: the
abstraction harmonizes the substrate but never hides the consequential choices. Cost, region, scale, and blast radius stay in the consumer's
configuration, where they belong.

## Decision

Build catzc as a **thin platform**: an API/CLI abstraction over a vendor layer (ADR-THINPLAT:1), kept thin by delegating to the vendor's own
primitives rather than reimplementing them (ADR-THINPLAT:2), consumed through a single CLI surface (ADR-THINPLAT:3), fully represented as
one living version of code (ADR-THINPLAT:4), and owned as a reusable product over a substrate that stays swappable behind the CLI
(ADR-THINPLAT:5). This is our implementation of the EaC and CD principles as a Team-Topologies platform, currently covering Azure and Azure
RM via Bicep plus a curated az CLI.

### How this holds together

- **Team Topologies** supplies the shape (a platform is an internal product; keep it to the Thinnest Viable Platform) and the ownership
  model (a platform team develops and manages it as X-as-a-Service).
- **Hohpe's _Platform Strategy_** supplies the discipline (harmonize, don't reimplement; build abstractions, not illusions) and the
  guardrail (surface the decisions that scale-time cost punishes).
- **`ADR-EAC` / `ADR-ONELIVE`** keep the abstraction fully materialized and singular — no drift, no legacy shims behind the thin layer.
- **`ADR-AZCLI` and the Bicep infrastructure track** are the concrete substrate bindings the CLI delegates to today.
- **`ADR-PARITY`** keeps the one CLI surface identical on a developer box and in the pipeline, which is what makes it a real service
  boundary.

## References

- Matthew Skelton & Manuel Pais, _Team Topologies_ — platform teams and the Thinnest Viable Platform (TVP):
  [What is a Thinnest Viable Platform (TVP)?](https://teamtopologies.com/key-concepts-content/what-is-a-thinnest-viable-platform-tvp)
- Gregor Hohpe, _Platform Strategy: Innovation Through Harmonization_ (Architect Elevator series):
  [The Architect Elevator](https://architectelevator.com) — platforms harmonize through abstraction; build abstractions, not illusions.

## Dora explains

DORA's research identifies flexible infrastructure and tool empowerment as drivers of team autonomy and delivery performance. Thin platforms
harmonize the vendor surface through a CLI abstraction, reducing cognitive load while keeping consequential decisions visible and delegating
to the vendor's own primitives.

- [Flexible infrastructure](https://dora.dev/capabilities/flexible-infrastructure/) — the thin abstraction keeps the vendor swappable behind
  the CLI.
- [Empowering teams to choose tools](https://dora.dev/capabilities/teams-empowered-to-choose-tools/) — the platform surfaces vendor
  decisions, not hiding them.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — delegation over reimplementation keeps the platform small
  and maintainable.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
