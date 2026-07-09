# ADR: DORA — Empowering teams to choose tools

## Rules: ADR-DORAECT

### Rule ADR-DORAECT:1

Tool choice is delegated, not mandated and not unconstrained. A team picks the languages, libraries, and tools that fit how it works and
what it builds, within an organization-wide baseline that exists to bound sprawl, not to override the team's judgment.

- [Summary](#summary)

### Rule ADR-DORAECT:2

The baseline is set by cross-functional representatives — covering languages, libraries, testing, deployment, monitoring, and data backends
— and revisited periodically, in retrospectives or an equivalent forum, so it reflects how teams actually work rather than a decision frozen
at one point in time.

- [How to apply](#how-to-apply)

### Rule ADR-DORAECT:3

A team that needs a tool outside the baseline follows a documented exception process: the tool and the reason for it are written down, so
the choice is discoverable for troubleshooting and can inform a future baseline revision, rather than living only in one team's head.

- [How to apply](#how-to-apply)

### Rule ADR-DORAECT:4

Empowerment is measured by asking teams whether they feel empowered to choose their tools, not by counting the number of tools in use or how
often they change — neither count distinguishes a genuine choice from a mandate or from directionless sprawl.

- [Common pitfalls](#common-pitfalls)

## Context

Empowering teams to choose tools sits among DORA's cultural and organizational capabilities, alongside capabilities like loosely coupled
teams and platform engineering that also shape how much autonomy a team has over its own work. DORA frames the capability as teams making
"informed choices about the tools and technologies they use to do their work," and its research ties that autonomy to both software delivery
performance and job satisfaction.[^1]

The capability sits between two failure modes DORA calls out directly: an organization that mandates every tool, and one that lets tool
choice run unconstrained. Neither extreme is the goal; the capability is the deliberate middle ground — a baseline that most teams use by
default, with a real, documented path to deviate from it when a team's work genuinely needs something different.

## Summary

DORA's research shows that teams which can choose their own tools make those choices based on how they work and the tasks they need to
perform, and that this improves both software delivery performance and job satisfaction. The effect compounds when it is combined with other
capabilities — visibility into how the system behaves, rapid feedback, and teams being accountable for the code they own — because those
capabilities give a team the information it needs to make a wise tool choice rather than an arbitrary one.

DORA's implementation guidance is concrete: establish baseline tooling through cross-functional representatives, review that baseline
periodically, and define an exception process for tools outside it. Google and Netflix are DORA's examples of organizations that support a
preferred stack while still permitting exceptions when a team accepts the support responsibility that comes with deviating from it.

## Why it matters

The mechanism is fit between a team's tools and its actual work. A team closest to a task is best placed to judge which tool serves it —
imposing a single toolset onto every team optimizes for uniformity instead of fit, and the mismatch shows up as friction the team absorbs on
every task the tool is wrong for. DORA's research finds this autonomy predicts both delivery performance and job satisfaction, which is the
expected result of removing a recurring, avoidable source of friction from a team's daily work.

The same mechanism explains why the capability is bounded rather than unlimited. Autonomy without any shared baseline shifts the cost
elsewhere: a proliferation of one-off tools becomes technical debt, fragility, and rising maintenance cost that can outweigh whatever the
new tool gained. The baseline-plus-exception shape is what keeps the benefit of fit without paying for uncoordinated sprawl.

## How to apply

catzc is itself an internal platform in the Team Topologies sense — a product a platform team develops and manages for the teams that build
on it ([thin-platforms](../design/thin-platforms.md)) — and DORA's baseline-tooling guidance describes exactly what that platform maintains:
a pinned, reviewed set of tools (`tools.yml`) that most consumers use by default, with the platform surfacing the vendor decisions behind it
rather than hiding them.

The devbox-version lever in [controlling-systemwide-deps](../automation/controlling-systemwide-deps.md) is the closest analog to DORA's
exception process: outside a pipeline, a tool may run at a declared `devbox_version` instead of the locked baseline version, a bounded,
declared deviation rather than an ungoverned one — while a pipeline run always enforces the locked baseline, so the exception never weakens
what actually ships. Reviewing and re-pinning `tools.yml` itself is the periodic-review half of the guidance: a version change is a pull
request, not a standing debate.

## Common pitfalls

- **Mandating every tool.** Forcing one toolset onto every team removes the fit between a team and its work, and limits the experimentation
  and growth that comes from a team trying an approach better suited to what it builds.

- **Unconstrained tool choice.** Letting every team pick freely with no baseline and no visibility produces one-off tools nobody else can
  support, rising technical debt, and fragility that can outweigh whatever the new tool gained — the opposite extreme from mandating.

- **Measuring the wrong signal.** Counting how many tools are in use, or how often teams change them, cannot tell a genuine choice apart
  from a mandate or from directionless sprawl; the only reliable signal is asking teams whether they feel empowered to choose.

## References

[^1]:
    DORA, _Empowering teams to choose tools_ capability, <https://dora.dev/capabilities/teams-empowered-to-choose-tools/>. Part of the DORA
    Core Model of capabilities that predict software delivery performance.

## Dora explains

DORA ties this capability to both software delivery performance and job satisfaction: a team with the freedom to fit its tools to its work
carries less avoidable friction, and that shows up in how the team performs and how the team feels about its work.

- [Loosely coupled teams](https://dora.dev/capabilities/loosely-coupled-teams/) — a team that can choose its own tools also needs the
  autonomy to change its own systems without waiting on another team.

- [Platform engineering](https://dora.dev/capabilities/platform-engineering/) — an internal platform is where an organization's baseline
  tooling and its exception process actually live.

- [Job satisfaction](https://dora.dev/capabilities/job-satisfaction/) — DORA's research links this capability to job satisfaction directly,
  alongside delivery performance.

- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
