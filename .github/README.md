---
catzc:
  immutable:
    with_body_sha: "2158970e7b9f"
    warning: "Do Not Edit, this file is generated"
---

# cats — the thin delivery platform

**One repository. One change process. Every delivery question answered from one commit.** cats turns software and infrastructure delivery
into code you can read, diff, review and query: pipelines, infrastructure, tooling, architecture decisions and tests, all behind one command
surface. In code the system is **catzc** (the `Catzc.*` modules, namespaces and types); to people it is **cats** — "ask cats".

[![CI][badge-1]](https://github.com/casperease/catzc/actions/workflows/ci-pwsh.yml) [![thesis][badge-2]](#the-thesis)
[![design][badge-3]](#a-thin-platform-not-a-framework) [![grounded in][badge-4]](#grounded-in-dora) [![get][badge-5]](#get-started)

[badge-1]: https://github.com/casperease/catzc/actions/workflows/ci-pwsh.yml/badge.svg
[badge-2]: https://img.shields.io/badge/thesis-one_source_of_truth-3b82f6?style=flat-square
[badge-3]: https://img.shields.io/badge/design-thinnest_viable_platform-8b5cf6?style=flat-square
[badge-4]: https://img.shields.io/badge/grounded_in-DORA-22c55e?style=flat-square
[badge-5]: https://img.shields.io/badge/get-started-f97316?style=flat-square

---

## Contents

- [The problem](#the-problem)
- [The thesis](#the-thesis)
- [The transformation](#the-transformation)
- [A thin platform, not a framework](#a-thin-platform-not-a-framework)
- [Zero ceremony, hard to fail](#zero-ceremony-hard-to-fail)
- [The principles](#the-principles)
- [Built for humans and agents](#built-for-humans-and-agents)
- [Grounded in DORA](#grounded-in-dora)
- [Get started](#get-started)
- [Learn more](#learn-more)

---

## The problem

Delivery is slow mainly because of a distributed-systems problem, not because building or deploying is hard. The truth about a system is
spread across stores that were never designed to agree: servers, CMDBs, deployment engines, ticket systems, requirement databases. Each
holds part of reality, and they drift. Teams spend their effort rebuilding a picture of the whole — and every synchronisation path between
stores is one more way to drift.

cats does not manage that distributed system better. **It removes it.**

[Read the problem statement →](../docs/drs/thesis/one-source-of-truth.md#the-problem)

---

## The thesis

Each claim is a thesis record, and each row is its first rule, read from the record itself.

| Record                                                                                                                                | Rule                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| ------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [One source of truth — delivery collapsed into one repository with one change process](../docs/drs/thesis/one-source-of-truth.md)     | A **source of truth** is the one store whose content decides what is true about the delivered system.                                                                                                                                                                                                                                                                                                                                           |
| [Truth stores — repositories, fact sources, and state machines, reconciled into actionable facts](../docs/drs/thesis/truth-stores.md) | A **truth store** is any store that holds part of the truth about a delivered system.                                                                                                                                                                                                                                                                                                                                                           |
| [Eac normal form — any code, verifiable within the repository's enabling constraints](../docs/drs/thesis/eac-normal-form.md)          | Everything inside a responsibility domain is code, managed through the one change process ([Truth stores — repositories, fact sources, and state machines, reconciled into actionable facts](../docs/drs/thesis/truth-stores.md#rule-tdr-stores-responsibilitydomain), [One source of truth — delivery collapsed into one repository with one change process](../docs/drs/thesis/one-source-of-truth.md#rule-tdr-onetruth-repositoryisrecord)). |
| [Closed loop — deterministic AI for experimental DevOps on one trunk](../docs/drs/thesis/closed-loop.md)                              | Catzc is deterministic AI for closed-loop experimental DevOps: a digital twin platform builds quality in through checks, tests and gates, while an orchestrated three-phase continuous flow carries changes authored by users alongside agentic actors into one trunk-based truth store holding everything as code plus configuration (EaC), auditable, sustainable, mappable.                                                                  |

---

## The transformation

| Before                                   | With cats                                              |
| ---------------------------------------- | ------------------------------------------------------ |
| ~~A CMDB kept in parity by hand~~        | **The repository is the record**                       |
| ~~Wiki pages that drift from what runs~~ | **Docs and READMEs generated from one source**         |
| ~~Manual checklists before release~~     | **Gates and asserts that fail fast**                   |
| ~~Approvals in a separate system~~       | **Approvals as config, driven one way from the trunk** |
| ~~Audit spreadsheets~~                   | **Git history, read through the query surface**        |
| ~~"Works on my machine"~~                | **Devbox and pipeline run the same commands**          |
| ~~Internal version matrices~~            | **Everything at HEAD; versions only at the boundary**  |

Service management follows delivery, never the reverse: a change record is the commit and its review
([processes follow delivery](../docs/drs/thesis/one-source-of-truth.md#rule-tdr-onetruth-processesfollowdelivery)).

---

## A thin platform, not a framework

cats is the **Thinnest Viable Platform** of Team Topologies: a reusable command-line surface over a vendor substrate. It standardises _how_
the organisation uses the vendor — it never reimplements it
([an abstraction over the vendor, not a copy of it](../docs/drs/design/thin-platforms.md)).

- **Delegate, don't reimplement** — Bicep does ARM templating, the az CLI does the control plane; cats harmonises one calling convention,
  one auth path and one set of defaults on top. _Abstractions, not illusions._
- **The platform is a CLI** — `Verb-Noun` commands plus configuration _are_ the API. Consumers edit config and compose commands; they never
  touch the vendor wiring.
- **Everything is code** — automation, configs, pinned tool versions, vendored dependencies and vendor bindings, in one living version
  ([no legacy, no back-compat, history in git](../docs/drs/principles/one-living-version.md)).
- **Swappable substrate** — the vendor sits behind the CLI; the consequential choices (cost, region, scale, blast radius) stay visible in
  configuration.
- **Safe self-service** — consumers provision through the repository, and every delivery travels as one immutable artifact
  ([consumers provision themselves](../docs/drs/design/self-service.md)).

---

## Zero ceremony, hard to fail

**Drop a file, get a command.** No manifests, no installers, no registration: a folder is a module, a file is a function, and its location
decides whether it is public. Every choice is judged against two questions — _does this add ceremony?_ and _can the author get this wrong?_
([zero ceremony, hard to fail](../docs/drs/automation/zero-ceremony-poka-yoke.md)).

Self-contained by design: vendored dependencies, no network calls at import, the same commands on a devbox and in a pipeline
([the devbox and the pipeline are one environment](../docs/drs/automation/devbox-pipeline-parity.md)).

---

## The principles

The design axioms every other decision cites, each with its first rule.

| Record                                                                                                                              | Rule                                                                                                                                                                                                                                                                                                                                                                         |
| ----------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [Everything as code](../docs/drs/principles/everything-as-code.md)                                                                  | Every artifact required to build, test, deploy, or operate the system lives in version control — application code, infrastructure, pipelines, environment config, schemas/migrations, specs, tests, container/orchestration, networking/DNS, and governing docs.                                                                                                             |
| [Configure, don't program — one mechanism per kind, one config entry per instance](../docs/drs/principles/configure-not-program.md) | Behaviour that varies by instance — a language, a tool, a target, an environment, a file class — is a config entry.                                                                                                                                                                                                                                                          |
| [Reduce variability](../docs/drs/principles/reduce-variability.md)                                                                  | Reduce variability in processes, tooling, and artifacts so outcomes are predictable and deviations stand out — build/test/deploy through the same steps, the same tools and versions, and a uniform artifact structure.                                                                                                                                                      |
| [Reduce waste](../docs/drs/principles/reduce-waste.md)                                                                              | For any step, ask "could I deliver the same outcome without this step?" — if yes, the step is waste; eliminate it, or address the structural constraint that makes it necessary.                                                                                                                                                                                             |
| [Poka-yoke — make mistakes impossible](../docs/drs/principles/poka-yoke.md)                                                         | Prefer structural prevention — make the wrong thing impossible to express; derive behavior from convention (naming, placement, structure) so there is no separate registration to fall out of sync.                                                                                                                                                                          |
| [One living version — no legacy, no back-compat, history in git](../docs/drs/principles/one-living-version.md)                      | The codebase expresses exactly one version of every **internal** behaviour — the current one.                                                                                                                                                                                                                                                                                |
| [Cats and catzc](../docs/drs/principles/cats-and-catzc.md)                                                                          | **catzc** is the source-level name of the system: the `Catzc` token that opens every full module name, declared once as the `pwsh` track's module namespace rather than repeated in each module folder, the C# `Catzc.*` namespaces, the `Catzc.` type-accelerator prefix, and the literal product token in code, configuration keys, contract paths and precise references. |

---

## Built for humans and agents

The rigour that makes delivery auditable is exactly what an AI agent needs to contribute safely. Every rule in the repository is a decision
record with a citable code, every defined term has one meaning, and every gate is a command an agent can run and read.

- **Citable rules** — every decision carries a short code that resolves to the rule it names
  ([every decision record, by domain](../docs/drs/index.md)).
- **A controlled vocabulary** — one glossary, generated from the modules that own the terms ([glossary](../docs/drs/glossary.md)).
- **An agent contract** — what every agent reads first and may never do
  ([the contract every agent works under](../docs/drs/repository/ai-agent-contract.md)).
- **Bounded everywhere** — every wait has a limit, so neither a person nor an agent hangs on a call
  ([fail fast, and bound every wait](../docs/drs/automation/fail-fast-with-asserts.md)).

---

## Grounded in DORA

The DORA research is the authority cats rests on: continuous delivery, trunk-based development, small batches, test and deployment
automation, and platform engineering — each mapped to the decisions that implement it.

| Capability                                                                                | How cats answers it                                         |
| ----------------------------------------------------------------------------------------- | ----------------------------------------------------------- |
| [Continuous delivery](../docs/drs/external/dora/continuous-delivery.md)                   | One change process keeps the trunk always releasable        |
| [Trunk-based development](../docs/drs/external/dora/trunk-based-development.md)           | Everything at HEAD inside one product mono-repository       |
| [Platform engineering](../docs/drs/external/dora/platform-engineering.md)                 | A thin, self-service platform-as-a-CLI                      |
| [Streamlining change approval](../docs/drs/external/dora/streamlining-change-approval.md) | Approvals are a step in the one change process              |
| [Version control](../docs/drs/external/dora/version-control.md)                           | Every artifact, config and decision lives in the repository |

[Explore the DORA reference →](../docs/references/dora/index.md) · [Delivery metrics →](../docs/references/dora/metrics.md) ·
[Capabilities →](../docs/references/dora/capabilities.md)

---

## Get started

### Choose how you take cats

| Pin the bundle                                                                                  | Own a clone                                                          |
| ----------------------------------------------------------------------------------------------- | -------------------------------------------------------------------- |
| Your trunk installs a released bundle and pins its version. You get the platform; we evolve it. | You change cats itself, in a trunk of your own with its own history. |
| `Export-Catzc -Root <your-repo>` places it under `.vendor/Catzc/<version>/`                     | Clone this repository and work at HEAD                               |

There is no third way: consuming cats implicitly across a repository boundary carries the coupling of one trunk without its atomic commits
([pin the bundle, or own a clone](../docs/drs/thesis/one-source-of-truth.md#pin-the-bundle-or-own-a-clone)).

### Four steps to your first delivery

[![1 Import][s1]](#1-import) [![2 Ask][s2]](#2-ask-cats) [![3 Add][s3]](#3-add-a-deployable-unit)
[![4 Ship][s4]](#4-ship-through-the-pipeline)

[s1]: https://img.shields.io/badge/1-Import-22c55e?style=for-the-badge
[s2]: https://img.shields.io/badge/2-Ask_cats-3b82f6?style=for-the-badge
[s3]: https://img.shields.io/badge/3-Add-8b5cf6?style=for-the-badge
[s4]: https://img.shields.io/badge/4-Ship-f97316?style=for-the-badge

#### 1. Import

One line, about half a second, no install step, no network:

```powershell
. ./importer.ps1
```

#### 2. Ask cats

The repository answers questions about the system it delivers — no CMDB, no portal:

```powershell
Get-AzureCustomers                                # every customer the repository delivers to
Get-AzureEnvironment <environment> <subscription> # one environment, resolved from config
```

#### 3. Add a deployable unit

Declare what you deliver and the files that trigger it; drop in a template, and its pipeline follows:
[add a deployable unit](../docs/how-to/getting-started/automation/add-a-deployable-unit.md) ·
[add an infrastructure template](../docs/how-to/getting-started/automation/add-an-infrastructure-template.md).

#### 4. Ship through the pipeline

Commit. The pipeline runs the same commands you ran on your devbox ([runner pattern](../docs/drs/flow/pipeline-runner-pattern.md)), and the
commit climbs its lifecycle to production ([commit lifecycle](../docs/drs/flow/commit-lifecycle.md)).

[**Full getting-started guide →**](../docs/how-to/getting-started/automation/index.md) ·
[FAQ →](../docs/how-to/getting-started/automation/faq.md)

---

## Learn more

- **[Documentation home](../docs/index.md)** — where every section of the docs starts
- **[Explanation](../docs/explanation/index.md)** — why cats is shaped the way it is
- **[Decision records](../docs/drs/index.md)** — every rule, by domain, with its citation code
- **[Thesis](../docs/drs/thesis/one-source-of-truth.md)** — what cats is for, in one record
- **[Thin platforms](../docs/drs/design/thin-platforms.md)** — the platform design in one record

Licensed under the [LICENSE](../LICENSE) at the repository root.

---

**One commit. One truth. Always releasable.**
