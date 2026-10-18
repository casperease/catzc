# ADR: Inspiration — read for ideas, never a reference implementation

## Rules: ADR-REPO-INSPIRE

### Rule ADR-REPO-INSPIRE-SIBLINGFORIDEAS

A sibling repository of the same project family, such as `eac`, may be read for ideas on every aspect of catzc: module and command design,
docs and ADR structure, contracts, testing, pipelines, and tooling. It is read only: nothing is written to it, and when it is absent the
work carries on without it.

- [Ideas from a sibling](#ideas-from-a-sibling)

### Rule ADR-REPO-INSPIRE-NEVERREFERENCE

An inspiration is never a reference implementation. Its structure and code are never copied as the answer, and it is never cited as an
authority for a catzc decision.

- [Not a reference implementation](#not-a-reference-implementation)

### Rule ADR-REPO-INSPIRE-CATZCADRSDECIDE

Catzc's ADRs decide. An idea from an inspiration is weighed against the domain rules of the aspect it touches, and the work says where the
idea came from. An idea in an area where catzc has made no decision, such as Go, opens a question for the user and is never a precedent.

- [The domain rules decide](#the-domain-rules-decide)

### Rule ADR-REPO-INSPIRE-REBUILTNOTPORTED

An idea that is taken is rebuilt here to catzc's rules, never ported alongside the catzc shape
([ADR-PRIN-ONELIVE](../principles/one-living-version.md)): catzc carries one living version of each behaviour.

- [Rebuilt, not ported](#rebuilt-not-ported)

### Rule ADR-REPO-INSPIRE-DECLAREDINSPIRATION

An **inspiration** is a sibling repository declared in `configs/inspiration.yml` of `Catzc.Tooling.Inspiration`, with its id, its root on
the workspace anchor, what it is, and the folders worth reading. `Get-Inspiration` lists the inspirations and reports whether each is
available on this machine; one that is absent is reported, never thrown on.

- [Declared, not described](#declared-not-described)

## Context

### Ideas from a sibling

Catzc has siblings in its project family. `eac` is a similar model built in Go, with its own modules, docs, ADRs, contracts, specs, tests,
and pipelines. A solution there to a problem catzc also has is worth reading, because it shortens the search for a good shape. A sibling is
not always checked out beside catzc, so nothing depends on it being present.

### Not a reference implementation

A sibling is built in another language, to its own rules, and at its own pace. Copying its structure imports decisions catzc never made, and
citing it as an authority puts a second set of rules beside the ADRs. Both turn an idea into an untested dependency on another repository.

### The domain rules decide

The ADRs are where catzc decides. An idea is a candidate, and the ADR of the aspect it touches judges it:

- **Module and command design:** [ADR-PWSH-ONEFUNC](../pwsh/one-function-per-file.md), [ADR-PWSH-PARAM](../pwsh/parameter-design.md), and
  the one resolution order of a setting,
  [ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder).
- **Docs and ADR structure:** the [authoring conventions](../index.md#authoring-conventions).
- **Contracts:** [ADR-REPO-CONTRACT](api-contracts.md).
- **Testing:** [ADR-AUTO-TEST](../automation/test-automation.md).
- **Pipelines:** [ADR-FLOW-CD](../flow/cd-discipline-and-promotion-flow.md) and [ADR-FLOW-CD-RUNNER](../flow/pipeline-runner-pattern.md).
- **Tooling:** [ADR-AUTO-PKGMGR](../automation/use-proper-package-managers.md) and [ADR-AUTO-UVPY](../automation/uv-python-handler.md).
- **Go:** [ADR-AUTO-GO](../automation/go/go-test-artifacts.md) — Go in catzc is test artifacts only, so a Go idea beyond that scope is a
  question for the user.

Saying where an idea came from keeps the reasoning reviewable: a reviewer sees that the shape was weighed, not assumed.

### Rebuilt, not ported

A ported copy beside the catzc shape is a second version of the same behaviour. Rebuilding the idea to catzc's rules keeps one living
version, so the idea lands as if catzc had always had it.

### Declared, not described

A path written into prose drifts and differs per machine. Declaring each inspiration in config, its root on the workspace anchor
([ADR-AUTO-PATH-WORKSPACEANCHOR](../automation/path-representation.md#rule-adr-auto-path-workspaceanchor)), gives one checked place to find
it, and reporting availability as a value keeps the work going on a machine where the sibling is absent.

## Decision

Sibling repositories are read for ideas and never treated as a reference implementation. Catzc's ADRs decide every aspect, an idea's origin
is stated, and an idea that is taken is rebuilt to catzc's rules.

### How this is enforced

- **`.claude/CLAUDE.md`** carries this policy in its `## Inspiration` section, so every session reads it before it reads a sibling.
- **`build-inspiration-module`**, the sub-agent that builds the inspiration module, rests on these rules in the agent registry
  ([agent-definitions](agent-definitions.md)), and `Test-AgentDefinitions` resolves its citations.
- Copying is caught where any second version is caught: by review against [ADR-PRIN-ONELIVE](../principles/one-living-version.md). No gate
  can tell an idea from a copy.
- **`InspirationConfig`** validates `inspiration.yml` on load, and **`Get-Inspiration`** reports each inspiration's availability.

## Consequences

- Catzc gains from a sibling's solutions without taking on its language, structure, or decisions.
- A sibling's absence costs nothing but the ideas: no check, build, or test depends on it.
- Each borrowed idea carries a note of its origin and passes through the same domain rules as any other change.
