# cats — the thin delivery platform

**One repository. One change process. Every delivery question answered from one commit.**

cats turns software and infrastructure delivery into code you can read, diff, review and query: pipelines, infrastructure, tooling,
architecture decisions and tests, all behind one command surface. In code the system is **catzc** (the `Catzc.*` modules, namespaces and
types); to people it is **cats** — "ask cats" ([PDR-CATS](../docs/drs/principles/cats-and-catzc.md)).

[![CI][ci-badge]][ci]
[![Thesis][thesis-badge]](#the-thesis)
[![Thin platform][thin-badge]](#a-thin-platform-not-a-framework)
[![DORA][dora-badge]](#grounded-in-dora)
[![Get started][start-badge]](#get-started)

[ci-badge]: https://github.com/casperease/catzc/actions/workflows/ci-pwsh.yml/badge.svg
[ci]: https://github.com/casperease/catzc/actions/workflows/ci-pwsh.yml
[thesis-badge]: https://img.shields.io/badge/thesis-one_source_of_truth-3b82f6?style=flat-square
[thin-badge]: https://img.shields.io/badge/design-thinnest_viable_platform-8b5cf6?style=flat-square
[dora-badge]: https://img.shields.io/badge/grounded_in-DORA-22c55e?style=flat-square
[start-badge]: https://img.shields.io/badge/get-started-f97316?style=flat-square

---

## Contents

- [The problem](#the-problem)
- [The thesis](#the-thesis)
- [The transformation](#the-transformation)
- [A thin platform, not a framework](#a-thin-platform-not-a-framework)
- [Zero ceremony, hard to fail](#zero-ceremony-hard-to-fail)
- [Built for humans and agents](#built-for-humans-and-agents)
- [Grounded in DORA](#grounded-in-dora)
- [Get started](#get-started)
- [Learn more](#learn-more)

---

## The problem

Delivery is slow mainly because of a distributed-systems problem, not because building or deploying is hard. The truth about a system is
spread across stores that were never designed to agree: servers, CMDBs, deployment engines, ticket systems, requirement databases. Each holds
part of reality, and they drift. Teams spend their effort rebuilding a picture of the whole — and every synchronisation path between stores
is one more way to drift.

cats does not manage that distributed system better. **It removes it.**

[Read the problem statement →](../docs/drs/thesis/one-source-of-truth.md#the-problem)

---

## The thesis

| | |
| --- | --- |
| **One source of truth** | The repository is the configuration record of everything it delivers. Infrastructure is reproducible from a commit, so no second database is kept in parity with it ([TDR-ONETRUTH](../docs/drs/thesis/one-source-of-truth.md)). |
| **One change process** | Changing anything and delivering it are the same motion: a reviewed commit, integrated into the trunk and delivered by its pipelines. Audit is answered once, by the history. |
| **Queryable truth** | Every question about the system's state is answered by reading the repository through `Get-*` commands, each of which also answers as JSON. |
| **Truth stores, honestly bounded** | Outside the repository's responsibility domain, fact sources and state machines are read and reported to at junctions — never silently mirrored ([TDR-STORES](../docs/drs/thesis/truth-stores.md)). |
| **A normal form for any code** | Every piece of code, imported fragments included, has a normal form: verifiable within the defaults and uncontested by the formatters, tests and asserts ([TDR-NORMALFORM](../docs/drs/thesis/eac-normal-form.md)). |
| **A closed loop** | A deterministic platform with a three-phase flow, where experiments run on the trunk ([TDR-CLOSEDLOOP](../docs/drs/thesis/closed-loop.md)). |

---

## The transformation

| Before | With cats |
| --- | --- |
| ~~A CMDB kept in parity by hand~~ | **The repository is the record** |
| ~~Wiki pages that drift from what runs~~ | **Docs and READMEs generated from one source** |
| ~~Manual checklists before release~~ | **Gates and asserts that fail fast** |
| ~~Approvals in a separate system~~ | **Approvals as config, driven one way from the trunk** |
| ~~Audit spreadsheets~~ | **Git history, read through the query surface** |
| ~~"Works on my machine"~~ | **Devbox and pipeline run the same commands** |
| ~~Internal version matrices~~ | **Everything at HEAD; versions only at the boundary** |

Service management follows delivery, never the reverse: a change record is the commit and its review
([TDR-ONETRUTH-PROCESSESFOLLOWDELIVERY](../docs/drs/thesis/one-source-of-truth.md#rule-tdr-onetruth-processesfollowdelivery)).

---

## A thin platform, not a framework

cats is the **Thinnest Viable Platform** of Team Topologies: a reusable command-line surface over a vendor substrate. It standardises _how_
the organisation uses the vendor — it never reimplements it ([DDR-THINPLAT](../docs/drs/design/thin-platforms.md)).

- **Delegate, don't reimplement** — Bicep does ARM templating, the az CLI does the control plane; cats harmonises one calling convention,
  one auth path and one set of defaults on top. _Abstractions, not illusions._
- **The platform is a CLI** — `Verb-Noun` commands plus configuration _are_ the API. Consumers edit config and compose commands; they never
  touch the vendor wiring.
- **Everything is code** — automation, configs, pinned tool versions, vendored dependencies and vendor bindings, in one living version
  ([PDR-ONELIVE](../docs/drs/principles/one-living-version.md)).
- **Swappable substrate** — the vendor sits behind the CLI; the consequential choices (cost, region, scale, blast radius) stay visible in
  configuration.
- **Safe self-service** — consumers provision through the repository, and every delivery travels as one immutable artifact
  ([DDR-SELFSERV](../docs/drs/design/self-service.md)).

---

## Zero ceremony, hard to fail

**Drop a file, get a command.** No manifests, no installers, no registration: a folder is a module, a file is a function, and its location
decides whether it is public. Every choice is judged against two questions — _does this add ceremony?_ and _can the author get this wrong?_
([ADR-AUTO-ZERO](../docs/drs/automation/zero-ceremony-poka-yoke.md)).

| Principle | What it buys you |
| --- | --- |
| [Everything as code](../docs/drs/principles/everything-as-code.md) | What can be diffed lives in version control |
| [Configure, don't program](../docs/drs/principles/configure-not-program.md) | Per-instance behaviour is a config entry with a default declared once |
| [Reduce variability](../docs/drs/principles/reduce-variability.md) | One way to do each thing, so there is one way to learn it |
| [Reduce waste](../docs/drs/principles/reduce-waste.md) | Nothing built that a sensible default already answers |
| [Poka-yoke](../docs/drs/principles/poka-yoke.md) | Mistakes are made impossible, not merely documented |
| [One living version](../docs/drs/principles/one-living-version.md) | No shims, no legacy, no `*V2` — history lives in git |

Self-contained by design: vendored dependencies, no network calls at import, the same commands on a devbox and in a pipeline
([ADR-AUTO-PARITY](../docs/drs/automation/devbox-pipeline-parity.md)).

---

## Built for humans and agents

The rigour that makes delivery auditable is exactly what an AI agent needs to contribute safely. Every rule in the repository is a decision
record with a citable code, every defined term has one meaning, and every gate is a command an agent can run and read.

- **Citable rules** — every decision carries a code such as `ADR-PWSH-ERROR-THROWNOTWRITEERROR`, resolvable to its anchor
  ([DRS index](../docs/drs/index.md)).
- **A controlled vocabulary** — one glossary, generated from the modules that own the terms ([glossary](../docs/drs/glossary.md)).
- **An agent contract** — what every agent reads first and may never do ([ADR-REPO-AI](../docs/drs/repository/ai-agent-contract.md)).
- **Bounded everywhere** — every wait has a limit, so neither a person nor an agent hangs on a call
  ([ADR-AUTO-FAILFAST](../docs/drs/automation/fail-fast-with-asserts.md)).

---

## Grounded in DORA

The DORA research is the authority cats rests on: continuous delivery, trunk-based development, small batches, test and deployment
automation, and platform engineering — each mapped to the decisions that implement it.

| Capability | How cats answers it |
| --- | --- |
| [Continuous delivery](../docs/drs/external/dora/continuous-delivery.md) | One change process keeps the trunk always releasable |
| [Trunk-based development](../docs/drs/external/dora/trunk-based-development.md) | Everything at HEAD inside one product mono-repository |
| [Platform engineering](../docs/drs/external/dora/platform-engineering.md) | A thin, self-service platform-as-a-CLI |
| [Streamlining change approval](../docs/drs/external/dora/streamlining-change-approval.md) | Approvals are a step in the one change process |
| [Version control](../docs/drs/external/dora/version-control.md) | Every artifact, config and decision lives in the repository |

[Explore the DORA reference →](../docs/references/dora/index.md) ·
[Delivery metrics →](../docs/references/dora/metrics.md) ·
[Capabilities →](../docs/references/dora/capabilities.md)

---

## Get started

From the repository root (the importer is dot-sourced, so its state lands in your session):

| Context              | Command            |
| -------------------- | ------------------ |
| Interactive terminal | `.\importer.ps1`   |
| Inside a script      | `. ./importer.ps1` |

```powershell
. ./importer.ps1
trap { Write-Exception $_; break }

Assert-Command git
Write-Message 'Ready to go'
```

Every command from every module is available after import. Next steps:
[getting started](../docs/how-to/getting-started/automation/index.md) ·
[add a deployable unit](../docs/how-to/getting-started/automation/add-a-deployable-unit.md) ·
[add an infrastructure template](../docs/how-to/getting-started/automation/add-an-infrastructure-template.md) ·
[FAQ](../docs/how-to/getting-started/automation/faq.md)

---

## Learn more

| | |
| --- | --- |
| **[Documentation home](../docs/index.md)** | Where every section of the docs starts |
| **[Explanation](../docs/explanation/index.md)** | Why cats is shaped the way it is |
| **[Decision records](../docs/drs/index.md)** | Every rule, by domain, with its citation code |
| **[Thesis](../docs/drs/thesis/one-source-of-truth.md)** | What cats is for, in one record |
| **[Thin platforms](../docs/drs/design/thin-platforms.md)** | The platform design in one record |

**One commit. One truth. Always releasable.**

Licensed under the [LICENSE](../LICENSE) at the repository root.
