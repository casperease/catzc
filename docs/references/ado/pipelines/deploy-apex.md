# .ado/pipelines/deploy-apex.yaml

The manual DEPLOY pipeline of the customer apex: it promotes the artifact a certifying `cd-apex` run built to one rung of the ladder,
through the unit's one deploy path in `stages/deploy-unit.yaml`. It has no triggers and takes two parameters: `CiRunId`, the run id of the
certifying `cd-apex` run, and `Target`, one of `release-uat`, `prod` or `rollback`. It is apex's only pipeline that deploys into the prod
subscription.

## Targets

- **`release-uat`** — one expedition at `test`, in the ADO environment `apex-release-uat`. This rung is test; the RC approval check on that
  environment holds the job for its certifier
  ([FDR-CD-TWORELEASEGATES](../../../drs/flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-tworeleasegates)).
- **`prod`** — the landing zone at `psub` (foundation, then discovery), then two expedition stages. The exact artifact is staged in
  pre-prod, the copy of prod that is not in use (`_preprod`, environment `apex-pre-prod`), then activated to prod (`_prod`, environment
  `apex-prod`)
  ([FDR-CD-TWOENVIRONMENTACTIVATION](../../../drs/flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-twoenvironmentactivation)). The prod
  stage depends on the pre-prod one and sets `CertifiedBy: apex-pre-prod`, so no job deploys unless that environment's deployment history
  holds the commit.
- **`rollback`** — the `prod` path run with the `CiRunId` of an earlier certifying run, so the artifact deployed is that earlier commit's.
  Its first stages set `CertifiedBy: apex-prod`, so no job deploys unless the earlier commit once ran in production. A rollback that removes
  a resource is a revert commit that climbs the same ladder
  ([CAF delivery](../../../drs/azure/landing-zones/landing-zones-caf.md#caf-delivery)); every template deploys in `Incremental` mode, so a
  resource the earlier template lacks stays in Azure until it is removed.

Every target downloads the artifact from the `cd-apex` run named by `CiRunId`, so the bytes deployed are the bytes CI built.
