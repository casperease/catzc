---
catzc:
  derived:
    path: docs/explanation/flow/index.md
    kind: explanation
    language: markdown
    filetype: md
    track: docs
    body_sha: c91496ef0580
    links:
      - docs/adr/flow/cd-discipline-and-promotion-flow.md
      - docs/adr/flow/durable-sha-globs.md
      - docs/adr/flow/pipeline-runner-pattern.md
      - docs/adr/index.md#flow
      - docs/explanation/flow/a-merge-runs-cd-to-prod.md
      - docs/explanation/flow/a-step-only-names-a-command.md
      - docs/explanation/flow/cd-builds-once-then-deploys-prod-itself.md
      - docs/explanation/flow/ci-budget-is-the-only-quality-gate.md
      - docs/explanation/flow/declare-or-add-folder-gate-names-overlaps.md
      - docs/explanation/flow/edit-globs-yml-then-read-the-output.md
      - docs/explanation/flow/gates-check-source-and-trigger.md
      - docs/explanation/flow/globs-module-owns-config-and-types.md
      - docs/explanation/flow/independence-check-groups-by-layer.md
      - docs/explanation/flow/no-gate-checks-rules-one-and-four.md
      - docs/explanation/flow/one-artifact-climbs-unchanged.md
      - docs/explanation/flow/one-scan-program-feeds-three-roles.md
      - docs/explanation/flow/overlap-gated-for-units-and-modules.md
      - docs/explanation/flow/peers-in-a-layer-never-overlap.md
      - docs/explanation/flow/pipeline-kinds-keyed-by-one-artifact.md
      - docs/explanation/flow/the-runner-is-the-only-seam.md
      - docs/explanation/flow/the-step-is-named-after-its-command.md
      - docs/explanation/flow/three-tasks-one-guard-one-runner.md
      - docs/explanation/flow/three-views-derived-live-from-one-program.md
      - docs/explanation/flow/two-declared-layers-one-derived.md
      - docs/explanation/index.md
---

# Flow explanations

```text
How a change flows to production.

The promotion flow    one artifact is built once and climbs to production unchanged
The pipeline runner   a pipeline step only names a command a developer can run locally
Globset layers        peers in a layer never share a file, except loose-filesets
Globset roles         one ordered program; its three views are derived live
```

These articles explain decisions from the [flow ADR domain](../../adr/index.md#flow): promotion, the pipeline runner, and the globsets that
decide which pipelines a change triggers. Each article narrates one diagram; the [explanation index](../index.md) says how to read them.

## The promotion flow

One artifact is built once and climbs to production unchanged
([cd-discipline-and-promotion-flow](../../adr/flow/cd-discipline-and-promotion-flow.md)).

| Lens           | Article                                                                                                                 |
| -------------- | ----------------------------------------------------------------------------------------------------------------------- |
| meta           | [One artifact is built once and climbs to production unchanged](one-artifact-climbs-unchanged.md)                       |
| architecture   | [CI, CD and DEPLOY are separate pipeline kinds keyed together by one artifact](pipeline-kinds-keyed-by-one-artifact.md) |
| implementation | [The customer CD pipeline builds once, then deploys the prod tier itself](cd-builds-once-then-deploys-prod-itself.md)   |
| operations     | [A merge to main runs the CD pipeline all the way to prod, with no approval](a-merge-runs-cd-to-prod.md)                |
| governance     | [The CI budget is the only promotion rule a quality gate checks](ci-budget-is-the-only-quality-gate.md)                 |

## The pipeline runner

A pipeline step only names a command that a developer can run locally
([pipeline-runner-pattern](../../adr/flow/pipeline-runner-pattern.md)).

| Lens           | Article                                                                                                                                   |
| -------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| meta           | [A pipeline step only names a command that a developer can run locally](a-step-only-names-a-command.md)                                   |
| architecture   | [The runner is the only seam from pipeline YAML into PowerShell](the-runner-is-the-only-seam.md)                                          |
| implementation | [Three tasks share one guard, and one runner imports, traps, sanitizes and invokes](three-tasks-one-guard-one-runner.md)                  |
| operations     | [The Azure DevOps step is named after its command, and its log echoes the command before it runs](the-step-is-named-after-its-command.md) |
| governance     | [No gate checks the runner rules 1 or 4, and the step template breaks rule 3](no-gate-checks-rules-one-and-four.md)                       |

## Globset layers

Peers in a layer never share a file, except in the loose-fileset layer ([durable-sha-globs](../../adr/flow/durable-sha-globs.md)).

| Lens           | Article                                                                                                                    |
| -------------- | -------------------------------------------------------------------------------------------------------------------------- |
| meta           | [Peers in a layer never share a file, except in the loose-fileset layer](peers-in-a-layer-never-overlap.md)                |
| architecture   | [Every globset carries one of three layers, and only two are declared](two-declared-layers-one-derived.md)                 |
| implementation | [Test-GlobSetIndependence groups every set by layer and tests each same-layer pair](independence-check-groups-by-layer.md) |
| operations     | [Declare a unit or add a module folder, and the gate names every overlap](declare-or-add-folder-gate-names-overlaps.md)    |
| governance     | [A gate checks overlap for units and modules, and loose-filesets are exempt](overlap-gated-for-units-and-modules.md)       |

## Globset roles

A globset is one ordered program, and its three views are derived live, never committed
([durable-sha-globs](../../adr/flow/durable-sha-globs.md)).

| Lens           | Article                                                                                                                                 |
| -------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| meta           | [A globset is one ordered program, and its three views are derived live, never committed](three-views-derived-live-from-one-program.md) |
| architecture   | [Catzc.Base.Globs computes every globset role from one typed registry](globs-module-owns-config-and-types.md)                           |
| implementation | [One method, GlobSet.ScanProgram(), feeds all three globset role functions](one-scan-program-feeds-three-roles.md)                      |
| operations     | [You edit globs.yml, and every other step prints what cats derived from it](edit-globs-yml-then-read-the-output.md)                     |
| governance     | [Gates check the source of each globset and the trigger, but not the git reflection or the identity](gates-check-source-and-trigger.md) |
