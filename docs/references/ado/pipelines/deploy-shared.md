# .ado/pipelines/deploy-shared.yaml

The manual DEPLOY pipeline of the shared platform unit: it promotes the artifact a certifying `cd-shared` run built to one rung, through the
unit's one deploy path in `stages/deploy-unit.yaml`. It has no triggers and takes two parameters: `CiRunId`, the run id of the certifying
`cd-shared` run, and `Target`, one of `release-uat`, `prod` or `rollback`. It is the shared unit's only pipeline that deploys into the prod
subscription.

## Targets

- **`release-uat`** — one expedition at `test`, in the ADO environment `shared-release-uat`. This rung is test; the RC approval check on
  that environment holds the job for its certifier
  ([FDR-CD-TWORELEASEGATES](../../../drs/flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-tworeleasegates)).
- **`prod`** — the landing zone at `psub`, foundation then discovery (`_prod`). The shared prod subscription hosts no shared expedition.
- **`rollback`** — the `prod` path run with the `CiRunId` of an earlier certifying run; it sets `CertifiedBy: shared-psub`, so no job
  deploys unless the earlier commit once ran there.

Every target downloads the artifact of the `cd-shared` run named by `CiRunId`, so the bytes deployed are the bytes CI built.
