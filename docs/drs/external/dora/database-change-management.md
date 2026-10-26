# EDR: DORA — Database change management

## Rules: EDR-DORA-DBCHANGE

### Rule EDR-DORA-DBCHANGE-VERSIONEDMIGRATIONS

Database changes are captured as migration scripts in version control and managed the same way as application code changes — not applied ad
hoc against a live schema outside the tracked history.

Source: [DORA, Database change management](../../../references/dora/capabilities.md#database-change-management)

Binds to [PDR-EAC-EVERYTHINGCOMMITTED](../../principles/everything-as-code.md#rule-pdr-eac-everythingcommitted).

### Rule EDR-DORA-DBCHANGE-SEQUENCEDSCRIPTS

Every migration is a uniquely sequenced script, and every database instance carries a record of which migrations have already run against
it, so the current schema state is always derivable and re-applying the set of migrations is safe.

Source: [DORA, Database change management](../../../references/dora/capabilities.md#database-change-management)

### Rule EDR-DORA-DBCHANGE-VISIBLEPENDINGCHANGES

Pending database changes are visible to, and discussed with, the people who own the production database before the change reaches it —
coordination happens ahead of the deployment, not as a late-stage escalation.

Source: [DORA, Database change management](../../../references/dora/capabilities.md#database-change-management)

### Rule EDR-DORA-DBCHANGE-EXPANDCONTRACT

A schema change that must not incur downtime adds new structures alongside the old ones and cuts traffic over later, rather than modifying
or deleting a live structure in place; the old and new structures coexist only until the cutover completes.

Source: [DORA, Database change management](../../../references/dora/capabilities.md#database-change-management)

Binds to [PDR-ONELIVE-BRANCHBYABSTRACTION](../../principles/one-living-version.md#rule-pdr-onelive-branchbyabstraction) and
[PDR-ONELIVE-NOCOMPATIBILITYSHIMS](../../principles/one-living-version.md#rule-pdr-onelive-nocompatibilityshims).

### Rule EDR-DORA-DBCHANGE-MEASUREDWORK

Database change work is measured, not treated as invisible overhead — the failure rate attributable to database issues, the lead time
database work adds, any scheduled downtime, and the proportion of changes that are fully automated are tracked toward a "push-button"
target.

Source: [DORA, Database change management](../../../references/dora/capabilities.md#database-change-management)

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

Database change management sits in the Core Model's fast-flow group and extends DORA's version-control and continuous-delivery findings to
the part of a system that is hardest to version and hardest to roll back: the schema and its data. DORA finds that integrating database work
into the delivery process contributes to continuous delivery, and through it to software delivery performance and availability.

- **Catalogue entry:** [Database change management](../../../references/dora/capabilities.md#database-change-management)
- **Category:** [Fast flow](../../../references/dora/capabilities.md#fast-flow) — Core Model v2.1.0:
  [fast flow](../../../references/dora/core-model.md#fast-flow).
- **Evidence:** the capability page cites no year; the catalogue attributes the finding to one report page:
  - [2018 Accelerate State of DevOps Report](../../../references/dora/publications.md#2018-accelerate-state-of-devops-report) — names
    database change management among the practices (with continuous testing, monitoring and observability, and early security integration)
    that are crucial.
- **Predicts:** [continuous delivery](../../../references/dora/capabilities.md#continuous-delivery), and through it
  [software delivery performance](../../../references/dora/core-model.md#software-delivery-performance) and availability (see
  [reliability](../../../references/dora/metrics.md#reliability)).
- **Related capabilities:**
  - [Version control](../../../references/dora/capabilities.md#version-control) — the versioning discipline database change management
    extends to schemas and migration scripts.
  - [Continuous delivery](../../../references/dora/capabilities.md#continuous-delivery) — the pipeline database changes must integrate into
    rather than bypass.
  - [Deployment automation](../../../references/dora/capabilities.md#deployment-automation) — the push-button automation target this
    capability's measurement points toward.
- [DORA research reference](../../../references/dora/index.md) — the overview these findings sit within.
