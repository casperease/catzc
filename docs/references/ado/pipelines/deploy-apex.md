# .ado/pipelines/deploy-apex.yaml

The manual DEPLOY pipeline of the customer apex: it promotes the artifact a certifying `cd-apex` run built to one rung of the ladder,
through the unit's one deploy path in `stages/deploy-unit.yaml`. It has no triggers and takes two parameters: `CiRunId`, the run id of the
certifying `cd-apex` run, and `Target`, either `release-uat` or `prod`.

## Targets

- **`release-uat`** — one expedition at `test`, in the ADO environment `apex-release-uat`. This rung is test; the RC approval check on that
  environment holds the job for its certifier
  ([FDR-CD-TWORELEASEGATES](../../../drs/flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-tworeleasegates)).
- **`prod`** — two stages. The exact artifact is staged in pre-prod, the copy of prod that is not in use (`_preprod`, environment
  `apex-pre-prod`), then activated to prod (`_prod`, environment `apex-prod`)
  ([FDR-CD-TWOENVIRONMENTACTIVATION](../../../drs/flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-twoenvironmentactivation)). The prod
  stage depends on the pre-prod one and sets `CertifiedBy: apex-pre-prod`, so no job deploys unless that environment's deployment history
  holds the commit.

Both targets download the artifact from the `cd-apex` run named by `CiRunId`, so the bytes deployed are the bytes CI built.
