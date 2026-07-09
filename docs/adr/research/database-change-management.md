# ADR: DORA — Database change management

## Rules: ADR-DORADCM

### Rule ADR-DORADCM:1

Database changes are captured as migration scripts in version control and managed the same way as application code changes — not applied ad
hoc against a live schema outside the tracked history.

- [Summary](#summary)

### Rule ADR-DORADCM:2

Every migration is a uniquely sequenced script, and every database instance carries a record of which migrations have already run against
it, so the current schema state is always derivable and re-applying the set of migrations is safe.

- [How to apply](#how-to-apply)

### Rule ADR-DORADCM:3

Pending database changes are visible to, and discussed with, the people who own the production database before the change reaches it —
coordination happens ahead of the deployment, not as a late-stage escalation.

- [Why it matters](#why-it-matters)

### Rule ADR-DORADCM:4

A schema change that must not incur downtime adds new structures alongside the old ones and cuts traffic over later, rather than modifying
or deleting a live structure in place; the old and new structures coexist only until the cutover completes.

- [Common pitfalls](#common-pitfalls)

### Rule ADR-DORADCM:5

Database change work is measured, not treated as invisible overhead — the failure rate attributable to database issues, the lead time
database work adds, any scheduled downtime, and the proportion of changes that are fully automated are tracked toward a "push-button"
target.

- [Summary](#summary)

## Context

Database change management sits alongside version control and continuous delivery in the DORA Core Model: it is the capability that keeps
schema and data changes from becoming the part of a deployment that cannot be automated, reviewed, or rolled back like everything else.
DORA's research finds that "integrating database work into the software delivery process positively contributes to continuous delivery," and
the foundational practice is that teams store "database changes as scripts in version control and manage these changes in the same way they
manage production application changes."[^1]

Database changes carry a risk profile that plain application code does not: a schema change is frequently harder to reverse than a code
deploy, and a database is frequently shared by more than one application. The capability exists to bring that risk under the same
disciplines — versioning, review, automation, and visibility — that already govern the rest of the delivery pipeline.

## Summary

The capability is treating database changes as first-class, versioned, delivery-pipeline artifacts rather than a manual side channel run by
a separate team on a separate schedule. Teams capture every change as a migration script kept in version control, under a unique sequence
number, using a migration tool (Flyway, Liquibase, Alembic, and others cover multiple languages and platforms). Each database instance keeps
a table recording which migrations have run against it, so the schema's current state is always known and reproducible.

Measurement closes the loop: the percentage of failed changes where a database issue contributed, how much database change work adds to
overall lead time, how much scheduled downtime it costs, and what proportion of changes are fully automated, "push-button" changes — a
proportion DORA's guidance points toward 100%.

## Why it matters

DORA's research associates comprehensive, automated database change management with the same delivery-performance gains that comprehensive
version control produces, for the same reason: when the change is versioned, reviewable, and repeatable, "database changes don't slow them
down or cause problems when they perform code deployments." The mechanism is coordination made structural rather than ad hoc — visibility
into pending changes lets the people who manage the production database catch a performance problem before it reaches production, rather
than after. Without that structure, database work becomes a bottleneck outside the pipeline's normal feedback loops: a change nobody
reviewed until deploy day, a migration nobody can safely re-run, a schema edit that forces a maintenance window because there was no other
way to make it safe.

## How to apply

This platform's general artifact-and-versioning discipline already covers the shape database change management asks for: every artifact
needed to build, test, deploy, or operate a system — explicitly including "database schemas and migration scripts" — lives in version
control ([ADR-EAC](../principles/everything-as-code.md)), so a migration script is diffed, reviewed, and rolled back exactly like any other
change. Where a schema change cannot land atomically — the zero-downtime case DORA describes as adding new structures alongside old ones —
the platform's branch-by-abstraction pattern is the sanctioned, temporary-coexistence route to it: a seam that lets old and new structures
coexist for a bounded migration window, with a built-in deletion plan, rather than an indefinite compatibility shim
([ADR-ONELIVE](../principles/one-living-version.md)). A database migration follows the same rule as every other contract change: it and its
callers move together, with no lingering dual-read fallback left behind once the cutover completes.

## Common pitfalls

- **Organizational silos.** DBAs working on a separate team with a separate process create friction and resistance around integrating
  database work into the delivery pipeline, rather than a shared, versioned practice.
- **Shared schemas across applications.** Multiple applications reading and writing the same schema need a coordinated migration approach;
  changing it in isolation for one consumer risks breaking the others.
- **Underestimating the architectural change.** Migration-based database change management and zero-downtime deployment together can demand
  significant architectural change — parallel change, data partitioning, or an event-sourced or NoSQL redesign — and treating it as a small
  add-on understates the work.
- **Leaving database work unmeasured.** Without tracking database-attributable failures, the lead time database work adds, and how much of
  it is automated, the capability has no feedback loop telling teams whether it is improving.

## References

[^1]:
    DORA, _Database change management_ capability, <https://dora.dev/capabilities/database-change-management/>. Part of the DORA Core Model
    of capabilities that predict software delivery performance.

## Dora explains

Database change management extends DORA's version-control and continuous-delivery findings to the part of a system that is hardest to
version and hardest to roll back: the schema and its data. Treating it as an automated, measured, pipeline-integrated practice removes one
of the most common bottlenecks between a versioned change and a safe production deployment.

- [Version control](https://dora.dev/capabilities/version-control/) — the versioning discipline database change management extends to
  schemas and migration scripts.
- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — the pipeline database changes must integrate into rather than
  bypass.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — the push-button automation target this capability's
  measurement points toward.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
