# .ado/pipelines/stages/deploy-expedition.yaml

The expedition stage of a unit's one deploy path. Only `deploy-unit.yaml` includes it, as its last stage, so the CD and DEPLOY pipelines
still call one entry; it is a separate file only to keep `deploy-unit.yaml` under the config line limit, the one nesting level
[ADR-ADO-TEMPLATE-MINIMALNESTING](../../../../drs/ado/custom-template-discipline.md#rule-adr-ado-template-minimalnesting) allows.

## Parameters

- **`Unit`**, **`Expeditions`**, **`ArtifactPipeline`**, **`RunId`**, **`StageSuffix`**, **`CertifiedBy`**, **`RemoveOrphans`** — passed on
  unchanged from `deploy-unit.yaml`.
- **`DependsOn`** and **`Condition`** — resolved by `deploy-unit.yaml`: the discovery stage when it runs, else the foundation stage, each
  with `Condition`; with neither, the caller's `DependsOn` and `FirstCondition`.

## Job shape

Every expedition entry becomes one deployment job, `Expedition_<env>` or `Expedition_<env>_<slot>` for a slotted one: it checks out, asserts
the deployment history of `CertifiedBy` when set, downloads the `expedition` artifact, previews with `Deploy-Bicep -DryRun` and then
deploys, and with `RemoveOrphans` lists and then removes the orphans the deploy left.
