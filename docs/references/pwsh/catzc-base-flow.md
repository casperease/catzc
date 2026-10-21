# Catzc.Base.Flow

Owns the promotion ladder a commit climbs: the rungs in climbing order, each with the gate a commit clears to enter it and the configuration
environment it deploys ([FDR-CD-RUNGSREGISTRY](../../drs/flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-rungsregistry)), and
the truth stores the delivery reads, drives or reports to, each classified by its kind
([TDR-STORES-THREEKINDS](../../drs/thesis/truth-stores.md#rule-tdr-stores-threekinds)). It does not run a gate, deploy anything or
call a store; it is the data the pipelines and the registration code read.

## Responsibilities

| Responsibility   | Area   | Name                                                                     |
| ---------------- | ------ | ------------------------------------------------------------------------ |
| responsibility:1 | ladder | [The rungs registry](#responsibility1--the-rungs-registry)               |
| responsibility:2 | stores | [The truth-stores registry](#responsibility2--the-truth-stores-registry) |

### responsibility:1 — The rungs registry

The ladder is declared once, on the `RungsConfig` type, and a repository with its own ladder states it in the shipped `rungs.yml`. Each rung
names the gate a commit clears to enter it (none, rc, rbc or prod-approval) and the configuration environment it deploys; a unit's ADO
environment for a rung is `<unit>-<rung>`. The rungs come back in climbing order, so a caller that walks the ladder reads the order from the
registry rather than restating it.

### responsibility:2 — The truth-stores registry

Every truth store is one entry: its kind (a version-controlled repository, a fact source, or a state machine), the live URL it answers at,
the state machine that owns it, and, for a repository, its projections: the adjacent stores the trunk's pipelines drive one way. The
defaults on the `TruthStoresConfig` type name Azure DevOps twice, its configuration as the repository's projection and its runtime state as
a fact source the platform owns; a repository with other stores states them in the shipped `truth-stores.yml`. The stores come back as data,
so where truth lives is a query
([TDR-ONETRUTH-TRUTHISQUERYABLE](../../drs/thesis/one-source-of-truth.md#rule-tdr-onetruth-truthisqueryable)). The module also
owns the provided contracts of the facts the delivery emits: the actionable fact and the inbound and outbound junction messages.

## What the module does

It is the single place the ladder and the truth stores are read from. The pipeline types, the environment registration and the promotion
checks ask it for the rungs instead of naming them, so remapping a rung is a one-line edit in the registry; a command that reads or reports
to a store asks it for the store's kind before it touches it.

## Division

The module's public functions, sorted into the responsibilities above.

| Responsibility                               | Function           |
| -------------------------------------------- | ------------------ |
| responsibility:1 — The rungs registry        | `Get-Rung`         |
| config                                       | `rungs.yml`        |
| responsibility:2 — The truth-stores registry | `Get-TruthStore`   |
| config                                       | `truth-stores.yml` |
