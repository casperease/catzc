# Catzc.Base.Flow

Owns the promotion ladder a commit climbs: the rungs in climbing order, each with the gate a commit clears to enter it and the configuration
environment it deploys ([ADR-FLOW-CD-RUNGSREGISTRY](../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd-rungsregistry)). It
does not run a gate or deploy anything; it is the data the pipelines and the registration code read.

## Responsibilities

| Responsibility   | Area   | Name                                                       |
| ---------------- | ------ | ---------------------------------------------------------- |
| responsibility:1 | ladder | [The rungs registry](#responsibility1--the-rungs-registry) |

### responsibility:1 — The rungs registry

The ladder is declared once, on the `RungsConfig` type, and a repository with its own ladder states it in the shipped `rungs.yml`. Each rung
names the gate a commit clears to enter it (none, rc, rbc or prod-approval) and the configuration environment it deploys; a unit's ADO
environment for a rung is `<unit>-<rung>`. The rungs come back in climbing order, so a caller that walks the ladder reads the order from the
registry rather than restating it.

## What the module does

It is the single place the ladder is read from. The pipeline types, the environment registration and the promotion checks ask it for the
rungs instead of naming them, so remapping a rung is a one-line edit in the registry.

## Division

The module's public function, sorted into the responsibility above.

| Responsibility                        | Function   |
| ------------------------------------- | ---------- |
| responsibility:1 — The rungs registry | `Get-Rung` |
