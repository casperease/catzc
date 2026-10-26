# .ado/pipelines/deploy-shared.yaml

The manual DEPLOY pipeline of the shared platform unit: it promotes the artifact a certifying `cd-shared` run built to the `release-uat`
rung, through the unit's one deploy path in `stages/deploy-unit.yaml`. It has no triggers and takes two parameters: `CiRunId`, the run id of
the certifying `cd-shared` run, and `Target`, which is `release-uat` only.

## Target

`release-uat` deploys one expedition at `test`, in the ADO environment `shared-release-uat`, from the artifact of the `cd-shared` run named
by `CiRunId`. This rung is test; the RC approval check on that environment holds the job for its certifier
([FDR-CD-TWORELEASEGATES](../../../drs/flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-tworeleasegates)).
