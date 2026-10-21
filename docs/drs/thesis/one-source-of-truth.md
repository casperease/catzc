# Thesis: One source of truth — delivery collapsed into one repository with one change process

## Rules: TDR-ONETRUTH

### Rule TDR-ONETRUTH-ONESTOREDECIDES

A **source of truth** is the one store whose content decides what is true about the delivered system. Delivery is slow because that truth is
spread across disjoint stores that drift apart: servers, databases, CMDBs, deployment engines, ticket systems, requirement databases.
Catzc's answer is one source of truth, the repository, with one simple, fast, and robust change process for everything in it, never
synchronisation between stores inside its responsibility domain.

- [The problem](#the-problem)
- [One source of truth, one change process](#one-source-of-truth-one-change-process)

### Rule TDR-ONETRUTH-REPOSITORYISCONFIGURATIONRECORD

The repository is the configuration record of everything it delivers. Infrastructure is reproducible from a commit, so no second database is
kept in parity with it, and nothing about delivery state has its source of truth (for BVT) outside it. An **adjacent store** is the one
legitimate second store: a repository or service, such as a GitOps or configuration repository or Azure DevOps Services SaaS / GitHub SaaS,
that keeps its own history and is driven one way from the trunk's pipelines, never edited beside it.

- [The repository is the configuration record](#the-repository-is-the-configuration-record)
- [Adjacent stores](#adjacent-stores)

### Rule TDR-ONETRUTH-TRUTHISQUERYABLE

The source of truth is queryable: every question about the system's state is answered by reading the repository through the tooling. The
**query surface** is the tooling's `Get-*` cmdlets, each of which also emits its answer as data (JSON), so a service-management tool reads
the truth without PowerShell.

- [The truth is queryable](#the-truth-is-queryable)

### Rule TDR-ONETRUTH-PRODUCTMONOREPOSITORY

A **product mono-repository** is one repository that several teams contribute to for one product, bounded into tracks and deployable-units
by path filters; catzc is one. The **trunk** is its one mainline, and inside it everything is at HEAD: modules depend on each other
implicitly, at the current commit, with no internal version numbers, and a shared change lands in one commit with all its consumers.
Synchronisation happens only at the repository boundary, as a pin. A **pin** is an explicit version, controlled by the consumer, of a
dependency that crosses the repository boundary inward, stitched into an immutable artifact at build time.

- [Inside the trunk, only HEAD](#inside-the-trunk-only-head)
- [Pins at the repository boundary](#pins-at-the-repository-boundary)

### Rule TDR-ONETRUTH-NOREPOSITORYVERSION

There is no repository-wide version. A version exists only where something crosses the repository boundary, and each unit that crosses it
versions on its own. Catzc's one provided pin point is the whole bundle: a consumer either pins a released bundle or keeps its own clone of
catzc, a trunk of its own with its own history, and never consumes catzc implicitly across a repository boundary.

- [Versions only at the boundary](#versions-only-at-the-boundary)
- [Pin the bundle, or own a clone](#pin-the-bundle-or-own-a-clone)

### Rule TDR-ONETRUTH-PROCESSESFOLLOWDELIVERY

Service-management processes align to the delivery mechanism, never the reverse. Change management, approvals, audit, and higher-level
release processes read the repository and act through its one change process, instead of keeping a separate model of delivery.

- [Service management follows delivery](#service-management-follows-delivery)

## Context

### The problem

Delivery is slow mainly because of a distributed-systems problem, not because building or deploying is hard. The truth about a system is
spread across many disjoint stores: servers, databases, CMDBs, deployment engines, ticket systems, and requirement databases. Each holds
part of reality, and they drift apart. Teams spend their effort rebuilding a picture of reality from stores that were never designed to
agree, losing parity between them and the view of the whole.

Managing that distributed system of information better keeps the problem: every store needs a synchronisation path to every other, and each
path is one more way to drift. The thesis is to remove the problem instead.

### What catzc is for

Catzc is tooling, a cmdlet and CLI tool, that controls every aspect of software and infrastructure delivery as code: delivery, DevOps,
infrastructure as code, architecture, and test constructs, through one command surface. Its purpose is to simplify software and
infrastructure delivery. Every other decision record serves that purpose, and this one states how catzc achieves it.

### Where the repository model comes from

The repository taxonomy (a product mono-repository, a trunk, adjacent stores) and the pin-and-stitch model at the repository boundary are
ideas from the sibling repository `eac`, read for inspiration. They are rebuilt here to catzc's rules, and this TDR decides them.

## Decision

Collapse the distributed system of information into one source of truth, the repository, and give it one change process.

### One source of truth, one change process

Everything delivery touches is code in the repository. Changing anything and delivering it are the same motion: a reviewed commit, with its
diff and its history, integrated into the trunk and delivered by its pipelines. That is what keeps the trunk always releasable, which is
continuous delivery as the DORA research defines it ([continuous-delivery](../research/continuous-delivery.md)) and as catzc's flow model
implements it. The thesis describes the product; the research is the authority it rests on. Audit and retrospection are answered once, by
the history.

The one source of truth covers the responsibility domain the repository holds. Outside it, the stores catzc does not own are truth stores of
other kinds ([TDR-STORES](truth-stores.md)).

### The repository is the configuration record

The code takes the place of the CMDBs. Infrastructure is reproducible from a commit, so the repository is the configuration record in its
totality, and no second database has to be kept in parity with it. The principle of everything as code holds the mechanics: every artifact
lives in version control, what can be diffed belongs there, and no configuration or operational state has its source of truth outside it.

### Adjacent stores

An adjacent store keeps its own history, but nobody edits it beside the trunk: the trunk's pipelines drive it, one way. It is a projection
of the truth, never a second record of it, so it adds no synchronisation path back. Catzc's adjacent store is the Azure DevOps
configuration: its approvals, build validations, pipeline definitions, and variables are declared in the repository and driven from the
trunk, so its history is the trunk that drives it. The rule allows another where a consumer such as a GitOps controller needs its own
repository.

### The truth is queryable

A store that cannot answer questions sends people back to the other stores. The repository answers through the tooling: the `Get-*` cmdlets
read it and return typed answers, and each can emit them as JSON, so a service-management tool reads the truth without running PowerShell.
No second database is built to answer queries.

### Inside the trunk, only HEAD

Inside the trunk there is no synchronisation. A module depends on another at the current commit, with no internal version number, so a
shared change and all its consumers land atomically in one commit. The principle of one living version is this rule seen from inside the
trunk. The tracks and deployable-units that bound a product mono-repository are path filters over the one tree, not separate histories.

### Pins at the repository boundary

Synchronisation exists in one place, the repository boundary, and in one form, a pin. A dependency that crosses the boundary inward is
pinned to an explicit version the consumer controls: tool versions in `tools.yml`, vendored modules in `pwsh/.vendor/`, and depended-on
contracts. It is then stitched into an immutable artifact at build time: the bundle and the release candidate.

### Versions only at the boundary

A product mono-repository is not a monolithic application. A version exists only where something crosses the repository boundary, and each
crossing unit versions on its own; nothing versions the repository as a whole.

### Pin the bundle, or own a clone

The bundle is catzc's one provided pin point, so what catzc provides versions with the bundle. A consumer chooses one of two shapes:

- **Pin.** Another trunk installs a released bundle (`Export-Catzc -Root <dir>` places it under `<dir>/.vendor/Catzc/<version>/`) and pins
  its version.
- **Clone.** A consumer that needs to change catzc keeps its own clone, a trunk of its own with its own history.

Consuming catzc implicitly across a repository boundary, at whatever commit happens to be current, is neither: it carries the coupling of
one trunk without its atomic commits and the cost of a pin without its control.

### Service management follows delivery

Service management (change management, approvals, audit, and higher-level release processes) aligns to the real delivery mechanism. A change
record is the commit and its review; an approval is a step in the one change process; an audit reads the history through the query surface.
A process that keeps its own model of delivery recreates the disjoint store this TDR removes.

## Consequences

- Every other decision record rests on this one: the principles state its mechanics, and the later decision records specialise them.
- Delivery state whose source of truth is outside the repository is a defect, unless it is an adjacent store driven one way from the trunk,
  or a fact source that a state machine owns and catzc only reads ([TDR-STORES](truth-stores.md)).
- A question about the system's state has one place to be answered, and the tooling owes an answer to it, as cmdlets and as data.
- Versions appear only at the repository boundary: on pins inward, and on the bundle outward.
- A consumer of catzc pins the bundle or owns a clone; no implicit cross-repository consumption exists to support.
