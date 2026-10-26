# Flow explanations

```text
How a change flows to production.

The promotion flow    one artifact is built once and climbs to production unchanged
The pipeline runner   a pipeline step only names a command a developer can run locally
Globset layers        peers in a layer never share a file, except loose-filesets
Globset roles         one ordered program; its three views are derived live
```

These articles explain decisions from the [flow decision-record domain](../../drs/index.md#flow): promotion, the pipeline runner, and the
globsets that decide which pipelines a change triggers. Each article narrates one diagram; the [explanation index](../index.md) says how to
read them.

## The promotion flow

One artifact is built once and climbs to production unchanged
([cd-discipline-and-promotion-flow](../../drs/flow/cd-discipline-and-promotion-flow.md)).

| Lens           | Article                                                                                                                 |
| -------------- | ----------------------------------------------------------------------------------------------------------------------- |
| meta           | [One artifact is built once and climbs to production unchanged](one-artifact-climbs-unchanged.md)                       |
| architecture   | [CI, CD and DEPLOY are separate pipeline kinds keyed together by one artifact](pipeline-kinds-keyed-by-one-artifact.md) |
| implementation | [The customer CD pipeline builds once, then deploys the prod tier itself](cd-builds-once-then-deploys-prod-itself.md)   |
| operations     | [A merge to main runs the CD pipeline all the way to prod, with no approval](a-merge-runs-cd-to-prod.md)                |
| governance     | [The CI budget is the only promotion rule a quality gate checks](ci-budget-is-the-only-quality-gate.md)                 |
| flow           | [A pwsh commit runs CI, is certified by CD, and deploy climbs the gated rungs](ci-pwsh-to-deploy-apex.md)               |

The manual queues of the promotion ladder ([manual-queues](../../drs/flow/manual-queues.md)), in ten slides:
[The manual queues of the promotion ladder, in ten slides](manual-queues-slides.md).

## The pipeline runner

A pipeline step only names a command that a developer can run locally
([pipeline-runner-pattern](../../drs/flow/pipeline-runner-pattern.md)).

- **meta**: [A pipeline step only names a command that a developer can run locally](a-step-only-names-a-command.md)
- **architecture**: [The runner is the only seam from pipeline YAML into PowerShell](the-runner-is-the-only-seam.md)
- **implementation**:
  [Three tasks share one guard, and one runner imports, traps, sanitizes and invokes](three-tasks-one-guard-one-runner.md)
- **operations**:
  [The Azure DevOps step is named after its command, and its log echoes the command before it runs](the-step-is-named-after-its-command.md)
- **governance**: [No gate checks the runner rules 1 or 4, and the step template breaks rule 3](no-gate-checks-rules-one-and-four.md)

## Globset layers

Peers in a layer never share a file, except in the loose-fileset layer ([durable-sha-globs](../../drs/flow/durable-sha-globs.md)).

- **meta**: [Peers in a layer never share a file, except in the loose-fileset layer](peers-in-a-layer-never-overlap.md)
- **architecture**: [Every globset carries one of three layers, and only two are declared](two-declared-layers-one-derived.md)
- **implementation**:
  [Test-GlobSetIndependence groups every set by layer and tests each same-layer pair](independence-check-groups-by-layer.md)
- **operations**: [Declare a unit or add a module folder, and the gate names every overlap](declare-or-add-folder-gate-names-overlaps.md)
- **governance**: [A gate checks overlap for units and modules, and loose-filesets are exempt](overlap-gated-for-units-and-modules.md)

## Globset roles

A globset is one ordered program, and its three views are derived live, never committed
([durable-sha-globs](../../drs/flow/durable-sha-globs.md)).

- **meta**:
  [A globset is one ordered program, and its three views are derived live, never committed](three-views-derived-live-from-one-program.md)
- **architecture**: [Catzc.Base.Globs computes every globset role from one typed registry](globs-module-owns-config-and-types.md)
- **implementation**: [One method, GlobSet.ScanProgram(), feeds all three globset role functions](one-scan-program-feeds-three-roles.md)
- **operations**: [You edit globs.yml, and every other step prints what cats derived from it](edit-globs-yml-then-read-the-output.md)
- **governance**:
  [Gates check the source of each globset and the trigger, but not the git reflection or the identity](gates-check-source-and-trigger.md)
