# .ado/pipelines/deploy-nova.yaml

The manual DEPLOY pipeline of the customer nova: it promotes the artifact a certifying `cd-nova` run built to the `release-uat` rung,
through the unit's one deploy path in `stages/deploy-unit.yaml`. It has no triggers and takes two parameters: `CiRunId`, the run id of the
certifying `cd-nova` run, and `Target`, which is `release-uat` only, since nova is nonprod-only.

## Target

`release-uat` deploys one expedition at `test`, in the ADO environment `nova-release-uat`, from the artifact of the `cd-nova` run named by
`CiRunId`. This rung is test; the RC approval check on that environment holds the job for its certifier
([FDR-CD-TWORELEASEGATES](../../../drs/flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-tworeleasegates)).
