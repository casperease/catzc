# .ado/pipelines/cd-shared.yaml

The CD pipeline of the shared platform unit. It builds the foundation, discovery and expedition templates for the configuration slots the
shared unit owns, publishes each as an artifact, and deploys them through `stages/deploy-unit.yaml`, on `main` only.

## Triggers

The include list takes the shared templates and modules plus the root `configuration/*.yml` of each tier; the exclude list drops every
customer subfolder, which the customer CD pipelines own. Root ymls and customer subfolders sit at one folder depth, so ADO may drop a root
yml from the filter; `Test-GlobSetAffected` is the exact backstop ([FDR-GLOBS](../../../drs/flow/durable-sha-globs.md)).

## Stages

- **CI** — one `Build` job on `ubuntu-latest`. It checks out with `fetchDepth: 0`, because `Test-GlobSetAffected` diffs real refs
  ([FDR-GLOBS-CHANGECOMPUTEDFROMGIT](../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-changecomputedfromgit)). It publishes the step
  output `AFFECTED`, then runs `Build-Bicep <tier> -Shared` for foundation, discovery and expedition. `Build-Bicep` writes each template to
  `out/template/<name>`, and the pipeline publishes that folder as the artifact the deploy stages consume. `-Shared` limits the build to the
  configuration slots at the configuration root; customer subfolders are built by their own customer CD.
- **Deploy** — the unit's one deploy path in `deploy-unit.yaml`, shared with its DEPLOY pipeline: foundation, then discovery, then
  expedition. Foundations and discoveries run at `nsub` and `psub`; expeditions at `dev` (ADO environment `shared-main-uat`) and `test`.

## Why it is shaped so

- **Stage order is the safety property.** Foundation owns the Key Vault the others use, and expedition lands in discovery's network
  ([FDR-TYPE](../../../drs/flow/pipeline-types.md),
  [ADR-AZ-LZ-LINKSNEEDBOTHNETWORKS](../../../drs/azure/landing-zones.md#rule-adr-az-lz-linksneedbothnetworks),
  [ADR-AZ-DATAMOD](../../../drs/azure/azure-data-model.md)).
- **An untouched unit deploys nothing.** The first Deploy stage is skipped when `AFFECTED` is not `True`, and the later Deploy stages chain
  on it, so they skip with it. Every Deploy stage also requires the `main` branch.
