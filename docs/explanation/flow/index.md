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

| Lens           | Article                                                                                                           |
| -------------- | ----------------------------------------------------------------------------------------------------------------- |
| meta           | [How one artifact climbs to production](one-artifact-climbs-unchanged.md)                                         |
| architecture   | [How CI, CD and DEPLOY pipelines link](how-ci-cd-and-deploy-pipelines-link.md)                                    |
| implementation | [How the customer CD pipeline builds and deploys](how-the-customer-cd-pipeline-builds-and-deploys.md)             |
| operations     | [How a merge to main reaches non-prod](how-a-merge-to-main-reaches-non-prod.md)                                   |
| governance     | [What the quality gate checks on the way to production](what-the-quality-gate-checks-on-the-way-to-production.md) |
| flow           | [A pwsh commit runs CI, is certified by CD, and deploy climbs the gated rungs](ci-pwsh-to-deploy-apex.md)         |

The manual queues of the promotion ladder ([manual-queues](../../drs/flow/manual-queues.md)), in ten slides:
[The manual queues of the promotion ladder, in ten slides](manual-queues-slides.md).

## The pipeline runner

A pipeline step only names a command that a developer can run locally ([pipeline-runner-pattern](../../drs/ado/pipeline-runner-pattern.md)).

- **meta**: [How a pipeline step maps to a local command](how-a-pipeline-step-maps-to-a-local-command.md)
- **architecture**: [How pipeline YAML enters PowerShell](how-pipeline-yaml-enters-powershell.md)
- **implementation**: [What the three pipeline tasks share](what-the-three-pipeline-tasks-share.md)
- **operations**: [How an Azure DevOps step is named](how-an-azure-devops-step-is-named.md)
- **governance**: [Which runner rules no gate checks](no-gate-checks-rules-one-and-four.md)

## Globset layers

Peers in a layer never share a file, except in the loose-fileset layer ([durable-sha-globs](../../drs/flow/durable-sha-globs.md)).

- **meta**: [Which globsets may share a file](which-globsets-may-share-a-file.md)
- **architecture**: [Which globset layers are declared](two-declared-layers-one-derived.md)
- **implementation**: [How the independence check pairs globsets](independence-check-groups-by-layer.md)
- **operations**: [How a new unit or module folder is checked for overlap](how-a-new-unit-or-module-folder-is-checked-for-overlap.md)
- **governance**: [Which globsets the overlap gate covers](overlap-gated-for-units-and-modules.md)

## Globset roles

A globset is one ordered program, and its three views are derived live, never committed
([durable-sha-globs](../../drs/flow/durable-sha-globs.md)).

- **meta**: [How the three views of a globset are derived](how-the-three-views-of-a-globset-are-derived.md)
- **architecture**: [What the Globs module owns](what-the-globs-module-owns.md)
- **implementation**: [What the scan program feeds](one-scan-program-feeds-three-roles.md)
- **operations**: [How a globs.yml edit shows in the output](how-a-globs-yml-edit-shows-in-the-output.md)
- **governance**: [What the globset gates check](what-the-globset-gates-check.md)
