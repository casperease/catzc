# ADR: DORA — Code maintainability

## Rules: ADR-DORACM

### Rule ADR-DORACM:1

Keep the codebase reusable across team boundaries: it is easy for any team to find examples, reuse code another team owns, and propose a
change to code it does not maintain, without waiting on that team to act first.

- [Summary](#summary)

### Rule ADR-DORACM:2

Every dependency, internal or external, is traceable to an exact version and resolves the same way on every machine — traceability (which
version is in a given build) and reproducibility (the build process is deterministic) are the two properties dependency management exists to
serve.

- [Why it matters](#why-it-matters)

### Rule ADR-DORACM:3

Treat dependency upgrades as a routine, automated activity, not a rare, manual one: run continuous integration and testing against
dependency changes, and keep a fast, low-friction path to pull in a new version.

- [How to apply](#how-to-apply)

### Rule ADR-DORACM:4

Comprehensive dependency management is the scope, not partial coverage — code that is searchable and reusable but whose dependencies drift
unpatched and unversioned is only partly maintainable, and the untracked dependency is where the next vulnerability surfaces.

- [Common pitfalls](#common-pitfalls)

### Rule ADR-DORACM:5

Apply one consistent dependency-management approach across the organization rather than leaving it to team-by-team discretion — a uniform,
declared strategy is what keeps dependencies traceable and upgrades tractable at scale.

- [Common pitfalls](#common-pitfalls)

## Context

Code maintainability sits alongside version control among DORA's technical capabilities: it assumes a shared, versioned codebase and extends
it with the further question of whether that codebase, and everything it depends on, stays easy to find, reuse, and change over time. DORA
defines the capability as the team's ability "to efficiently find, reuse, and modify code across the organization's codebase," spanning both
the discoverability of the code itself and the health of what it depends on.

It sits in the DORA Core Model as a predictor of software delivery performance: teams that can reach and change any part of the codebase,
and whose dependencies stay current and traceable, deliver faster and recover from incidents more quickly. A codebase that is fragmented
across inaccessible repositories, or that carries dependencies nobody can trace back to a version, resists exactly the kind of change
continuous delivery depends on.

## Summary

The capability has three parts. It is easy for a team to find examples in the codebase, reuse other teams' code, and change code maintained
by another team. It is easy for a team to add a new dependency to its project and to migrate to a new version of one it already has. And a
team's dependencies are stable and rarely break its code.

DORA ties four benefits to this: faster delivery, because teams that can see and change one another's code have fewer cross-team blockers;
higher stability, because refactoring and incident response often require touching multiple parts of the codebase at once; better security,
because current dependencies carry fewer undiscovered vulnerabilities than aging ones; and higher code quality, because an accessible
codebase can be maintained and improved organization-wide rather than team by team.

## Why it matters

The mechanism runs through visibility and traceability. When any team can search the whole codebase, propose a change through a pull
request, and see who owns what, a cross-team dependency stops being a blocker and becomes a change like any other. When every dependency can
be traced back from a deployed artifact to the exact version in use, and the build that assembled it is deterministic, an incident response
or a security patch is a lookup rather than an investigation.

Without that traceability, dependency age becomes risk that accumulates silently: the longer a dependency goes unexamined, the more likely a
vulnerability has been discovered in it since it was pulled in, and the harder it is to know which of the organization's systems are
exposed. Code maintainability is what keeps both the codebase and its dependency tree legible enough that speed and safety do not trade off
against each other.

## How to apply

This platform realizes the source-code half of the capability through the mono-repo itself: every module lives in one searchable repository,
and the audited server remote ([ADR-REMOTE](../design/server-remote-integration.md)) is the single place a pull request can propose a change
to code another team maintains.

The dependency half is realized through explicit, checked-in declaration rather than ambient install state. Internal module edges are
declared once and gated against the code so the graph stays acyclic and legible
([ADR-MODDEPS](../automation/controlling-module-dependencies.md)). Internal dependencies are vendored into the repository so loading is a
path read with no network call and no version drift, and an upgrade is a deliberate, reviewed diff
([ADR-VENDOR](../automation/powershell/vendor-toolset-dependencies.md)). External dependencies are pulled at build time through the package
manager suited to that dependency, chosen for the security and traceability of its supply chain rather than convenience
([ADR-PKGMGR](../automation/use-proper-package-managers.md)). Together these keep every dependency, internal or external, traceable from a
build back to an exact, pinned version.

Measuring the capability follows the same three concerns DORA highlights: how much of the codebase is searchable and how much is duplicate
or dead; how long it takes to land a change in code the requesting team does not own; and how many distinct versions of a given library are
running in production, and how long it takes a known vulnerability to be patched everywhere it appears.

## Common pitfalls

- **Fragmented or restricted repositories.** Multiple version control repositories, or repositories with restrictive access settings, defeat
  searchability and make cross-team reuse a special request instead of a pull request.
- **No path to change code you do not own.** Lacking a pull-request mechanism for code outside a team's direct write access turns every
  cross-team change into a blocker on someone else's queue.
- **Under-resourced or inconsistent dependency management.** Treating dependency upgrades as occasional manual work, or letting each team
  pick its own approach, leaves version distribution wide and vulnerability exposure impossible to see across the organization.

## References

[^1]:
    DORA, _Code maintainability_ capability, <https://dora.dev/capabilities/code-maintainability/>. Part of the DORA Core Model of
    capabilities that predict software delivery performance.

## Dora explains

Code maintainability compounds DORA's delivery metrics: a codebase any team can search and safely change, backed by dependencies that are
traceable to an exact version, is what lets change lead time stay short and delivery stay frequent without trading away stability.

- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — depends on a codebase and dependency tree that any team can
  safely and quickly change.
- [Test automation](https://dora.dev/capabilities/test-automation/) — the automated coverage that makes a dependency upgrade or a cross-team
  change safe to land quickly.
- [Loosely coupled teams](https://dora.dev/capabilities/loosely-coupled-teams/) — a searchable, reusable codebase is what lets teams work
  independently without blocking on each other's code.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
