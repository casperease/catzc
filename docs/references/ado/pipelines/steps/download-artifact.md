# .ado/pipelines/steps/download-artifact.yaml

The step template that downloads one pipeline artifact into `$(Pipeline.Workspace)/<Artifact>`.

## Parameters

- **`Artifact`** — the artifact name.
- **`ArtifactPipeline`** and **`RunId`** — both empty by default. With no `RunId` the artifact comes from this run. With one, it comes from
  that run of `ArtifactPipeline`, so DEPLOY takes the exact artifact CI built, by run id
  ([FDR-CD-PRODPROGRESSIONISDEPLOY](../../../../drs/flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-prodprogressionisdeploy)).
